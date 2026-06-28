package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Notification;
import util.DBConnection;
import util.EmailService; // Tambahan Import

public class NotificationDAO {

    // 1. Fetch Unread Notifications for a Club (Used in Dashboard)
    public List<Notification> getUnreadNotifications(int clubId) {
        List<Notification> list = new ArrayList<>();
        // Fetch unread, newest first
        String sql = "SELECT * FROM notifications WHERE clubId = ? AND isRead = 0 ORDER BY createdAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setNotificationId(rs.getInt("notificationId"));
                    n.setTitle(rs.getString("title"));
                    n.setMessage(rs.getString("message"));
                    n.setType(rs.getString("type"));
                    n.setActionLink(rs.getString("actionLink"));
                    n.setActionLabel(rs.getString("actionLabel"));
                    n.setCreatedAt(rs.getTimestamp("createdAt"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Specific Logic: Send AGM Reminder (Triggered by MPP)
    public boolean sendAGMReminder(int clubId) {
        String title = "Action Required: AGM Report";
        String message = "Your club has not submitted the Annual General Meeting report for 2026. Please submit it immediately to avoid suspension.";
        String type = "REMINDER";
        String actionLink = "/common/agm"; // Link to your AGM submission page
        String actionLabel = "Submit Report";

        return createNotification(clubId, title, message, type, actionLink, actionLabel);
    }

    // 3. Specific Logic: Send "Approved" Status (Triggered when MPP approves something)
    public boolean sendApprovalNotification(int clubId, String eventName) {
        String title = "Proposal Approved";
        String message = "Good news! Your event proposal '" + eventName + "' has been approved by MPP.";
        String type = "STATUS";
        String actionLink = "/chc/events";
        String actionLabel = "View Event";

        return createNotification(clubId, title, message, type, actionLink, actionLabel);
    }

    // 4. Generic Helper: Insert Notification into DB
    public boolean createNotification(int clubId, String title, String message, String type, String link, String label) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean isSuccess = false;

        // Ensure table columns match this!
        String sql = "INSERT INTO notifications (clubId, title, message, type, actionLink, actionLabel, isRead) VALUES (?, ?, ?, ?, ?, ?, 0)";

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setInt(1, clubId);
            ps.setString(2, title);
            ps.setString(3, message);
            ps.setString(4, type);     // ENUM: 'REMINDER', 'STATUS', 'ANNOUNCEMENT'
            ps.setString(5, link);     // Can be NULL
            ps.setString(6, label);    // Can be NULL

            isSuccess = ps.executeUpdate() > 0;

            // --- JIKA BERJAYA SIMPAN, HANTAR E-MEL KE AJK KELAB ---
            if (isSuccess) {
                dispatchEmailsAsync(clubId, title, message, null);
            }

            return isSuccess;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
    }

    // 5. Mark as Read (When user clicks "Mark all read")
    public boolean markAllAsRead(int clubId) {
        String sql = "UPDATE notifications SET isRead = 1 WHERE clubId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 6. Fungsi Khas untuk Notifikasi Bersasar (Target Role)
    public boolean createNotificationWithRole(int clubId, String title, String message, String type, String link, String label, String targetRole) {
        String sql = "INSERT INTO notifications (clubId, title, message, type, actionLink, actionLabel, isRead, targetRole) VALUES (?, ?, ?, ?, ?, ?, 0, ?)";
        boolean isSuccess = false;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clubId);
            ps.setString(2, title);
            ps.setString(3, message);
            ps.setString(4, type);
            ps.setString(5, link);
            ps.setString(6, label);
            ps.setString(7, targetRole);

            isSuccess = ps.executeUpdate() > 0;

            // --- JIKA BERJAYA SIMPAN, HANTAR E-MEL BERSASAR ---
            if (isSuccess) {
                dispatchEmailsAsync(clubId, title, message, targetRole);
            }

            return isSuccess;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================================
    // HELPER METHOD: Cari Penerima E-mel & Tembak (Background)
    // ========================================================
    private void dispatchEmailsAsync(int clubId, String title, String message, String targetRole) {
        new Thread(() -> {
            System.out.println("\n[EMAIL SYSTEM] Memulakan pencarian e-mel untuk Notifikasi: " + title);
            System.out.println("[EMAIL SYSTEM] Target Role: " + targetRole + " | Club ID: " + clubId);

            String sql = "";

            // 1. Roles Universiti (HEPA, MPP, Faculty) - Tiada kaitan dengan clubId spesifik
            boolean isUniversal = "HEPA".equalsIgnoreCase(targetRole) || "MPP".equalsIgnoreCase(targetRole) || "Faculty".equalsIgnoreCase(targetRole);

            // 2. Role Penasihat (Advisor) - Terikat dengan clubId spesifik
            boolean isAdvisor = "Advisor".equalsIgnoreCase(targetRole);

            if (isUniversal) {
                sql = "SELECT email, fullName FROM user WHERE role = ? AND isActive = 1";
            } else if (isAdvisor) {
                // Cari Advisor KHAS untuk Kelab ini sahaja
                sql = "SELECT u.email, u.fullName FROM user u JOIN clubs c ON u.userId = c.advisorId WHERE c.clubId = ? AND u.isActive = 1";
            } else {
                // Sasar kepada Pelajar / CHC Kelab ini sahaja
                sql = "SELECT u.email, u.fullName FROM user u "
                        + "JOIN club_memberships cm ON u.userId = cm.userId "
                        + "WHERE cm.clubId = ? AND cm.isActive = 1";

                if (targetRole != null && !targetRole.trim().isEmpty() && !"CHC".equalsIgnoreCase(targetRole)) {
                    sql += " AND cm.position = ?";
                }
            }

            System.out.println("[EMAIL SYSTEM] SQL Digunakan: " + sql);

            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

                if (isUniversal) {
                    ps.setString(1, targetRole);
                } else if (isAdvisor) {
                    ps.setInt(1, clubId); // Masukkan parameter clubId untuk cari Advisor yang betul
                } else {
                    ps.setInt(1, clubId);
                    if (targetRole != null && !targetRole.trim().isEmpty() && !"CHC".equalsIgnoreCase(targetRole)) {
                        ps.setString(2, targetRole);
                    }
                }

                int jumlahUser = 0;
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        jumlahUser++;
                        String email = rs.getString("email");
                        String name = rs.getString("fullName");

                        System.out.println("[EMAIL SYSTEM] Jumpa Penerima ke-" + jumlahUser + ": " + name + " (" + email + ")");
                        util.EmailService.sendGeneralNotification(email, name, title, message);
                    }
                }

                if (jumlahUser == 0) {
                    System.err.println("[EMAIL SYSTEM ERROR] GAGAL HANTAR: Tiada pengguna ditemui dalam database untuk peranan '" + targetRole + "'!");
                } else {
                    System.out.println("[EMAIL SYSTEM] Selesai menghantar kepada " + jumlahUser + " orang penerima.\n");
                }

            } catch (Exception e) {
                System.err.println("[EMAIL SYSTEM CRASH] Ralat Thread Email: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }

    // --- FUNGSI BARU 1: Tandakan SATU notifikasi sebagai dibaca ---
    public boolean markAsRead(int notificationId) {
        String sql = "UPDATE notifications SET isRead = 1 WHERE notificationId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- FUNGSI BARU 2: Tandakan SEMUA dibaca (Sokong Club & Role) ---
    public boolean markAllAsReadDynamic(int clubId, String role) {
        // Kalau dia CHC, update ikut clubId. Kalau dia HEPA/MPP, update ikut targetRole
        String sql = "UPDATE notifications SET isRead = 1 WHERE (clubId = ? AND clubId != 0) OR targetRole = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            ps.setString(2, role);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Notification> getUnreadNotificationsForRole(String role) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE targetRole = ? AND isRead = 0 ORDER BY createdAt DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setNotificationId(rs.getInt("notificationId"));
                    n.setTitle(rs.getString("title"));
                    n.setMessage(rs.getString("message"));
                    n.setType(rs.getString("type"));
                    n.setActionLink(rs.getString("actionLink"));
                    n.setActionLabel(rs.getString("actionLabel"));
                    n.setCreatedAt(rs.getTimestamp("createdAt"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
