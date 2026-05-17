#!/bin/bash
# Genera archivo plano para cifrar con CipherConsole en GFS.
# Valores desde secrets.env en la raíz del repo (no versionar secretos aquí).

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
if [[ -f "${REPO_ROOT}/secrets.env" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "${REPO_ROOT}/secrets.env"
  set +a
else
  echo "Cree ${REPO_ROOT}/secrets.env desde secrets.env.example" >&2
  exit 1
fi

client="${CLIENT_ID_CIPHER:-${CLIENT_ID}}"
tenant="${TENANT_ID}"
MailCorreo="${MAIL_CORREO}"
pathd="${PATH_DESTINATION:-${PathGFS}/jar/mail-attachment/91212}"
# PRIVATE_CERTIFICATE: artifact/jar/certs/account/<alias>-full.pem (ver certs/README.md)
privateCertificate="${PRIVATE_CERTIFICATE}"
certificatePassword="${CERTIFICATE_PASSWORD}"
proxy="${PROXY_HOST}"
proxyPort="${PROXY_PORT}"

File="${MAIL_CIPHER_FILE:-sfg_domiciliacion}"
FileDec="$File.enc"
FileOut="${File}_out"
pathSalida="/gfssterling/cipher/$FileOut"

: >"$pathSalida"
{
  echo "client=\"${client}\""
  echo "tenant=\"${tenant}\""
  echo "privateCertificate=\"${privateCertificate}\""
  echo "certificatePassword=\"${certificatePassword}\""
  echo "proxy=\"${proxy}\""
  echo "proxyPort=\"${proxyPort}\""
} >>"$pathSalida"
cat "$pathSalida"

echo ""
echo "Siguiente: cifrar en GFS con CipherConsole — docs/implementacion/MANUAL-O365-GRAPH.md sección 5.4"
echo "  cd /gfssterling/cipher"
echo "  ./CipherConsole encrypt -i ${FileOut} -o ${FileDec} -f enc -n ${File} --pwdfile clave.enc --pwdkey llavecifrado.key"
