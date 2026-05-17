# Entregable de despliegue — `artifact/`

Carpeta **canónica** con todos los componentes **operativos** que se instalan o actualizan en el ambiente Sterling (GFS).  
El código Java vive en `src/` y se **compila** a JAR; lo que va a producción/lab se materializa bajo `artifact/` + el binario en `target/`.

| Documento | Contenido |
|-----------|-----------|
| [jar/CLAUDE.md](jar/CLAUDE.md) | Detalle ficheros en `jar/` |
| [jar/certs/README.md](jar/certs/README.md) | Certificados |
| [docs/implementacion/MANUAL-O365-GRAPH.md](../docs/implementacion/MANUAL-O365-GRAPH.md) §7 | Procedimiento despliegue |
| [docs/definiciones/ESTANDAR-RUTAS-GFS-O365.md](../docs/definiciones/ESTANDAR-RUTAS-GFS-O365.md) | Rutas GFS |

---

## Regla de oro

| En repo | En servidor GFS (lab Colpatria) |
|---------|----------------------------------|
| `artifact/jar/*` | `/gfssterling/jar/*` (misma forma relativa) |
| `artifact/jar/certs/*` | `/gfssterling/jar/certs/*` |
| `target/O365InboxAttachmentToDisk-<ver>.jar` | `/gfssterling/jar/5.0.0/O365InboxAttachmentToDisk-<ver>.jar` |

**Cambio operativo** → editar primero en `artifact/`, desplegar al GFS, luego reflejar en docs si aplica.

---

## Contenido del entregable

```text
artifact/
└── jar/                              → /gfssterling/jar/
    ├── app.conf                        # JARPATH, FileJar, JAVA_HOME, Netty
    ├── app.5.4.0.sh                    # Wrapper Sterling (producción)
    ├── app.5.4.0-debug.sh              # Igual con trazas
    ├── app.5.4.0-test-unit.sh          # Pruebas en host
    ├── mail_list                       # correo → alias Cipher (.enc)
    ├── 1.cifrar_configs.sh             # Genera plano para Cipher (estación)
    └── certs/                          # → /gfssterling/jar/certs/
        ├── README.md
        ├── account/                    # PEM/crt por buzón
        └── microsoft/                  # CAs referencia
```

### Incluido en el despliegue (desde `artifact/jar/`)

| Componente | Rol |
|------------|-----|
| `app.5.4.0.sh` | Punto de entrada del BP Sterling |
| `app.conf` | Rutas JAR, Java, Netty |
| `mail_list` | Índice buzón → archivo cifrado |
| `certs/` | Autenticación Graph por certificado |
| Scripts auxiliares | debug, test-unit, cifrado local |

### Compilado aparte (no está dentro de `artifact/`, pero es parte del release)

| Artefacto | Origen | Destino GFS |
|-----------|--------|-------------|
| `O365InboxAttachmentToDisk-<version>.jar` | `./build.sh` → `target/` | `/gfssterling/jar/5.0.0/` |
| Librerías Netty | Referenciadas en `app.conf` (`REPO`) | `/gfssterling/jar/5.0.0/jars/4.1.118/` |

### Infraestructura en servidor (no versionada en `artifact/`)

| Componente | Ruta GFS típica | Notas |
|------------|-----------------|-------|
| JRE 17 | `/gfssterling/java/temurin-jre-17.0.13` | Prerrequisito plataforma |
| CipherConsole | `/gfssterling/cipher/CipherConsole` | Cifrado config por buzón |
| `*.enc`, llaves maestras | `/gfssterling/cipher/` | Generados en servidor |
| Salida runtime | `/gfssterling/jar/mail-attachment/<WFID>/` | Creado por el batch |

---

## Checklist de despliegue

1. **Build:** `./build.sh` → JAR en `target/`.
2. **Revisar** `artifact/jar/app.conf` (`FileJar`, versión).
3. **Copiar JAR** a `/gfssterling/jar/5.0.0/` (scp).
4. **Sincronizar** contenido `artifact/jar/` → `/gfssterling/jar/` (scripts, `mail_list`, `app.conf`; no sobrescribir `mail-attachment/`).
5. **Certificados** en `artifact/jar/certs/account/` → mismo path en GFS (material sensible, no Git).
6. **Cipher:** `.enc` por buzón en `/gfssterling/cipher/` (ver manual §5).
7. **Smoke:** `app.5.4.0.sh "<correo>" "<WFID>"` o JAR sin args en servidor.

Ejemplo scp del árbol `jar/` (excluir material gitignored local si aplica):

```bash
export JASPER_SCP_BIN=/mnt/c/Windows/System32/OpenSSH/scp.exe
$JASPER_SCP_BIN -r artifact/jar/app.conf artifact/jar/app.5.4.0.sh artifact/jar/mail_list \
  sterling@192.168.137.190:/gfssterling/jar/
# certs y .enc: según política del banco (no siempre por scp masivo)
```

---

## Qué **no** es `artifact/`

| Ruta | Motivo |
|------|--------|
| `src/` | Código fuente — desarrollo |
| `docs/` | Documentación humana |
| `secrets.env` | Secretos estación de trabajo (gitignore) |
| `postman/` | Pruebas API, no producción |
| `target/` | Salida Maven — solo el JAR se despliega |

---

## Relación con el repo

```text
  src/ + pom.xml  ──build──►  target/*.jar  ──deploy──►  GFS .../5.0.0/
                                    ▲
  artifact/jar/  ──sync──────────────┴──►  GFS /gfssterling/jar/
```

Sterling BP solo invoca lo desplegado en GFS; el entregable operativo es **`artifact/` + JAR versionado**.
