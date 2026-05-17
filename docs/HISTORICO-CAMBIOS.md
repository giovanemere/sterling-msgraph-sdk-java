# Histórico de cambios — O365InboxAttachmentToDisk

Registro funcional y técnico. Versión del artefacto Maven: `pom.xml`.

---

## v2.0 — Simplificación carpetas well-known (2026-04-27)

**Commit:** `67b4547` — *Reorganize project structure and simplify codebase* (Edisson Zuñiga)

### Problema (v1)

- Carpeta personalizada **`processed`** como hijo del Inbox.
- Lógica de búsqueda en `childFolders`, **creación** si no existía (`createChildFolder`).
- Reintentos ante `already exists` y `Thread.sleep(1000)`.
- ~200+ líneas solo en gestión de carpetas en `Mailbox.java`.

### Solución (v2)

- **Sin crear** carpetas en Exchange.
- Destino por variable de entorno `PROCESSED_FOLDER` (default **`deleteditems`**).
- Acceso directo: `mailFolders().byMailFolderId("deleteditems")`.
- Solo nombres **well-known**: `inbox`, `sentitems`, `drafts`, `deleteditems`, `junkemail`, `outbox`.

### Cambios en código (`Mailbox.java`)

| Antes | Después |
|-------|---------|
| `PROCESSED_FOLDER = "processed"` (constante) | `PROCESSED_FOLDER` configurable, default `deleteditems` |
| `getProcessedFolder()` | `getDestinationFolder()` |
| `moveMessage2Processed()` | `moveMessageToDestinationFolder()` |
| `createChildFolder()` | **Eliminado** |
| Listar hijos Inbox + crear carpeta | `byMailFolderId(well-known).get()` |

### Documentación añadida en el mismo commit

- `docs/DELETED_ITEMS_CONFIGURATION.md`
- Reorganización `docs/design/`, `docs/implementacion/` (uso, deploy), `docs/support/`
- `docs/CHANGELOG.md` (entrada 2.1 posterior)

### Comportamiento operativo

Los mensajes procesados **no** van a una carpeta llamada `processed`; van a **Elementos eliminados** (u otra well-known configurada). El buzón queda sin carpeta custom adicional.

---

## v2.1 — Claridad de logs y organización (2026-04 / 2026-05)

- Renombre de métodos y mensajes de log (carpeta real en español).
- Scripts en `scripts/build/`, `scripts/tests/`.
- `build.sh`, `run-tests.sh` en raíz.
- Ver detalle en [CHANGELOG.md](CHANGELOG.md).

---

## v5.4.x — Artefacto y dependencias

| Versión | Notas |
|---------|--------|
| 5.4.0 | JAR base en GFS lab |
| 5.4.1 | Limpieza duplicados AppEnhanced/MailboxEnhanced (commit `04d2872`) |
| 5.4.2 / 5.4.3 | Actualización dependencias Graph/Azure; despliegue lab 2026-05 |

---

## v5.3.0 y anteriores

- JAR histórico en `/gfssterling/jar/5.0.0/O365InboxAttachmentToDisk-5.3.0.jar` (legacy).
- Evolución previa a well-known documentada solo por commits antiguos en Git.

---

## Documentación y secretos (2026-05-16)

- Centralización de credenciales en **`secrets.env`** (no versionado).
- Manual único: [MANUAL-O365-GRAPH.md](implementacion/MANUAL-O365-GRAPH.md).
- `scripts/load-secrets.sh`, `scripts/sync-postman-env.sh`.
- `docs/build/` creado; índice en [index.md](index.md).

---

## Elementos legacy (no alineados con v2.0)

| Elemento | Estado |
|----------|--------|
| Postman *Create Processed Folder* | Obsoleto; JAR no crea carpetas |
| `docs/support/postman.md` secciones "processed" | Referencia histórica / pruebas manuales |
| Flags CLI `--mail-correo` en docs viejos | Incorrectos; usar `-email`, `-dir`, etc. |

---

## Cómo inspeccionar el diff v2.0 en Git

```bash
git show 67b4547 -- src/main/java/co/com/edtech/msgraph/Mailbox.java
git log -1 --format=fuller 67b4547
```
