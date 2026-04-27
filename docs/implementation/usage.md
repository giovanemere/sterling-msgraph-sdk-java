# 📖 Guía de Uso

## 🚀 Inicio Rápido

### 1. Configuración Básica
```bash
# Configurar variables de entorno
export TENANT_ID="your-tenant-id"
export CLIENT_ID="your-client-id"
export CLIENT_SECRET="your-client-secret"
export MAIL_CORREO="mailbox@domain.com"
export PATH_DESTINATION="/path/to/attachments"
export PROCESSED_FOLDER="deleteditems"
```

### 2. Ejecución Simple
```bash
java -jar O365InboxAttachmentToDisk-*.jar
```

## ⚙️ Configuración Avanzada

### Carpetas de Destino
```bash
# Elementos eliminados (por defecto)
export PROCESSED_FOLDER="deleteditems"

# Elementos enviados
export PROCESSED_FOLDER="sentitems"

# Borradores
export PROCESSED_FOLDER="drafts"

# Correo no deseado
export PROCESSED_FOLDER="junkemail"
```

### Configuración de Proxy
```bash
export PROXY_HOST="proxy.company.com"
export PROXY_PORT="3128"
```

## 📁 Organización de Archivos

### Estructura Generada
```
PATH_DESTINATION/
├── domain1.com/
│   ├── user1@domain1.com/
│   │   ├── document1.pdf
│   │   └── spreadsheet1.xlsx
│   └── user2@domain1.com/
│       └── presentation1.pptx
└── domain2.com/
    └── user3@domain2.com/
        └── image1.jpg
```

## 🔍 Monitoreo

### Logs de Aplicación
```bash
# Ejecutar con logging detallado
java -jar app.jar 2>&1 | tee application.log

# Buscar errores
grep -i "error\|exception" application.log

# Contar mensajes procesados
grep -c "Mensaje movido a processed" application.log
```

### Verificación de Resultados
```bash
# Verificar archivos descargados
find $PATH_DESTINATION -type f -name "*.pdf" | wc -l

# Verificar estructura de directorios
tree $PATH_DESTINATION
```

## 🚨 Troubleshooting

### Error de Autenticación
```bash
# Verificar credenciales
echo "Tenant: $TENANT_ID"
echo "Client: $CLIENT_ID"
echo "Secret: ${CLIENT_SECRET:0:5}..."

# Test de conectividad
curl -X POST "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token"
```

### Error de Permisos
```bash
# Verificar permisos en Azure AD
# Debe tener: Mail.ReadWrite
# Debe estar granted por admin
```

### Error de Proxy
```bash
# Test de conectividad
curl -x $PROXY_HOST:$PROXY_PORT https://graph.microsoft.com/v1.0/
```
