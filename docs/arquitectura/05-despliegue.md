# C4 — Vista de despliegue

**Dónde** se ejecutan los contenedores (servidor GFS y servicios cloud).

← [Índice](README.md) · Entregable: [artifact/README.md](../../artifact/README.md) · Rutas: [ESTANDAR-RUTAS-GFS-O365.md](../definiciones/ESTANDAR-RUTAS-GFS-O365.md)

---

## Diagrama de despliegue (GFS)

```mermaid
flowchart TD
  root["/gfssterling"]

  root --> jar["/jar"]
  root --> cipher["/cipher"]
  root --> java["/java/temurin-jre-17.0.13"]

  jar --> conf["app.conf"]
  jar --> sh["app.5.4.0.sh"]
  jar --> ml["mail_list"]
  jar --> certs["certs/account · certs/microsoft"]
  jar --> v5["5.0.0/O365InboxAttachmentToDisk-*.jar"]
  jar --> netty["5.0.0/jars/4.1.118/*.jar"]
  jar --> out["mail-attachment/WFID/domain/user/files"]
  jar --> xml["mail-attachment/WFID/ListF.xml"]

  cipher --> cc["CipherConsole"]
  cipher --> enc["sfg_*.enc"]
  cipher --> keys["clave.enc · llavecifrado.key"]
```

---

## Nodos

| Nodo | Rol |
|------|-----|
| **Servidor GFS** (lab `192.168.137.190`) | Host único on-prem: shell, JAR, Cipher, salida |
| **Microsoft 365** | Entra + Graph + Exchange (SaaS) |
| **Estación desarrollo** | Build Maven, `secrets.env`, pruebas locales |
| **Proxy corporativo** | Opcional en ruta salida |

---

## Rutas y contenedores

| Ruta GFS | Contenedor / artefacto |
|----------|-------------------------|
| `/gfssterling/jar/app.conf` | Config shell |
| `/gfssterling/jar/app.5.4.0.sh` | Shell |
| `/gfssterling/jar/mail_list` | Mapa buzón → cipher |
| `/gfssterling/jar/5.0.0/*.jar` | JAR + Netty |
| `/gfssterling/jar/certs/` | Certificados canónicos (`account/`, `microsoft/`) — [README](../../artifact/jar/certs/README.md) |
| `/gfssterling/cipher/` | CipherConsole, `.enc` |
| `/gfssterling/jar/mail-attachment/<WFID>/` | Salida batch |
| `/gfssterling/java/...` | JRE 17 |

---

## Referencias

- Manual despliegue: [implementacion/MANUAL-O365-GRAPH.md](../implementacion/MANUAL-O365-GRAPH.md) §7
- Contenedores: [02-contenedores.md](02-contenedores.md)
