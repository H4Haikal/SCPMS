package util;

import java.security.SecureRandom;

public class PasswordUtil {

    private static final String CHAR_CAPS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String CHAR_SMALL = "abcdefghijklmnopqrstuvwxyz";
    private static final String CHAR_NUM = "0123456789";
    private static final String CHAR_SPECIAL = "!@#$";

    private static final String PASSWORD_ALLOW_BASE = CHAR_CAPS + CHAR_SMALL + CHAR_NUM + CHAR_SPECIAL;
    private static final SecureRandom random = new SecureRandom();

    public static String generateRandomPassword(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int rndCharAt = random.nextInt(PASSWORD_ALLOW_BASE.length());
            char rndChar = PASSWORD_ALLOW_BASE.charAt(rndCharAt);
            sb.append(rndChar);
        }
        return sb.toString();
    }
}
