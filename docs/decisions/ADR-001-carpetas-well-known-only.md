# ADR-001: Solo carpetas well-known; destino por defecto `deleteditems`

- **Estado:** Aceptado  
- **Fecha:** 2026-04-27 (implementación commit `67b4547`)  
- **Contexto:** O365InboxAttachmentToDisk / Sterling GFS

## Contexto

La v1 buscaba o creaba una subcarpeta **`processed`** bajo Inbox (`createChildFolder`, reintentos, listado de `childFolders`). Eso añadía fallos por permisos, propagación y código (~90 LOC).

## Decisión

1. No crear ni buscar carpetas personalizadas en Exchange.  
2. Mover mensajes procesados solo a carpetas **well-known** de Graph.  
3. Destino configurable con `PROCESSED_FOLDER`; **default `deleteditems`** (Elementos eliminados).  
4. Valores permitidos: `inbox`, `sentitems`, `drafts`, `deleteditems`, `junkemail`, `outbox`.

## Consecuencias

### Positivas

- Menos llamadas Graph y menos errores de creación.  
- Comportamiento predecible en todos los tenants.  
- Logs con nombre real de carpeta (español vía `getWellKnownFolderDisplayName`).

### Negativas

- No hay carpeta dedicada “processed” visible con ese nombre.  
- Operación debe aceptar mensajes en Elementos eliminados (u otra well-known elegida).

## Alternativas descartadas

| Alternativa | Motivo descarte |
|-------------|-----------------|
| Carpeta `processed` bajo Inbox | Complejidad; fallos already exists |
| No mover mensaje (solo descargar) | Buzón crece; reprocess risk |
| Carpeta personalizada por WFID | Fuera de alcance v2 |

## Referencias

- [HISTORICO-CAMBIOS.md](../HISTORICO-CAMBIOS.md)  
- [DELETED_ITEMS_CONFIGURATION.md](../DELETED_ITEMS_CONFIGURATION.md)  
- `Mailbox.java`: `getDestinationFolder()`, `isWellKnownFolder()`
