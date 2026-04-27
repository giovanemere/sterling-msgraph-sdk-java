# 🎯 Sterling Microsoft Graph SDK - Contexto Completo del Proyecto

## 📋 Resumen Ejecutivo

**Sterling Microsoft Graph SDK** es una aplicación Java simplificada que procesa adjuntos de correos de Office 365 usando Microsoft Graph API. La solución descarga adjuntos organizadamente por dominio/usuario y mueve mensajes procesados a carpetas well-known de Office 365.

### 🎯 Problema Resuelto
- Automatizar descarga de adjuntos de correos corporativos
- Organizar archivos por dominio y usuario
- Mantener buzón limpio moviendo mensajes procesados

### ✅ Solución Implementada
- Aplicación Java standalone con Microsoft Graph SDK
- Uso exclusivo de carpetas well-known (deleteditems, sentitems, drafts, junkemail)
- Arquitectura simplificada sin creación de carpetas personalizadas
- Reducción de código del 70% (de ~350 a ~120 líneas)

## 🏗️ Arquitectura Técnica

### Componentes Principales
```
📧 Office 365 Exchange Online
    ↓ (Microsoft Graph API)
🔌 GraphServiceClient (Azure Identity)
    ↓
📧 Mailbox.java (Core Logic)
    ↓
💾 File System (Organized Storage)
```

### Flujo de Procesamiento
1. **Autenticación**: Client Credentials Flow con Azure AD
2. **Filtrado**: Mensajes con `hasAttachments eq true`
3. **Descarga**: Adjuntos a estructura `domain/user/archivo.ext`
4. **Movimiento**: Mensaje a carpeta well-known configurada

### Stack Tecnológico
- **Java**: 17+ (JRE mínimo)
- **Framework**: Java puro (sin Spring Boot)
- **SDK**: Microsoft Graph SDK 6.15.0
- **Auth**: Azure Identity 1.13.2
- **Build**: Maven 3.6+
- **Docs**: MkDocs + TechDocs

## ⚙️ Configuración

### Variables de Entorno Críticas
```bash
# Azure AD (Requeridas)
TENANT_ID=d98b231e-79bb-4aff-b916-0157f4cdc5bc
CLIENT_ID=fee4cb62-31c3-4361-90f3-b34c46c953ff
CLIENT_SECRET=T6r8Q~5-RlZcICyRvcBpDijHWUFZfXIq7NmS.dfb
MAIL_CORREO=sfg_domiciliacion@edtech.com.co

# Aplicación (Requeridas)
PATH_DESTINATION=/data/attachments
PROCESSED_FOLDER=deleteditems  # deleteditems|sentitems|drafts|junkemail

# Proxy (Opcional)
PROXY_HOST=latam-proxy-SLV.glb.lnm.bns
PROXY_PORT=3128
```

### Permisos Azure AD Requeridos
- **Mail.ReadWrite**: Leer y modificar correos
- **Application Permission**: Para Client Credentials Flow
- **Admin Consent**: Requerido para permisos de aplicación

## 📁 Estructura del Proyecto

```
sterling-msgraph-sdk-java/
├── 📚 docs/                           # Documentación TechDocs
│   ├── design/                        # Requisitos, arquitectura, decisiones
│   │   ├── requirements.md
│   │   ├── architecture.md
│   │   └── decisions.md
│   ├── build/                         # Build, desarrollo, instalación
│   │   ├── build-guide.md
│   │   ├── development.md
│   │   └── installation.md
│   ├── implementation/                # Deployment, uso
│   │   ├── deployment-guide.md
│   │   └── usage.md
│   └── support/                       # Troubleshooting, API
│       ├── troubleshooting.md
│       ├── api.md
│       └── postman.md
├── 🧪 scripts/                        # Scripts organizados
│   ├── build/                         # compile.sh, check-hardcoded.sh
│   ├── tests/                         # test-*.sh, validate-solution.sh
│   └── deployment/                    # deploy.sh
├── 📦 src/main/java/co/com/edtech/msgraph/
│   ├── Main.java                      # Entry point
│   ├── Mailbox.java                   # Core logic (~120 líneas)
│   ├── AuthProvider.java              # Authentication
│   ├── ConfigManager.java             # Configuration
│   └── FileManager.java               # File operations
├── ⚙️ .env                            # Configuración local
├── 🔨 build.sh                        # Build principal
├── 🧪 run-tests.sh                    # Tests principales
├── 📄 pom.xml                         # Maven dependencies
├── 📚 mkdocs.yml                      # TechDocs configuration
└── 📄 README.md                       # Documentación principal
```

## 🔧 Código Core - Mailbox.java

