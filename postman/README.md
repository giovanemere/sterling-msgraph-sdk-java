# 📋 Postman Collection

Esta carpeta contiene todos los archivos relacionados con Postman para el proyecto Microsoft Graph Sterling.

## 📁 Archivos

### 🔧 Collection y Environment
- `Microsoft_Graph_Sterling_Complete.postman_collection.json` - Colección completa con funcionalidades enhanced
- `Sterling_Graph_Environment.postman_environment.json` - Variables de entorno configuradas

## 🚀 Importar en Postman

1. **Abrir Postman Desktop**
2. **Import** → Seleccionar ambos archivos
3. **Environment** → Seleccionar "Sterling Graph Environment"
4. **Configurar variables** según documentación

## 📚 Documentación

Ver documentación completa en: `../docs/postman.md`

## 🔧 Estructura de la Colección

- 🔐 **Authentication** - Obtener token OAuth2
- 📁 **Folder Management** - Gestión de carpetas
- 📧 **Mail Operations** - Operaciones de correo
- 📎 **Attachment Operations** - Procesamiento de adjuntos
- 🔄 **Batch Processing** - Procesamiento por lotes (Enhanced)
- 🔧 **Utilities & Validation** - Herramientas y validación

## ⚙️ Variables Requeridas

Configurar en el environment:
- `tenant_id`
- `client_id` 
- `client_secret`
- `mail_email`

Las demás variables se llenan automáticamente durante la ejecución.
