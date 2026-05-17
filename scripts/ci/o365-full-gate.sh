#!/usr/bin/env bash
# Gate completo: build, tests, OWASP dependency-check, SpotBugs, deploy lab Sterling, pruebas Graph.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${REPO_ROOT}"

export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/temurin-17-jdk-amd64}"
export PATH="${JAVA_HOME}/bin:${PATH}"
export JASPER_SSH_BIN="${JASPER_SSH_BIN:-/mnt/c/Windows/System32/OpenSSH/ssh.exe}"
export JASPER_SCP_BIN="${JASPER_SCP_BIN:-/mnt/c/Windows/System32/OpenSSH/scp.exe}"

SKIP_OWASP="${SKIP_OWASP:-false}"
# Por defecto OWASP no aborta el gate (lab); use FAIL_ON_OWASP=true para CI estricto
FAIL_ON_OWASP="${FAIL_ON_OWASP:-false}"
SKIP_DEPLOY="${SKIP_DEPLOY:-false}"
SKIP_REMOTE="${SKIP_REMOTE:-false}"
OWASP_OK=1

log() { echo ""; echo "=== $* ==="; }

log "1/5 — Maven clean + unit tests + package (shade JAR)"
mvn -B clean test package -Ddependency-check.skip=true -Dspotbugs.skip=true

JAR="$(ls -1 target/O365InboxAttachmentToDisk-*.jar 2>/dev/null | head -1)"
[[ -n "${JAR}" ]] || { echo "JAR no generado" >&2; exit 1; }
echo "OK: ${JAR} ($(du -h "${JAR}" | awk '{print $1}'))"

if [[ "${SKIP_OWASP}" != "true" ]]; then
  log "2/5 — OWASP Dependency-Check (CVE / dependency leaks, CVSS fail >= 7)"
  if mvn -B dependency-check:check -Dspotbugs.skip=true -DskipTests; then
    echo "OWASP: PASS"
  else
    OWASP_OK=0
    echo "OWASP: FAIL — CVE >= 7 o error. Reporte: target/dependency-check-report.html" >&2
    if [[ "${FAIL_ON_OWASP}" == "true" ]]; then
      exit 1
    fi
    echo "Continuando gate (FAIL_ON_OWASP=false). Use FAIL_ON_OWASP=true para bloquear."
  fi
else
  echo "SKIP_OWASP=true — omitiendo dependency-check"
fi

log "3/5 — SpotBugs"
mvn -B compile spotbugs:check -Ddependency-check.skip=true -DskipTests

if [[ "${SKIP_DEPLOY}" != "true" ]]; then
  log "4/5 — Deploy lab Sterling (${LAB_HOST:-192.168.137.190})"
  ./scripts/deploy/deploy-lab.sh
else
  echo "SKIP_DEPLOY=true — omitiendo deploy"
fi

if [[ "${SKIP_REMOTE}" != "true" ]]; then
  log "5/5 — Pruebas Sterling / Graph (permisos + deleteditems)"
  if [[ -f "${REPO_ROOT}/scripts/load-secrets.sh" ]]; then
    # shellcheck disable=SC1091
    source "${REPO_ROOT}/scripts/load-secrets.sh"
  fi
  ./scripts/tests/test-permissions.sh
  if [[ -x "${REPO_ROOT}/scripts/tests/test-deleteditems.sh" ]]; then
    ./scripts/tests/test-deleteditems.sh || true
  fi
else
  echo "SKIP_REMOTE=true — omitiendo pruebas remotas"
fi

if [[ "${OWASP_OK}" -eq 0 ]]; then
  log "GATE OK (con advertencia OWASP) — O365InboxAttachmentToDisk listo"
  echo "Revisar: target/dependency-check-report.html"
  exit 0
fi
log "GATE OK — O365InboxAttachmentToDisk listo"
