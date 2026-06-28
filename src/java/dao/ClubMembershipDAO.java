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
import util.EmailService;
import util.PasswordUtil; // Import your new utility

public class ClubMembershipDAO {

    // 1. Get All Active Members for a Club
    public List<Map<String, String>> getMembers(int clubId) {
        List<Map<String, String>> members = new ArrayList<>();
        String sql = "SELECT u.userId, u.fullName, u.email, u.phone, cm.Position, cm.joinYear "
                + "FROM club_memberships cm "
                + "JOIN user u ON cm.userId = u.userId "
                + "WHERE cm.clubId = ? AND cm.isActive = 1 "
                + "ORDER BY CASE "
                + "WHEN cm.Position = 'Pres' THEN 1 "
                + "WHEN cm.Position = 'Vice Pres' THEN 2 "
                + "WHEN cm.Position = 'Secr' THEN 3 "
                + "WHEN cm.Position = 'Treas' THEN 4 "
                + "ELSE 5 END, u.fullName ASC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> m = new HashMap<>();
                    m.put("userId", rs.getString("userId"));
                    m.put("fullName", rs.getString("fullName"));
                    m.put("email", rs.getString("email"));
                    m.put("phone", rs.getString("phone"));
                    m.put("position", rs.getString("Position"));
                    m.put("joinedDate", rs.getString("joinYear"));
                    members.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return members;
    }

