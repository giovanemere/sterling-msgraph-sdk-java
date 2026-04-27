# 🚀 Guía de Implementación

## 📋 Pre-implementación

### 1. Preparación de Azure AD
```bash
# Registrar aplicación en Azure AD
# Configurar permisos: Mail.ReadWrite
# Generar client secret
# Anotar: tenant_id, client_id, client_secret
```

### 2. Preparación del Servidor
```bash
# Verificar Java 17+
java --version

# Crear directorio de aplicación
sudo mkdir -p /opt/sterling-msgraph
sudo chown $USER:$USER /opt/sterling-msgraph

# Crear directorio de datos
sudo mkdir -p /data/attachments
sudo chown $USER:$USER /data/attachments
```

## ⚙️ Configuración

### 1. Variables de Entorno
```bash
# Crear archivo de configuración
cat > /opt/sterling-msgraph/.env << EOF
# Azure AD Configuration
TENANT_ID=your-tenant-id
CLIENT_ID=your-client-id
CLIENT_SECRET=your-client-secret
MAIL_CORREO=mailbox@domain.com

# Proxy Configuration (si aplica)
PROXY_HOST=proxy.company.com
PROXY_PORT=3128

# Application Configuration
PATH_DESTINATION=/data/attachments
PROCESSED_FOLDER=deleteditems

# API Configuration
SCOPE=https://graph.microsoft.com/.default
GRANT_TYPE=client_credentials
EOF
```

### 2. Permisos de Archivos
```bash
chmod 600 /opt/sterling-msgraph/.env
chmod +x /opt/sterling-msgraph/O365InboxAttachmentToDisk-*.jar
```

## 🚀 Deployment

### 1. Copiar Artefactos
```bash
# Copiar JAR
cp target/O365InboxAttachmentToDisk-*.jar /opt/sterling-msgraph/

# Copiar scripts
cp *.sh /opt/sterling-msgraph/
chmod +x /opt/sterling-msgraph/*.sh
```

### 2. Crear Script de Ejecución
```bash
cat > /opt/sterling-msgraph/run.sh << 'EOF'
#!/bin/bash
cd /opt/sterling-msgraph
source .env

java -Xmx512m -jar O365InboxAttachmentToDisk-*.jar \
    --mail-correo="$MAIL_CORREO" \
    --path-destination="$PATH_DESTINATION" \
    --tenant-id="$TENANT_ID" \
    --client-id="$CLIENT_ID" \
    --client-secret="$CLIENT_SECRET" \
    --proxy-host="$PROXY_HOST" \
    --proxy-port="$PROXY_PORT"
EOF

chmod +x /opt/sterling-msgraph/run.sh
```

## 🔄 Automatización

### 1. Cron Job
```bash
# Ejecutar cada hora
crontab -e
# Agregar línea:
0 * * * * /opt/sterling-msgraph/run.sh >> /var/log/sterling-msgraph.log 2>&1
```

### 2. Systemd Service
```bash
cat > /etc/systemd/system/sterling-msgraph.service << EOF
[Unit]
Description=Sterling Microsoft Graph Email Processor
After=network.target

[Service]
Type=oneshot
User=sterling
WorkingDirectory=/opt/sterling-msgraph
ExecStart=/opt/sterling-msgraph/run.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Habilitar servicio
systemctl enable sterling-msgraph.service
```

### 3. Systemd Timer
```bash
cat > /etc/systemd/system/sterling-msgraph.timer << EOF
[Unit]
Description=Run Sterling Microsoft Graph every hour
Requires=sterling-msgraph.service

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Habilitar timer
systemctl enable sterling-msgraph.timer
systemctl start sterling-msgraph.timer
```

## 🧪 Verificación

### 1. Test Manual
```bash
cd /opt/sterling-msgraph
./run.sh
```

### 2. Verificar Logs
```bash
# Logs de aplicación
tail -f /var/log/sterling-msgraph.log

# Logs de systemd
journalctl -u sterling-msgraph.service -f
```

### 3. Verificar Archivos
```bash
# Verificar estructura de directorios
ls -la /data/attachments/
# Debe mostrar: domain.com/user/archivos...
```

## 🔧 Configuraciones Avanzadas

### 1. Múltiples Buzones
```bash
# Crear configuración por buzón
cp .env .env.buzón1
cp .env .env.buzón2

# Modificar MAIL_CORREO en cada archivo
# Crear scripts separados
```

### 2. Monitoreo
```bash
# Script de monitoreo
cat > /opt/sterling-msgraph/monitor.sh << 'EOF'
#!/bin/bash
LOG_FILE="/var/log/sterling-msgraph.log"
ERROR_COUNT=$(tail -100 "$LOG_FILE" | grep -c "ERROR\|Exception")

if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "ALERT: $ERROR_COUNT errors found in last 100 log lines"
    # Enviar notificación
fi
EOF
```
