# Certificados — carpeta canónica

**Única carpeta** de material criptográfico del proyecto (repo y paridad GFS).

| Entorno | Ruta |
|---------|------|
| **Repositorio (desarrollo)** | `artifact/jar/certs/` |
| **GFS producción / lab** | `/gfssterling/jar/certs/` |

Configurar en `secrets.env`: `PRIVATE_CERTIFICATE` → PEM usado por `-certificate` del JAR.  
Ver también: [docs/definiciones/ESTANDAR-RUTAS-GFS-O365.md](../../../docs/definiciones/ESTANDAR-RUTAS-GFS-O365.md).

---

## Estructura

```text
certs/
├── README.md                 ← este archivo (versionado)
├── account/                  ← certificados cliente Entra (app registration)
│   ├── <buzón>-full.pem      ← cadena + clave para Graph (CLI -certificate)
│   ├── <buzón>.crt           ← certificado público
│   ├── <buzón>.key           ← clave privada (NO Git)
│   ├── ca.crt, intermedia.cer
│   └── <cliente>/            ← opcional: agrupar por convénio (ej. colpatria/)
│       └── sadbogca591-full.pem
└── microsoft/                ← CAs / raíces Microsoft (referencia TLS)
    ├── developer.microsoft.com.cer
    └── DigiCert Global Root G3.cer
```

---

## Convenciones de nombres

| Archivo | Uso |
|---------|-----|
| `<alias>-full.pem` | **Producción Graph** — ruta en config cifrada `privateCertificate` y `PRIVATE_CERTIFICATE` |
| `<alias>.crt` | Subir clave **pública** a Entra → Certificates & secrets |
| `<alias>.key` | Clave privada suelta (si no va solo en el PEM) |
| `*-ca.cer`, `intermedia.cer` | Cadena intermedia / CA |

`<alias>` suele alinearse con el dominio del buzón o el nombre en `mail_list` / Cipher (`correo:alias`).

---

## Flujo

1. Generar o exportar cert cliente para la app en Entra ID.
2. Colocar PEM operativo en `account/<alias>-full.pem` (repo local o GFS).
3. Registrar `.crt` (público) en portal Azure.
4. `secrets.env`: `PRIVATE_CERTIFICATE=artifact/jar/certs/account/<alias>-full.pem` (ruta relativa al repo) o ruta absoluta en GFS.
5. `1.cifrar_configs.sh` / Cipher: `privateCertificate` y `certificatePassword` en el `.enc` del buzón.

---

## Git

**No commitear** claves ni PEM con material privado. `.gitignore` excluye `*.key`, `*.pem`, `*.p12`, `*.pkcs8`, `*.crt`, `*.cer` bajo `certs/`.  
Sí se versionan: este `README.md` y `.gitkeep` en subcarpetas.

---

## Variables (`secrets.env` / shell)

| Variable | Descripción |
|----------|-------------|
| `PRIVATE_CERTIFICATE` | Ruta al `*-full.pem` |
| `CERTIFICATE_PASSWORD` | Password del PKCS#12 / PEM si aplica |
| `O365_CERTS_ROOT` | Opcional; default `artifact/jar/certs` (exporta `load-secrets.sh`) |
| `O365_CERTS_ACCOUNT` | Opcional; default `$O365_CERTS_ROOT/account` |
