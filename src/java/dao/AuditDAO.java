package dao;

import util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.AuditLog;

public class AuditDAO {

    // 1. General System Log
    public void log(String userId, String action, String description) {
        new Thread(() -> {
            String sql = "INSERT INTO audit_logs (userId, Action, Description, createdAt) VALUES (?, ?, ?, NOW())";
            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, userId);
                ps.setString(2, action);
                ps.setString(3, description);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }).start();
    }

    // 2. Log specifically for Proposal Tracking (The "Parcel Tracker" Engine)
    public void logProposalEvent(String userId, int proposalId, String action, String description) {
        new Thread(() -> {
            String sql = "INSERT INTO audit_logs (userId, proposalId, Action, Description, createdAt) VALUES (?, ?, ?, ?, NOW())";
            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, userId);
                ps.setInt(2, proposalId);
                ps.setString(3, action);
                ps.setString(4, description);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }).start();
    }

    // 3. Fetch Timeline for a specific Proposal (Oldest first for chronological parcel tracking)
    public List<AuditLog> getProposalTimeline(int proposalId) {
        List<AuditLog> timeline = new ArrayList<>();
        String sql = "SELECT * FROM audit_logs WHERE proposalId = ? ORDER BY createdAt ASC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, proposalId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuditLog log = new AuditLog();
                    log.setLogId(rs.getInt("logId"));
                    log.setUserId(rs.getString("userId"));
                    log.setAction(rs.getString("Action"));
                    log.setDescription(rs.getString("Description"));
                    if (rs.getTimestamp("createdAt") != null) {
                        log.setTimestamp(rs.getTimestamp("createdAt").toString());
                    }
                    timeline.add(log);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return timeline;
    }

    // 4. FIX: Fetch ALL logs for the Forensic Audit Trail (Newest first)
    public List<AuditLog> getAllLogs() {
        List<AuditLog> logs = new ArrayList<>();
        
        // Using strict camelCase matching your DB (userId, fullName, createdAt)
        String sql = "SELECT a.*, u.fullName, u.role, u.department " +
                     "FROM audit_logs a " +
                     "LEFT JOIN user u ON a.userId = u.userId " +
                     "ORDER BY a.createdAt DESC";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                AuditLog log = new AuditLog();
                // Make sure "logId", "action", and "description" match your DB exactly
                log.setLogId(rs.getInt("logId"));
                log.setUserId(rs.getString("userId"));
                log.setAction(rs.getString("action")); // changed from "Action"
                log.setDescription(rs.getString("description")); // changed from "Description"
                
                if (rs.getTimestamp("createdAt") != null) {
                    log.setTimestamp(rs.getTimestamp("createdAt").toString());
                }

                // --- CAPTURE THE JOINED USER DATA ---
                String fName = rs.getString("fullName");
                log.setUserName((fName != null && !fName.isEmpty()) ? fName : "Unknown User");
                
                String role = rs.getString("role");
                String dept = rs.getString("department");
                
                if (role != null) {
                    if ("CHC".equals(role) && dept != null && !dept.isEmpty()) {
                        log.setUserRole("Club (" + dept + ")");
                    } else if ("MPP".equals(role) && dept != null && !dept.isEmpty()) {
                        log.setUserRole("MPP (" + dept + ")");
                    } else {
                        log.setUserRole(role);
                    }
                } else {
                    log.setUserRole("System / Unregistered");
                }
                
                logs.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error in getAllLogs. Please check column names.");
        }
        return logs;
    }

    // 5. Fetch Recent Logs (Useful for Dashboards)
    public List<AuditLog> getRecentLogs() {
        List<AuditLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM audit_logs ORDER BY createdAt DESC LIMIT 10";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AuditLog log = new AuditLog();
                log.setLogId(rs.getInt("logId"));
                log.setUserId(rs.getString("userId"));
                log.setAction(rs.getString("Action"));
                log.setDescription(rs.getString("Description"));
                if (rs.getTimestamp("createdAt") != null) {
                    log.setTimestamp(rs.getTimestamp("createdAt").toString());
                }
                logs.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }
}
