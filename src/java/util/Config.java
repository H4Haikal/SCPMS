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
    public static final String GEMINI_API_KEY = "AQ.Ab8RN6IVPgeg3OvM7nBV13HWY-02JBw_Mxb_OCTvwwauR9ZYYA";
    public static final String OPENAI_API_KEY = "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";

    // ==========================================
    // 4. GOOGLE MEET OAUTH CREDENTIALS
    // ==========================================
    public static final String GOOGLE_CLIENT_ID = "871264798352-4o8dt8eg0gkdp8jvlmarjfpid1aal6rb.apps.googleusercontent.com";
    public static final String GOOGLE_CLIENT_SECRET = "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";
    public static final String GOOGLE_REFRESH_TOKEN = "1//041mSj5beRMj5CgYIARAAGAQSNwF-L9IroFXpHRVLT0fw48WY2J2emc40zcqw0P_L8gFnOc57fz_pW7F5N6DK9g8ak9eCBmBFjUQ";

}
