# API Documentation - Sterling Msgraph Sdk Java

## 🔌 Endpoints

### Health Check
`GET /health`

Verificación de salud del servicio.

**Response:**
```json
{
  "status": "ok",
  "service": "sterling-msgraph-sdk-java",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

### Version Info
`GET /version`

**Response:**
```json
{
  "name": "sterling-msgraph-sdk-java",
  "version": "1.0.0",
  "build": "latest"
}
```

## 🔐 Autenticación

### JWT Token
```bash
Authorization: Bearer <token>
```
