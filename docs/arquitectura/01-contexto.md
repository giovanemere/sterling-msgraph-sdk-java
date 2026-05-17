# C4 — Nivel 1: Diagrama de contexto

**Sistema en foco:** `O365InboxAttachmentToDisk` (solución on-prem en GFS).

**Audiencia:** negocio, arquitectura, operaciones MFT.

← [Índice C4](README.md) · Siguiente: [02-contenedores.md](02-contenedores.md)

---

## Diagrama

```mermaid
C4Context
  title Nivel 1 — Contexto del sistema O365 Graph + Sterling

  Person(operador, "Operador MFT", "Operación Sterling / soporte")
  Person(remitente, "Remitentes externos", "Envían correo con adjuntos al buzón")

  System(sterling, "IBM Sterling File Gateway", "BP invoca app.5.4.0.sh con correo + WFID")
  System(o365sol, "O365InboxAttachmentToDisk", "Descarga adjuntos y mueve mensajes en Exchange")
  System(m365, "Microsoft 365", "Entra ID + Exchange Online + Graph API")
  System(proxy, "Proxy corporativo", "Salida HTTPS hacia Graph y login.microsoftonline.com")

  Rel(operador, sterling, "Configura flujos, monitoriza")
  Rel(sterling, o365sol, "Ejecuta por transferencia", "shell + WFID")
  Rel(o365sol, m365, "Lee/mueve correo", "HTTPS / Graph REST")
  Rel(o365sol, proxy, "Opcional", "HTTP CONNECT")
  Rel(remitente, m365, "Correo con adjuntos")
  Rel(m365, o365sol, "Tokens OAuth2, mail API")
```

### Vista alternativa (flowchart)

Si el visor no renderiza `C4Context`:

```mermaid
flowchart TB
  subgraph Actores
    OP[Operador MFT]
    REM[Remitentes → buzón]
  end

  subgraph OnPrem["On-premises / GFS"]
    SFG[IBM Sterling SFG<br/>Business Process]
    SOL[O365InboxAttachmentToDisk<br/>GFS + JAR + Cipher]
    SFG -->|app.5.4.0.sh correo WFID| SOL
  end

  subgraph Cloud["Microsoft 365"]
    AAD[Microsoft Entra ID]
    EXO[Exchange Online]
    GR[Microsoft Graph API]
    AAD --> GR
    GR --> EXO
  end

  PROXY[Proxy corporativo]
  OP -.-> SFG
  REM --> EXO
  SOL -->|OAuth2 + Mail API| GR
  SOL -.-> PROXY
  GR -.-> PROXY
```

---

## Elementos del contexto

| Elemento | Tipo C4 | Rol en el negocio | En este flujo |
|----------|---------|-------------------|---------------|
| Operador MFT | Persona | Configura Sterling y GFS | `mail_list`, `.enc`, despliegue JAR |
| Remitentes externos | Persona | Envían correo al buzón | Dejan adjuntos en **Inbox** |
| IBM Sterling SFG | Sistema | Orquestador MFT | BP → shell; consume `ListF.xml` |
| O365InboxAttachmentToDisk | **Sistema** (caja) | Solución batch | Todo entre invocación shell y XML |
| Microsoft 365 | Sistema externo | Identidad + correo + API | Entra, Graph, Exchange |
| Proxy corporativo | Sistema externo | Salida HTTPS | Opcional |

---

## Relaciones principales

| Desde | Hacia | Descripción |
|-------|-------|-------------|
| Sterling | O365InboxAttachmentToDisk | Ejecuta `app.5.4.0.sh` con correo + WFID |
| O365InboxAttachmentToDisk | Microsoft 365 | OAuth2 + REST Graph (mail, attachments, move) |
| Remitentes | Microsoft 365 | Correo entrante con adjuntos |
| Operador | Sterling | Configuración y monitoreo de flujos |

---

## Límites de responsabilidad

- Sterling **no** llama a Graph directamente.
- Microsoft **no** escribe en GFS.
- La solución **no** crea carpetas custom bajo Inbox (solo **well-known** — [ADR-001](../decisions/ADR-001-carpetas-well-known-only.md)).

---

## Referencias

- Contenedores: [02-contenedores.md](02-contenedores.md)
- Secuencia E2E: [06-dinamica-e2e.md](06-dinamica-e2e.md)
