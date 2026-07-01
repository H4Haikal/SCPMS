//package dao;
//
//import util.DBConnection;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
//
//public class MPPDashboardDAO {
//
//    public int getActiveClubs() {
//        String sql = "SELECT COUNT(*) FROM Clubs WHERE status = 'active'";
//        return getCount(sql);
//    }
//
//    public int getTotalMembers() {
//        String sql = "SELECT COUNT(*) FROM Club_Memberships WHERE isActive = TRUE";
//        return getCount(sql);
//    }
//
//    public int getEventsThisWeek() {
//        // Dec 30, 2025 → This week: Dec 23 to Dec 31
//        String sql = "SELECT COUNT(*) FROM Event WHERE finalDate BETWEEN '2025-12-23' AND '2025-12-31'";
//        return getCount(sql);
//    }
//
//    public int getTotalEvents2025() {
//        String sql = "SELECT COUNT(*) FROM Event WHERE YEAR(finalDate) = 2025 OR finalDate IS NULL";
//        return getCount(sql);
//    }
//// NEW: Recent Activities from Audit_Logs + EventProposal + AGM_Report
//
//    public List<String> getRecentActivities() {
//        List<String> activities = new ArrayList<>();
//        String sql = """
//            SELECT CONCAT(Action, ': ', Description) AS activity, createdAt 
//            FROM Audit_Logs 
//            UNION ALL
//            SELECT CONCAT('New Proposal: ', title), createdAt 
//            FROM EventProposal 
//            UNION ALL
//            SELECT CONCAT('AGM Report: ', clubName, ' - ', status), submittedAt 
//            FROM AGM_Report ar JOIN Clubs c ON ar.clubId = c.clubId
//            ORDER BY createdAt DESC 
//            LIMIT 5
//            """;
//
//        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                activities.add(rs.getString(1));
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return activities;
//    }
//
//    // NEW: Upcoming Events (next 5 events)
//    public List<EventSummary> getUpcomingEvents() {
//        List<EventSummary> events = new ArrayList<>();
//        String sql = """
//            SELECT e.finalDate, e.Venue, c.clubName, ep.title
//            FROM Event e
//            JOIN EventProposal ep ON e.proposalId = ep.proposalId
//            JOIN Clubs c ON ep.clubId = c.clubId
//            WHERE e.finalDate >= CURDATE()
//            ORDER BY e.finalDate ASC
//            LIMIT 5
//            """;
//
//        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                EventSummary event = new EventSummary();
//                event.setTitle(rs.getString("title"));
//                event.setClubName(rs.getString("clubName"));
//                event.setDate(rs.getDate("finalDate"));
//                event.setVenue(rs.getString("Venue"));
//                events.add(event);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return events;
//    }
//
//    // Helper class for upcoming events
//    public static class EventSummary {
//
//        private String title;
//        private String clubName;
//        private java.sql.Date date;
//        private String venue;
//
//        // Getters and Setters
//        public String getTitle() {
//            return title;
//        }
//
//        public void setTitle(String title) {
//            this.title = title;
//        }
//
//        public String getClubName() {
//            return clubName;
//        }
//
//        public void setClubName(String clubName) {
//            this.clubName = clubName;
//        }
//
//        public java.sql.Date getDate() {
//            return date;
//        }
//
//        public void setDate(java.sql.Date date) {
//            this.date = date;
//        }
//
//        public String getVenue() {
//            return venue;
//        }
//
//        public void setVenue(String venue) {
//            this.venue = venue;
//        }
//    }
//
//    private int getCount(String sql) {
//        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
//            if (rs.next()) {
//                return rs.getInt(1);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return 0;
//    }
//}
package dao;

import util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MPPDashboardDAO {

    public int getActiveClubs() {
        // Nama jadual: clubs (Berdasarkan DB kau)
        String sql = "SELECT COUNT(*) FROM clubs WHERE status = 'active'";
        return getCount(sql);
    }

    public int getTotalMembers() {
        // Nama jadual: club_memberships (1 = true dalam MySQL)
        String sql = "SELECT COUNT(*) FROM club_memberships WHERE isActive = 1";
        return getCount(sql);
    }

    public int getEventsThisWeek() {
        // Gunakan fungsi tarikh dinamik MySQL (CURDATE) supaya lebih bijak
        String sql = "SELECT COUNT(*) FROM eventproposal WHERE proposedDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)";
        return getCount(sql);
    }

    public int getTotalEventsThisYear() {
        // Dinamik ikut tahun semasa
        String sql = "SELECT COUNT(*) FROM eventproposal WHERE YEAR(proposedDate) = YEAR(CURDATE())";
        return getCount(sql);
    }

    public List<String> getRecentActivities() {
        List<String> activities = new ArrayList<>();
        // Sesuaikan dengan nama jadual sebenar: audit_logs, eventproposal, agm_report, clubs
        String sql = """
            SELECT CONCAT(Action, ': ', Description) AS activity, createdAt 
            FROM audit_logs 
            UNION ALL
            SELECT CONCAT('New Proposal: ', title), createdAt 
            FROM eventproposal 
            UNION ALL
            SELECT CONCAT('AGM Report: ', clubName, ' - ', status), submittedAt 
            FROM agm_report ar JOIN clubs c ON ar.clubId = c.clubId
            ORDER BY createdAt DESC 
            LIMIT 5
            """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                activities.add(rs.getString("activity"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    public List<EventSummary> getUpcomingEvents() {
        List<EventSummary> events = new ArrayList<>();
        // Gabungkan jadual eventproposal dan clubs (Kita buang table Event yang tak wujud tu)
        String sql = """
            SELECT ep.proposedDate, ep.venue, c.clubName, ep.title
            FROM eventproposal ep
            JOIN clubs c ON ep.clubId = c.clubId
            WHERE ep.proposedDate >= CURDATE() AND ep.Status IN ('Approved', 'Meeting_Scheduled')
            ORDER BY ep.proposedDate ASC
            LIMIT 5
            """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                EventSummary event = new EventSummary();
                event.setTitle(rs.getString("title"));
                event.setClubName(rs.getString("clubName"));
                event.setDate(rs.getDate("proposedDate"));
                event.setVenue(rs.getString("venue"));
                events.add(event);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return events;
    }

    // Helper class for upcoming events
    public static class EventSummary {

        private String title;
        private String clubName;
        private java.sql.Date date;
        private String venue;

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getClubName() {
            return clubName;
        }

        public void setClubName(String clubName) {
            this.clubName = clubName;
        }

        public java.sql.Date getDate() {
            return date;
        }

        public void setDate(java.sql.Date date) {
            this.date = date;
        }

        public String getVenue() {
            return venue;
        }

        public void setVenue(String venue) {
            this.venue = venue;
        }
    }

    private int getCount(String sql) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalEventsByYear(int year) {
        int total = 0;
        // Example SQL: "SELECT COUNT(*) FROM events WHERE YEAR(event_date) = ?"
        String sql = "SELECT COUNT(*) FROM eventproposal WHERE EXTRACT(YEAR FROM proposedDate) = ? AND status = 'Approved'";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }
}
