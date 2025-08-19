# Guía de Uso - Sterling Msgraph Sdk Java

## 🎯 Casos de Uso Principales

### 1. Integración Básica

#### Autenticación
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "user@example.com",
    "password": "password"
  }'
```

#### Usar API
```bash
curl -X GET http://localhost:8080/api/v1/resources \
  -H "Authorization: Bearer <token>"
```

## 📊 Monitoreo

### Health Checks
- Aplicación: `/health`
- Base de datos: `/health/db`

### Métricas
- Endpoint: `/actuator/metrics`
