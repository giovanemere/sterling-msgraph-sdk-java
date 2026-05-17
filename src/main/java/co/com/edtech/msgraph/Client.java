package co.com.edtech.msgraph;


import com.azure.identity.ClientCertificateCredential;
import com.azure.identity.ClientCertificateCredentialBuilder;

import com.azure.identity.ClientSecretCredential;
import com.azure.identity.ClientSecretCredentialBuilder;

import com.microsoft.graph.core.authentication.AzureIdentityAuthenticationProvider;
import com.microsoft.graph.core.requests.GraphClientFactory;
import com.microsoft.graph.serviceclient.GraphServiceClient;

import com.azure.core.http.HttpClient;
import com.azure.core.http.ProxyOptions;
import com.azure.core.http.ProxyOptions.Type;
import com.azure.core.http.netty.NettyAsyncHttpClientBuilder;
import okhttp3.OkHttpClient;

import java.net.InetSocketAddress;
import java.net.Proxy;

public class Client {

    final static String[] SCOPES = new String[]{"https://graph.microsoft.com/.default"};
    final static String[] ALLOWED_HOSTS = new String[]{"graph.microsoft.com"};

    private static GraphServiceClient client;


    public static GraphServiceClient getClientBySecret(String clientId, String tenantId, String clientSecret, String proxyHost, int proxyPort ) throws Exception {
        final InetSocketAddress proxyAddress = new InetSocketAddress(proxyHost,
                proxyPort);

        // Setup proxy for the token credential from azure-identity
        // From the com.azure.core.http.* packages
        final ProxyOptions options = new ProxyOptions(Type.HTTP, proxyAddress);
        final HttpClient credentialHttpClient = new NettyAsyncHttpClientBuilder().proxy(options)
                .build();

        ClientSecretCredential credential = getSecretCredentials(clientId, tenantId, clientSecret, credentialHttpClient);


        if (credential == null) {
            throw new Exception("Could not create credential");
        }

        // scopes is a list of permission scope strings
        final AzureIdentityAuthenticationProvider authProvider =
                new AzureIdentityAuthenticationProvider(credential, ALLOWED_HOSTS);

        // Setup proxy for the Graph client
        final Proxy proxy = new Proxy(Proxy.Type.HTTP, proxyAddress);
        final OkHttpClient httpClient = GraphClientFactory.create().proxy(proxy).build();

        return new GraphServiceClient(authProvider, httpClient);
    }

    public static ClientSecretCredential getSecretCredentials(String clientId, String tenantId, String clientSecret, HttpClient httpClient){
        return new ClientSecretCredentialBuilder()
                .clientId(clientId)
                .tenantId(tenantId)
                .clientSecret(clientSecret)
                .httpClient(httpClient)
                .build();
    }


    public static GraphServiceClient getClientByCertificate(String clientId,
                                                            String tenantId,
                                                            String clientCertificatePath,
                                                            String clientCertificatePassword,
                                                            String proxyHost,
                                                            int proxyPort ) throws Exception {
        final InetSocketAddress proxyAddress = new InetSocketAddress(proxyHost,
                proxyPort);

        // Setup proxy for the token credential from azure-identity
        // From the com.azure.core.http.* packages
        ClientCertificateCredential credential = new ClientCertificateCredentialBuilder()
                .httpClient(new NettyAsyncHttpClientBuilder().proxy(new ProxyOptions(Type.HTTP, proxyAddress))
                        .build())
                .clientId(clientId).tenantId(tenantId)
                .pfxCertificate(clientCertificatePath)
                .clientCertificatePassword(clientCertificatePassword)
                .build();

        if (credential == null) {
            throw new Exception("Could not create credential");
        }

        // scopes is a list of permission scope strings
        final AzureIdentityAuthenticationProvider authProvider =
                new AzureIdentityAuthenticationProvider(credential, ALLOWED_HOSTS);

        // Setup proxy for the Graph client
        final Proxy proxy = new Proxy(Proxy.Type.HTTP, proxyAddress);
        final OkHttpClient httpClient = GraphClientFactory.create().proxy(proxy).build();

        GraphServiceClient graphClient = new GraphServiceClient(authProvider, httpClient);
        setClient(graphClient);
        return graphClient;
    }

    public static GraphServiceClient getClientByCertificate(String clientId, String tenantId, String clientCertificatePath, String clientCertificatePassword){

        final ClientCertificateCredential credential = new ClientCertificateCredentialBuilder()
                .clientId(clientId).tenantId(tenantId).pemCertificate(clientCertificatePath)
                .clientCertificatePassword(clientCertificatePassword)
                .build();
        GraphServiceClient graphClient = new GraphServiceClient(credential, SCOPES);
        setClient(graphClient);
        return graphClient;
    }

    public static GraphServiceClient getClientBySecret(String clientId, String tenantId, String clientSecret){
        if(Validator.isNullOrEmpty(clientId) || Validator.isNullOrEmpty(tenantId) ||Validator.isNullOrEmpty(clientSecret))
            throw new IllegalArgumentException();

        final ClientSecretCredential secretCredential = new ClientSecretCredentialBuilder()
                .clientId(clientId).tenantId(tenantId).clientSecret(clientSecret)
                .build();
        GraphServiceClient graphClient = new GraphServiceClient(secretCredential);
        setClient(graphClient);
        return graphClient;
    }

    public static GraphServiceClient getClient(){
        GraphServiceClient current = Client.client;
        if (current == null) {
            throw new NullPointerException();
        }
        return current;
    }

    /**
     * Builds a Graph client from CLI credentials (secret or certificate, optional proxy).
     */
    public static GraphServiceClient resolve(
            String clientId,
            String tenantId,
            String clientSecret,
            String certificateFilePath,
            String certificatePassword,
            String proxyHost,
            int proxyPort) throws Exception {
        boolean useProxy = proxyPort > 0;
        if (!Validator.isNullOrEmpty(clientSecret)) {
            if (useProxy) {
                return getClientBySecret(clientId, tenantId, clientSecret, proxyHost, proxyPort);
            }
            return getClientBySecret(clientId, tenantId, clientSecret);
        }
        if (useProxy) {
            return getClientByCertificate(
                    clientId, tenantId, certificateFilePath, certificatePassword, proxyHost, proxyPort);
        }
        return getClientByCertificate(clientId, tenantId, certificateFilePath, certificatePassword);
    }

    private static void setClient(GraphServiceClient client){
        Client.client = client;
    }

}
