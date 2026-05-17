#!/bin/bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../scripts/load-secrets.sh
source "${REPO_ROOT}/scripts/load-secrets.sh"

if [ -z "${TENANT_ID:-}" ] || [ -z "${CLIENT_ID:-}" ] || [ -z "${CLIENT_SECRET:-}" ]; then
    echo "Error: faltan TENANT_ID, CLIENT_ID o CLIENT_SECRET en secrets.env" >&2
    exit 1
fi

SCOPE="${SCOPE:-https://graph.microsoft.com/.default}"
GRANT_TYPE="${GRANT_TYPE:-client_credentials}"

curl -s -X POST "https://login.microsoftonline.com/${TENANT_ID}/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&scope=${SCOPE}&grant_type=${GRANT_TYPE}" \
  | jq -r '.access_token'
