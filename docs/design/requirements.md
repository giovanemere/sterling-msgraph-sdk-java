# 🎯 Requisitos del Sistema

## 📋 Requisitos Funcionales

### RF-001: Procesamiento de Correos
- **Descripción**: Leer mensajes de inbox con adjuntos
- **Criterio**: Filtrar por `hasAttachments eq true`
- **Prioridad**: Alta

### RF-002: Descarga de Adjuntos
- **Descripción**: Descargar y guardar adjuntos localmente
- **Organización**: `domain/user/archivo.ext`
- **Prioridad**: Alta

### RF-003: Movimiento de Mensajes
- **Descripción**: Mover mensajes procesados a carpeta well-known
- **Destino**: deleteditems (por defecto)
- **Prioridad**: Alta

## 🔧 Requisitos No Funcionales

### RNF-001: Performance
- **Tiempo**: < 5 segundos por mensaje
- **Memoria**: < 512MB heap
- **Concurrencia**: Procesamiento secuencial

### RNF-002: Seguridad
- **Autenticación**: Client Credentials Flow
- **Permisos**: Mail.ReadWrite mínimo
- **Proxy**: Soporte corporativo

### RNF-003: Compatibilidad
- **Java**: JRE 17+
- **Office 365**: Todos los tenants
- **SO**: Linux, Windows, macOS

## 🎯 Casos de Uso

### CU-001: Procesamiento Batch
```
Actor: Sistema Automatizado
Precondición: Credenciales configuradas
Flujo:
1. Autenticar con Azure AD
2. Obtener mensajes con adjuntos
3. Descargar adjuntos
4. Mover mensaje a carpeta destino
5. Continuar con siguiente mensaje
```

### CU-002: Configuración de Carpeta
```
Actor: Administrador
Precondición: Acceso a variables de entorno
Flujo:
1. Configurar PROCESSED_FOLDER
2. Validar carpeta well-known
3. Ejecutar aplicación
```

## 🚫 Restricciones

- Solo carpetas well-known de Office 365
- Sin creación de carpetas personalizadas
- Procesamiento secuencial (no paralelo)
- Sin interfaz gráfica
