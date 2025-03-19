package co.com.edtech.msgraph;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.io.IOException;

import javax.mail.internet.AddressException;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class AppTest {

    private App app;

    @BeforeEach
    void setUp() {
        app = new App();
    }

    @Test
    void setEmail_validEmail_setsEmail() throws AddressException {
        app.setEmail("sfg_domiciliacion@edtech.com.co");
        assertEquals("sfg_domiciliacion@edtech.com.co", app.getEmail());
    }

    @Test
    void setEmail_invalidEmail_throwsAddressException() {
        assertThrows(AddressException.class, () -> app.setEmail("invalid-email"));
    }

    @Test
    void setDestinationFilePath_validPath_setsPath() {
        app.setDestinationFilePath("D:\\Repositorios\\edtech\\temp\\mail-attachment");
        assertEquals("D:\\Repositorios\\edtech\\temp\\mail-attachment", app.getDestinationFilePath());
    }

    @Test
    void setDestinationFilePath_invalidPath_throwsIllegalArgumentException() {
        assertThrows(IllegalArgumentException.class, () -> app.setDestinationFilePath(null));
    }

    @Test
    void setClientId_validId_setsId() {
        app.setClientId("validId");
        assertEquals("validId", app.getClientId());
    }

    @Test
    void setClientId_invalidId_throwsIllegalArgumentException() {
        assertThrows(IllegalArgumentException.class, () -> app.setClientId(null));
    }

    @Test
    void init_validParams_setsParams() throws IOException, NoSuchFieldException, AddressException {
        String[] args = {"-email", "sfg_domiciliacion@edtech.com.co", "-dir", "D:\\Repositorios\\edtech\\temp\\mail-attachment", "-tenant", "d98b231e-79bb-4aff-b916-0157f4cdc5bc", "-client", "fee4cb62-31c3-4361-90f3-b34c46c953ff", "-secret", "DEk8Q~Rarg4JsLDF3OLy3txerGEGjoj9-HlL7a4L"};
        app.init(args);
        assertEquals("sfg_domiciliacion@edtech.com.co", app.getEmail());
        assertEquals("D:\\Repositorios\\edtech\\temp\\mail-attachment", app.getDestinationFilePath());
        assertEquals("d98b231e-79bb-4aff-b916-0157f4cdc5bc", app.getTenantId());
        assertEquals("fee4cb62-31c3-4361-90f3-b34c46c953ff", app.getClientId());
        assertEquals("DEk8Q~Rarg4JsLDF3OLy3txerGEGjoj9-HlL7a4L", app.getClientSecret());
    }

    @Test
    void init_invalidParams_throwsIOException() {
        String[] args = {"-email", "sfg_domiciliacion@edtech.com.co", "-dir"};
        assertThrows(IOException.class, () -> app.init(args));
    }

    @Test
    void validate_missingParameters_throwsIOException() throws AddressException {
        app.setEmail("sfg_domiciliacion@edtech.com.co");
        app.setDestinationFilePath("D:\\Repositorios\\edtech\\temp\\mail-attachment");
        assertThrows(IOException.class, () -> app.validate());
    }
}