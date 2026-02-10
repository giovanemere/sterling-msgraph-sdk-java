# Microsoft Graph Sterling - Guía Completa de Postman

## 🆕 Versión Enhanced - Nuevas Funcionalidades

### 📦 Procesamiento por Lotes
- **Process All Messages with Attachments**: Configura el procesamiento por lotes de todos los mensajes con adjuntos
- **Process Single Message (Loop)**: Procesa mensajes uno por uno con bucle automático
- **Batch Processing Status**: Monitorea el progreso del procesamiento por lotes

### 📋 Verificación de Carpeta Processed
- **List Messages in Processed Folder**: Lista todos los mensajes movidos a la carpeta processed
- Muestra información detallada: asunto, remitente, fecha, adjuntos
- Ordenados por fecha de recepción (más recientes primero)

### 🧹 Utilidades Mejoradas
- **Reset Batch Variables**: Limpia todas las variables de procesamiento por lotes
- Variables de entorno mejoradas para seguimiento de estado

## 📋 Prerrequisitos

### Azure AD Application
1. **Registrar aplicación** en Azure AD
2. **Permisos requeridos**:
   - `Mail.ReadWrite` - Para leer y modificar correos
   - `Mail.ReadBasic.All` - Para acceso básico
   - `MailboxSettings.Read` - Para configuración de buzón
   - `MailboxSettings.ReadWrite` - Para modificar configuración

### Credenciales Necesarias
- `tenant_id` - ID del directorio Azure AD
- `client_id` - ID de la aplicación registrada
- `client_secret` - Secreto de la aplicación (valor, no ID)
- `mail_email` - Dirección del buzón a procesar

## 🔧 Configuración en Postman

### 1. Importar Archivos
1. **Importar Collection**: `postman/Microsoft_Graph_Sterling_Complete.postman_collection.json` 🆕
2. **Importar Environment**: `postman/Sterling_Graph_Environment.postman_environment.json`
3. **Seleccionar Environment**: "Sterling Graph Environment"

### 2. Configurar Variables de Environment

| Variable | Valor Ejemplo | Descripción | Requerido |
|----------|---------------|-------------|-----------|
| `tenant_id` | `d98b231e-79bb-4aff-b916-0157f4cdc5bc` | ID del tenant Azure AD | ✅ |
| `client_id` | `fee4cb62-31c3-4361-90f3-b34c46c953ff` | ID de la aplicación | ✅ |
| `client_secret` | `T6r8Q~5-RlZcICyRvcBpDijHWUFZfXIq7NmS.dfb` | Secreto de la aplicación | ✅ |
| `mail_email` | `sfg_domiciliacion@edtech.com.co` | Email del buzón | ✅ |
| `scope` | `https://graph.microsoft.com/.default` | Alcance OAuth2 | ✅ |
| `grant_type` | `client_credentials` | Tipo de concesión | ✅ |
| `access_token` | *(automático)* | Token JWT generado | 🔄 |
| `message_id` | *(automático)* | ID del mensaje actual | 🔄 |
| `processed_folder_id` | *(automático)* | ID carpeta processed | 🔄 |
| `attachment_id` | *(automático)* | ID del adjunto | 🔄 |
| `inbox_folder_id` | *(automático)* | ID carpeta inbox | 🔄 |
| `batch_current_index` | *(automático)* | 🆕 Índice actual del lote | 🔄 |
| `batch_total_messages` | *(automático)* | 🆕 Total de mensajes | 🔄 |
| `batch_processed_count` | *(automático)* | 🆕 Mensajes procesados | 🔄 |
| `batch_failed_count` | *(automático)* | 🆕 Mensajes fallidos | 🔄 |

**Leyenda**: ✅ = Configurar manualmente, 🔄 = Se llena automáticamente

### 3. Pasos de Configuración Detallados

#### En Postman Desktop:
1. **Environments** → **Import** → Seleccionar `Sterling_Graph_Environment.postman_environment.json`
2. **Collections** → **Import** → Seleccionar `Microsoft_Graph_Sterling.postman_collection.json`
3. **Environment dropdown** (esquina superior derecha) → Seleccionar "Sterling Graph Environment"
4. **Environment** → **Edit** → Actualizar variables requeridas (✅)
5. **Marcar todas las variables como enabled** (✓)

