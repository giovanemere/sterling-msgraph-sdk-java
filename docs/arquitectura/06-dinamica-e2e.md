# C4 — Vista dinámica: flujo E2E

**Cuándo** ocurre cada interacción entre contenedores (Sterling → Graph → GFS).

← [Índice](README.md) · Contexto: [01-contexto.md](01-contexto.md)

---

## Diagrama de secuencia

```mermaid
sequenceDiagram
  autonumber
  box Sterling / GFS
    participant BP as Sterling BP
    participant SH as app.5.4.0.sh
    participant CC as CipherConsole
    participant JAR as App + Mailbox
    participant FS as GFS mail-attachment
  end
  box Microsoft 365
    participant EN as Entra ID
    participant GR as Graph API
    participant MB as Buzón Exchange
  end

  BP->>SH: ./app.5.4.0.sh correo WFID
  SH->>SH: load app.conf
  SH->>SH: lookup mail_list
  SH->>CC: decrypt → *_out
  CC-->>SH: client, tenant, cert, proxy
  SH->>SH: rm *_out
  SH->>JAR: java -cp … App -certificate … -dir pathd/

  JAR->>EN: POST token
  EN-->>JAR: access_token
  JAR->>GR: GET inbox/messages hasAttachments
  GR->>MB: query
  MB-->>GR: messages[]
  GR-->>JAR: messages[]

  loop Por cada mensaje con adjunto
    JAR->>FS: guardar domain/user/archivo
    JAR->>GR: GET mailFolders/deleteditems
    JAR->>GR: POST messages/{id}/move
    GR->>MB: mover a well-known
  end

  SH->>FS: generar ListF.xml
  SH-->>BP: exit 0 + XML
```

---

## Paso a paso

| # | Quién | Acción |
|---|--------|--------|
| 1 | Sterling BP | `./app.5.4.0.sh "<correo>" "<WFID>"` |
| 2 | Shell | Lee `app.conf` |
| 3 | Shell | Resuelve buzón en `mail_list` |
| 4 | CipherConsole | Decrypt `<alias>.enc` |
| 5 | Shell | Borra `*_out`; arma classpath |
| 6 | JAR / Client | Token OAuth2 |
| 7 | JAR / Mailbox | GET Inbox con adjuntos |
| 8 | JAR / Mailbox | Escribe ficheros en GFS |
| 9 | JAR / Mailbox | Move a well-known |
| 10 | Shell | Genera `ListF.xml` |
| 11 | Sterling BP | Continúa flujo MFT |

---

## Resultados esperados

- **Exchange:** mensajes fuera de Inbox (default **deleteditems**).
- **GFS:** `mail-attachment/<WFID>/` + `ListF.xml`.

Histórico carpeta `processed`: [HISTORICO-CAMBIOS.md](../HISTORICO-CAMBIOS.md).

---

## Referencias

- Estados correo: [07-dinamica-exchange.md](07-dinamica-exchange.md)
- Componentes: [03-componentes.md](03-componentes.md)
