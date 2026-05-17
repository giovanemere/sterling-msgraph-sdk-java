# Backlog y orden de implementación — O365InboxAttachmentToDisk

Documento **único** de planificación: orden sugerido, dependencias y definición de hecho.  
**Índice docs:** [`README.md`](../README.md) · **Manual:** [MANUAL-O365-GRAPH.md](MANUAL-O365-GRAPH.md).

---

## 1. Visión del entregable

| Capa | Entrega |
|------|---------|
| **Azure AD** | App registration, `Mail.ReadWrite` (application), admin consent, cert o secret |
| **JAR** | `O365InboxAttachmentToDisk-<version>.jar` en `/gfssterling/jar/5.0.0/` |
| **GFS config** | Entregable [`artifact/`](../../artifact/README.md): `jar/app.conf`, `mail_list`, `certs/` + `*.enc` en `/gfssterling/cipher/` |
| **Sterling** | BP/flujo invoca `app.5.4.0.sh` → `ListF.xml` + adjuntos por WFID |

**Constantes lab:** host `192.168.137.190`, usuario `sterling`, `FileJar` en `app.conf` alineado a `pom.xml`.

### Estado del plan (2026-05)

| Área | Estado |
|------|--------|
| Código v2 well-known + JAR 5.4.3 | Hecho |
| Manual + histórico + arquitectura Mermaid | Hecho |
| Despliegue lab JAR + E2E `app.5.4.0.sh` | Hecho (ver manual §7) |
| Postman alineado v2 (deleteditems) | Hecho **B-15** |
| CI gate (build + test) | Hecho **B-16** (`.github/workflows/o365-ci.yml`) |
| ADR + runbooks índice | Hecho **B-17** |
| Rotación secretos / certs fuera de Git | Operación **B-18** |

---

## 2. Orden de implementación (checklist)

Marcar **[x]** cuando cumpla validación mínima.

| # | Componente | Acción | Validar | ID | Listo |
|:-:|------------|--------|---------|:--:|:-----:|
| 0.1 | Repo y secretos | `secrets.env` desde example | `source scripts/load-secrets.sh` | B-01 | [x] |
| 0.2 | Build local | `./build.sh` | JAR en `target/` | B-02 | [x] |
| 1 | Azure AD app | Registrar + `Mail.ReadWrite` + consent | `get-jwt.sh` + HTTP 200 mailFolders | B-03 | [ ] |
| 2 | Acceso buzón app-only | Política Exchange si aplica | GET user/mailFolders OK | B-04 | [ ] |
| 3 | Certificado en Entra + GFS | Upload .cer + PEM en `artifact/jar/certs/account/` (GFS: `/gfssterling/jar/certs/`) | Auth por cert en lab | B-05 | [ ] |
| 4 | Cipher llave + `.enc` | SetupCipher + encrypt por buzón | decrypt OK en debug script | B-06 | [ ] |
| 5 | `mail_list` | Línea `correo=:nombre_base` | `app.5.4.0.sh` encuentra entrada | B-07 | [ ] |
| 6 | Despliegue JAR GFS | scp a `5.0.0/` | SHA256 local = remoto | B-08 | [x] |
| 7 | `app.conf` | `FileJar` = versión pom (5.4.3) | Smoke `Missing parameters` | B-09 | [x] |
| 8 | E2E Sterling | `app.5.4.0.sh correo WFID` | `ListF.xml` + logs deleteditems | B-10 | [x] |
| 9 | Unit tests | `mvn test` | Surefire green | B-11 | [x] |
| 10 | Integración remota | `test-permissions.sh` / Postman | Token + deleteditems | B-12 | [x] |

---

## 3. Backlog documentación y deuda técnica

| ID | Prioridad | Tarea | DoD | Estado |
|:--:|:---------:|-------|-----|:------:|
| B-13 | Alta | Manual único operativo | `MANUAL-O365-GRAPH.md` publicado | [x] |
| B-14 | Alta | Histórico v2.0 processed → deleteditems | `HISTORICO-CAMBIOS.md` + commit ref | [x] |
| B-15 | Media | Postman v2 deleteditems | Colección + `postman.md` alineados | [x] |
| B-16 | Media | GitHub Actions: `mvn test` + package; OWASP/SpotBugs en `main`/semanal | `.github/workflows/o365-ci.yml` | [x] |
| B-17 | Media | ADR-001 well-known | `docs/decisions/ADR-001-*.md` | [x] |
| B-18 | Alta | Secretos solo en `secrets.env` | Sin secrets en docs/Postman JSON | [x] |
| B-19 | Baja | `test-deleteditems.sh` flags CLI | Usar `-email` no `--mail-correo` | [x] |
| B-20 | Baja | Eliminar `*.backup` en `scripts/tests/` | Repo limpio | [x] |
| B-21 | Media | Skill + `scripts/deploy/deploy-lab.sh` | `.cursor/skills/` + deploy lab | [x] |
| B-22 | Baja | TechDocs validar `mkdocs build` | Sin enlaces rotos | [ ] |

---

## 4. Kanban por fase (referencia)

| Fase | IDs | Objetivo |
|------|-----|----------|
| **Fundamentos** | B-01–B-02 | Secretos + build |
| **Identity** | B-03–B-05 | Azure + cert |
| **GFS seguridad** | B-06–B-07 | Cipher + mail_list |
| **Deploy** | B-08–B-10 | JAR + E2E |
| **Calidad** | B-11–B-12, B-15–B-16 | Tests + Postman + CI |
| **Docs** | B-13–B-14, B-17–B-22 | Estructura Claude + mantenimiento |

---

## 5. Definición de hecho (DoD) global

1. JAR desplegado en lab con checksum verificado.  
2. `app.5.4.0.sh` exit 0 con WFID de prueba y `PROCESSED_FOLDER=deleteditems`.  
3. Documentación: manual + backlog + ADR; README enlaza índice.  
4. Sin secretos en archivos versionados.  
5. Cambios de comportamiento registrados en `HISTORICO-CAMBIOS.md`.

---

## 6. Enlaces

- [MANUAL-O365-GRAPH.md](MANUAL-O365-GRAPH.md)  
- [HISTORICO-CAMBIOS.md](../HISTORICO-CAMBIOS.md)  
- [arquitectura/README.md](../arquitectura/README.md)
