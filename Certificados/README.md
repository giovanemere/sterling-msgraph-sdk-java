# Getting Started
# Create self-certificate
# Window
https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-self-signed-certificate

# Linux
https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-certificates-linux-openssl


# Self-signed root certificate
This section helps you generate a self-signed root certificate. After you generate the certificate, you export root certificate public key data file.

The following example helps you generate the self-signed root certificate.


openssl genrsa -out caKey.pem 2048
openssl req -x509 -new -nodes -key caKey.pem -subj "/CN=VPN CA" -days 3650 -out caCert.pem

# Print the self-signed root certificate public data in base64 format. This is the format that's supported by Azure. Upload this certificate to Azure as part of your P2S configuration steps.

openssl x509 -in caCert.pem -outform der | base64 -w0 && echo

# Client certificates
In this section, you generate the user certificate (client certificate). Certificate files are generated in the local directory in which you run the commands. You can use the same client certificate on each client computer, or generate certificates that are specific to each client. It's crucial is that the client certificate is signed by the root certificate.

To generate a client certificate, use the following examples.


export PASSWORD="password"
export USERNAME=$(hostnamectl --static)

# Generate a private key
openssl genrsa -out "${USERNAME}Key.pem" 2048

# Generate a CSR (Certificate Sign Request)
openssl req -new -key "${USERNAME}Key.pem" -out "${USERNAME}Req.pem" -subj "/CN=${USERNAME}"

# Sign the CSR using the CA certificate and CA key
openssl x509 -req -days 365 -in "${USERNAME}Req.pem" -CA caCert.pem -CAkey caKey.pem -CAcreateserial -out "${USERNAME}Cert.pem" -extfile <(echo -e "subjectAltName=DNS:${USERNAME}\nextendedKeyUsage=clientAuth")
To verify the client certificate, use the following example.


openssl verify -CAfile caCert.pem caCert.pem "${USERNAME}Cert.pem"