### Métodos Principales
```java
// Configuración y validación
public static void readMailFolder(GraphServiceClient client, String folderId, String destinationPath, String email)

// Obtener carpeta well-known (simplificado)
public static MailFolder getProcessedFolder(GraphServiceClient client)

// Mover mensaje a carpeta destino
private static void moveMessage2Processed(GraphServiceClient client, Message mail)

// Validar carpetas well-known
private static boolean isWellKnownFolder(String folderName)
```

### Carpetas Well-Known Soportadas
- `deleteditems`: Elementos eliminados (por defecto)
- `sentitems`: Elementos enviados
- `drafts`: Borradores
- `junkemail`: Correo no deseado
- `inbox`: Bandeja de entrada

## 🚀 Comandos Principales

### Build y Ejecución
```bash
# Build completo
./build.sh

# Ejecución básica
java -jar target/O365InboxAttachmentToDisk-*.jar

# Ejecución con parámetros
java -jar target/O365InboxAttachmentToDisk-*.jar \
    --mail-correo="user@domain.com" \
    --path-destination="/data/attachments" \
    --tenant-id="tenant-id" \
    --client-id="client-id" \
    --client-secret="client-secret"
```

### Testing
```bash
# Todos los tests
./run-tests.sh

# Tests específicos
./scripts/tests/test-deleteditems.sh      # Test carpeta eliminados
./scripts/tests/test-integration.sh      # Test integración completa
./scripts/tests/test-permissions.sh      # Test permisos Azure AD
```

## 📊 Métricas y Performance

### Código
- **Líneas totales**: ~120 líneas (reducción 70%)
- **Archivos Java**: 5 archivos principales
- **Dependencias**: 2 principales (Graph SDK + Azure Identity)
- **Complejidad**: Baja (sin frameworks pesados)

### Runtime
- **Memoria**: < 512MB heap
- **Startup**: < 5 segundos
- **Throughput**: ~1 mensaje/segundo
- **Compatibilidad**: Java 17+, Linux/Windows/macOS

### Organización de Archivos
```
/data/attachments/
├── edtech.com.co/
│   ├── user1@edtech.com.co/
│   │   ├── document1.pdf
│   │   └── spreadsheet1.xlsx
│   └── user2@edtech.com.co/
└── domain2.com/
    └── user3@domain2.com/
```

## 🔍 Troubleshooting Común

### Error de Autenticación
```bash
# Verificar credenciales
echo "Tenant: $TENANT_ID"
echo "Client: $CLIENT_ID"

# Test de token
curl -X POST "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token" \
  -d "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&scope=https://graph.microsoft.com/.default&grant_type=client_credentials"
```

### Error de Permisos
- Verificar `Mail.ReadWrite` en Azure AD
- Confirmar Admin Consent otorgado
- Validar que la aplicación tenga permisos de aplicación (no delegados)

### Error de Carpeta Well-Known
```bash
# Solo valores válidos
export PROCESSED_FOLDER="deleteditems"  # ✅
export PROCESSED_FOLDER="custom"        # ❌ Error
```

## 🎯 Casos de Uso

### Caso 1: Procesamiento Batch Diario
```bash
# Cron job diario
0 2 * * * /opt/sterling-msgraph/run.sh >> /var/log/sterling.log 2>&1
```

### Caso 2: Múltiples Buzones
```bash
# Configuraciones separadas
MAIL_CORREO=buzón1@domain.com ./run.sh
MAIL_CORREO=buzón2@domain.com ./run.sh
```

### Caso 3: Diferentes Carpetas Destino
```bash
# Elementos eliminados (por defecto)
PROCESSED_FOLDER=deleteditems ./run.sh

# Elementos enviados
PROCESSED_FOLDER=sentitems ./run.sh
```

## 🔄 Evolución del Proyecto

### Versión 1.0 (Inicial)
- Carpetas personalizadas con creación/validación compleja
- ~350 líneas de código
- Lógica de reintentos y cache delays
- Múltiples métodos de búsqueda y creación

### Versión 2.0 (Actual - Simplificada)
- Solo carpetas well-known de Office 365
- ~120 líneas de código (70% reducción)
- Acceso directo sin validaciones complejas
- Arquitectura simplificada y confiable

## 📚 Documentación Completa

La documentación está organizada en TechDocs con navegación por fases:
- **Diseño**: Requisitos → Arquitectura → Decisiones
- **Build**: Compilación → Desarrollo → Instalación  
- **Implementación**: Deployment → Uso
- **Soporte**: Troubleshooting → API → Postman

Acceso: `mkdocs serve` o TechDocs integrado en el portal corporativo.

---

**Este contexto proporciona una visión completa del proyecto Sterling Microsoft Graph SDK, incluyendo arquitectura, configuración, código core, comandos principales, y guías de troubleshooting para mantener contexto fácil en futuras conversaciones.**
