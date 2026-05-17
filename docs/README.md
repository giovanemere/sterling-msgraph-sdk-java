# Documentación — O365InboxAttachmentToDisk

Índice de la documentación en `docs/`. Código Java en `src/`; **entregable de despliegue** en [`artifact/`](../artifact/README.md) (paridad GFS).

- **Raíz del repo:** [README.md](../README.md)
- **Memoria agente:** [CLAUDE.md](../CLAUDE.md)
- **Backlog / orden:** [implementacion/00-BACKLOG-y-orden-implementacion.md](implementacion/00-BACKLOG-y-orden-implementacion.md)
- **Manual operativo:** [implementacion/MANUAL-O365-GRAPH.md](implementacion/MANUAL-O365-GRAPH.md)

---

## Cómo está organizada `docs/`

```text
docs/
├── README.md                      ← este índice
├── index.md                       ← portada MkDocs / TechDocs
├── CHANGELOG.md · HISTORICO-CAMBIOS.md
├── DELETED_ITEMS_CONFIGURATION.md
├── decisions/                     ← ADR (por qué)
├── runbooks/                      ← índice operativo (cómo en prod)
├── definiciones/                  ← rutas GFS, glosario
├── arquitectura/                   ← modelo C4 (contexto, contenedores, componentes, vistas)
├── design/                        ← requisitos, decisiones (resumen diseño)
├── build/                         ← Maven, instalación
├── implementacion/                ← manual único + backlog
└── support/                       ← API, troubleshooting, Postman
```

Código y scripts:

| Ruta | Descripción |
|------|-------------|
| [`src/main/java/co/com/edtech/msgraph/`](../src/main/java/co/com/edtech/msgraph/) | App, Client, Mailbox, Validator |
| [**`artifact/`**](../artifact/README.md) | **Entregable completo** desplegable en GFS |
| [`artifact/jar/`](../artifact/jar/) | Scripts, config, `mail_list`, `certs/` |
| [`scripts/`](../scripts/) | build, tests, `load-secrets.sh` |

**Regla Cursor:** [`.cursor/rules/msgraph-o365-project.mdc`](../.cursor/rules/msgraph-o365-project.mdc)

---

## 1. Implementación y operación

| Documento | Contenido |
|-----------|-----------|
| [**MANUAL-O365-GRAPH.md**](implementacion/MANUAL-O365-GRAPH.md) | **Manual único** — despliegue, Cipher, GFS, uso, checklist |
| [**00-BACKLOG-y-orden-implementacion.md**](implementacion/00-BACKLOG-y-orden-implementacion.md) | Checklist B-01…, deuda doc, estado |
| [implementacion/README.md](implementacion/README.md) | Índice carpeta implementación |
| [HISTORICO-CAMBIOS.md](HISTORICO-CAMBIOS.md) | v2.0: fin carpeta `processed` → `deleteditems` |
| [CHANGELOG.md](CHANGELOG.md) | Versiones release |

---

## 2. Arquitectura (modelo C4)

| Documento | Contenido |
|-----------|-----------|
| [**arquitectura/README.md**](arquitectura/README.md) | **Índice C4** — niveles 1–4 y vistas complementarias |
| [01-contexto.md](arquitectura/01-contexto.md) | Nivel 1 — actores y sistemas |
| [02-contenedores.md](arquitectura/02-contenedores.md) | Nivel 2 — shell, Cipher, JAR, M365 |
| [03-componentes.md](arquitectura/03-componentes.md) | Nivel 3 — App, Client, Mailbox, Validator |
| [04-codigo.md](arquitectura/04-codigo.md) | Nivel 4 — fuentes y artefactos |
| [05-despliegue.md](arquitectura/05-despliegue.md) · [06-dinamica-e2e.md](arquitectura/06-dinamica-e2e.md) | Vistas despliegue y secuencia E2E |
| [requirements.md](design/requirements.md) | RF/RNF |
| [decisions.md](design/decisions.md) | Resumen decisiones (enlaza ADR) |

---

## 3. Decisiones (ADR)

| Documento | Contenido |
|-----------|-----------|
| [decisions/README.md](decisions/README.md) | Índice ADR |
| [ADR-001-carpetas-well-known-only.md](decisions/ADR-001-carpetas-well-known-only.md) | Solo well-known; default deleteditems |

---

## 4. Definiciones y normas

| Documento | Contenido |
|-----------|-----------|
| [definiciones/README.md](definiciones/README.md) | Glosario |
| [ESTANDAR-RUTAS-GFS-O365.md](definiciones/ESTANDAR-RUTAS-GFS-O365.md) | Rutas `/gfssterling`, nombres archivos |

---

## 5. Runbooks

| Documento | Contenido |
|-----------|-----------|
| [runbooks/README.md](runbooks/README.md) | Índice procedimientos → secciones del manual |

---

## 6. Build y soporte

| Documento | Contenido |
|-----------|-----------|
| [build-guide.md](build/build-guide.md) | Maven, JAR shade |
| [development.md](build/development.md) | Dev local |
| [installation.md](build/installation.md) | scp lab |
| [api.md](support/api.md) | Flags CLI, Graph, Swagger local |
| [openapi/README.md](../openapi/README.md) | OpenAPI + `serve-swagger.sh` |
| [troubleshooting.md](support/troubleshooting.md) | Errores frecuentes |
| [postman.md](support/postman.md) | Colección (nota legacy processed) |

---

## 7. MkDocs / TechDocs

```bash
mkdocs serve   # desde raíz, lee mkdocs.yml
```

Portada: [index.md](index.md)
