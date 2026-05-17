# Arquitectura — modelo C4

Documentación estructurada según el [modelo C4](https://c4model.com/): **contexto → contenedores → componentes → código**, más **vistas complementarias** (despliegue, dinámicas, seguridad, integraciones).

**Sistema documentado:** `O365InboxAttachmentToDisk` — batch Sterling + GFS + Microsoft Graph.

Versión JAR: `pom.xml`. Manual: [MANUAL-O365-GRAPH.md](../implementacion/MANUAL-O365-GRAPH.md).

---

## Resumen ejecutivo

1. Un **Business Process** de Sterling invoca `app.5.4.0.sh` con buzón y **WFID**.
2. El shell desencripta config por buzón (**CipherConsole**) y lanza el **JAR**.
3. El JAR obtiene token OAuth2, descarga adjuntos del **Inbox** y mueve mensajes a carpeta **well-known** (default `deleteditems`).
4. El shell genera **`ListF.xml`** para que Sterling continúe el MFT.

---

## Niveles C4 (estáticos)

| Nivel | Vista C4 | Documento | Alcance |
|-------|----------|-----------|---------|
| **1** | Diagrama de contexto | [01-contexto.md](01-contexto.md) | Actores y sistemas externos |
| **2** | Diagrama de contenedores | [02-contenedores.md](02-contenedores.md) | Shell, Cipher, JAR, GFS, M365 |
| **3** | Diagrama de componentes | [03-componentes.md](03-componentes.md) | `App`, `Client`, `Mailbox`, `Validator` |
| **4** | Diagrama de código | [04-codigo.md](04-codigo.md) | Paquete Java, artefactos, enlaces al repo |

Zoom in: cada nivel amplía el anterior (mismo sistema, más detalle).

---

## Vistas complementarias C4

| Vista | Documento | Contenido |
|-------|-----------|-----------|
| **Despliegue** | [05-despliegue.md](05-despliegue.md) | Árbol `/gfssterling`, nodos físicos/lógicos |
| **Dinámica E2E** | [06-dinamica-e2e.md](06-dinamica-e2e.md) | Secuencia Sterling → Graph → GFS (paso 1–11) |
| **Dinámica dominio** | [07-dinamica-exchange.md](07-dinamica-exchange.md) | Estados Inbox → well-known |
| **Seguridad / datos** | [08-seguridad-datos.md](08-seguridad-datos.md) | `secrets.env`, Cipher, certificados Entra |
| **Integraciones** | [09-integraciones.md](09-integraciones.md) | Protocolos y contratos entre piezas |
| **Entornos** | [10-entornos-stack.md](10-entornos-stack.md) | Dev vs producción, stack tecnológico |

---

## Decisiones y requisitos (fuera del C4)

| Documento | Rol |
|-----------|-----|
| [design/requirements.md](../design/requirements.md) | RF/RNF |
| [design/decisions.md](../design/decisions.md) | Resumen decisiones |
| [decisions/ADR-001](../decisions/ADR-001-carpetas-well-known-only.md) | Solo carpetas well-known |
| [definiciones/ESTANDAR-RUTAS-GFS-O365.md](../definiciones/ESTANDAR-RUTAS-GFS-O365.md) | Nomenclatura GFS |
| [HISTORICO-CAMBIOS.md](../HISTORICO-CAMBIOS.md) | v2.0 sin carpeta `processed` |

---

## Mapa de zoom (C4)

```text
[Nivel 1 Contexto]     Sterling, M365, operador, remitentes
        ↓
[Nivel 2 Contenedores] shell, Cipher, JAR, Entra, Graph, Exchange, GFS
        ↓
[Nivel 3 Componentes] App → Client / Mailbox / Validator
        ↓
[Nivel 4 Código]       src/.../msgraph/*.java, artifact/jar/
```

Vistas **despliegue** y **dinámicas** cortan los niveles para explicar *dónde* corre y *cuándo* ocurre cada paso.
