---
name: o365-lab-gate
description: Gate completo O365 — mvn clean test package, OWASP dependency-check, SpotBugs, deploy lab Sterling, test-permissions Graph.
---

# Skill: gate completo O365

## Cuándo usar

Usuario pide validar build, seguridad (CVE), desplegar a lab y probar permisos Graph antes de entrega.

## Prerrequisitos

- JDK 17, Maven
- `secrets.env` para fases remotas
- WSL2: `JASPER_SSH_BIN`, `JASPER_SCP_BIN` (ver reglas proyecto)

## Ejecución

Desde raíz del repo:

```bash
export JAVA_HOME=/usr/lib/jvm/temurin-17-jdk-amd64
export JASPER_SSH_BIN=/mnt/c/Windows/System32/OpenSSH/ssh.exe
export JASPER_SCP_BIN=/mnt/c/Windows/System32/OpenSSH/scp.exe
source scripts/load-secrets.sh   # para fase 5
./scripts/ci/o365-full-gate.sh
```

## Fases del script

1. `mvn clean test package` (9 unit tests + JAR shaded)
2. OWASP `dependency-check:check` (fail CVSS ≥ 7)
3. SpotBugs `spotbugs:check`
4. `./scripts/deploy/deploy-lab.sh` (SHA256 + smoke `Missing parameters`)
5. `./scripts/tests/test-permissions.sh`

## Omitir fases

```bash
SKIP_OWASP=true ./scripts/ci/o365-full-gate.sh    # OWASP lento
SKIP_DEPLOY=true ./scripts/ci/o365-full-gate.sh
SKIP_REMOTE=true ./scripts/ci/o365-full-gate.sh
```

## Referencias

- Reglas: [`.cursor/rules/msgraph-o365-project.mdc`](../../.cursor/rules/msgraph-o365-project.mdc) §7–8
- CI: [`.github/workflows/o365-ci.yml`](../../.github/workflows/o365-ci.yml)
