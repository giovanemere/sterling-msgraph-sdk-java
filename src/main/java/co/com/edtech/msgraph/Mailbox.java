package co.com.edtech.msgraph;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;

import com.microsoft.graph.serviceclient.GraphServiceClient;
import com.microsoft.graph.models.Attachment;
import com.microsoft.graph.models.FileAttachment;
import com.microsoft.graph.models.MailFolder;
import com.microsoft.graph.models.Message;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Mailbox {
    private static String USER_ID;
    private final static String INBOX = "inbox";
    private static String PROCESSED_FOLDER = "deleteditems"; // Por defecto elementos eliminados
    private static String PATH;
    private final static Logger logger = LoggerFactory.getLogger(Mailbox.class);

    private static void moveMessageToDestinationFolder(GraphServiceClient client, Message mail){
        try {
            MailFolder destinationFolder = getDestinationFolder(client);
            if (destinationFolder != null) {
                moveMessage(client, mail, destinationFolder);
                logger.info("📁 Mensaje movido a {}: {}", 
                           getWellKnownFolderDisplayName(PROCESSED_FOLDER),
                           mail.getSubject() != null ? mail.getSubject() : "Sin asunto");
            } else {
                logger.warn("⚠️ Carpeta {} no disponible, continuando...", getWellKnownFolderDisplayName(PROCESSED_FOLDER));
            }
        } catch (Exception e) {
            logger.warn("⚠️ No se pudo mover mensaje: {}", e.getMessage());
            // Continuar procesamiento sin fallar
        }
    }

    private static void moveMessage (GraphServiceClient client, Message mail, MailFolder folder){
        moveMessage(client, mail.getId(), folder.getId());
    }
    private static void  moveMessage (GraphServiceClient client, String messageId, String folderId){
        com.microsoft.graph.users.item.messages.item.move.MovePostRequestBody movePostRequestBody = new com.microsoft.graph.users.item.messages.item.move.MovePostRequestBody();
        movePostRequestBody.setDestinationId(folderId);
        client.users().byUserId(USER_ID).messages().byMessageId(messageId).move().post(movePostRequestBody);
        // System.out.println(result.getFrom());
    }

    public static void readMailFolder(GraphServiceClient client, MailFolder myFolder){
        readMailFolder(client, myFolder.getId());
    }

    public static void readMailFolder(GraphServiceClient client, String myFolderId, String destinationPath){
        Mailbox.PATH = destinationPath;
        readMailFolder(client, myFolderId);
    }

    public static void readMailFolder(GraphServiceClient client, String myFolderId, String destinationPath, String email){
        Mailbox.USER_ID = email;
        
        // Configurar carpeta destino desde variable de entorno
        String processedFolderName = System.getenv("PROCESSED_FOLDER");
        if (processedFolderName != null && !processedFolderName.trim().isEmpty()) {
            PROCESSED_FOLDER = processedFolderName.trim();
        } else {
            PROCESSED_FOLDER = "deleteditems"; // Por defecto usar carpeta eliminados
        }
        
        if (isWellKnownFolder(PROCESSED_FOLDER)) {
            logger.info("📁 Usando carpeta: {}", getWellKnownFolderDisplayName(PROCESSED_FOLDER));
        } else {
            throw new RuntimeException("❌ Solo se permiten carpetas well-known. Configurar PROCESSED_FOLDER con: deleteditems, sentitems, drafts, junkemail");
        }
        
        readMailFolder(client, myFolderId, destinationPath);
    }
    public static void readMailFolder(GraphServiceClient client, String myFolderId){
        String mailFolder;
        List<Message> messages = Objects.requireNonNull(client.users().byUserId(USER_ID).mailFolders().byMailFolderId(myFolderId).messages().get(
                requestConfiguration -> {
                    assert requestConfiguration.queryParameters != null;
                    requestConfiguration.queryParameters.filter = "hasAttachments eq true";
                    requestConfiguration.queryParameters.expand = new String[]{"attachments"};
                }
        )).getValue();
        // System.out.println(messages.size());
        if(messages == null)
            return;
        for(Message msg: messages){
            //System.out.println(msg.getSubject());
            mailFolder =getSubfolderFromMailAddress(Objects.requireNonNull(Objects.requireNonNull(msg.getFrom()).getEmailAddress()).getAddress());
            logger.info("📁 Carpeta destino: {}", mailFolder);
            try {
                Files.createDirectories(Paths.get(PATH + mailFolder));
                logger.info("📂 Ruta creada: {}", PATH + mailFolder);
                saveAttachment(msg, PATH + mailFolder);
            } catch (IOException e) {
                //e.printStackTrace();
                logger.warn("Error guardando adjunto del correo: {}", msg.getSubject(), e);
            }
            
            // Intentar mover mensaje, pero continuar si falla
            try {
                moveMessageToDestinationFolder(client, msg);
            } catch (Exception e) {
                logger.error("Error moviendo mensaje '{}' a {}: {}", msg.getSubject(), getWellKnownFolderDisplayName(PROCESSED_FOLDER), e.getMessage());
                // Continuar con el siguiente mensaje
            }
        }
    }



    public static MailFolder getDestinationFolder(GraphServiceClient client){
        try {
            if (isWellKnownFolder(PROCESSED_FOLDER)) {
                logger.info("📁 Obteniendo carpeta well-known: '{}' ({})", PROCESSED_FOLDER, getWellKnownFolderDisplayName(PROCESSED_FOLDER));
                MailFolder folder = client.users().byUserId(USER_ID).mailFolders().byMailFolderId(PROCESSED_FOLDER).get();
                logger.info("✅ Carpeta '{}' obtenida: {}", PROCESSED_FOLDER, folder.getDisplayName());
                return folder;
            } else {
                throw new RuntimeException("❌ Solo se permiten carpetas well-known. Configurar PROCESSED_FOLDER con: deleteditems, sentitems, drafts, junkemail");
            }
        } catch (Exception e) {
            throw new RuntimeException("❌ Error obteniendo carpeta '" + PROCESSED_FOLDER + "': " + e.getMessage());
        }
    }

    /**
     * Verifica si el nombre de carpeta corresponde a una carpeta well-known de Office 365
     */
    private static boolean isWellKnownFolder(String folderName) {
        return "inbox".equalsIgnoreCase(folderName) ||
               "sentitems".equalsIgnoreCase(folderName) ||
               "drafts".equalsIgnoreCase(folderName) ||
               "deleteditems".equalsIgnoreCase(folderName) ||
               "junkemail".equalsIgnoreCase(folderName) ||
               "outbox".equalsIgnoreCase(folderName);
    }

    /**
     * Obtiene el nombre descriptivo de una carpeta well-known
     */
    private static String getWellKnownFolderDisplayName(String folderName) {
        switch (folderName.toLowerCase()) {
            case "inbox": return "Bandeja de entrada";
            case "sentitems": return "Elementos enviados";
            case "drafts": return "Borradores";
            case "deleteditems": return "Elementos eliminados";
            case "junkemail": return "Correo no deseado";
            case "outbox": return "Bandeja de salida";
            default: return folderName;
        }
    }



    private static void saveAttachment(Message msg, String folderPath) throws IOException{
        List<Attachment> items = msg.getAttachments();

        if(Boolean.FALSE.equals(msg.getHasAttachments()) || items == null)
            return;

        for(Attachment item : items){
            //System.out.println(item instanceof FileAttachment);
            if(item instanceof FileAttachment){
                saveFileAttachment((FileAttachment) item, folderPath);
            }
        }
    }

    private static void saveFileAttachment(FileAttachment file, String folderPath) throws IOException{
        if(file.getContentBytes() == null)
            return;
        logger.info("📄 Escribiendo archivo: {}", file.getName());
        Files.write(Paths.get(folderPath + file.getName()), file.getContentBytes(), StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
    }

    private static String getSubfolderFromMailAddress(String mailAddress){
        int index;
        if(mailAddress == null || mailAddress.replaceAll(" ", "").isEmpty() || !mailAddress.contains("@"))
            return "";
        index = mailAddress.indexOf("@");
        return mailAddress.substring(index+1) + "/" + mailAddress.substring(0, index) + "/";
    }
}
