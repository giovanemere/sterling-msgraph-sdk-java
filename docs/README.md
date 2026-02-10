# O365InboxAttachmentToDisk - Enhanced Version

Este proyecto Java, `O365InboxAttachmentToDisk`, es una aplicación que utiliza Microsoft Graph API para descargar archivos adjuntos de correos electrónicos de Office 365 y guardarlos en el disco.

## 🆕 Nuevas Funcionalidades

### 📦 Procesamiento por Lotes
- Procesa automáticamente todos los mensajes con adjuntos
- Contadores de éxito y fallos
- Logging detallado del progreso
- Manejo robusto de errores

### 📋 Verificación de Carpeta Processed
- Lista mensajes movidos a la carpeta processed
- Información detallada de cada mensaje
- Verificación de que el procesamiento fue exitoso

### 🔧 Modos de Ejecución
- **Standard**: Procesamiento tradicional mensaje por mensaje
- **Batch**: Procesamiento masivo con estadísticas
- **List**: Verificación de mensajes procesados

## 📚 Documentación

La documentación completa del proyecto se encuentra en la carpeta `docs/`:

- **[Instalación](docs/installation.md)** - Configuración e instalación del proyecto
- **[Arquitectura](docs/architecture.md)** - Diseño y componentes del sistema
- **[Uso](docs/usage.md)** - Guía de uso de la aplicación
- **[API](docs/api.md)** - Documentación de la API
- **[Desarrollo](docs/development.md)** - Guía para desarrolladores
- **[Despliegue](docs/deployment.md)** - Instrucciones de despliegue
- **[Postman](docs/postman.md)** - Guía completa de Postman con funcionalidades enhanced

## 🚀 Inicio Rápido

### Prerrequisitos
- Java Development Kit (JDK) 17 o superior
- Maven 3.6+
- Credenciales de Azure AD (tenant_id, client_id, client_secret)

### Compilar
```bash
mvn clean install
```

### Ejecutar

#### Modo Estándar (Original)
```bash
./app-enhanced.sh standard
```

#### 🆕 Modo Batch (Procesamiento Masivo)
```bash
./app-enhanced.sh batch
```

#### 🆕 Listar Mensajes Procesados
```bash
./app-enhanced.sh list
```

#### Script Original (Compatibilidad)
```bash
./app.5.4.0.sh
```

## 📁 Estructura del Proyecto

```
├── postman/                   # 🆕 Archivos de Postman organizados
│   ├── Microsoft_Graph_Sterling_Complete.postman_collection.json
│   ├── Sterling_Graph_Environment.postman_environment.json
│   └── README.md
├── docs/                   # Documentación completa
├── src/main/java/co/com/edtech/msgraph/
│   ├── App.java           # Punto de entrada original
│   ├── AppEnhanced.java   # 🆕 Versión mejorada con nuevas funcionalidades
│   ├── Client.java        # Cliente Microsoft Graph
│   ├── Mailbox.java       # Operaciones de correo originales
│   ├── MailboxEnhanced.java # 🆕 Operaciones mejoradas con batch processing
│   └── Validator.java     # Validaciones
├── Microsoft_Graph_Sterling_Complete.postman_collection.json # 🆕 Colección completa unificada
├── Sterling_Graph_Environment.postman_environment.json
├── app.5.4.0.sh          # Script de ejecución original
├── app-enhanced.sh       # 🆕 Script mejorado con nuevos modos
└── POSTMAN_ENHANCED_README.md # 🆕 Documentación de mejoras
```

## 🔧 Configuración

### Variables de Entorno
```bash
TENANT_ID=d98b231e-79bb-4aff-b916-0157f4cdc5bc
CLIENT_ID=fee4cb62-31c3-4361-90f3-b34c46c953ff
CLIENT_SECRET=T6r8Q~5-RlZcICyRvcBpDijHWUFZfXIq7NmS.dfb
MAIL_CORREO=sfg_domiciliacion@edtech.com.co
PATH_DESTINATION=/path/to/save/attachments
```

### 🆕 Parámetros de Ejecución Mejorados
```bash
java -cp $CLASSPATH co.com.edtech.msgraph.AppEnhanced \
    -client $CLIENT_ID \
    -tenant $TENANT_ID \
    -secret $CLIENT_SECRET \
    -email $MAIL_CORREO \
    -dir $PATH_DESTINATION \
    -batch true \                    # 🆕 Modo batch
    -list false \                    # 🆕 Listar procesados
    -certificatePassword $CERTIFICATE_PASSWORD \
    -host $PROXY_HOST \
    -port $PROXY_PORT
```

## 🧪 Testing con Postman

### Colección Original
El proyecto incluye una colección completa de Postman organizada en subcarpetas:

#### Orden de Ejecución
1. **🔐 Authentication** - Obtener token OAuth2
2. **📁 Folder Management** - Gestión de carpetas
3. **📧 Mail Operations** - Operaciones de correo
4. **📎 Attachment Operations** - Procesamiento de adjuntos

### 🆕 Colección Mejorada
Nueva colección con funcionalidades adicionales:

#### Nuevas Secciones
5. **🔄 Batch Processing** - Procesamiento por lotes automático
6. **📋 Verification** - Verificación de mensajes procesados
7. **🧹 Utilities** - Herramientas de limpieza y reset

#### Importar en Postman
1. Importar `Microsoft_Graph_Sterling_Complete.postman_collection.json` 🆕
2. Importar `Sterling_Graph_Environment.postman_environment.json`
3. Seleccionar el environment "Sterling Graph Environment"

## 📊 Funcionalidades

### Originales
- ✅ Autenticación OAuth2 con Microsoft Graph
- ✅ Soporte para client secret y certificados
- ✅ Configuración de proxy
- ✅ Filtrado de mensajes con adjuntos
- ✅ Descarga automática de adjuntos
- ✅ Organización por remitente
- ✅ Movimiento a carpeta "processed"
- ✅ Validación de parámetros
- ✅ Logging y manejo de errores

### 🆕 Nuevas
- ✅ **Procesamiento por lotes** con estadísticas
- ✅ **Verificación de mensajes procesados**
- ✅ **Logging mejorado** con emojis y colores
- ✅ **Contadores de éxito/fallo**
- ✅ **Manejo robusto de errores** sin interrumpir el proceso
- ✅ **Múltiples modos de ejecución**
- ✅ **Colección Postman mejorada** con bucles automáticos
- ✅ **Scripts de ejecución flexibles**

## 📈 Comparación de Rendimiento

| Característica | Versión Original | Versión Enhanced |
|----------------|------------------|------------------|
| Procesamiento | Secuencial básico | Batch con estadísticas |
| Logging | Básico | Detallado con emojis |
| Manejo de errores | Falla en primer error | Continúa procesando |
| Verificación | Manual | Automática |
| Postman | Requests individuales | Bucles automáticos |
| Modos | Solo estándar | Standard/Batch/List |

## 🤝 Contribuir

1. Fork el proyecto
2. Crear rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 📞 Soporte

Para soporte técnico, consultar:
- [Documentación completa](docs/)
- **Colección Postman**: `postman/Microsoft_Graph_Sterling_Complete.postman_collection.json`
- Crear un issue en el repositorio
