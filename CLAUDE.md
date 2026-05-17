# O365InboxAttachmentToDisk — memoria del proyecto

Aplicación Java batch: **Microsoft Graph** (adjuntos Inbox) + despliegue **Sterling GFS** (`app.5.4.0.sh`, CipherConsole). Lab: `192.168.137.190`, JAR en `/gfssterling/jar/5.0.0/`.

## Reglas obligatorias (leer antes de editar)

- **Fuente de verdad:** [`.cursor/rules/msgraph-o365-project.mdc`](.cursor/rules/msgraph-o365-project.mdc) — código, IDE, build, seguridad, despliegue.
- **Cursor (atajo):** [`.cursorrules`](.cursorrules)

No inventar flags CLI, clases Java ni rutas GFS. No documentar carpeta `processed` como destino actual.

## Instalación y entorno local

| Requisito | Notas |
|-----------|--------|
| **JDK 17** | `export JAVA_HOME=/usr/lib/jvm/temurin-17-jdk-amd64` |
| **Maven 3.x** | `mvn -version` |
| **Cursor / VS Code** | Extension Pack for Java; **deshabilitar** `oracle.oracle-java` |
| **WSL2 → lab** | `JASPER_SSH_BIN=/mnt/c/Windows/System32/OpenSSH/ssh.exe` |
| **Secretos** | `cp secrets.env.example secrets.env` → `source scripts/load-secrets.sh` |

Abrir en el IDE **solo** esta carpeta (raíz con `pom.xml`), no mezclar con `sterling_udp_goanywhere` si falla el classpath.

```bash
./scripts/ide-refresh-maven.sh
# Paleta: Java: Clean Java Language Server Workspace → Reload
```

## Comandos frecuentes

```bash
# Build + tests + JAR (~85 MB shaded)
mvn clean test package -Ddependency-check.skip=true -Dspotbugs.skip=true

# Gate completo (build + OWASP + SpotBugs + deploy lab + permisos Graph)
./scripts/ci/o365-full-gate.sh

# Solo deploy lab
export JASPER_SSH_BIN=/mnt/c/Windows/System32/OpenSSH/ssh.exe
export JASPER_SCP_BIN=/mnt/c/Windows/System32/OpenSSH/scp.exe
source scripts/load-secrets.sh
./scripts/deploy/deploy-lab.sh
./scripts/tests/test-permissions.sh
```

Gate parcial: `SKIP_OWASP=true ./scripts/ci/o365-full-gate.sh` (OWASP es lento).

## Mapas únicos (no duplicar tablas en respuestas)

| Tema | Documento |
|------|-----------|
| Índice documentación | [`docs/README.md`](docs/README.md) |
| Manual operativo | [`docs/implementacion/MANUAL-O365-GRAPH.md`](docs/implementacion/MANUAL-O365-GRAPH.md) |
| Backlog | [`docs/implementacion/00-BACKLOG-y-orden-implementacion.md`](docs/implementacion/00-BACKLOG-y-orden-implementacion.md) |
| Histórico (v2.0 well-known) | [`docs/HISTORICO-CAMBIOS.md`](docs/HISTORICO-CAMBIOS.md) |
| Arquitectura C4 | [`docs/arquitectura/README.md`](docs/arquitectura/README.md) |
| ADR | [`docs/decisions/README.md`](docs/decisions/README.md) |
| Rutas GFS | [`docs/definiciones/ESTANDAR-RUTAS-GFS-O365.md`](docs/definiciones/ESTANDAR-RUTAS-GFS-O365.md) |
| Carpetas destino | [`docs/DELETED_ITEMS_CONFIGURATION.md`](docs/DELETED_ITEMS_CONFIGURATION.md) |

## Código y artefactos

| Área | Ruta |
|------|------|
| Java | [`src/main/java/co/com/edtech/msgraph/`](src/main/java/co/com/edtech/msgraph/) |
| Despliegue GFS | [`artifact/jar/`](artifact/jar/) |
| Scripts | [`scripts/`](scripts/) — `build/`, `deploy/`, `tests/`, `ci/o365-full-gate.sh` |
| CI | [`.github/workflows/o365-ci.yml`](.github/workflows/o365-ci.yml) |

## Skills (Cursor / Claude Code)

| Skill | Uso |
|-------|-----|
| [`.cursor/skills/o365-deploy-lab/`](.cursor/skills/o365-deploy-lab/) | Deploy JAR + smoke lab |
| [`.cursor/skills/o365-lab-gate/`](.cursor/skills/o365-lab-gate/) | Gate completo local + remoto |

Paridad Claude: [`.claude/skills/`](.claude/skills/).

## Hot path runtime

`app.5.4.0.sh` → CipherConsole → `java … App -certificate …` → `Mailbox.readMailFolder` → adjuntos en `mail-attachment/<WFID>/` → move a **`destinationWellKnownFolder`** (env `PROCESSED_FOLDER`, default `deleteditems`) → `ListF.xml`.

## Clases Java

`App`, `Client`, `Mailbox`, `Validator` — detalle en [`.cursor/rules/msgraph-o365-project.mdc`](.cursor/rules/msgraph-o365-project.mdc) §2.
