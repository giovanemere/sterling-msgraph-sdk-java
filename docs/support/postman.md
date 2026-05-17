# Microsoft Graph — Postman (v2 well-known)

Alineado con el JAR **v2**: mensajes se mueven a **`deleteditems`** (Elementos eliminados).  
**No** se crea carpeta `processed` bajo Inbox. Ver [HISTORICO-CAMBIOS.md](../HISTORICO-CAMBIOS.md).

## Archivos

| Archivo | Uso |
|---------|-----|
| `postman/Microsoft_Graph_Sterling_Complete.postman_collection.json` | Colección |
| `postman/Sterling_Graph_Environment.postman_environment.json` | Variables |
| `postman/get-jwt.sh` | Token CLI (usa `secrets.env`) |

## Configuración

```bash
cp secrets.env.example secrets.env
source scripts/load-secrets.sh
./scripts/sync-postman-env.sh
```

Importar colección + environment en Postman. Variables manuales: `tenant_id`, `client_id`, `client_secret`, `mail_email`.

| Variable | Descripción |
|----------|-------------|
| `destination_folder_id` | ID de `deleteditems` (auto tras **Get deleteditems**) |
| `destination_folder_wellknown` | `deleteditems` (default) |
| `message_id` | Mensaje de prueba (auto) |
| `inbox_folder_id` | Inbox (auto) |

## Flujo recomendado

1. **Get Access Token (Client Secret)**
2. **List Mail Folders** (opcional)
3. **Get deleteditems (well-known)** → guarda `destination_folder_id`
4. **Get Messages with Attachments (Java Filter)** → inbox + `hasAttachments`
5. **Move Message to deleteditems** → `destinationId` = `{{destination_folder_id}}`
6. **List Messages in deleteditems (well-known)** — verificar movidos

## Batch

**Process All Messages** + **Process Single Message (Loop)** usan `destination_folder_id` (misma semántica que el JAR).

## Equivalencia con el JAR

| JAR / shell | Postman |
|-------------|---------|
| `PROCESSED_FOLDER=deleteditems` | Carpeta well-known `deleteditems` |
| `Mailbox` move | POST `messages/{id}/move` |
| Filtro adjuntos | `$filter=hasAttachments eq true` |

## Troubleshooting

- **403:** `Mail.ReadWrite` (application) + admin consent.
- **404 deleteditems:** buzón o permisos app-only.
- **Move sin destination_folder_id:** ejecutar **Get deleteditems** antes.

Más: [MANUAL-O365-GRAPH.md](../implementacion/MANUAL-O365-GRAPH.md) · [api.md](api.md)
