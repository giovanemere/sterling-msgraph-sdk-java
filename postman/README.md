# 📋 Postman Collection

Esta carpeta contiene todos los archivos relacionados con Postman para el proyecto Microsoft Graph Sterling.

## 📁 Archivos

### Colección y environment (v2 — deleteditems)
- `Microsoft_Graph_Sterling_Complete.postman_collection.json` — sin carpeta `processed` custom
- `Sterling_Graph_Environment.postman_environment.json` — `destination_folder_id`, `destination_folder_wellknown`

## 🚀 Importar en Postman

1. **Abrir Postman Desktop**
2. **Import** → Seleccionar ambos archivos
3. **Environment** → Seleccionar "Sterling Graph Environment"
4. **Configurar variables** según documentación

## 📚 Documentación

Ver: [docs/support/postman.md](../docs/support/postman.md)

## 🔧 Estructura de la Colección

- 🔐 **Authentication** - Obtener token OAuth2
- 📁 **Folder Management** - List folders, **Get deleteditems**, list moved messages
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
