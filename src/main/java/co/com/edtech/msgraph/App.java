package co.com.edtech.msgraph;

import java.io.IOException;
import java.io.PrintStream;

public class App {
    public static final String FOLDER_ID = "Inbox";
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

    public void setEmail(String email) {
        if (!Validator.isValidEmail(email)) {
            throw new IllegalArgumentException("Email invalido: " + email);
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


    private void setParams(String option, String value) throws NoSuchFieldException {
        switch (option) {
            case "-e", "-email" -> this.setEmail(value);
            case "-d", "-dir" -> this.setDestinationFilePath(value);
            case "-tenant" -> this.setTenantId(value);
            case "-client" -> this.setClientId(value);
            case "-secret" -> this.setClientSecret(value);
            case "-p", "-port", "--proxy-port" -> this.setProxyPort(Integer.parseInt(value));
            case "-h", "-host", "--proxy-host" -> this.setProxyHost(value);
            case "-c", "-certificate", "-privateCertificate", "--certificate-path" ->
                    this.setCertificateFilePath(value);
            case "-certificatePassword", "-certpwd", "--client-certificate-password" ->
                    this.setCertificatePassword(value);
            default -> throw new NoSuchFieldException("Argument not defined" + option);
        }
    }

    public void init(String[] args) throws IOException, IllegalArgumentException, NoSuchFieldException {
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

        if (!Validator.isNullOrEmpty(this.getProxyHost())
                && !Validator.validateProxy(this.getProxyHost(), this.getProxyPort())) {
            throw new IOException("Wrong Proxy parameters");
        }
    }

    private void getAttachments() throws Exception {
        Mailbox.readMailFolder(
                Client.resolve(
                        this.getClientId(),
                        this.getTenantId(),
                        this.getClientSecret(),
                        this.getCertificateFilePath(),
                        this.getCertificatePassword(),
                        this.getProxyHost(),
                        this.getProxyPort()),
                App.FOLDER_ID,
                this.getDestinationFilePath(),
                this.getEmail());
    }
    public static void main(String[] args) {
        int exitCode = run(args, System.err);
        System.exit(exitCode);
    }

    /** Package-visible for tests; logs failures to {@code err}. */
    static int run(String[] args, PrintStream err) {
        try {
            App exec = new App();
            exec.init(args);
            exec.validate();
            exec.getAttachments();
            return 0;
        } catch (Exception e) {
            err.println("O365InboxAttachmentToDisk failed: " + e.getMessage());
            e.printStackTrace(err);
            return 1;
        }
    }
}
