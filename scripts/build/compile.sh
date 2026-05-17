#!/usr/bin/env bash
# Compilación Maven (JAR sombreado). Invocado por build.sh y run-tests.sh.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${REPO_ROOT}"

echo "Compilando O365InboxAttachmentToDisk..."
mvn clean package -DskipTests \
  -Ddependency-check.skip=true \
  -Dspotbugs.skip=true

JAR="$(ls -1 target/O365InboxAttachmentToDisk-*.jar 2>/dev/null | head -1)"
if [[ -z "${JAR}" ]]; then
  echo "JAR no generado en target/" >&2
  exit 1
fi
echo "OK: ${JAR}"
