# Arquitectura - Sterling Microsoft Graph SDK

## 🏗️ Visión General

Aplicación Java para procesar adjuntos de correos de Office 365 usando Microsoft Graph API, con arquitectura simplificada que usa únicamente carpetas well-known.

### 📊 Análisis del Código
- **Archivos Java**: 5 archivos principales
- **Framework**: Java puro + Microsoft Graph SDK
- **Tipo**: Aplicación batch standalone

## 📊 Diagrama de Arquitectura

```mermaid
graph TB
    subgraph "Office 365 Tenant"
        subgraph "Exchange Online"
            Inbox[Inbox<br/>Mensajes con adjuntos]
            WellKnown[Carpetas Well-Known<br/>deleteditems, sentitems, drafts]
        end
        
        subgraph "Azure AD"
            Auth[Authentication<br/>Client Credentials]
            Perms[Permissions<br/>Mail.ReadWrite]
        end
    end
    
    subgraph "☁️ Microsoft Graph API"
        GraphAPI[Graph Endpoint<br/>https://graph.microsoft.com/v1.0]
        MailAPI["Mail API<br/>users/{id}/mailFolders"]
        AttachAPI["📎 Attachments API<br/>messages/{id}/attachments"]
    end
    
    subgraph "Sterling Application"
        subgraph "Core Components"
            Main[Main<br/>Entry Point & CLI]
            Mailbox[Mailbox<br/>Mail Processing Logic]
            GraphClient[🔌 GraphServiceClient<br/>SDK Integration]
        end
        
        subgraph "Configuration"
            EnvConfig[Environment Variables<br/>PROCESSED_FOLDER=deleteditems]
            AuthConfig[Auth Config<br/>Tenant, Client, Secret]
        end
        
        subgraph "File System"
            LocalStorage[Local Storage<br/>Organized by domain/user]
            Attachments[Downloaded Files<br/>PDF, DOC, XLS, etc.]
        end
    end
    
    subgraph "Infrastructure"
        Proxy[Corporate Proxy<br/>Network Gateway]
        JVM[☕ Java Runtime<br/>JRE 17+]
    end
    
    %% Flow Connections
    Main --> EnvConfig
    Main --> AuthConfig
    Main --> GraphClient
    GraphClient --> Auth
    Auth --> GraphAPI
    GraphClient --> MailAPI
    GraphClient --> AttachAPI
    
    Mailbox --> GraphClient
    MailAPI --> Inbox
    MailAPI --> WellKnown
    AttachAPI --> Attachments
    Attachments --> LocalStorage
    
    GraphAPI --> Proxy
    Proxy --> JVM
    
    %% Styling
    classDef office fill:#0078d4,color:#fff,stroke:#005a9e,stroke-width:2px
    classDef graphStyle fill:#00bcf2,color:#fff,stroke:#0099cc,stroke-width:2px
    classDef app fill:#107c10,color:#fff,stroke:#0e6e0e,stroke-width:2px
    classDef config fill:#ff8c00,color:#fff,stroke:#cc7000,stroke-width:2px
    classDef storage fill:#5c2d91,color:#fff,stroke:#4a2374,stroke-width:2px
    classDef infra fill:#6c757d,color:#fff,stroke:#545862,stroke-width:2px
    
    class Inbox,WellKnown,Auth,Perms office
    class GraphAPI,MailAPI,AttachAPI graphStyle
    class Main,Mailbox,GraphClient app
    class EnvConfig,AuthConfig config
    class LocalStorage,Attachments storage
    class Proxy,JVM infra
```

## 🔄 Flujo de Procesamiento Actualizado

```mermaid
sequenceDiagram
    participant App as 🚀 Sterling App
    participant Graph as 🌐 Microsoft Graph
    participant Inbox as 📥 Inbox
    participant Dest as 🗂️ Carpeta Destino
    participant FS as 💾 File System
    
    App->>Graph: 🔐 Authenticate (Client Credentials)
    Graph-->>App: ✅ Access Token
    
    App->>Graph: 📧 Get messages with attachments
    Graph->>Inbox: 🔍 Filter: hasAttachments eq true
    Inbox-->>Graph: 📬 Messages list
    Graph-->>App: 📋 Messages with attachments
    
    loop For each message
        App->>Graph: 📎 Download attachments
        Graph-->>App: 💾 Attachment bytes
        App->>FS: 💾 Save to domain/user folder
        FS-->>App: ✅ File saved
        
        Note over App: getDestinationFolder()
        App->>Graph: 🗂️ Get well-known folder (deleteditems)
        Graph-->>App: ✅ Folder reference
        
        App->>Graph: 📧 Move to destination folder
        Graph->>Dest: 📧 Move message
        Note over Dest: Elementos eliminados<br/>Elementos enviados<br/>Borradores, etc.
        Dest-->>Graph: ✅ Message moved
        Graph-->>App: ✅ Operation complete
        
        Note over App: Log: "Mensaje movido a Elementos eliminados"
    end
```

## ✅ Características Clave Actualizadas

### 🎯 **Nomenclatura Clara**
- **Métodos descriptivos**: `getDestinationFolder()`, `moveMessageToDestinationFolder()`
- **Logging específico**: Muestra carpeta real (ej: "Elementos eliminados")
- **Variables claras**: `PROCESSED_FOLDER` configura carpeta destino

### 🗂️ **Scripts Organizados**
```
scripts/
├── build/          # compile.sh, check-hardcoded.sh
├── tests/          # test-*.sh, validate-solution.sh  
├── deployment/     # deploy.sh
├── verify-paths.sh # Verificador de rutas
└── fix-paths.sh   # Corrector automático
```

### 📊 **Logging Mejorado**
```bash
# Configuración
📁 Usando carpeta: Elementos eliminados

# Procesamiento  
📁 Obteniendo carpeta well-known: 'deleteditems' (Elementos eliminados)
✅ Carpeta 'deleteditems' obtenida: Deleted Items
📁 Mensaje movido a Elementos eliminados: Factura enero 2024
```

## 🚀 **Ventajas de la Arquitectura**
- ✅ **Confiable**: Usa infraestructura nativa de Office 365
- ✅ **Eficiente**: Sin overhead de creación/validación de carpetas
- ✅ **Mantenible**: Código simple y directo
- ✅ **Escalable**: Procesa cualquier volumen de mensajes
