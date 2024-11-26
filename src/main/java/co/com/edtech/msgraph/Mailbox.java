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
        MailFolder processedFolder = getProcessedFolder(client);
        moveMessage(client, mail, processedFolder);
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
            moveMessage2Processed(client, msg);
        }
    }

    public static MailFolder getProcessedFolder(GraphServiceClient client){
        MailFolder processedFolder;
        try {
            processedFolder = Objects.requireNonNull(Objects.requireNonNull(client.users().byUserId(USER_ID).mailFolders().byMailFolderId(INBOX).childFolders().get())
                    .getValue()).stream().filter(currentFolder -> PROCESSED_FOLDER.equals(currentFolder.getDisplayName())).findFirst().orElseThrow(NoSuchElementException::new);
            // System.out.println(processedFolder.getDisplayName());
        } catch (Exception e) {
            //e.printStackTrace();
            logger.error(e.getMessage(), e);
            processedFolder = createChildFolder(client, USER_ID, INBOX, PROCESSED_FOLDER);
        }

        return processedFolder; //!= null ? processedFolder : createChildFolder(client, USER_ID, INBOX, PROCESSED_FOLDER);
    }

    public static MailFolder createChildFolder(GraphServiceClient client, String user, String parent, String folder){
        MailFolder mailFolder = new MailFolder();
        mailFolder.setDisplayName(folder);
        mailFolder.setIsHidden(Boolean.FALSE);
        return client.users().byUserId(user).mailFolders().byMailFolderId(parent).childFolders().post(mailFolder);
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
