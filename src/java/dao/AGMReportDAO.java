package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import util.DBConnection;

public class AGMReportDAO {

    private final NotificationDAO notifDAO = new NotificationDAO();

    // 1. KELAB (CHC) HANTAR LAPORAN AGM (Dengan Logik Anti-Duplicate)
    public boolean submitAGMReport(int clubId, String reportYear, String reportPath) {
        String checkSql = "SELECT agmId FROM agm_report WHERE clubId = ? AND reportYear = ?";
        String insertSql = "INSERT INTO agm_report (clubId, reportYear, reportPath, status, submittedAt) VALUES (?, ?, ?, 'Pending_MPP', NOW())";
        String updateSql = "UPDATE agm_report SET reportPath = ?, status = 'Pending_MPP', submittedAt = NOW() WHERE agmId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, clubId);
            checkPs.setString(2, reportYear);
            ResultSet rs = checkPs.executeQuery();

            boolean success = false;
            if (rs.next()) {
                int agmId = rs.getInt("agmId");
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setString(1, reportPath);
                    updatePs.setInt(2, agmId);
                    success = updatePs.executeUpdate() > 0;
                }
            } else {
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setInt(1, clubId);
                    insertPs.setString(2, reportYear);
                    insertPs.setString(3, reportPath);
                    success = insertPs.executeUpdate() > 0;
                }
            }

            // --- NOTIFIKASI KE MPP ---
            if (success) {
                notifDAO.createNotificationWithRole(clubId, "Semakan AGM Diperlukan",
                        "Kelab ID " + clubId + " telah menghantar laporan AGM tahun " + reportYear,
                        "STATUS", "/mpp/agm", "Semak Sekarang", "MPP");
            }
            return success;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. PAPARAN UNTUK KELAB (CHC)
    public List<Map<String, Object>> getAGMReportsByClub(int clubId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM agm_report WHERE clubId = ? ORDER BY reportYear DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("agmId", rs.getInt("agmId"));
                    map.put("reportYear", rs.getString("reportYear"));
                    map.put("reportPath", rs.getString("reportPath"));
                    map.put("status", rs.getString("status"));
                    map.put("remarks", rs.getString("remarks"));
                    map.put("submittedAt", rs.getTimestamp("submittedAt"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3A. VIEW FOR MPP (Pulls ALL history, prioritizes Pending_MPP at the top)
    public List<Map<String, Object>> getAGMReportsForMPP() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT a.*, c.clubName, c.cluster FROM agm_report a JOIN clubs c ON a.clubId = c.clubId "
                + "ORDER BY CASE WHEN a.status = 'Pending_MPP' THEN 1 ELSE 2 END, a.submittedAt DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("agmId", rs.getInt("agmId"));
                map.put("clubId", rs.getInt("clubId"));
                map.put("clubName", rs.getString("clubName"));
                map.put("reportYear", rs.getString("reportYear"));
                map.put("reportPath", rs.getString("reportPath"));
                map.put("status", rs.getString("status"));
                map.put("remarks", rs.getString("remarks"));
                map.put("cluster", rs.getString("cluster"));
                map.put("submittedAt", rs.getTimestamp("submittedAt"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3B. VIEW FOR HEPA (Pulls Pending_HEPA, Accepted, Missing history)
    public List<Map<String, Object>> getAGMReportsForHEPA() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT a.*, c.clubName, c.cluster FROM agm_report a JOIN clubs c ON a.clubId = c.clubId "
                + "WHERE a.status IN ('Pending_HEPA', 'Accepted', 'Missing') "
                + "ORDER BY CASE WHEN a.status = 'Pending_HEPA' THEN 1 ELSE 2 END, a.submittedAt DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("agmId", rs.getInt("agmId"));
                map.put("clubId", rs.getInt("clubId"));
                map.put("clubName", rs.getString("clubName"));
                map.put("reportYear", rs.getString("reportYear"));
                map.put("reportPath", rs.getString("reportPath"));
                map.put("status", rs.getString("status"));
                map.put("remarks", rs.getString("remarks"));
                map.put("cluster", rs.getString("cluster"));
                map.put("submittedAt", rs.getTimestamp("submittedAt"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. KEMASKINI STATUS OLEH MPP ATAU HEPA
    // 4. UPDATE STATUS BY MPP OR HEPA (Fixed ENUM & Dual Notifications)
    public boolean updateAGMStatus(int agmId, int clubId, String decision, String year, String role, String remarks) {
        String nextStatus = "";
        if ("MPP".equals(role)) {
            nextStatus = "accepted".equalsIgnoreCase(decision) ? "Pending_HEPA" : "Missing";
        } else if ("HEPA".equals(role)) {
            nextStatus = "accepted".equalsIgnoreCase(decision) ? "Accepted" : "Missing";
        }

        String sql = "UPDATE agm_report SET status = ?, remarks = ? WHERE agmId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nextStatus);
            ps.setString(2, remarks);
            ps.setInt(3, agmId);

            if (ps.executeUpdate() > 0) {
                String msgSuffix = ("Missing".equals(nextStatus) && remarks != null && !remarks.isEmpty()) ? "\nReason: " + remarks : "";

                // FIXED ENUM: Replaced "SUCCESS"/"WARNING" with "STATUS"
                if ("Pending_HEPA".equals(nextStatus)) {
                    // Alert HEPA to review
                    notifDAO.createNotificationWithRole(clubId, "AGM Endorsed by MPP", "AGM Report " + year + " endorsed by MPP. Pending your final approval.", "STATUS", "/hepa/agm", "Review", "HEPA");
                    // Alert CHC that they passed stage 1
                    notifDAO.createNotificationWithRole(clubId, "AGM Endorsed by MPP", "AGM Report " + year + " has been endorsed by MPP and is awaiting HEPA approval.", "STATUS", "/common/agm", "View Status", "CHC");
                } else if ("Accepted".equals(nextStatus)) {
                    notifDAO.createNotificationWithRole(clubId, "AGM Approved by HEPA", "AGM Report " + year + " has been officially approved.", "STATUS", "/common/agm", "View", "CHC");
                } else if ("Missing".equals(nextStatus)) {
                    notifDAO.createNotificationWithRole(clubId, "AGM Rejected (" + role + ")", "AGM Report " + year + " rejected." + msgSuffix, "STATUS", "/common/agm", "Update", "CHC");
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. BLAST "REMINDER" 
    public boolean sendAGMReminder(int clubId, String year) {
        try {
            notifDAO.createNotificationWithRole(clubId, "AMARAN: Laporan AGM Tertunggak!",
                    "Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun " + year + " dengan segera bagi mengelakkan kelab digantung.",
                    "WARNING", "/common/agm", "Hantar Sekarang", "CHC");
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
