# Contexto del proyecto (agentes)

**Fuente de verdad:** [CLAUDE.md](CLAUDE.md) y [docs/README.md](docs/README.md).

Este archivo se mantiene como alias corto. No duplicar tablas aquí.

| Necesidad | Documento |
|-----------|-----------|
| Reglas anti-alucinación | `.cursor/rules/msgraph-o365-project.mdc` |
| Manual operativo | `docs/implementacion/MANUAL-O365-GRAPH.md` |
| Backlog | `docs/implementacion/00-BACKLOG-y-orden-implementacion.md` |
| Histórico v2.0 | `docs/HISTORICO-CAMBIOS.md` |
| Arquitectura C4 | `docs/arquitectura/README.md` |
| Entregable despliegue GFS | `artifact/README.md` |

Hot path: `app.5.4.0.sh` → decrypt → JAR → Graph → adjuntos GFS → move `deleteditems` → `ListF.xml`.
