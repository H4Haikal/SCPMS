package controller.common;

import dao.MasterCalendarDAO;
import model.CalendarEvent;
import model.User;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.BufferedReader;
import java.io.InputStreamReader;

// Make sure it is routed to /common/calendar so all roles can access it
@WebServlet(name = "MasterCalendarServlet", urlPatterns = {"/common/calendar"})
public class MasterCalendarServlet extends HttpServlet {

    private MasterCalendarDAO calendarDAO = new MasterCalendarDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Security Check
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Use your brand new unified Gson method!
        String eventsJson = calendarDAO.getAllCalendarEventsAsJson();

        request.setAttribute("eventsJson", eventsJson);
        // 3. Forward to the unified JSP
        request.getRequestDispatcher("/WEB-INF/jsp/common/MasterCalendar.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security Check - Only MPP or HEPA can make modifications!
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || (!"MPP".equals(user.getRole()) && !"HEPA".equals(user.getRole()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only Admins can modify the calendar.");
            return;
        }

        String action = request.getParameter("action");

        // --- 1. SYNC LOGIC (Fetch API) ---
        if ("sync".equals(action)) {
            syncPublicHolidays();
            response.sendRedirect(request.getContextPath() + "/common/calendar?msg=synced");
            return; // Stop here, don't run the rest
        }

        // --- 2. DELETE LOGIC ---
        if ("delete".equals(action)) {
            try {
                String rawId = request.getParameter("eventId").replace("M_", "");
                int id = Integer.parseInt(rawId);
                calendarDAO.deleteEvent(id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        } // --- 3. ADD / UPDATE LOGIC ---
        else {
            String title = request.getParameter("title");
            String startStr = request.getParameter("startDate");
            String endStr = request.getParameter("endDate");
            String type = request.getParameter("type");
            String desc = request.getParameter("description");

            CalendarEvent event = new CalendarEvent();
            event.setEventTitle(title);
            event.setStartDate(Date.valueOf(startStr));
            event.setEndDate(Date.valueOf(endStr));
            event.setEventType(type);
            event.setDescription(desc);

            if ("update".equals(action)) {
                String rawId = request.getParameter("eventId").replace("M_", "");
                int id = Integer.parseInt(rawId);
                event.setCalendarId(id);
                calendarDAO.updateEvent(event);
            } else {
                calendarDAO.addEvent(event);
            }
        }

        response.sendRedirect(request.getContextPath() + "/common/calendar?msg=success");
    }

    // --- HYBRID SYNC: Try API -> Fallback to Manual Data ---
    private void syncPublicHolidays() {
        System.out.println("--- [SYNC STARTED] ---");
        boolean apiSuccess = false;

        try {
            int year = 2026;
            String urlString = "https://date.nager.at/api/v3/publicholidays/" + year + "/MY";
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            int responseCode = conn.getResponseCode();
            System.out.println("API Response: " + responseCode);

            if (responseCode == 200) {
                apiSuccess = true;
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder jsonStr = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    jsonStr.append(line);
                }
                br.close();
                
            }
        } catch (Exception e) {
            System.out.println("API Failed. Switching to fallback.");
        }

        // 2. FALLBACK: If API failed (204) or crashed, use Manual 2026 Data
        if (!apiSuccess) {
            System.out.println("--- Using Manual 2026 Holiday Data ---");
            addManualHoliday("New Year's Day", "2026-01-01");
            addManualHoliday("Thaipusam", "2026-02-01");
            addManualHoliday("Chinese New Year", "2026-02-17");
            addManualHoliday("Chinese New Year (Day 2)", "2026-02-18");
            addManualHoliday("Hari Raya Aidilfitri", "2026-03-20");
            addManualHoliday("Hari Raya Aidilfitri (Day 2)", "2026-03-21");
            addManualHoliday("Labour Day", "2026-05-01");
            addManualHoliday("Wesak Day", "2026-05-31");
            addManualHoliday("Agong's Birthday", "2026-06-07");
            addManualHoliday("Hari Raya Haji", "2026-05-27");
            addManualHoliday("Awal Muharram", "2026-06-16");
            addManualHoliday("Merdeka Day", "2026-08-31");
            addManualHoliday("Malaysia Day", "2026-09-16");
            addManualHoliday("Prophet Muhammad's Birthday", "2026-09-24");
            addManualHoliday("Deepavali", "2026-11-08");
            addManualHoliday("Christmas Day", "2026-12-25");
        }
        System.out.println("--- [SYNC FINISHED] ---");
    }

    // Helper for the Fallback
    private void addManualHoliday(String title, String dateStr) {
        Date sqlDate = Date.valueOf(dateStr);
        if (!calendarDAO.eventExists(title, sqlDate)) {
            CalendarEvent holiday = new CalendarEvent();
            holiday.setEventTitle(title);
            holiday.setStartDate(sqlDate);
            holiday.setEndDate(sqlDate);
            holiday.setEventType("Public Holiday");
            holiday.setDescription("Federal Holiday (2026)");
            calendarDAO.addEvent(holiday);
            System.out.println("Added: " + title);
        }
    }

    // --- HELPER: Extract JSON Value ---
    private String extractValue(String json, String key) {
        int startIndex = json.indexOf(key);
        if (startIndex == -1) {
            return null;
        }
        startIndex += key.length();
        int quoteStart = json.indexOf("\"", startIndex);
        if (quoteStart == -1) {
            return null;
        }
        int quoteEnd = json.indexOf("\"", quoteStart + 1);
        if (quoteEnd == -1) {
            return null;
        }
        return json.substring(quoteStart + 1, quoteEnd);
    }

    // --- HELPER: Escape JSON Strings ---
    private String escape(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("\"", "\\\"").replace("\n", " ");
    }
}
