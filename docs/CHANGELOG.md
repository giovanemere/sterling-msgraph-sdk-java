# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/).  
Histórico funcional detallado (v2.0 well-known, commits): **[HISTORICO-CAMBIOS.md](HISTORICO-CAMBIOS.md)**.

---

## [5.4.5] — 2026-05-17

### Fixed
- Paquete offline: `dependency:copy-dependencies` con scope **runtime** (incluye OpenTelemetry; corrige `NoClassDefFoundError: ImplicitContextKeyed`).
- `app.conf`: Netty tcnative **2.0.77.Final**, carpeta legacy `jars/4.1.133`.

---

## [5.4.4] — 2026-05-17

### Added
- Paquete offline: `scripts/build/sync-artifact-offline.sh` → `artifact/jar/jars/deps/` + JAR fino.
- Gate CI: `scripts/ci/o365-full-gate.sh`, deploy lab, perfiles proxy (`PROXY_HOST_WSL` / `PROXY_HOST_LAB`).

### Changed
- Netty **4.1.133**, Azure Identity **1.16.2**, Kiota **1.8.5**, commons-beanutils **1.11.0**.
- OWASP dependency-check: PASS con supresiones documentadas; `FAIL_ON_OWASP` opcional.
- `app.5.4.0.sh`: classpath `jars/deps` para servidor sin Internet.

### Fixed
- SpotBugs (0 bugs); validación proxy por IP; `App.validate` solo si `-host` definido.

### Deployed
- Lab Sterling `192.168.137.190`: JAR 5.4.4 + libs offline en `/gfssterling/jar/jars/deps/`.

---

## [5.4.3] — 2026-05

### Changed
- Dependencias Microsoft Graph / Azure Identity actualizadas.
- Documentación: manual único, índice, `secrets.env`, arquitectura Mermaid.

### Deployed
- Lab Sterling `192.168.137.190`: `/gfssterling/jar/5.0.0/O365InboxAttachmentToDisk-5.4.3.jar`.

---

## [5.4.1] — 2026-04

### Removed
- Clases duplicadas `AppEnhanced`, `MailboxEnhanced`.

### Changed
- Reorganización `docs/`, `scripts/`, Postman en `postman/`.

---

## [2.1] — 2026-04 / 2026-05

### Changed
- `moveMessage2Processed` → `moveMessageToDestinationFolder`
- `getProcessedFolder` → `getDestinationFolder`
- Logs con nombre real de carpeta (ej. "Elementos eliminados")
- Scripts: `scripts/build/compile.sh`, `run-tests.sh`, `verify-paths.sh`

---

## [2.0] — 2026-04-27

### Changed
- **Breaking:** ya no se crea carpeta `processed` bajo Inbox.
- Destino por `PROCESSED_FOLDER`; default `deleteditems`.
- Eliminados `createChildFolder()` y reintentos de creación.

### Removed
- ~90 líneas de gestión de carpetas personalizadas en `Mailbox.java`.

Ver commit `67b4547` y [HISTORICO-CAMBIOS.md](HISTORICO-CAMBIOS.md#v20--simplificación-carpetas-well-known-2026-04-27).

---

## [1.x] — Legacy

- Carpeta personalizada `processed` con creación/validación bajo Inbox.
- Documentación dispersa; sustituida por estructura `docs/` actual.
