#!/usr/bin/env bash
# Despliega JAR + artifact/jar (app.conf, scripts) al lab Sterling.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${REPO_ROOT}"

export JASPER_SSH_BIN="${JASPER_SSH_BIN:-/mnt/c/Windows/System32/OpenSSH/ssh.exe}"
export JASPER_SCP_BIN="${JASPER_SCP_BIN:-/mnt/c/Windows/System32/OpenSSH/scp.exe}"
LAB_HOST="${LAB_HOST:-192.168.137.190}"
LAB_USER="${LAB_USER:-sterling}"
REMOTE_JAR_DIR="/gfssterling/jar/5.0.0"
REMOTE_JAR_BASE="/gfssterling/jar"

VERSION="$(mvn -q help:evaluate -Dexpression=project.version -DforceStdout)"
JAR_LOCAL="target/O365InboxAttachmentToDisk-${VERSION}.jar"

echo "Build..."
./scripts/build/compile.sh

if [[ ! -f "${JAR_LOCAL}" ]]; then
  echo "JAR no encontrado: ${JAR_LOCAL}" >&2
  exit 1
fi

THIN_JAR_LOCAL="${REPO_ROOT}/artifact/jar/5.0.0/O365InboxAttachmentToDisk-${VERSION}.jar"
USE_THIN=false
if [[ -f "${THIN_JAR_LOCAL}" ]]; then
  USE_THIN=true
  echo "Modo offline: JAR fino + jars/deps"
  echo "Copiando JAR fino + libs offline (artifact/jar/5.0.0 + jars/)..."
  "${JASPER_SCP_BIN}" "${THIN_JAR_LOCAL}" "${LAB_USER}@${LAB_HOST}:${REMOTE_JAR_DIR}/"
  if [[ -d "${REPO_ROOT}/artifact/jar/jars" ]]; then
    "${JASPER_SSH_BIN}" "${LAB_USER}@${LAB_HOST}" "mkdir -p ${REMOTE_JAR_BASE}/jars/deps ${REMOTE_JAR_BASE}/jars/4.1.133"
    "${JASPER_SCP_BIN}" -r "${REPO_ROOT}/artifact/jar/jars/"* \
      "${LAB_USER}@${LAB_HOST}:${REMOTE_JAR_BASE}/jars/"
  fi
  LOCAL_SHA=$(sha256sum "${THIN_JAR_LOCAL}" | awk '{print $1}')
else
  echo "Copiando JAR shaded (target/)..."
  "${JASPER_SCP_BIN}" "${JAR_LOCAL}" "${LAB_USER}@${LAB_HOST}:${REMOTE_JAR_DIR}/"
  LOCAL_SHA=$(sha256sum "${JAR_LOCAL}" | awk '{print $1}')
fi

echo "Copiando artifact/jar (app.conf, app.5.4.0.sh, mail_list)..."
"${JASPER_SCP_BIN}" \
  "${REPO_ROOT}/artifact/jar/app.conf" \
  "${REPO_ROOT}/artifact/jar/app.5.4.0.sh" \
  "${REPO_ROOT}/artifact/jar/mail_list" \
  "${LAB_USER}@${LAB_HOST}:${REMOTE_JAR_BASE}/"

echo "Verificando SHA256 remoto..."
REMOTE_SHA=$("${JASPER_SSH_BIN}" "${LAB_USER}@${LAB_HOST}" \
  "sha256sum ${REMOTE_JAR_DIR}/O365InboxAttachmentToDisk-${VERSION}.jar" | awk '{print $1}')

if [[ "${LOCAL_SHA}" != "${REMOTE_SHA}" ]]; then
  echo "SHA256 no coincide: local=${LOCAL_SHA} remote=${REMOTE_SHA}" >&2
  exit 1
fi

if [[ "${USE_THIN}" == "true" ]]; then
  echo "Smoke classpath (Missing parameters esperado)..."
  "${JASPER_SSH_BIN}" "${LAB_USER}@${LAB_HOST}" \
    "cd ${REMOTE_JAR_BASE} && . ./app.conf && cp=etc; for j in jars/deps/*.jar; do cp=\$cp:\$j; done; cp=\$cp:5.0.0/O365InboxAttachmentToDisk-${VERSION}.jar; \${JAVA_HOME}/bin/java -cp \"\$cp\" co.com.edtech.msgraph.App 2>&1 | head -3" || true
else
  echo "Smoke JAR shaded (Missing parameters esperado)..."
  "${JASPER_SSH_BIN}" "${LAB_USER}@${LAB_HOST}" \
    "/gfssterling/java/temurin-jre-17.0.13/bin/java -jar ${REMOTE_JAR_DIR}/O365InboxAttachmentToDisk-${VERSION}.jar 2>&1 | head -3" || true
fi

echo ""
echo "Despliegue OK: ${VERSION} en ${LAB_HOST}"
echo "FileJar en app.conf debe ser: O365InboxAttachmentToDisk-${VERSION}.jar"
echo "E2E: ssh ${LAB_USER}@${LAB_HOST} 'cd /gfssterling/jar && ./app.5.4.0.sh \"<correo>\" \"<WFID>\"'"
