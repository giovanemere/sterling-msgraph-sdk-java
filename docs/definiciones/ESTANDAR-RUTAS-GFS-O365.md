# Estándar de rutas GFS — O365 Graph (Colpatria lab)

Rutas de referencia en servidor **`192.168.137.190`**. Ajustar en otros ambientes manteniendo la misma forma lógica.

**Entregable en repo:** [`artifact/`](../../artifact/README.md) — contenido desplegable; `artifact/jar/` ↔ `/gfssterling/jar/`.

## Raíz

| Variable / concepto | Ruta |
|---------------------|------|
| `PathGFS` | `/gfssterling` |
| `PathJar` | `/gfssterling/jar` |
| `JARPATH` (en app.conf) | `/gfssterling/jar/5.0.0` |

## JAR y configuración

| Artefacto | Ruta |
|-----------|------|
| JAR activo | `/gfssterling/jar/5.0.0/O365InboxAttachmentToDisk-<version>.jar` |
| `app.conf` | `/gfssterling/jar/app.conf` |
| `FileJar` | Nombre archivo solo (ej. `O365InboxAttachmentToDisk-5.4.3.jar`) |
| Wrapper | `/gfssterling/jar/app.5.4.0.sh` |
| `mail_list` | `/gfssterling/jar/mail_list` |

## Salida de adjuntos

```text
/gfssterling/jar/mail-attachment/<WFID>/<dominio>/<usuario>/<archivo>
/gfssterling/jar/mail-attachment/<WFID>/ListF.xml
```

## Cifrado

| Artefacto | Ruta |
|-----------|------|
| CipherConsole | `/gfssterling/cipher/CipherConsole` |
| Clave maestra | `/gfssterling/cipher/clave.enc`, `llavecifrado.key` |
| Config cifrada por buzón | `/gfssterling/cipher/<nombre_base>.enc` |

## Certificados (carpeta canónica)

| Entorno | Raíz |
|---------|------|
| **GFS** | `/gfssterling/jar/certs/` |
| **Repo** | `artifact/jar/certs/` (paridad con GFS) |

| Uso | Ruta |
|-----|------|
| PEM Graph (`-certificate`) | `.../certs/account/<alias>-full.pem` |
| Cert público Entra | `.../certs/account/<alias>.crt` |
| Por cliente (opcional) | `.../certs/account/<cliente>/` (ej. `colpatria/`) |
| CAs Microsoft | `.../certs/microsoft/*.cer` |

Detalle y convenciones: [`artifact/jar/certs/README.md`](../../artifact/jar/certs/README.md).

**No versionar** claves privadas en Git (ver `.gitignore`).

## Java

| Uso | Ruta |
|-----|------|
| JRE 17 | `/gfssterling/java/temurin-jre-17.0.13` |

## Repo local (desarrollo)

| Artefacto | Ruta |
|-----------|------|
| Secretos | `<repo>/secrets.env` |
| JAR build | `<repo>/target/O365InboxAttachmentToDisk-*.jar` |
| Paridad scripts | `<repo>/artifact/jar/` |
| Certificados dev | `<repo>/artifact/jar/certs/account/` |
