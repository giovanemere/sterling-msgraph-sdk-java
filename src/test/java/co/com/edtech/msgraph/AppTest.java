package co.com.edtech.msgraph;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

class AppTest {

    private App app;

    @BeforeEach
    void setUp() {
        app = new App();
    }

    @Test
    void testAppInitialization() {
        assertNotNull(app);
        assertNull(app.getEmail());
        assertEquals("", app.getDestinationFilePath());
        assertEquals("", app.getClientId());
        assertEquals("", app.getTenantId());
        assertEquals(-1, app.getProxyPort());
    }

    @Test
    void testSettersAndGetters() throws Exception {
        // Create test directory
        java.nio.file.Files.createDirectories(java.nio.file.Paths.get("./test"));
        
        app.setEmail("test@example.com");
        app.setClientId("test-client-id");
        app.setTenantId("test-tenant-id");
        app.setDestinationFilePath("./test");

        assertEquals("test@example.com", app.getEmail());
        assertEquals("test-client-id", app.getClientId());
        assertEquals("test-tenant-id", app.getTenantId());
        assertEquals("./test", app.getDestinationFilePath());
        
        // Cleanup
        java.nio.file.Files.deleteIfExists(java.nio.file.Paths.get("./test"));
    }

    @Test
    void testProxyConfiguration() {
        app.setProxyHost("proxy.example.com");
        app.setProxyPort(8080);

        assertEquals("proxy.example.com", app.getProxyHost());
        assertEquals(8080, app.getProxyPort());
    }

    @Test
    void testCertificateConfiguration() throws Exception {
        // Create test cert file
        java.nio.file.Files.createFile(java.nio.file.Paths.get("./cert.pem"));
        
        app.setCertificateFilePath("./cert.pem");
        app.setCertificatePassword("password123");

        assertEquals("./cert.pem", app.getCertificateFilePath());
        assertEquals("password123", app.getCertificatePassword());
        
        // Cleanup
        java.nio.file.Files.deleteIfExists(java.nio.file.Paths.get("./cert.pem"));
    }
}
