# Configuración: carpetas well-known

> Histórico del cambio v1 (`processed` custom) → v2 (`deleteditems`): [HISTORICO-CAMBIOS.md](HISTORICO-CAMBIOS.md).  
> Manual: [MANUAL-O365-GRAPH.md](implementacion/MANUAL-O365-GRAPH.md) §8.

## Configuración actual

El sistema ahora usa únicamente **carpetas well-known** de Office 365, eliminando la complejidad de crear carpetas personalizadas.

### **Por Defecto: Elementos Eliminados**
```bash
PROCESSED_FOLDER=deleteditems  # Elementos eliminados (recomendado)
```

### **Otras Opciones Disponibles:**
```bash
PROCESSED_FOLDER=sentitems     # Elementos enviados
PROCESSED_FOLDER=drafts        # Borradores  
PROCESSED_FOLDER=junkemail     # Correo no deseado
PROCESSED_FOLDER=inbox         # Bandeja de entrada
```

## 🎯 **Ventajas de la Simplificación:**

- ✅ **Sin creación de carpetas**: Solo usa carpetas nativas de Office 365
- ✅ **Sin validaciones complejas**: Acceso directo a carpetas existentes
- ✅ **Sin reintentos**: Carpetas siempre disponibles
- ✅ **Sin cache delays**: No hay propagación de cambios
- ✅ **Código más simple**: Menos líneas, menos errores

## 🚀 **Uso:**

```bash
# Configurar y ejecutar
export PROCESSED_FOLDER=deleteditems
java -jar target/O365InboxAttachmentToDisk-*.jar [parámetros]
```

## 📋 **Logging Simplificado:**

```
📁 Usando carpeta: Elementos eliminados
📁 Obteniendo carpeta well-known: 'deleteditems'
✅ Carpeta 'deleteditems' obtenida: Deleted Items
📁 Mensaje movido a Elementos eliminados: [Asunto del mensaje]
```

## ⚠️ **Restricciones:**

- Solo se permiten carpetas well-known de Office 365
- No se crean carpetas personalizadas
- Configuraciones inválidas generan error al inicio
