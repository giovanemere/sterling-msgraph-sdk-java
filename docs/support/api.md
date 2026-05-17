# 📚 Referencia de API

## Swagger UI (local)

OpenAPI 3.0 del subset Graph + token Entra usado por el JAR:

| Recurso | Ruta |
|---------|------|
| Spec YAML | [`openapi/o365-sterling-graph.openapi.yaml`](../../openapi/o365-sterling-graph.openapi.yaml) |
| Guía | [`openapi/README.md`](../../openapi/README.md) |

```bash
./scripts/serve-swagger.sh
# → http://127.0.0.1:8088/
```

En Swagger: **Authorize** con `Bearer <token>` (obtener vía `POST .../token` o `source scripts/load-secrets.sh` + Postman).

---

## 🔌 Microsoft Graph Endpoints

### Autenticación
```http
POST https://login.microsoftonline.com/{tenant}/oauth2/v2.0/token
Content-Type: application/x-www-form-urlencoded

client_id={client_id}
&client_secret={client_secret}
&scope=https://graph.microsoft.com/.default
&grant_type=client_credentials
```

### Obtener Carpetas de Correo
```http
GET https://graph.microsoft.com/v1.0/users/{user-id}/mailFolders
Authorization: Bearer {token}
```

### Obtener Mensajes con Adjuntos
```http
GET https://graph.microsoft.com/v1.0/users/{user-id}/mailFolders/inbox/messages?$filter=hasAttachments eq true&$expand=attachments
Authorization: Bearer {token}
```

### Mover Mensaje
```http
POST https://graph.microsoft.com/v1.0/users/{user-id}/messages/{message-id}/move
Authorization: Bearer {token}
Content-Type: application/json

{
  "destinationId": "{folder-id}"
}
```

## 🗂️ Carpetas Well-Known

| Nombre | ID | Descripción |
|--------|----|-----------| 
| `inbox` | inbox | Bandeja de entrada |
| `sentitems` | sentitems | Elementos enviados |
| `drafts` | drafts | Borradores |
| `deleteditems` | deleteditems | Elementos eliminados |
| `junkemail` | junkemail | Correo no deseado |

## ⚙️ Configuración (`secrets.env`)

Valores reales en **`secrets.env`** (no versionado). Plantilla: `secrets.env.example`.

```bash
source scripts/load-secrets.sh
```

| Variable | Requerida | Descripción | Consumida por |
|----------|-----------|-------------|---------------|
| `TENANT_ID` | ✅ | Tenant Azure AD | CLI `-tenant` (scripts exportan desde secrets) |
| `CLIENT_ID` | ✅ | App registration | CLI `-client` |
| `CLIENT_SECRET` | ✅* | Secret (*o certificado) | CLI `-secret` |
| `MAIL_CORREO` | ✅ | Buzón | CLI `-email` |
| `PATH_DESTINATION` | ✅ | Directorio adjuntos | CLI `-dir` |
| `PROCESSED_FOLDER` | ❌ | Carpeta well-known destino | **Solo** `Mailbox.java` (`getenv`) |
| `PROXY_HOST` / `PROXY_PORT` | ❌ | Proxy | CLI `-host` / `-port` |
| `PRIVATE_CERTIFICATE` | ❌ | `artifact/jar/certs/account/*-full.pem` (GFS: `/gfssterling/jar/certs/…`) | CLI `-certificate` |

## 🔧 Parámetros CLI (`App.java`)

Pares `opción valor` (no flags `--nombre`):

```bash
source scripts/load-secrets.sh
java -jar target/O365InboxAttachmentToDisk-*.jar \
  -tenant "$TENANT_ID" \
  -client "$CLIENT_ID" \
  -secret "$CLIENT_SECRET" \
  -email "$MAIL_CORREO" \
  -dir "$PATH_DESTINATION/" \
  -host "$PROXY_HOST" \
  -port "$PROXY_PORT"
```

Autenticación por certificado: `-certificate` y `-certificatePassword` en lugar de `-secret`.

## 📊 Códigos de Respuesta

### Éxito
- `200 OK`: Operación exitosa
- `201 Created`: Recurso creado
- `204 No Content`: Operación exitosa sin contenido

### Errores de Cliente
- `400 Bad Request`: Solicitud malformada
- `401 Unauthorized`: Token inválido o expirado
- `403 Forbidden`: Permisos insuficientes
- `404 Not Found`: Recurso no encontrado

### Errores de Servidor
- `500 Internal Server Error`: Error interno
- `502 Bad Gateway`: Error de proxy
- `503 Service Unavailable`: Servicio no disponible

## 🔍 Filtros OData

### Mensajes con Adjuntos
```
$filter=hasAttachments eq true
```

### Mensajes por Fecha
```
$filter=receivedDateTime ge 2024-01-01T00:00:00Z
```

### Mensajes por Remitente
```
$filter=from/emailAddress/address eq 'sender@domain.com'
```

## 📝 Ejemplos de Respuesta

### Lista de Mensajes
```json
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users('user%40domain.com')/mailFolders('inbox')/messages",
  "value": [
    {
      "id": "AAMkAGE...",
      "subject": "Documento importante",
      "hasAttachments": true,
      "from": {
        "emailAddress": {
          "address": "sender@domain.com",
          "name": "Sender Name"
        }
      },
      "attachments": [
        {
          "@odata.type": "#microsoft.graph.fileAttachment",
          "id": "AAMkAGE...",
          "name": "document.pdf",
          "contentType": "application/pdf",
          "size": 1024000
        }
      ]
    }
  ]
}
```
