# Runbooks — índice operativo

Procedimientos en producción/lab. El contenido detallado está en el [manual](../implementacion/MANUAL-O365-GRAPH.md); aquí solo enlaces por escenario.

| Escenario | Manual § | Comandos clave |
|-----------|----------|----------------|
| Rotar client secret Azure | §4.4 | Entra portal → `secrets.env` → re-cifrar `.enc` |
| Alta nuevo buzón | §5.1, §5.2 | `mail_list` + llave Cipher + `.enc` |
| Desplegar JAR nueva versión | §7.2 | `./build.sh` + scp + SHA256 |
| Ejecutar transferencia Sterling | §7.3 | `app.5.4.0.sh "<correo>" "<WFID>"` |
| Fallo 403 Graph | §10 + [troubleshooting](../support/troubleshooting.md) | Admin consent, Mail.ReadWrite |
| Fallo decrypt Cipher | §5.5, §10 | `clave.enc`, nombre llave, `mail_list` |
| Cambiar carpeta destino mensajes | §8 | `export PROCESSED_FOLDER=sentitems` |
| Prueba sin Sterling (dev) | §6 | `java -jar … -secret …` |

**Lab SSH (WSL2):** `JASPER_SSH_BIN=/mnt/c/Windows/System32/OpenSSH/ssh.exe`, host `192.168.137.190`.

**Checklist post-cambio:** [MANUAL-O365-GRAPH.md §11](../implementacion/MANUAL-O365-GRAPH.md).
