package co.com.edtech.msgraph;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import jakarta.mail.internet.AddressException;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class AppTest {

    private App app;
    private Properties properties;

    @BeforeEach
    void setUp() throws IOException {
        app = new App();
        properties = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("variables.properties")) {
            if (input == null) {
                throw new IOException("Unable to find variables.properties");
            }
            properties.load(input);
        }
    }

    @Test
    void setEmail_validEmail_setsEmail() throws AddressException {
        app.setEmail(properties.getProperty("email"));
        assertEquals(properties.getProperty("email"), app.getEmail());
    }

    @Test
    void setEmail_invalidEmail_throwsAddressException() {
        assertThrows(AddressException.class, () -> app.setEmail("invalid-email"));
    }

    @Test
    void setDestinationFilePath_validPath_setsPath() {
        app.setDestinationFilePath(properties.getProperty("destinationFilePath"));
        assertEquals(properties.getProperty("destinationFilePath"), app.getDestinationFilePath());
    }

    @Test
    void setDestinationFilePath_invalidPath_throwsIllegalArgumentException() {
        assertThrows(IllegalArgumentException.class, () -> app.setDestinationFilePath(null));
    }

    @Test
    void setClientId_validId_setsId() {
        app.setClientId(properties.getProperty("clientId"));
        assertEquals(properties.getProperty("clientId"), app.getClientId());
    }

    @Test
    void setClientId_invalidId_throwsIllegalArgumentException() {
        assertThrows(IllegalArgumentException.class, () -> app.setClientId(null));
    }

    @Test
    void init_validParams_setsParams() throws IOException, NoSuchFieldException, AddressException {
        String[] args = {
                "-email", properties.getProperty("email"),
                "-dir", properties.getProperty("destinationFilePath"),
                "-tenant", properties.getProperty("tenantId"),
                "-client", properties.getProperty("clientId"),
                "-secret", properties.getProperty("clientSecret")
        };
        app.init(args);
        assertEquals(properties.getProperty("email"), app.getEmail());
        assertEquals(properties.getProperty("destinationFilePath"), app.getDestinationFilePath());
        assertEquals(properties.getProperty("tenantId"), app.getTenantId());
        assertEquals(properties.getProperty("clientId"), app.getClientId());
        assertEquals(properties.getProperty("clientSecret"), app.getClientSecret());
    }

    @Test
    void init_invalidParams_throwsIOException() {
        String[] args = {"-email", properties.getProperty("email"), "-dir"};
        assertThrows(IOException.class, () -> app.init(args));
    }

    @Test
    void validate_missingParameters_throwsIOException() throws AddressException {
        app.setEmail(properties.getProperty("email"));
        app.setDestinationFilePath(properties.getProperty("destinationFilePath"));
        assertThrows(IOException.class, () -> app.validate());
    }
}