package util;

/**
 * SECURE CONFIGURATION VAULT This file is ignored by Git (.gitignore) and will
 * NOT be uploaded to GitHub. It contains all sensitive API keys, database
 * credentials, and passwords.
 */
public class Config {

    // ==========================================
    // 1. DATABASE CREDENTIALS
    // ==========================================
    public static final String DB_URL = "jdbc:mysql://localhost:3307/umt_clubsphere_dev?useSSL=false&serverTimezone=Asia/Kuala_Lumpur";
    public static final String DB_USERNAME = "root";
    public static final String DB_PASSWORD = "";

    // ==========================================
    // 2. EMAIL SERVICE (App Passwords)
    // ==========================================
    public static final String EMAIL_SENDER = "clubsphere.umt2026@gmail.com";
    public static final String EMAIL_PASSWORD = "rpvgliwsyehohlyk";

    // ==========================================
    // 3. AI ENGINE API KEYS (Gemini & OpenAI)
    // ==========================================
    public static final String GEMINI_API_KEY = "AQ.Ab8RN6Jm13Jy4h7DUD126tHO6DRtOf1ucH4NjTEIn-mfy5slIg";
    public static final String OPENAI_API_KEY = "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";

    // ==========================================
    // 4. GOOGLE MEET OAUTH CREDENTIALS
    // ==========================================
    public static final String GOOGLE_CLIENT_ID = "871264798352-4o8dt8eg0gkdp8jvlmarjfpid1aal6rb.apps.googleusercontent.com";
    public static final String GOOGLE_CLIENT_SECRET = "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";
    public static final String GOOGLE_REFRESH_TOKEN = "1//04fwhHBEL7gkCCgYIARAAGAQSNwF-L9IrBi0TMM50-Iz_7zNDjhByuaUAY3NnpW7LUlkHq7H_e8myvCz9SbccXl5GDVBCcnuZcLQ";

}
