# 📚 Referencia de API

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

## ⚙️ Variables de Entorno

| Variable | Requerida | Descripción | Ejemplo |
|----------|-----------|-------------|---------|
| `TENANT_ID` | ✅ | ID del tenant de Azure | `d98b231e-79bb-4aff-b916-0157f4cdc5bc` |
| `CLIENT_ID` | ✅ | ID de la aplicación | `fee4cb62-31c3-4361-90f3-b34c46c953ff` |
| `CLIENT_SECRET` | ✅ | Secret de la aplicación | `T6r8Q~5-RlZcICyRvcBpDijHWUFZfXIq7NmS.dfb` |
| `MAIL_CORREO` | ✅ | Buzón a procesar | `user@domain.com` |
| `PATH_DESTINATION` | ✅ | Directorio de adjuntos | `/data/attachments` |
| `PROCESSED_FOLDER` | ❌ | Carpeta destino | `deleteditems` |
| `PROXY_HOST` | ❌ | Host del proxy | `proxy.company.com` |
| `PROXY_PORT` | ❌ | Puerto del proxy | `3128` |

## 🔧 Parámetros de Línea de Comandos

```bash
java -jar O365InboxAttachmentToDisk-*.jar \
    --mail-correo="user@domain.com" \
    --path-destination="/data/attachments" \
    --tenant-id="tenant-id" \
    --client-id="client-id" \
    --client-secret="client-secret" \
    --proxy-host="proxy.company.com" \
    --proxy-port="3128"
```

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
