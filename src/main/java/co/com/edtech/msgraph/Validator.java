package co.com.edtech.msgraph;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.apache.commons.validator.routines.EmailValidator;

public class Validator {

    public static boolean isNullOrEmpty(String value){
        return value == null || value.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        if (isNullOrEmpty(email)) {
            return false;
        }
        return EmailValidator.getInstance().isValid(email);
    }

    public static boolean validatePath(String textPath){
        Path path = Paths.get(textPath);
        return Files.exists(path);
    }

    public static boolean validateProxy(String host, int port){
        return isValidPort(port) && isValidHost(host);
    }

    public static boolean isValidPort(int port) {
        return port >= 0 && port <= 65535;
    }

    @SuppressWarnings("ResultOfMethodCallIgnored")
    public static boolean isValidHost(String host) {
        try {
            InetAddress.getByName(host);
            return true;
        } catch (UnknownHostException e) {
            return false;
        }
    }
}
