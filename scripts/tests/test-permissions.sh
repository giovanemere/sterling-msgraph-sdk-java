#!/usr/bin/env bash
# Verifica permisos Graph (Mail.ReadWrite) y carpeta well-known deleteditems.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
cd "${REPO_ROOT}"

if [[ -f "${REPO_ROOT}/scripts/load-secrets.sh" ]]; then
  # shellcheck disable=SC1091
  source "${REPO_ROOT}/scripts/load-secrets.sh"
fi

: "${MAIL_CORREO:?Defina MAIL_CORREO en secrets.env}"

echo "Verificando permisos Microsoft Graph para ${MAIL_CORREO}..."

TOKEN="$("${REPO_ROOT}/postman/get-jwt.sh" 2>/dev/null)" || true
if [[ -z "${TOKEN}" ]]; then
  echo "No se pudo obtener token (postman/get-jwt.sh)." >&2
  exit 1
fi
echo "Token OK"

HTTP_USER=$(curl -s -o /tmp/o365-user.json -w "%{http_code}" \
  -H "Authorization: Bearer ${TOKEN}" \
  "https://graph.microsoft.com/v1.0/users/${MAIL_CORREO}")

HTTP_FOLDERS=$(curl -s -o /tmp/o365-folders.json -w "%{http_code}" \
  -H "Authorization: Bearer ${TOKEN}" \
  "https://graph.microsoft.com/v1.0/users/${MAIL_CORREO}/mailFolders")

HTTP_DELETED=$(curl -s -o /tmp/o365-deleted.json -w "%{http_code}" \
  -H "Authorization: Bearer ${TOKEN}" \
  "https://graph.microsoft.com/v1.0/users/${MAIL_CORREO}/mailFolders/deleteditems")

echo ""
echo "Usuario:     HTTP ${HTTP_USER}"
echo "mailFolders: HTTP ${HTTP_FOLDERS}"
echo "deleteditems: HTTP ${HTTP_DELETED}"

if [[ "${HTTP_DELETED}" == "200" ]] && command -v jq >/dev/null 2>&1; then
  DELETED_ID=$(jq -r '.id' /tmp/o365-deleted.json)
  DELETED_NAME=$(jq -r '.displayName' /tmp/o365-deleted.json)
  echo "deleteditems id=${DELETED_ID} displayName=${DELETED_NAME}"
fi

FAIL=0
[[ "${HTTP_FOLDERS}" == "200" ]] || FAIL=1
[[ "${HTTP_DELETED}" == "200" ]] || FAIL=1

if [[ "${HTTP_USER}" != "200" ]]; then
  echo "(GET /users puede ser 403 con permiso solo Mail — no bloquea si mailFolders OK)"
fi

if [[ ${FAIL} -ne 0 ]]; then
  echo ""
  echo "Fallo: revisar Mail.ReadWrite + admin consent en Entra ID." >&2
  exit 1
fi

echo ""
echo "Permisos OK (mailFolders + deleteditems well-known)."
