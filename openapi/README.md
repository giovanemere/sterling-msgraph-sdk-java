# OpenAPI / Swagger UI (local)

Especificación OpenAPI 3.0 de los servicios **Microsoft Graph** y **Entra ID** usados por este proyecto (no hay API REST propia del JAR).

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `o365-sterling-graph.openapi.yaml` | Subset operativo (token, mailFolders, messages, move) |
| `index.html` | Swagger UI 5 (carga el YAML por HTTP) |

## Levantar Swagger UI en local

Desde la raíz del repo:

```bash
./scripts/serve-swagger.sh
```

Abrir en el navegador: **http://127.0.0.1:8088/**

> No abrir `index.html` con `file://` — el navegador bloquea la carga del YAML.

Puerto alternativo:

```bash
SWAGGER_PORT=9090 ./scripts/serve-swagger.sh
```

## Probar endpoints (Try it out)

1. Obtener token: en Swagger, sección **Auth** → `POST /{tenant}/oauth2/v2.0/token`  
   O desde terminal:
   ```bash
   source scripts/load-secrets.sh
   ./postman/get-jwt.sh   # imprime token si está configurado
   ```
2. **Authorize** en Swagger UI → pegar `Bearer <access_token>`.
3. Sustituir `{user-id}` por el UPN del buzón (`MAIL_CORREO`).

Variables: `secrets.env` (plantilla `secrets.env.example`).

## Spec completa Microsoft Graph

Microsoft publica el catálogo completo (miles de operaciones):

- Descarga: [Microsoft Graph OpenAPI](https://learn.microsoft.com/en-us/graph/openapi)
- Archivo típico: `openapi/v1.0.yaml` o `openapi/v1.0.json`

Para la spec oficial completa, descargar desde [Microsoft Graph OpenAPI](https://learn.microsoft.com/en-us/graph/openapi) e importar el YAML en Swagger UI (**Import file**) o en Postman. El subset del repo es el recomendado para operación Sterling.

## Otras herramientas

- **Postman:** `postman/Microsoft_Graph_Sterling_Complete.postman_collection.json`
- **Referencia CLI:** `docs/support/api.md`
