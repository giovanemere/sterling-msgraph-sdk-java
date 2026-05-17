---
name: o365-deploy-lab
description: Compila O365InboxAttachmentToDisk, despliega JAR a Sterling lab 192.168.137.190 y valida con app.5.4.0.sh o smoke JAR.
---

# Skill: despliegue lab O365 Graph

## Cuándo usar

Usuario pide desplegar JAR, actualizar lab Sterling, o smoke remoto.

## Pasos

```bash
export JAVA_HOME=/usr/lib/jvm/temurin-17-jdk-amd64
export JASPER_SSH_BIN=/mnt/c/Windows/System32/OpenSSH/ssh.exe
export JASPER_SCP_BIN=/mnt/c/Windows/System32/OpenSSH/scp.exe
source scripts/load-secrets.sh
./scripts/deploy/deploy-lab.sh
```

El script: `mvn clean package` (via `compile.sh`), `scp` JAR + `app.conf` + `app.5.4.0.sh` + `mail_list`, verifica SHA256, smoke JAR.

## Post-deploy

1. Confirmar `FileJar` en `/gfssterling/jar/app.conf` coincide con `pom.xml` version.
2. Permisos Graph: `./scripts/tests/test-permissions.sh`
3. E2E: `ssh sterling@192.168.137.190` → `cd /gfssterling/jar && ./app.5.4.0.sh "<correo>" "<WFID>"`

## Referencias

- [MANUAL-O365-GRAPH.md](../../../docs/implementacion/MANUAL-O365-GRAPH.md) §7
- Gate completo: skill `o365-lab-gate` / `./scripts/ci/o365-full-gate.sh`