## 🔐 Autenticación OAuth2 y JWT

### Componentes del Proyecto para JWT

#### Script de Generación de JWT: `postman/get-jwt.sh`
```bash
#!/bin/bash
# Cargar variables desde .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found"
    exit 1
fi

# Obtener JWT token
curl -s -X POST "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&scope=$SCOPE&grant_type=$GRANT_TYPE" \
  | jq -r '.access_token'
```

#### Archivo de Configuración: `.env`
```bash
# Microsoft Graph API Configuration
TENANT_ID=d98b231e-79bb-4aff-b916-0157f4cdc5bc
CLIENT_ID=fee4cb62-31c3-4361-90f3-b34c46c953ff
CLIENT_SECRET=T6r8Q~5-RlZcICyRvcBpDijHWUFZfXIq7NmS.dfb
MAIL_CORREO=sfg_domiciliacion@edtech.com.co

# Certificate Configuration (alternativo)
PRIVATE_CERTIFICATE=./artifact/jar/certs/account/sadbogca591-full.pem
CERTIFICATE_PASSWORD=""

# Proxy Configuration
PROXY_HOST=latam-proxy-SLV.glb.lnm.bns
PROXY_PORT=3128

# API Configuration
SCOPE=https://graph.microsoft.com/.default
GRANT_TYPE=client_credentials
```

#### Uso del Script JWT:
```bash
# Hacer ejecutable
chmod +x postman/get-jwt.sh

# Ejecutar para obtener token
./postman/get-jwt.sh

# Usar en variable de entorno
export ACCESS_TOKEN=$(./postman/get-jwt.sh)
```

### Flujo de Autenticación
```
Client Credentials Flow:
1. POST /oauth2/v2.0/token
2. Body: client_id + client_secret + scope + grant_type
3. Response: access_token (JWT) válido por 3599 segundos
```

### Estructura del JWT Token
```json
{
  "token_type": "Bearer",
  "expires_in": 3599,
  "access_token": "eyJ0eXAiOiJKV1QiLCJub25jZSI6..."
}
```

## 🚀 Orden de Ejecución Recomendado

### 1. Configuración Inicial
1. **🔐 Get Access Token (Client Secret)**
2. **📁 List Mail Folders**
3. **📁 List Inbox Child Folders**
4. **📁 Create Processed Folder** (si es necesario)

### 2. Procesamiento Individual (Modo Original)
1. **📧 Get Messages with Attachments (Java Filter)**
2. **📎 List Message Attachments**
3. **📎 Get File Attachment Content**
4. **📧 Move Message to Processed Folder**

### 3. 🆕 Procesamiento por Lotes (Modo Enhanced)
1. **📧 Get Messages with Attachments (Java Filter)**
2. **📦 Process All Messages with Attachments**
3. **🔄 Process Single Message (Loop)** - Se ejecuta automáticamente en bucle
4. **📊 Batch Processing Status** - Para monitorear progreso

### 4. 🆕 Verificación
1. **📋 List Messages in Processed Folder** - Verificar que los archivos se movieron correctamente

### 5. 🆕 Limpieza
1. **🧹 Reset Batch Variables** - Limpiar variables antes de nueva sesión

## 🔄 Funcionalidades del Procesamiento por Lotes

### Características:
- ✅ Procesamiento automático de múltiples mensajes
- ✅ Bucle automático con delay de 1 segundo entre requests
- ✅ Contador de éxitos y fallos
- ✅ Progreso en tiempo real
- ✅ Manejo de errores sin interrumpir el proceso
- ✅ Resumen final de procesamiento

### Flujo de Trabajo:
1. Obtiene todos los mensajes con adjuntos
2. Los guarda en variables de entorno
3. Procesa cada mensaje individualmente
4. Mueve cada mensaje a la carpeta "processed"
5. Continúa automáticamente hasta completar todos
6. Muestra resumen final

## 📋 Verificación de Carpeta Processed