    // 2. Add a New Member
    public String addMember(int clubId, String userId, String fullName, String rawPosition, String inputEmail) {

        String position = mapPositionToCode(rawPosition);
        if (position == null || position.isEmpty()) {
            return "Position is required.";
        }

        if (isHighCommittee(position)) {
            if (isPositionTaken(clubId, position, null)) {
                return "Failed: This club already has a " + rawPosition + ". Only 1 allowed.";
            }
            if (inputEmail == null || inputEmail.trim().isEmpty()) {
                return "Personal Email is required for " + rawPosition + ".";
            }
        }

        String emailToSave = (isHighCommittee(position)) ? inputEmail : userId.toLowerCase() + "@ocean.umt.edu.my";

        if (!userExists(userId)) {
            boolean created = createGhostStudent(userId, fullName, emailToSave);
            if (!created) {
                return "Failed to auto-create user.";
            }
        } else {
            if (isHighCommittee(position)) {
                updateUserEmail(userId, emailToSave);
            }
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            if (isMember(clubId, userId)) {
                String sql = "UPDATE club_memberships SET isActive = 1, Position = ? WHERE clubId = ? AND userId = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, position);
                    ps.setInt(2, clubId);
                    ps.setString(3, userId);
                    ps.executeUpdate();
                }
            } else {
                String sql = "INSERT INTO club_memberships (clubId, userId, Position, isActive, joinYear) VALUES (?, ?, ?, 1, YEAR(CURDATE()))";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, clubId);
                    ps.setString(2, userId);
                    ps.setString(3, position);
                    ps.executeUpdate();
                }
            }

            if (isHighCommittee(position)) {
                updateUserRole(conn, userId, "CHC");
                // UPDATED: Pass Club ID and Position
                sendCredentialsEmail(conn, clubId, userId, fullName, emailToSave, position);
            } else {
                updateUserRole(conn, userId, "Student");
            }

            conn.commit();
            return "SUCCESS";

        } catch (SQLException e) {
            if (conn != null) try {
                conn.rollback();
            } catch (SQLException ex) {
            }
            return "Database Error: " + e.getMessage();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
            }
        }
    }

    // 3. Update Member Details
    public boolean updateMemberDetails(int clubId, String userId, String fullName, String phone, String position, String inputEmail) {
        String dbPosition = mapPositionToCode(position);

        if (isHighCommittee(dbPosition)) {
            if (isPositionTaken(clubId, dbPosition, userId)) {
                return false;
            }
        }

        String emailToSave = null;
        if (isHighCommittee(dbPosition) && inputEmail != null && !inputEmail.isEmpty()) {
            emailToSave = inputEmail;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sqlUser = "UPDATE user SET fullName = ?, phone = ?" + (emailToSave != null ? ", email = ?" : "") + " WHERE userId = ?";
            try (PreparedStatement psUser = conn.prepareStatement(sqlUser)) {
                psUser.setString(1, fullName);
                psUser.setString(2, phone);
                if (emailToSave != null) {
                    psUser.setString(3, emailToSave);
                    psUser.setString(4, userId);
                } else {
                    psUser.setString(3, userId);
                }
                psUser.executeUpdate();
            }

            String sqlMember = "UPDATE club_memberships SET Position = ? WHERE clubId = ? AND userId = ?";
            try (PreparedStatement psMember = conn.prepareStatement(sqlMember)) {
                psMember.setString(1, dbPosition);
                psMember.setInt(2, clubId);
                psMember.setString(3, userId);
                psMember.executeUpdate();
            }

            if (isHighCommittee(dbPosition)) {
                updateUserRole(conn, userId, "CHC");
                String targetEmail = (emailToSave != null) ? emailToSave : getUserEmail(conn, userId);
                // UPDATED: Pass Club ID and Position
                sendCredentialsEmail(conn, clubId, userId, fullName, targetEmail, dbPosition);
            } else {
                updateUserRole(conn, userId, "Student");
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) try {
                conn.rollback();
            } catch (SQLException ex) {
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
    }

    // 4. Update Position ONLY (Quick Dropdown)
    public boolean updatePosition(int clubId, String userId, String rawPosition) {
        String dbPosition = mapPositionToCode(rawPosition);

        if (isHighCommittee(dbPosition)) {
            if (isPositionTaken(clubId, dbPosition, userId)) {
                return false;
            }
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sql = "UPDATE club_memberships SET Position = ? WHERE clubId = ? AND userId = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, dbPosition);
                ps.setInt(2, clubId);
                ps.setString(3, userId);
                ps.executeUpdate();
            }

            if (isHighCommittee(dbPosition)) {
                updateUserRole(conn, userId, "CHC");
                String fullName = getFullName(conn, userId);
                String email = getUserEmail(conn, userId);
                // UPDATED: Pass Club ID and Position
                sendCredentialsEmail(conn, clubId, userId, fullName, email, dbPosition);
            } else {
                updateUserRole(conn, userId, "Student");
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try {
                conn.rollback();
            } catch (Exception ex) {
            }
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
    }

    // --- HELPER METHODS ---
    // NEW: Updated to use PasswordUtil, fetch Club Name, and pass Role
    private void sendCredentialsEmail(Connection conn, int clubId, String userId, String fullName, String targetEmail, String position) throws SQLException {

        // 1. Generate STRONG password
        String tempPassword = PasswordUtil.generateRandomPassword(10);

        // 2. Save password
        String sql = "UPDATE user SET password = ? WHERE userId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tempPassword);
            ps.setString(2, userId);
            ps.executeUpdate();
        }

        // 3. Get Club Name
        String clubName = getClubName(conn, clubId);

        // 4. Send Email Background
        new Thread(() -> {
            EmailService.sendPasswordEmail(targetEmail, fullName, tempPassword, position, clubName);
        }).start();
    }

    // NEW: Helper to fetch club name
    private String getClubName(Connection conn, int clubId) {
        String sql = "SELECT clubName FROM club WHERE clubId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("clubName");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "the Club"; // Fallback
    }

    private boolean createGhostStudent(String userId, String fullName, String email) {
        String sql = "INSERT INTO user (userId, fullName, password, role, isActive, email, phone, department) "
                + "VALUES (?, ?, ?, 'Student', 1, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setString(2, fullName);
            ps.setString(3, userId); // Password = ID initially
            ps.setString(4, email);
            ps.setString(5, "");
            ps.setString(6, "General");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void updateUserEmail(String userId, String email) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement("UPDATE user SET email = ? WHERE userId = ?")) {
            ps.setString(1, email);
            ps.setString(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private String getUserEmail(Connection conn, String userId) {
        try (PreparedStatement ps = conn.prepareStatement("SELECT email FROM user WHERE userId = ?")) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString(1);
                }
            }
        } catch (Exception e) {
        }
        return userId + "@ocean.umt.edu.my";
    }

    private boolean isHighCommittee(String positionCode) {
        return "Pres".equals(positionCode)
                || "Vice Pres".equals(positionCode)
                || "Secr".equals(positionCode)
                || "Treas".equals(positionCode);
    }

    private boolean isPositionTaken(int clubId, String positionCode, String excludeUserId) {
        String sql = "SELECT COUNT(*) FROM club_memberships WHERE clubId = ? AND Position = ? AND isActive = 1";
        if (excludeUserId != null) {
            sql += " AND userId != ?";
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            ps.setString(2, positionCode);
            if (excludeUserId != null) {
                ps.setString(3, excludeUserId);
            }
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

    private void updateUserRole(Connection conn, String userId, String newRole) throws SQLException {
        String sql = "UPDATE user SET role = ? WHERE userId = ? AND role != 'MPP'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newRole);
            ps.setString(2, userId);
            ps.executeUpdate();
        }
    }

    private String mapPositionToCode(String pos) {
        if (pos == null) {
            return "Member";
        }
        switch (pos) {
            case "Secretary":
                return "Secr";
            case "Treasurer":
                return "Treas";
            case "Vice President":
                return "Vice Pres";
            case "Committee":
                return "Member";
            default:
                return pos;
        }
    }

    private boolean userExists(String userId) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM user WHERE userId = ?")) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }

    private boolean isMember(int clubId, String userId) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM club_memberships WHERE clubId = ? AND userId = ?")) {
            ps.setInt(1, clubId);
            ps.setString(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean removeMember(int clubId, String userId) {
        String sql = "UPDATE club_memberships SET isActive = 0 WHERE clubId = ? AND userId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            ps.setString(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    private String getFullName(Connection conn, String userId) {
        try (PreparedStatement ps = conn.prepareStatement("SELECT fullName FROM user WHERE userId = ?")) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString(1);
                }
            }
        } catch (Exception e) {
        }
        return "Member";
    }

    // 5. Get Single Member Info (Used for security verification)
    public model.User getMemberById(String userId) {
        // Note: Adjusted table name 'user' based on your DAO's SELECT query
        String sql = "SELECT u.userId, u.fullName, u.email, cm.Position "
                + "FROM user u "
                + "JOIN club_memberships cm ON u.userId = cm.userId "
                + "WHERE u.userId = ? AND cm.isActive = 1";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    model.User u = new model.User();
                    u.setUserId(rs.getString("userId"));
                    u.setFullName(rs.getString("fullName"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("Position"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
