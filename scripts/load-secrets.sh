#!/usr/bin/env bash
# Carga secrets.env en el shell actual. Uso: source scripts/load-secrets.sh
set -euo pipefail

_REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SECRETS_FILE="${SECRETS_FILE:-${_REPO_ROOT}/secrets.env}"

if [[ ! -f "${SECRETS_FILE}" ]]; then
  echo "secrets.env no encontrado. Copie la plantilla:" >&2
  echo "  cp secrets.env.example secrets.env" >&2
  return 1 2>/dev/null || exit 1
fi

set -a
# shellcheck disable=SC1090
source "${SECRETS_FILE}"
set +a

# Carpeta canónica de certificados (repo ↔ paridad /gfssterling/jar/certs/)
export O365_CERTS_ROOT="${O365_CERTS_ROOT:-${_REPO_ROOT}/artifact/jar/certs}"
export O365_CERTS_ACCOUNT="${O365_CERTS_ACCOUNT:-${O365_CERTS_ROOT}/account}"
export O365_CERTS_MICROSOFT="${O365_CERTS_MICROSOFT:-${O365_CERTS_ROOT}/microsoft}"

# Rutas relativas al repo (ej. artifact/jar/certs/account/foo-full.pem)
if [[ -n "${PRIVATE_CERTIFICATE:-}" && "${PRIVATE_CERTIFICATE}" != /* ]]; then
  PRIVATE_CERTIFICATE="${_REPO_ROOT}/${PRIVATE_CERTIFICATE#./}"
  export PRIVATE_CERTIFICATE
fi

# Proxy corporativo por perfil (ver secrets.env.example)
#   lab|gfs  → PROXY_HOST_LAB (192.168.137.3 en Hyper-V)
#   wsl|cursor → PROXY_HOST_WSL (172.21.224.1 desde Cursor/WSL)
#   default → PROXY_HOST (latam-proxy-SLV.glb.lnm.bns en GFS con DNS interno)
if [[ -n "${PROXY_PORT:-}" ]]; then
  _proxy_profile="${O365_PROXY_PROFILE:-}"
  if [[ -z "${_proxy_profile}" ]] && [[ -n "${WSL_DISTRO_NAME:-}" || -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
    _proxy_profile="wsl"
  fi
  case "${_proxy_profile}" in
    wsl|cursor)
      if [[ -n "${PROXY_HOST_WSL:-}" ]]; then
        export PROXY_HOST="${PROXY_HOST_WSL}"
      fi
      ;;
    lab|gfs|sterling)
      if [[ -n "${PROXY_HOST_LAB:-}" ]]; then
        export PROXY_HOST="${PROXY_HOST_LAB}"
      fi
      ;;
  esac
  unset _proxy_profile
fi
