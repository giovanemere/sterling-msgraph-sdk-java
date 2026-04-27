# 📧 Sterling Microsoft Graph SDK

Aplicación Java simplificada para procesar adjuntos de correos de Office 365 usando Microsoft Graph API. Descarga adjuntos organizadamente y mueve mensajes a carpetas well-known.

## 🚀 Inicio Rápido

```bash
# 1. Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales

# 2. Build
./build.sh

# 3. Ejecutar
java -jar target/O365InboxAttachmentToDisk-*.jar
```

## ✅ Características

- ✅ **Simplicidad**: Solo usa carpetas well-known de Office 365
- ✅ **Seguridad**: Client Credentials Flow con Azure AD  
- ✅ **Organización**: Archivos por dominio/usuario
- ✅ **Confiabilidad**: Sin creación de carpetas personalizadas
- ✅ **Proxy Support**: Compatible con redes corporativas

## 📁 Estructura del Proyecto

```
sterling-msgraph-sdk-java/
├── 📚 docs/                    # Documentación organizada
│   ├── design/                 # Requisitos, arquitectura, decisiones
│   ├── build/                  # Build, desarrollo, instalación
│   ├── implementation/         # Deployment, uso
│   └── support/                # Troubleshooting, API, postman
├── 🧪 scripts/                 # Scripts organizados
│   ├── build/                  # compile.sh, check-hardcoded.sh
│   ├── tests/                  # test-*.sh, validate-solution.sh
│   └── deployment/             # deploy.sh
├── 📦 src/main/java/           # Código fuente
├── ⚙️ .env                     # Configuración
├── 🔨 build.sh                 # Build principal
├── 🧪 run-tests.sh             # Tests principales
└── 📄 pom.xml                  # Maven configuration
```

## ⚙️ Configuración

### Variables de Entorno Requeridas
```bash
TENANT_ID=your-tenant-id
CLIENT_ID=your-client-id  
CLIENT_SECRET=your-client-secret
MAIL_CORREO=mailbox@domain.com
PATH_DESTINATION=/data/attachments
PROCESSED_FOLDER=deleteditems    # deleteditems, sentitems, drafts, junkemail
```

### Configuración Opcional
```bash
PROXY_HOST=proxy.company.com
PROXY_PORT=3128
```

## 🧪 Testing

```bash
# Todos los tests
./run-tests.sh

# Test específico
./scripts/tests/test-deleteditems.sh
```

## 📚 Documentación

- [📋 Requisitos](docs/design/requirements.md)
- [🏗️ Arquitectura](docs/design/architecture.md)
- [🔨 Build Guide](docs/build/build-guide.md)
- [🚀 Deployment](docs/implementation/deployment-guide.md)
- [🚨 Troubleshooting](docs/support/troubleshooting.md)

## 🔧 Desarrollo

```bash
# Setup desarrollo
git clone <repo>
cd sterling-msgraph-sdk-java
cp .env.example .env

# Build y test
./build.sh
./run-tests.sh
```

## 📊 Métricas

- **Código**: ~120 líneas (70% reducción vs v1.0)
- **Dependencias**: Microsoft Graph SDK + Azure Identity
- **Memoria**: < 512MB heap
- **Startup**: < 5 segundos
- **Compatibilidad**: Java 17+, todos los SO
