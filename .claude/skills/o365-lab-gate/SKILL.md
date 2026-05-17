---
name: o365-lab-gate
description: Gate completo O365 — mvn clean test package, OWASP dependency-check, SpotBugs, deploy lab Sterling, test-permissions Graph.
---

# Skill: gate completo O365

Mismo contenido que [`.cursor/skills/o365-lab-gate/SKILL.md`](../../.cursor/skills/o365-lab-gate/SKILL.md).

```bash
export JAVA_HOME=/usr/lib/jvm/temurin-17-jdk-amd64
export JASPER_SSH_BIN=/mnt/c/Windows/System32/OpenSSH/ssh.exe
source scripts/load-secrets.sh
./scripts/ci/o365-full-gate.sh
```
