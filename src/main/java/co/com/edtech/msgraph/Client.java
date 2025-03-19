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
        final HttpClient client = new NettyAsyncHttpClientBuilder().proxy(options)
                .build();

        ClientSecretCredential credential = getSecretCredentials(clientId, tenantId, clientSecret, client);


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

    public static ClientSecretCredential getSecretCredentials(String clientId, String tenantId, String clientSecret, HttpClient client){
        return new ClientSecretCredentialBuilder()
                .clientId(clientId)
                .tenantId(tenantId)
                .clientSecret(clientSecret)
                .httpClient(client)
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

        setClient(new GraphServiceClient(authProvider, httpClient));
        return Client.client;
    }

    public static GraphServiceClient getClientByCertificate(String clientId, String tenantId, String clientCertificatePath, String clientCertificatePassword){

        final ClientCertificateCredential credential = new ClientCertificateCredentialBuilder()
                .clientId(clientId).tenantId(tenantId).pemCertificate(clientCertificatePath)
                .clientCertificatePassword(clientCertificatePassword)
                .build();
        setClient(new GraphServiceClient(credential, SCOPES));
        return Client.client;
    }

    public static GraphServiceClient getClientBySecret(String clientId, String tenantId, String clientSecret){
        if(Validator.isNullOrEmpty(clientId) || Validator.isNullOrEmpty(tenantId) ||Validator.isNullOrEmpty(clientSecret))
            throw new IllegalArgumentException();

        final ClientSecretCredential secretCredential = new ClientSecretCredentialBuilder()
                .clientId(clientId).tenantId(tenantId).clientSecret(clientSecret)
                .build();
        setClient(new GraphServiceClient(secretCredential));

        return Client.client;
    }

    public static GraphServiceClient getClient(){
        if(Client.client == null){
            throw new NullPointerException();
        }
        return Client.client;
    }

    private static void setClient(GraphServiceClient client){
        Client.client = client;
    }

}
