package dao;

import com.google.gson.Gson;
import model.CalendarEvent;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MasterCalendarDAO {

    // ==========================================================
    // EXISTING CRUD METHODS (Kept intact for MPP/HEPA functions)
    // ==========================================================
    // 1. ADD EVENT
    public boolean addEvent(CalendarEvent event) {
        String sql = "INSERT INTO master_calendar (eventTitle, startDate, endDate, eventType, description) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, event.getEventTitle());
            ps.setDate(2, event.getStartDate());
            ps.setDate(3, event.getEndDate());
            ps.setString(4, event.getEventType());
            ps.setString(5, event.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. GET ALL EVENTS (Standard Java Objects)
    public List<CalendarEvent> getAllEvents() {
        List<CalendarEvent> events = new ArrayList<>();
        String sql = "SELECT * FROM master_calendar ORDER BY startDate ASC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CalendarEvent event = new CalendarEvent();
                event.setCalendarId(rs.getInt("calendarId"));
                event.setEventTitle(rs.getString("eventTitle"));
                event.setStartDate(rs.getDate("startDate"));
                event.setEndDate(rs.getDate("endDate"));
                event.setEventType(rs.getString("eventType"));
                event.setDescription(rs.getString("description"));
                events.add(event);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return events;
    }

    // 3. UPDATE EVENT
    public boolean updateEvent(CalendarEvent event) {
        String sql = "UPDATE master_calendar SET eventTitle=?, startDate=?, endDate=?, eventType=?, description=? WHERE calendarId=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, event.getEventTitle());
            ps.setDate(2, event.getStartDate());
            ps.setDate(3, event.getEndDate());
            ps.setString(4, event.getEventType());
            ps.setString(5, event.getDescription());
            ps.setInt(6, event.getCalendarId()); // Check ID
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. DELETE EVENT
    public boolean deleteEvent(int calendarId) {
        String sql = "DELETE FROM master_calendar WHERE calendarId=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, calendarId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. CHECK IF EVENT EXISTS (To prevent duplicates during Sync)
    public boolean eventExists(String title, Date startDate) {
        String sql = "SELECT COUNT(*) FROM master_calendar WHERE eventTitle = ? AND startDate = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setDate(2, startDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==========================================================
    // NEW: UNIFIED JSON AGGREGATOR FOR THE UI
    // ==========================================================
    public String getAllCalendarEventsAsJson() {
        List<Map<String, Object>> events = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            // A. FETCH MANUAL EVENTS & HOLIDAYS (From master_calendar table)
            String sqlMaster = "SELECT calendarId, eventTitle, eventType, startDate, endDate, description FROM master_calendar";
            try (PreparedStatement ps = conn.prepareStatement(sqlMaster); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> event = new HashMap<>();
                    event.put("id", "M_" + rs.getInt("calendarId"));
                    event.put("title", rs.getString("eventTitle"));
                    event.put("start", rs.getString("startDate"));
                    event.put("end", rs.getString("endDate"));
                    event.put("type", rs.getString("eventType"));
                    event.put("desc", rs.getString("description"));
                    event.put("editable", true);
                    events.add(event);
                }
            }

            // B. FETCH FULLY APPROVED CLUB EVENTS (Joined with Clubs table)
            String sqlApproved = "SELECT p.proposalId, p.title, p.proposedDate AS startDate, p.endDate, c.clubName "
                    + "FROM eventproposal p JOIN clubs c ON p.clubId = c.clubId "
                    + "WHERE p.status = 'Approved'";
            try (PreparedStatement ps = conn.prepareStatement(sqlApproved); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> event = new HashMap<>();
                    event.put("id", "P_" + rs.getInt("proposalId"));
                    event.put("title", "✅ " + rs.getString("title"));
                    event.put("start", rs.getString("startDate"));
                    event.put("end", rs.getString("endDate"));
                    event.put("type", "Approved");
                    event.put("desc", "Official Club Program. Fully Endorsed.");
                    event.put("clubName", rs.getString("clubName")); // NEW: Pass the club name
                    event.put("editable", false);
                    events.add(event);
                }
            }

            // C. FETCH PITCHING SESSIONS (Joined with Clubs table)
            String sqlMeet = "SELECT p.proposalId, p.title, p.pitchingDate, p.pitchingLocation, p.clubId, c.clubName "
                    + "FROM eventproposal p JOIN clubs c ON p.clubId = c.clubId "
                    + "WHERE p.pitchingLocation IS NOT NULL AND p.pitchingLocation != ''";
            try (PreparedStatement ps = conn.prepareStatement(sqlMeet); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> event = new HashMap<>();
                    event.put("id", "G_" + rs.getInt("proposalId"));
                    event.put("title", "🎥 Pitching: " + rs.getString("title"));

                    String pDate = rs.getString("pitchingDate");
                    if (pDate != null && pDate.length() >= 10) {
                        event.put("start", pDate.substring(0, 10));
                        event.put("end", pDate.substring(0, 10));
                    }
                    event.put("type", "Pitching");
                    event.put("desc", "Official Pitching Session.");
                    event.put("url", rs.getString("pitchingLocation"));
                    event.put("clubId", rs.getInt("clubId")); // NEW: For security check
                    event.put("clubName", rs.getString("clubName")); // NEW: For display
                    event.put("editable", false);
                    events.add(event);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new com.google.gson.Gson().toJson(events);
    }
}
