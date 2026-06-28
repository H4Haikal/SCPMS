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
    public static final String GEMINI_API_KEY = "AQ.Ab8RN6IDNRE8pP2muwr1YbbXli2ClLXp72yA8j4mAe6ATVKT9A";
    public static final String OPENAI_API_KEY = "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";

    // ==========================================
    // 4. GOOGLE MEET OAUTH CREDENTIALS
    // ==========================================
    public static final String GOOGLE_CLIENT_ID = "871264798352-4o8dt8eg0gkdp8jvlmarjfpid1aal6rb.apps.googleusercontent.com";
    public static final String GOOGLE_CLIENT_SECRET = "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";
    public static final String GOOGLE_REFRESH_TOKEN = "Insert Token Here";

}
