#!/usr/bin/env bash
# Sincroniza JAR fino + todas las dependencias Maven en artifact/jar/ (despliegue sin Internet).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${REPO_ROOT}"

export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/temurin-17-jdk-amd64}"
export PATH="${JAVA_HOME}/bin:${PATH}"

VERSION="$(mvn -q help:evaluate -Dexpression=project.version -DforceStdout)"
NETTY_VER="${NETTY_VERSION:-4.1.133.Final}"
NETTY_NATIVE_VER="${NETTY_TCNATIVE_VERSION:-2.0.77.Final}"
ARTIFACT_JAR="${REPO_ROOT}/artifact/jar"
JAR_DIR="${ARTIFACT_JAR}/5.0.0"
DEPS_DIR="${ARTIFACT_JAR}/jars/deps"
NETTY_DIR="${ARTIFACT_JAR}/jars/4.1.133"
THIN_JAR="${JAR_DIR}/O365InboxAttachmentToDisk-${VERSION}.jar"

REQUIRED_JAR_PREFIXES=(
  opentelemetry-api
  opentelemetry-context
  microsoft-graph-
  azure-identity
)

echo "==> Compilar JAR fino (sin shade) + dependencias runtime (compile+runtime)..."
mvn -q clean compile jar:jar dependency:copy-dependencies \
  -DskipTests \
  -Dmaven.shade.skip=true \
  -DincludeScope=runtime \
  -DoutputDirectory="${REPO_ROOT}/target/dependency-copy"

echo "==> Limpiar destinos en artifact/jar/"
rm -rf "${JAR_DIR}" "${ARTIFACT_JAR}/jars/deps" "${ARTIFACT_JAR}/jars/4.1.133" "${ARTIFACT_JAR}/jars/4.1.119"
mkdir -p "${JAR_DIR}" "${DEPS_DIR}" "${NETTY_DIR}"

echo "==> Copiar JAR aplicación (fino) -> ${THIN_JAR}"
cp -f "${REPO_ROOT}/target/O365InboxAttachmentToDisk-${VERSION}.jar" "${THIN_JAR}"

echo "==> Copiar dependencias -> ${DEPS_DIR}/"
cp -f "${REPO_ROOT}"/target/dependency-copy/*.jar "${DEPS_DIR}/"
DEP_COUNT="$(find "${DEPS_DIR}" -maxdepth 1 -name '*.jar' | wc -l)"

echo "==> Verificar JARs críticos en deps..."
for prefix in "${REQUIRED_JAR_PREFIXES[@]}"; do
  if ! compgen -G "${DEPS_DIR}/${prefix}*.jar" >/dev/null; then
    echo "ERROR: falta ${prefix}*.jar en ${DEPS_DIR} (revisar scope runtime en copy-dependencies)" >&2
    exit 1
  fi
done

echo "==> Copiar Netty (fallback legacy app.5.4.0.sh) -> ${NETTY_DIR}/"
for pattern in \
  "netty-buffer-${NETTY_VER}.jar" \
  "netty-codec-${NETTY_VER}.jar" \
  "netty-codec-http-${NETTY_VER}.jar" \
  "netty-codec-http2-${NETTY_VER}.jar" \
  "netty-common-${NETTY_VER}.jar" \
  "netty-handler-${NETTY_VER}.jar" \
  "netty-handler-proxy-${NETTY_VER}.jar" \
  "netty-tcnative-boringssl-static-${NETTY_NATIVE_VER}.jar"; do
  src="${DEPS_DIR}/${pattern}"
  if [[ -f "${src}" ]]; then
    cp -f "${src}" "${NETTY_DIR}/${pattern}"
  else
    echo "WARN: falta ${pattern} en deps (revisar NETTY_* en app.conf)" >&2
  fi
done

echo "==> Actualizar app.conf (FileJar, Netty)"
if [[ -f "${ARTIFACT_JAR}/app.conf" ]]; then
  sed -i "s/^FileJar=.*/FileJar=O365InboxAttachmentToDisk-${VERSION}.jar/" "${ARTIFACT_JAR}/app.conf"
  sed -i "s/^NETTY_VERSION=.*/NETTY_VERSION=\"${NETTY_VER}\"/" "${ARTIFACT_JAR}/app.conf"
  sed -i "s/^NETTY_TCNATIVE_VERSION=.*/NETTY_TCNATIVE_VERSION=\"${NETTY_NATIVE_VER}\"/" "${ARTIFACT_JAR}/app.conf"
  sed -i 's|^REPO=.*|REPO="$PathJar/jars/4.1.133"|' "${ARTIFACT_JAR}/app.conf"
fi

echo ""
echo "OK — paquete offline en artifact/jar/"
echo "  JAR fino:     ${THIN_JAR}"
echo "  Dependencias: ${DEPS_DIR}/ (${DEP_COUNT} jars, scope=runtime)"
echo "  Netty:        ${NETTY_DIR}/"
echo ""
echo "Despliegue GFS:"
echo "  ${JAR_DIR}/  -> /gfssterling/jar/5.0.0/"
echo "  ${ARTIFACT_JAR}/jars/ -> /gfssterling/jar/jars/"
