package util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class GoogleMeetUtil {

    // SAFELY CALLING FROM CONFIG.JAVA
    private static final String CLIENT_ID = Config.GOOGLE_CLIENT_ID;
    private static final String CLIENT_SECRET = Config.GOOGLE_CLIENT_SECRET;
    private static final String REFRESH_TOKEN = Config.GOOGLE_REFRESH_TOKEN;

    private static String getFreshAccessToken() throws Exception {
        URL url = new URL("https://oauth2.googleapis.com/token");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);

        String params = "client_id=" + CLIENT_ID
                + "&client_secret=" + CLIENT_SECRET
                + "&refresh_token=" + REFRESH_TOKEN
                + "&grant_type=refresh_token";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes("utf-8"));
        }

        // BACA BALASAN (Berjaya atau Error)
        int responseCode = conn.getResponseCode();
        InputStream inputStream = (responseCode >= 200 && responseCode < 300)
                ? conn.getInputStream()
                : conn.getErrorStream();

        BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, "utf-8"));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            response.append(line.trim());
        }

        String res = response.toString();
        if (responseCode == 200 && res.contains("\"access_token\": \"")) {
            return res.split("\"access_token\": \"")[1].split("\"")[0];
        } else {
            System.out.println("❌ GOOGLE OAUTH ERROR: " + res);
            throw new Exception("Gagal dapat Access Token. Status: " + responseCode);
        }
    }

    public static String generateMeetLink(String eventTitle, String startDate, String endDate) {
        try {
            // 1. Dapatkan pas masuk sementara (Access Token)
            String accessToken = getFreshAccessToken();
            String uniqueId = "umt-meet-" + System.currentTimeMillis();

            // 2. Sediakan URL API Kalendar Google
            URL url = new URL("https://www.googleapis.com/calendar/v3/calendars/primary/events?conferenceDataVersion=1");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            // 3. Format JSON (Zon masa Kuala Lumpur)
            String jsonInput = "{"
                    + "\"summary\": \"" + eventTitle + "\","
                    + "\"description\": \"Sesi Pitching Kertas Kerja. Dijana automatik oleh UMT ClubSphere.\","
                    + "\"start\": {\"dateTime\": \"" + startDate + "\", \"timeZone\": \"Asia/Kuala_Lumpur\"},"
                    + "\"end\": {\"dateTime\": \"" + endDate + "\", \"timeZone\": \"Asia/Kuala_Lumpur\"},"
                    + "\"conferenceData\": {"
                    + "  \"createRequest\": {"
                    + "    \"requestId\": \"" + uniqueId + "\", "
                    + "    \"conferenceSolutionKey\": {\"type\": \"hangoutsMeet\"}"
                    + "  }"
                    + "}"
                    + "}";

            // 4. Hantar JSON ke Google
            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonInput.getBytes("utf-8"));
            }

            // 5. Baca hasil pautan
            int responseCode = conn.getResponseCode();
            InputStream inputStream = (responseCode >= 200 && responseCode < 300)
                    ? conn.getInputStream()
                    : conn.getErrorStream();

            BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, "utf-8"));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }

            String res = response.toString();
            if (responseCode == 200 && res.contains("\"hangoutLink\": \"")) {
                // Berjaya rompak link Meet!
                return res.split("\"hangoutLink\": \"")[1].split("\"")[0];
            } else {
                System.out.println("❌ GOOGLE CALENDAR ERROR: " + res);
            }

        } catch (Exception e) {
            System.out.println("❌ JAVA INTERNAL ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
