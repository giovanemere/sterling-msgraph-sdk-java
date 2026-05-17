#!/usr/bin/env bash
# Prueba local: PROCESSED_FOLDER=deleteditems y flags CLI reales (App.java).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
cd "${REPO_ROOT}"

if [[ -f "${REPO_ROOT}/scripts/load-secrets.sh" ]]; then
  # shellcheck disable=SC1091
  source "${REPO_ROOT}/scripts/load-secrets.sh"
fi

: "${TENANT_ID:?Defina TENANT_ID en secrets.env}"
: "${CLIENT_ID:?Defina CLIENT_ID en secrets.env}"
: "${CLIENT_SECRET:?Defina CLIENT_SECRET en secrets.env}"
: "${MAIL_CORREO:?Defina MAIL_CORREO en secrets.env}"

export PROCESSED_FOLDER="${PROCESSED_FOLDER:-deleteditems}"

JAR_FILE="$(ls -1 "${REPO_ROOT}"/target/O365InboxAttachmentToDisk-*.jar 2>/dev/null | head -1)"
if [[ -z "${JAR_FILE}" ]]; then
  echo "JAR no encontrado. Ejecute ./build.sh desde la raíz del repo." >&2
  exit 1
fi

TEST_DIR="${REPO_ROOT}/tmp-test-deleteditems"
mkdir -p "${TEST_DIR}"

echo "PROCESSED_FOLDER=${PROCESSED_FOLDER}"
echo "JAR: ${JAR_FILE}"
echo "Destino: ${TEST_DIR}/"
echo ""

PROXY_ARGS=()
if [[ -n "${PROXY_HOST:-}" && -n "${PROXY_PORT:-}" ]]; then
  PROXY_ARGS=(-host "${PROXY_HOST}" -port "${PROXY_PORT}")
fi

set +e
java -jar "${JAR_FILE}" \
  -tenant "${TENANT_ID}" \
  -client "${CLIENT_ID}" \
  -secret "${CLIENT_SECRET}" \
  -email "${MAIL_CORREO}" \
  -dir "${TEST_DIR}/" \
  "${PROXY_ARGS[@]}" \
  2>&1 | tee "${REPO_ROOT}/test-deleteditems.log"
JAVA_EXIT=${PIPESTATUS[0]}
set -e

echo ""
if [[ ${JAVA_EXIT} -ne 0 ]]; then
  echo "Fallo: exit code ${JAVA_EXIT} (esperado 0 si Graph y buzón OK)." >&2
  exit "${JAVA_EXIT}"
fi

echo "OK: JAR terminó con exit 0."
echo "Log: ${REPO_ROOT}/test-deleteditems.log"
echo "Revise en log: 'Usando carpeta: Elementos eliminados' y moves a deleteditems."
