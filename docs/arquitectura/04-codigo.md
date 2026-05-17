# C4 — Nivel 4: Diagrama de código

Detalle de implementación del contenedor JAR (opcional en C4; útil para desarrollo).

← [03-componentes.md](03-componentes.md) · [Índice](README.md)

---

## Estructura del paquete

```text
src/main/java/co/com/edtech/msgraph/
├── App.java          # main, parseo CLI, orquestación
├── Client.java       # GraphServiceClient, OAuth, proxy Netty/OkHttp
├── Mailbox.java      # Inbox, adjuntos, move well-known
└── Validator.java    # Validaciones de entrada
```

**Regla del proyecto:** no inventar quinta clase de dominio; extensiones van en estas cuatro o en scripts GFS.

---

## Mapa componente → archivo

| Componente C4 | Archivo | Líneas aprox. |
|---------------|---------|---------------|
| App | `App.java` | CLI, setters validados |
| Client | `Client.java` | `getClientBySecret`, `getClientByCertificate` |
| Mailbox | `Mailbox.java` | `readMailFolder`, `saveAttachment`, `moveMessage` |
| Validator | `Validator.java` | email, path, proxy, null checks |

Contexto agente: [`src/main/java/co/com/edtech/msgraph/CLAUDE.md`](../../src/main/java/co/com/edtech/msgraph/CLAUDE.md).

---

## Artefactos relacionados (fuera del JAR)

| Artefacto | Ruta repo | Ruta GFS |
|-----------|-----------|----------|
| Wrapper Sterling | `artifact/jar/app.5.4.0.sh` | `/gfssterling/jar/app.5.4.0.sh` |
| Config global | `artifact/jar/app.conf` | `/gfssterling/jar/app.conf` |
| Lista buzones | `artifact/jar/mail_list` | `/gfssterling/jar/mail_list` |
| Certificados | `artifact/jar/certs/` | `/gfssterling/jar/certs/` |

Paridad obligatoria `artifact/jar/` ↔ GFS en despliegue. Certificados: [`certs/README.md`](../../artifact/jar/certs/README.md).

---

## Build

- `pom.xml` — versión del JAR (ej. 5.4.3)
- `mvn package` / `./build.sh` — shade JAR
- Dependencias: `microsoft-graph`, `azure-identity`, `msal4j`

Ver [build/build-guide.md](../build/build-guide.md).

---

## Referencias

- API CLI: [support/api.md](../support/api.md)
- Contenedores: [02-contenedores.md](02-contenedores.md)
