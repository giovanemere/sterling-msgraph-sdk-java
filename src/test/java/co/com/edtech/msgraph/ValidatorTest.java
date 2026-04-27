package co.com.edtech.msgraph;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

class ValidatorTest {

    @BeforeEach
    void setUp() {
        // Setup test data
    }

    @Test
    void testIsValidEmail_ValidEmail() {
        assertTrue(Validator.isValidEmail("test@example.com"));
        assertTrue(Validator.isValidEmail("user.name@domain.co"));
    }

    @Test
    void testIsValidEmail_InvalidEmail() {
        assertFalse(Validator.isValidEmail("invalid-email"));
        assertFalse(Validator.isValidEmail("@domain.com"));
        assertFalse(Validator.isValidEmail("user@"));
        assertFalse(Validator.isValidEmail(""));
        assertFalse(Validator.isValidEmail(null));
    }

    @Test
    void testIsNullOrEmpty() {
        assertTrue(Validator.isNullOrEmpty(null));
        assertTrue(Validator.isNullOrEmpty(""));
        assertTrue(Validator.isNullOrEmpty("   "));
        assertFalse(Validator.isNullOrEmpty("test"));
    }

    @Test
    void testIsValidPort() {
        assertTrue(Validator.isValidPort(80));
        assertTrue(Validator.isValidPort(443));
        assertTrue(Validator.isValidPort(8080));
        assertFalse(Validator.isValidPort(-1));
        assertFalse(Validator.isValidPort(65536));
    }

    @Test
    void testValidateProxy() {
        assertTrue(Validator.validateProxy("localhost", 8080));
        assertFalse(Validator.validateProxy("invalid-host-name-that-does-not-exist", 8080));
        assertFalse(Validator.validateProxy("localhost", -1));
    }
}
