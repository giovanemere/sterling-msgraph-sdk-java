# Contexto — paquete `co.com.edtech.msgraph`

## Clases (solo estas cuatro)

| Clase | Rol |
|-------|-----|
| `App` | `main`, CLI (rule switch), `Client.resolve`, `Mailbox.readMailFolder` |
| `Client` | `GraphServiceClient`, `Client.resolve(...)` |
| `Mailbox` | Inbox + adjuntos + move a well-known |
| `Validator` | Email, paths, proxy |

## Env y destino post-proceso

| Nombre | Uso |
|--------|-----|
| `PROCESSED_FOLDER` | Solo **nombre** de variable de entorno (`System.getenv`) |
| `destinationWellKnownFolder` | Campo estático en `Mailbox` (default `deleteditems`) |

No confundir ambos nombres en código Java.

## CLI

Ver [docs/support/api.md](../../../../docs/support/api.md). Flags `-email`, `-dir`, `-tenant` — no `--nombre`.

## Tests

`src/test/java/co/com/edtech/msgraph/*Test.java`