### Información Mostrada:
- 📧 **Asunto**: Título del mensaje
- 👤 **Remitente**: Dirección de email del remitente
- 📅 **Fecha**: Fecha y hora de recepción
- 📎 **Adjuntos**: Si tiene o no adjuntos
- 📊 **Cantidad**: Total de mensajes en la carpeta

### Ejemplo de Salida:
```
📋 Found 3 messages in processed folder

=== PROCESSED MESSAGES ===
1. Subject: Documento importante
   From: usuario1@ejemplo.com
   Received: 2/9/2024, 3:45:30 PM
   Has Attachments: Yes
   ---
2. Subject: Reporte mensual
   From: usuario2@ejemplo.com
   Received: 2/9/2024, 2:30:15 PM
   Has Attachments: Yes
   ---
=========================
```

## 🔄 Variables Dinámicas

### Variables que se Capturan Automáticamente:

```javascript
// En Get Access Token
pm.environment.set('access_token', response.access_token);

// En List Inbox Child Folders  
pm.environment.set('processed_folder_id', processedFolder.id);

// En Get Messages with Attachments
pm.environment.set('message_id', firstMessage.id);
pm.environment.set('attachment_id', firstAttachment.id);
```

### Uso en Requests:
```
Authorization: Bearer {{access_token}}
URL: /users/{{mail_email}}/messages/{{message_id}}
Body: {"destinationId": "{{processed_folder_id}}"}
```

## 🚀 Ejecución

### Manual en Postman
1. Ejecutar requests en orden secuencial
2. Verificar que variables se llenan automáticamente
3. Revisar logs en Console

### Con Script JWT (Alternativo)
```bash
# Obtener token desde línea de comandos
TOKEN=$(./postman/get-jwt.sh)

# Usar en curl directo
curl -H "Authorization: Bearer $TOKEN" \
  "https://graph.microsoft.com/v1.0/users/sfg_domiciliacion@edtech.com.co/mailFolders"
```

## 🛠️ Troubleshooting

### Error: Variables no se resuelven
**Síntoma**: `{{variable_name}}` aparece literal
**Solución**:
1. Verificar environment seleccionado
2. Verificar variables habilitadas (✓)
3. Verificar valores en "Current Value"

### Error: 401 Unauthorized
**Síntoma**: `"error": "invalid_client"`
**Solución**:
1. Verificar `client_id` correcto
2. Verificar `client_secret` (usar Value, no Secret ID)
3. Verificar `tenant_id`
4. Usar script `get-jwt.sh` para validar credenciales

### Error: 403 Forbidden
**Síntoma**: `"error": "Authorization_RequestDenied"`
**Solución**:
1. Verificar permisos en Azure AD
2. Otorgar admin consent
3. Verificar roles asignados

### Error: 404 Not Found (Attachments)
**Síntoma**: `"error": "ErrorItemNotFound"`
**Solución**:
1. Ejecutar requests en orden correcto
2. Procesar adjuntos ANTES de mover mensaje
3. Verificar que `{{message_id}}` existe

### Error: Script JWT no funciona
**Síntoma**: `postman/get-jwt.sh` falla
**Solución**:
1. Verificar archivo `.env` existe
2. Instalar `jq`: `sudo apt install jq`
3. Verificar permisos: `chmod +x postman/get-jwt.sh`
4. Validar variables en `.env`

## 📊 Estructura de Subcarpetas Enhanced

```
Microsoft Graph Sterling Complete/
├── 🔐 Authentication/
│   └── Get Access Token (Client Secret)
├── 📁 Folder Management/
│   ├── List Mail Folders
│   ├── List Inbox Child Folders
│   └── Create Processed Folder
├── 📧 Mail Operations/
│   ├── Get Messages with Attachments (Java Filter)
│   └── Move Message to Processed Folder
├── 📎 Attachment Operations/
│   ├── List Message Attachments
│   └── Get File Attachment Content
├── 🆕 🔄 Batch Processing/
│   ├── Process All Messages with Attachments
│   ├── Process Single Message (Loop)
│   └── Batch Processing Status
├── 🆕 📋 Verification/
│   └── List Messages in Processed Folder
├── 🆕 🧹 Utilities/
│   └── Reset Batch Variables
└── 🔧 Utilities & Validation/
    ├── Validate Email Access
    └── Health Check - Graph API
```

