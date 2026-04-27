# 🏗️ Decisiones de Diseño

## 🎯 Decisiones Arquitectónicas

### DA-001: Carpetas Well-Known Only
**Decisión**: Usar únicamente carpetas nativas de Office 365
**Razón**: 
- Elimina complejidad de creación/validación
- Garantiza disponibilidad
- Reduce código en 70%
**Alternativas**: Carpetas personalizadas (descartada por complejidad)

### DA-002: Procesamiento Secuencial
**Decisión**: Procesar mensajes uno por uno
**Razón**:
- Simplicidad de implementación
- Control de memoria
- Evita rate limiting
**Alternativas**: Procesamiento paralelo (innecesario para el volumen)

### DA-003: Client Credentials Flow
**Decisión**: Autenticación de aplicación sin usuario
**Razón**:
- Ideal para procesos batch
- No requiere interacción humana
- Permisos granulares
**Alternativas**: Authorization Code Flow (inadecuado para batch)

## 🔧 Decisiones Técnicas

### DT-001: Java Puro + Microsoft Graph SDK
**Decisión**: Sin frameworks adicionales
**Razón**:
- Menor overhead
- Startup más rápido
- Menos dependencias
**Alternativas**: Spring Boot (excesivo para esta funcionalidad)

### DT-002: Organización por Dominio/Usuario
**Decisión**: `domain.com/user/archivo.ext`
**Razón**:
- Organización lógica
- Fácil localización
- Escalable
**Alternativas**: Carpeta única (difícil de organizar)

### DT-003: Configuración por Variables de Entorno
**Decisión**: `.env` y variables del sistema
**Razón**:
- Seguridad (no hardcoded)
- Flexibilidad de deployment
- Estándar de la industria
**Alternativas**: Archivos de configuración (menos seguro)

## 📊 Trade-offs

| Aspecto | Decisión Tomada | Beneficio | Costo |
|---------|----------------|-----------|-------|
| Carpetas | Well-known only | Simplicidad | Menos flexibilidad |
| Procesamiento | Secuencial | Control | Menor throughput |
| Framework | Java puro | Performance | Más código manual |
| Autenticación | Client Credentials | Automatización | Setup inicial |

## 🔄 Evolución del Diseño

### Versión 1.0 (Inicial)
- Carpetas personalizadas
- Lógica compleja de creación/validación
- ~350 líneas de código

### Versión 2.0 (Actual)
- Solo carpetas well-known
- Lógica simplificada
- ~120 líneas de código
- 70% menos complejidad
