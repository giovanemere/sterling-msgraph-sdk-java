# 🚨 Guía de Troubleshooting

## 🔍 Diagnóstico Rápido

### 1. Verificación de Sistema
```bash
# Java version
java --version
# Debe ser 17+

# Conectividad
ping graph.microsoft.com

# Espacio en disco
df -h $PATH_DESTINATION

# Permisos
ls -la $PATH_DESTINATION
```

## ❌ Errores Comunes

### Error: Authentication Failed
```
❌ Error: AADSTS70011: The provided value for the input parameter 'scope' is not valid
```
**Causa**: Scope incorrecto
**Solución**:
```bash
export SCOPE="https://graph.microsoft.com/.default"
```

### Error: Insufficient Privileges
```
❌ Error: Insufficient privileges to complete the operation
```
**Causa**: Permisos insuficientes en Azure AD
**Solución**:
1. Ir a Azure Portal → App Registrations
2. Seleccionar aplicación
3. API Permissions → Add permission
4. Microsoft Graph → Application permissions
5. Agregar `Mail.ReadWrite`
6. Grant admin consent

### Error: Proxy Connection
```
❌ Error: Connection timed out
```
**Causa**: Configuración de proxy incorrecta
**Solución**:
```bash
# Verificar configuración
echo "Proxy: $PROXY_HOST:$PROXY_PORT"

# Test manual
curl -x $PROXY_HOST:$PROXY_PORT https://graph.microsoft.com/v1.0/
```

### Error: Well-Known Folder Invalid
```
❌ Error: Solo se permiten carpetas well-known
```
**Causa**: PROCESSED_FOLDER con valor inválido
**Solución**:
```bash
# Valores válidos únicamente
export PROCESSED_FOLDER="deleteditems"  # Recomendado
export PROCESSED_FOLDER="sentitems"
export PROCESSED_FOLDER="drafts"
export PROCESSED_FOLDER="junkemail"
```

### Error: File Permission Denied
```
❌ Error: java.nio.file.AccessDeniedException
```
**Causa**: Sin permisos de escritura
**Solución**:
```bash
# Verificar permisos
ls -la $PATH_DESTINATION

# Corregir permisos
chmod 755 $PATH_DESTINATION
chown $USER:$USER $PATH_DESTINATION
```

## 🔧 Herramientas de Diagnóstico

### 1. Script de Verificación
```bash
#!/bin/bash
echo "🔍 Diagnóstico del Sistema"
echo "========================="

# Java
echo "Java Version:"
java --version

# Variables de entorno
echo -e "\nVariables de Entorno:"
echo "TENANT_ID: ${TENANT_ID:0:8}..."
echo "CLIENT_ID: ${CLIENT_ID:0:8}..."
echo "CLIENT_SECRET: ${CLIENT_SECRET:0:5}..."
echo "MAIL_CORREO: $MAIL_CORREO"
echo "PROCESSED_FOLDER: $PROCESSED_FOLDER"

# Conectividad
echo -e "\nConectividad:"
ping -c 1 graph.microsoft.com && echo "✅ Graph API accesible" || echo "❌ Graph API no accesible"

# Permisos
echo -e "\nPermisos:"
[ -w "$PATH_DESTINATION" ] && echo "✅ Directorio escribible" || echo "❌ Sin permisos de escritura"
```

### 2. Test de Autenticación
```bash
#!/bin/bash
# test-auth.sh
curl -X POST "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "scope=https://graph.microsoft.com/.default" \
  -d "grant_type=client_credentials"
```

### 3. Test de Graph API
```bash
#!/bin/bash
# test-graph.sh
TOKEN=$(curl -s -X POST "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "scope=https://graph.microsoft.com/.default" \
  -d "grant_type=client_credentials" | jq -r '.access_token')

curl -H "Authorization: Bearer $TOKEN" \
  "https://graph.microsoft.com/v1.0/users/$MAIL_CORREO/mailFolders"
```

## 📊 Monitoreo y Logs

### Niveles de Log
```bash
# Debug completo
java -Dlogging.level.root=DEBUG -jar app.jar

# Solo errores
java -Dlogging.level.root=ERROR -jar app.jar

# Log a archivo
java -jar app.jar > application.log 2>&1
```

### Análisis de Logs
```bash
# Errores críticos
grep -i "error\|exception\|failed" application.log

# Mensajes procesados
grep -c "Mensaje movido a processed" application.log

# Tiempo de ejecución
grep "Execution time" application.log
```

## 🆘 Escalación

### Información para Soporte
```bash
# Recopilar información del sistema
cat > support-info.txt << EOF
Fecha: $(date)
Java Version: $(java --version | head -1)
OS: $(uname -a)
Aplicación: $(ls -la *.jar)
Variables de entorno: 
  TENANT_ID: ${TENANT_ID:0:8}...
  CLIENT_ID: ${CLIENT_ID:0:8}...
  MAIL_CORREO: $MAIL_CORREO
  PROCESSED_FOLDER: $PROCESSED_FOLDER
Últimos 50 logs:
$(tail -50 application.log)
EOF
```

### Contactos de Soporte
- **Nivel 1**: Administrador local del sistema
- **Nivel 2**: Equipo de desarrollo
- **Nivel 3**: Microsoft Graph API Support