## 🛠️ Mejoras en el Código Java

### Recomendaciones para sincronizar con Postman:

1. **Logging mejorado**: Agregar más logs para seguimiento
2. **Manejo de errores**: Continuar procesamiento aunque falle un mensaje
3. **Contador de procesados**: Implementar contadores como en Postman
4. **Verificación post-proceso**: Método para listar mensajes en processed

### Ejemplo de implementación sugerida:

```java
public static void processAllMessagesWithAttachments(GraphServiceClient client, String email, String destinationPath) {
    int totalMessages = 0;
    int processedCount = 0;
    int failedCount = 0;
    
    try {
        List<Message> messages = getMessagesWithAttachments(client, email);
        totalMessages = messages.size();
        
        logger.info("🚀 Starting batch processing of {} messages", totalMessages);
        
        for (int i = 0; i < messages.size(); i++) {
            Message msg = messages.get(i);
            try {
                logger.info("🔄 Processing message {}/{}: {}", i + 1, totalMessages, msg.getSubject());
                
                // Process attachments
                processMessageAttachments(msg, destinationPath);
                
                // Move to processed
                moveMessage2Processed(client, msg);
                
                processedCount++;
                logger.info("✅ Message processed successfully");
                
            } catch (Exception e) {
                failedCount++;
                logger.error("❌ Failed to process message '{}': {}", msg.getSubject(), e.getMessage());
                // Continue with next message
            }
        }
        
        logger.info("🎉 Batch processing completed!");
        logger.info("📊 Summary - Total: {}, Processed: {}, Failed: {}", totalMessages, processedCount, failedCount);
        
    } catch (Exception e) {
        logger.error("❌ Batch processing failed: {}", e.getMessage(), e);
    }
}
```

## 🔒 Seguridad

### Mejores Prácticas:
1. **No hardcodear secretos** en colecciones
2. **Usar variables de environment** para credenciales
3. **Usar archivo `.env`** para configuración local
4. **Rotar client_secret** regularmente
5. **Usar HTTPS** siempre
6. **Validar permisos mínimos** necesarios

### Variables Sensibles:
- `client_secret` - Nunca compartir
- `access_token` - Expira automáticamente
- `tenant_id` - Específico por organización

### Archivo `.env.example`:
```bash
# Microsoft Graph API Configuration
TENANT_ID=your_tenant_id_here
CLIENT_ID=your_client_id_here
CLIENT_SECRET=your_client_secret_here
MAIL_CORREO=your_email@domain.com

# Certificate Configuration
PRIVATE_CERTIFICATE=/path/to/certificate.pem
CERTIFICATE_PASSWORD=your_certificate_password

# Proxy Configuration
PROXY_HOST=your_proxy_host
PROXY_PORT=3128

# API Configuration
SCOPE=https://graph.microsoft.com/.default
GRANT_TYPE=client_credentials
```

## 📈 Monitoreo

### Logs Importantes:
```javascript
console.log('✅ Token obtained and saved');
console.log('📁 Found', response.value.length, 'mail folders');
console.log('📎 Found', response.value.length, 'messages with attachments');
console.log('✅ Message moved to processed folder successfully');
```

### Métricas:
- Tiempo de respuesta promedio: ~300ms
- Tasa de éxito: >95%
- Duración de token: 3599 segundos

## 🔧 Herramientas del Proyecto

### Archivos de Configuración:
- `.env` - Variables de entorno (no versionar)
- `.env.example` - Plantilla de variables
- `postman/get-jwt.sh` - Script para generar JWT
- `postman/Microsoft_Graph_Sterling_Complete.postman_collection.json` - Colección Postman
- `postman/Sterling_Graph_Environment.postman_environment.json` - Environment Postman

### Dependencias:
- `curl` - Para requests HTTP
- `jq` - Para procesar JSON
- Postman Desktop - Para testing manual

Esta guía completa permite configurar y usar la colección de Postman exitosamente con los componentes específicos del proyecto.
