# C4 — Entornos y stack tecnológico

Comparación desarrollo / producción y tecnologías por capa.

← [Índice](README.md)

---

## Desarrollo vs producción

| Aspecto | Desarrollo | Producción GFS |
|---------|------------|----------------|
| Credenciales | `secrets.env` + `-secret` | `*.enc` + cert PEM |
| Invocación | `java -jar …` | `app.5.4.0.sh` |
| Salida | `./tmp-attachments/` | `mail-attachment/<WFID>/` |
| Sterling | No | BP + `ListF.xml` |
| Postman | `get-jwt.sh` | N/A |

---

## Stack tecnológico

| Capa | Tecnología |
|------|------------|
| Orquestación | IBM Sterling File Gateway (BP) |
| Shell / batch | `app.5.4.0.sh`, CipherConsole |
| Runtime | Eclipse Temurin JRE 17 |
| Aplicación | Java: App, Client, Mailbox, Validator |
| SDK | microsoft-graph 6.x, azure-identity, msal4j |
| Identidad | Entra ID — application permissions |
| API | Microsoft Graph v1.0 |
| Correo | Exchange Online |
| Build | Maven shade |
| Documentación | MkDocs + Mermaid C4 |

---

## Referencias

- Build: [build/build-guide.md](../build/build-guide.md)
- Uso y despliegue: [implementacion/MANUAL-O365-GRAPH.md](../implementacion/MANUAL-O365-GRAPH.md) §6–7
