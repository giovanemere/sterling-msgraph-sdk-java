---
name: o365-deploy-lab
description: Compila O365InboxAttachmentToDisk, despliega JAR a Sterling lab 192.168.137.190 y valida con app.5.4.0.sh o smoke JAR.
---

# Skill: despliegue lab O365 Graph

Mismo contenido que [`.cursor/skills/o365-deploy-lab/SKILL.md`](../../.cursor/skills/o365-deploy-lab/SKILL.md).

```bash
export JASPER_SSH_BIN=/mnt/c/Windows/System32/OpenSSH/ssh.exe
export JASPER_SCP_BIN=/mnt/c/Windows/System32/OpenSSH/scp.exe
source scripts/load-secrets.sh
./scripts/deploy/deploy-lab.sh
```

Tras deploy: alinear `artifact/jar/app.conf` → `FileJar=O365InboxAttachmentToDisk-<version>.jar`.
