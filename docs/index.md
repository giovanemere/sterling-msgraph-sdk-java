# O365InboxAttachmentToDisk

Aplicación Java: **Microsoft Graph** (adjuntos) + **Sterling GFS** (Cipher, `app.5.4.0.sh`).

## Empezar aquí

| Rol | Enlace |
|-----|--------|
| Operaciones / despliegue | [Manual completo](implementacion/MANUAL-O365-GRAPH.md) |
| Planificación | [Backlog](implementacion/00-BACKLOG-y-orden-implementacion.md) |
| Índice de toda la doc | [README.md](README.md) |
| Arquitectura C4 | [arquitectura/README.md](arquitectura/README.md) |
| Entregable GFS | [artifact/README.md](../artifact/README.md) |
| Agente / Claude Code | [CLAUDE.md](../CLAUDE.md) |

## Documentación por carpeta

- **implementacion/** — manual único + backlog ([índice](implementacion/README.md))  
- **decisions/** — ADR  
- **runbooks/** — índice operativo  
- **definiciones/** — rutas GFS, glosario  
- **arquitectura/** — modelo C4 ([índice](arquitectura/README.md))  
- **design/** — requisitos, decisiones (resumen)  
- **build/** — Maven  
- **support/** — API, troubleshooting, Postman  

## Cambio importante (v2.0)

Los mensajes ya **no** van a una carpeta `processed` creada bajo Inbox; van a **Elementos eliminados** (`deleteditems`) u otra well-known. Detalle: [HISTORICO-CAMBIOS.md](HISTORICO-CAMBIOS.md).

## Quick start

```bash
cp secrets.env.example secrets.env
source scripts/load-secrets.sh
./build.sh
```

Ver [build/development.md](build/development.md).
