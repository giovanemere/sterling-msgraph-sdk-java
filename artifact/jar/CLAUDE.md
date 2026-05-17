# Contexto — `artifact/jar/` (paridad `/gfssterling/jar/`)

Parte del **entregable de despliegue**: [artifact/README.md](../README.md).

Cambio aquí → desplegar al GFS y actualizar manual si aplica.

| Archivo | Uso |
|---------|-----|
| `app.conf` | `FileJar`, `JARPATH`, `JAVA_HOME`, `REPO` Netty |
| `app.5.4.0.sh` | Producción: decrypt + Java + `ListF.xml` |
| `app.5.4.0-debug.sh` | Igual con trazas |
| `mail_list` | `correo=:nombre_cipher` |
| `1.cifrar_configs.sh` | Genera plano `*_out` desde `secrets.env` |
| `certs/` | Certificados — [certs/README.md](certs/README.md) |

Manual: [docs/implementacion/MANUAL-O365-GRAPH.md](../../docs/implementacion/MANUAL-O365-GRAPH.md) §5–7.

**Certificados:** solo bajo `certs/` (paridad `/gfssterling/jar/certs/`). Material sensible gitignored.
