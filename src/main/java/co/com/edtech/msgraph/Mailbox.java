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
    private final static String PROCESSED_FOLDER = "processed";
    private static String PATH;
    private final static Logger logger = LoggerFactory.getLogger(Mailbox.class);

    private static void moveMessage2Processed(GraphServiceClient client, Message mail){
        try {
            MailFolder processedFolder = getProcessedFolder(client);
            if (processedFolder != null) {
                moveMessage(client, mail, processedFolder);
                logger.info("Mensaje movido a carpeta processed: {}", mail.getSubject());
            } else {
                logger.warn("No se pudo mover el mensaje - carpeta processed no disponible");
            }
        } catch (Exception e) {
            logger.error("Error al mover mensaje a processed: {}", e.getMessage(), e);
            // Continuar procesamiento sin fallar completamente
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
            System.out.println(mailFolder);
            try {
                Files.createDirectories(Paths.get(PATH + mailFolder));
                System.out.println(PATH + mailFolder);
                saveAttachment(msg, PATH + mailFolder);
            } catch (IOException e) {
                //e.printStackTrace();
                logger.warn("Error guardando adjunto del correo: {}", msg.getSubject(), e);
            }
            
            // Intentar mover mensaje, pero continuar si falla
            try {
                moveMessage2Processed(client, msg);
            } catch (Exception e) {
                logger.error("Error moviendo mensaje '{}' a processed: {}", msg.getSubject(), e.getMessage());
                // Continuar con el siguiente mensaje
            }
        }
    }

    public static MailFolder getProcessedFolder(GraphServiceClient client){
        MailFolder processedFolder = null;
        try {
            // Intentar obtener la carpeta processed existente
            List<MailFolder> childFolders = Objects.requireNonNull(
                client.users().byUserId(USER_ID).mailFolders().byMailFolderId(INBOX).childFolders().get()
            ).getValue();
            
            if (childFolders != null) {
                processedFolder = childFolders.stream()
                    .filter(currentFolder -> PROCESSED_FOLDER.equalsIgnoreCase(currentFolder.getDisplayName()))
                    .findFirst()
                    .orElse(null);
            }
            
            // Si no se encuentra, intentar crearla
            if (processedFolder == null) {
                logger.info("Carpeta 'processed' no encontrada, intentando crear...");
                processedFolder = createChildFolder(client, USER_ID, INBOX, PROCESSED_FOLDER);
                logger.info("Carpeta 'processed' creada exitosamente");
            } else {
                logger.info("Carpeta 'processed' encontrada: {}", processedFolder.getId());
            }
            
        } catch (Exception e) {
            logger.error("Error al obtener/crear carpeta processed: {}", e.getMessage());
            // Si falla la creación porque ya existe, intentar buscarla nuevamente
            if (e.getMessage() != null && e.getMessage().contains("already exists")) {
                try {
                    Thread.sleep(1000); // Esperar un momento
                    List<MailFolder> retryFolders = Objects.requireNonNull(
                        client.users().byUserId(USER_ID).mailFolders().byMailFolderId(INBOX).childFolders().get()
                    ).getValue();
                    
                    if (retryFolders != null) {
                        processedFolder = retryFolders.stream()
                            .filter(folder -> PROCESSED_FOLDER.equalsIgnoreCase(folder.getDisplayName()))
                            .findFirst()
                            .orElse(null);
                    }
                } catch (Exception retryException) {
                    logger.error("Error en reintento: {}", retryException.getMessage());
                }
            }
        }

        if (processedFolder == null) {
            throw new RuntimeException("No se pudo obtener o crear la carpeta 'processed'");
        }

        return processedFolder;
    }

    public static MailFolder createChildFolder(GraphServiceClient client, String user, String parent, String folder){
        try {
            MailFolder mailFolder = new MailFolder();
            mailFolder.setDisplayName(folder);
            mailFolder.setIsHidden(Boolean.FALSE);
            MailFolder createdFolder = client.users().byUserId(user).mailFolders().byMailFolderId(parent).childFolders().post(mailFolder);
            logger.info("Carpeta '{}' creada exitosamente", folder);
            return createdFolder;
        } catch (Exception e) {
            logger.error("Error al crear carpeta '{}': {}", folder, e.getMessage());
            // Si la carpeta ya existe, intentar obtenerla
            if (e.getMessage() != null && e.getMessage().contains("already exists")) {
                logger.info("La carpeta '{}' ya existe, intentando obtenerla...", folder);
                try {
                    List<MailFolder> existingFolders = Objects.requireNonNull(
                        client.users().byUserId(user).mailFolders().byMailFolderId(parent).childFolders().get()
                    ).getValue();
                    
                    if (existingFolders != null) {
                        return existingFolders.stream()
                            .filter(f -> folder.equalsIgnoreCase(f.getDisplayName()))
                            .findFirst()
                            .orElse(null);
                    }
                } catch (Exception getException) {
                    logger.error("Error al obtener carpeta existente: {}", getException.getMessage());
                }
            }
            throw new RuntimeException("No se pudo crear o obtener la carpeta: " + folder, e);
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
        System.out.println("Writing file " + file.getName());
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
