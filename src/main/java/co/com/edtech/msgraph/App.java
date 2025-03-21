package co.com.edtech.msgraph;

import com.microsoft.graph.serviceclient.GraphServiceClient;
import org.apache.commons.validator.routines.EmailValidator;

import jakarta.mail.internet.AddressException;
import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class App {
    public static String FOLDER_ID = "Inbox";
    private String email;
    private String destinationFilePath;
    private String tenantId;
    private String clientId;

    private String clientSecret;
    private String certificateFilePath;

    private String certificatePassword;
    private String proxyHost;
    private int proxyPort;

    public App() {
        // Data
        this.email = null;
        this.destinationFilePath = "";
        // Connection
        this.clientId = "";
        this.tenantId = "";
        this.clientSecret = "";
        this.certificateFilePath = "";
        //Proxy
        this.proxyHost = "";
        this.proxyPort = -1;
    }

    public String getCertificatePassword() {
        return certificatePassword;
    }

    public void setCertificatePassword(String setClientCertificatePassword) {
        this.certificatePassword = setClientCertificatePassword;
    }

    public String getCertificateFilePath() {
        return certificateFilePath;
    }

    public void setCertificateFilePath(String certificateFilePath) {
        if(Validator.isNullOrEmpty(certificateFilePath) || !Validator.validatePath(certificateFilePath))
            throw new IllegalArgumentException("Ruta invalida: " + certificateFilePath );
        this.certificateFilePath = certificateFilePath;
    }

    public String getProxyHost() {
        return proxyHost;
    }

    public void setProxyHost(String proxyHost) {
        this.proxyHost = proxyHost;
    }

    public int getProxyPort() {
        return proxyPort;
    }

    public void setProxyPort(int proxyPort) {
        this.proxyPort = proxyPort;
    }


    public String getClientSecret() {
        return clientSecret;
    }

    public void setClientSecret(String clientSecret) {
        if(Validator.isNullOrEmpty(clientSecret))
            throw new IllegalArgumentException();
        this.clientSecret = clientSecret;
    }

    public String getClientId() {
        return clientId;
    }

    public void setClientId(String clientId) {
        if(Validator.isNullOrEmpty(clientId))
            throw new IllegalArgumentException();
        this.clientId = clientId;
    }

    public String getTenantId() {
        return tenantId;
    }

    public void setTenantId(String tenantId) {
        if(Validator.isNullOrEmpty(tenantId))
            throw new IllegalArgumentException();
        this.tenantId = tenantId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) throws AddressException {
        if(! EmailValidator.getInstance().isValid(email)){
            throw new jakarta.mail.internet.AddressException();
        }
        this.email = email;
    }

    public String getDestinationFilePath() {
        return destinationFilePath;
    }

    public void setDestinationFilePath(String destinationFilePath) {
        if(Validator.isNullOrEmpty(destinationFilePath) || !Validator.validatePath(destinationFilePath))
            throw new IllegalArgumentException("Ruta invalida " + destinationFilePath);

        this.destinationFilePath = destinationFilePath;
    }


    private void setParams(String option, String value) throws AddressException, NoSuchFieldException {
        switch (option) {
            case "-e":
            case "-email":
                this.setEmail(value);
                break;
            case "-d":
            case "-dir":
                this.setDestinationFilePath(value);
                break;
            case "-tenant":
                this.setTenantId(value);
                break;
            case "-client":
                this.setClientId(value);
                break;
            case "-secret":
                this.setClientSecret(value);
                break;
            case "-p":
            case "-port":
            case "--proxy-port":
                this.setProxyPort(Integer.parseInt(value));
                break;
            case "-h":
            case "-host":
            case "--proxy-host":
                this.setProxyHost(value);
                break;
            case "-c":
            case "-certificate":
            case "-privateCertificate":
            case "--certificate-path":
                this.setCertificateFilePath(value);
                break;
            case "-certificatePassword":
            case "-certpwd":
            case "--client-certificate-password":
                this.setCertificatePassword(value);
                break;
            default:
                throw new NoSuchFieldException("Argument not defined" + option);
        }

    }

    public void init(String[] args) throws IOException,IllegalArgumentException, NoSuchFieldException, AddressException {
        int size = args.length;
        int i = 0;
        if (size % 2 == 1) {
            throw new IOException("Wrong input parameters, please check");
        } else {
            while(i < size && args[i].startsWith("-")) {
                String option = args[i];
                ++i;
                String value = args[i];
                this.setParams(option, value);
                ++i;
            }

        }
    }

    public void validate() throws IOException{
        if( Validator.isNullOrEmpty(this.getClientId())
             || Validator.isNullOrEmpty(this.getTenantId())
             || Validator.isNullOrEmpty(this.getEmail())
             || Validator.isNullOrEmpty(this.getDestinationFilePath()) 
             || ( Validator.isNullOrEmpty(this.getClientSecret()) && Validator.isNullOrEmpty(this.getCertificateFilePath()))
             || (!Validator.isNullOrEmpty(this.getCertificateFilePath()) && Validator.isNullOrEmpty(this.getCertificatePassword()))
        )
            throw new IOException("Missing parameters");

        if(!Validator.isNullOrEmpty(this.getProxyHost()) || Validator.isValidPort(this.getProxyPort()))
            if(!Validator.validateProxy(this.getProxyHost(), this.getProxyPort()))
                throw new IOException("Wrong Proxy parameters");
    }

    private GraphServiceClient getSecretClient() throws Exception {
        if(this.getProxyPort() > 0)
            return Client.getClientBySecret(
                    this.getClientId(),
                    this.getTenantId(),
                    this.getClientSecret(),
                    this.getProxyHost(),
                    this.getProxyPort());

        return Client.getClientBySecret(this.getClientId(), this.getTenantId(), this.getClientSecret());
    }

    private GraphServiceClient getCertificateClient() throws Exception {
        if(this.getProxyPort() > 0)
            return Client.getClientByCertificate(
                    this.getClientId(),
                    this.getTenantId(),
                    this.getCertificateFilePath(),
                    this.getCertificatePassword(),
                    this.getProxyHost(),
                    this.getProxyPort());
        return Client.getClientByCertificate(this.getClientId(), this.getTenantId(), this.getCertificateFilePath(), this.getCertificatePassword());
    }

    private void getAttachments() throws Exception {
        GraphServiceClient client = Validator.isNullOrEmpty(this.getClientSecret()) ? this.getCertificateClient() : this.getSecretClient();
        Mailbox.readMailFolder(client, App.FOLDER_ID, this.getDestinationFilePath(), this.getEmail());
    }
    public static void main(String[] args) {
        Logger logger = LoggerFactory.getLogger(App.class);
        try {
            App exec = new App();
            exec.init(args);
            exec.validate();
            exec.getAttachments();
        } catch (Exception e) {
            logger.error(e.getMessage());
        }

    }
}
