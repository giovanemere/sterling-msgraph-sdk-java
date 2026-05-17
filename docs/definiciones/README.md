# Definiciones y glosario

| Término | Significado |
|---------|-------------|
| **WFID** | ID de flujo Sterling; subcarpeta bajo `mail-attachment/` |
| **well-known folder** | Carpeta Exchange con id fijo (`deleteditems`, `inbox`, …) |
| **PROCESSED_FOLDER** | Env var; carpeta destino del move (solo la lee el JAR) |
| **mail_list** | Mapa `correo@dominio=:nombre_base` → archivo `.enc` |
| **ListF.xml** | Lista XML de adjuntos generada por `app.5.4.0.sh` |
| **CipherConsole** | Utilidad GFS para encrypt/decrypt config por buzón |
| **certs/** | Carpeta canónica certificados: `artifact/jar/certs/` ↔ `/gfssterling/jar/certs/` |

Norma de rutas: [ESTANDAR-RUTAS-GFS-O365.md](ESTANDAR-RUTAS-GFS-O365.md). Certificados: [artifact/jar/certs/README.md](../../artifact/jar/certs/README.md).
