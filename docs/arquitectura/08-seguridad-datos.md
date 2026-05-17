# C4 — Vista: seguridad y datos sensibles

Flujo de credenciales (desarrollo vs producción GFS).

← [Índice](README.md) · Manual Cipher: [MANUAL-O365-GRAPH.md](../implementacion/MANUAL-O365-GRAPH.md) §5

---

## Diagrama

```mermaid
flowchart TB
  subgraph Dev["Estación desarrollo"]
    SE[secrets.env]
    PJ[postman/get-jwt.sh]
    SE --> PJ
  end

  subgraph GFS_sec["GFS — producción"]
    ML[mail_list]
    ENC["*.enc por buzón"]
    CC[CipherConsole]
    PEM["jar/certs/account/*-full.pem"]
    CL[clave.enc + llavecifrado.key]
    ML --> CC
    ENC --> CC
    CL --> CC
    CC -->|export vars| SH[app.5.4.0.sh]
    PEM --> JAR[Client cert credential]
  end

  subgraph Entra["Entra ID"]
    APP[App registration]
    CSEC[Client secret lab]
    CER[Cert público]
    APP --> CSEC
    APP --> CER
  end

  PEM -.->|clave pública| CER
  CSEC -.->|solo dev| SE
```

---

## Artefactos

| Artefacto | Ubicación | Uso |
|-----------|-----------|-----|
| `secrets.env` | Repo local (gitignore) | Dev, Postman |
| `mail_list` | `/gfssterling/jar/` | Correo → alias cipher |
| `<alias>.enc` | `/gfssterling/cipher/` | Config cifrada |
| `*-full.pem` | `/gfssterling/jar/certs/account/` (repo: `artifact/jar/certs/account/`) | Auth cert Graph |
| CAs | `.../certs/microsoft/` | Referencia TLS Microsoft |
| Cert en Entra | Azure Portal | Clave pública registrada |

**Regla:** no commitear secretos. Producción usa Cipher + PEM, no `secrets.env` en servidor.

---

## Referencias

- Integraciones OAuth: [09-integraciones.md](09-integraciones.md)
- Despliegue: [05-despliegue.md](05-despliegue.md)
