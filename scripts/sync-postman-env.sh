#!/usr/bin/env bash
# Rellena postman/Sterling_Graph_Environment.postman_environment.json desde secrets.env
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=scripts/load-secrets.sh
source "${REPO_ROOT}/scripts/load-secrets.sh"

ENV_JSON="${REPO_ROOT}/postman/Sterling_Graph_Environment.postman_environment.json"
if [[ ! -f "${ENV_JSON}" ]]; then
  echo "No existe: ${ENV_JSON}" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Se requiere jq. Exporte variables manualmente desde secrets.env." >&2
  exit 1
fi

tmp="$(mktemp)"
jq --arg t "${TENANT_ID}" --arg c "${CLIENT_ID}" --arg s "${CLIENT_SECRET}" --arg m "${MAIL_CORREO}" '
  .values |= map(
    if .key == "tenant_id" then .value = $t
    elif .key == "client_id" then .value = $c
    elif .key == "client_secret" then .value = $s
    elif .key == "mail_email" then .value = $m
    else . end
  )
' "${ENV_JSON}" > "${tmp}"
mv "${tmp}" "${ENV_JSON}"
echo "Postman environment actualizado desde secrets.env"
