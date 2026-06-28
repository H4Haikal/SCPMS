package dao;

import model.CalendarEvent;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MasterCalendarDAO {

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

    // 2. GET ALL EVENTS
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

    // 3. UPDATE EVENT (New)
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

    // 4. DELETE EVENT (New)
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
}
