package dao;

import model.Club;
import model.User;
import util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import util.PasswordUtil;
import util.EmailService;

public class ClubDAO {

    // 1. Get All Clubs (DIPERBAIKI UNTUK CLUSTER)
    public List<Club> getAllClubs() {
        List<Club> clubs = new ArrayList<>();

        String sql = "SELECT c.*, c.agmReminderCount, "
                + "u.fullName AS presidentName, "
                + "(SELECT u2.fullName FROM user u2 JOIN club_memberships cm2 ON u2.userId = cm2.userId WHERE cm2.clubId = c.clubId AND cm2.position = 'Secr' AND cm2.isActive = 1 LIMIT 1) as secName, "
                + "(SELECT u3.fullName FROM user u3 JOIN club_memberships cm3 ON u3.userId = cm3.userId WHERE cm3.clubId = c.clubId AND cm3.position = 'Treas' AND cm3.isActive = 1 LIMIT 1) as tresName, "
                + "ar.status AS agmStatus, ar.reportPath, ar.submittedAt "
                + "FROM clubs c "
                + "LEFT JOIN club_memberships cm ON c.clubId = cm.clubId AND cm.position = 'Pres' AND cm.isActive = 1 "
                + "LEFT JOIN user u ON cm.userId = u.userId "
                + "LEFT JOIN agm_report ar ON c.clubId = ar.clubId AND ar.reportYear = ? "
                + "WHERE c.clubId != 9999 " // <--- TAMPAL FILTER NI KAT SINI
                + "ORDER BY c.clubId ASC";

        int currentYear = Calendar.getInstance().get(Calendar.YEAR);

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, currentYear);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Club club = new Club();
                club.setAgmReminderCount(rs.getInt("agmReminderCount"));
                club.setClubId(rs.getInt("clubId"));
                club.setClubName(rs.getString("clubName"));

                club.setCategory(rs.getString("category")); // Akademik / Bukan Akademik

                // --- INI YANG TERTINGGAL SEBELUM NI ---
                // Cuba tangkap data 'cluster', abaikan kalau error (jika table kau takde column ni)
                try {
                    club.setCluster(rs.getString("cluster"));
                } catch (Exception e) {
                    System.out.println("Nota: Lajur 'cluster' mungkin tiada dalam database, diabaikan.");
                }
                // --------------------------------------

                club.setLogoPath(rs.getString("logoPath"));
                club.setEstablishedYear(rs.getInt("establishedYear"));
                club.setStatus(rs.getString("status"));

                club.setPresidentName(rs.getString("presidentName"));
                club.setSecretaryName(rs.getString("secName"));
                club.setTreasurerName(rs.getString("tresName"));

                String agmStatus = rs.getString("agmStatus");
                if (agmStatus != null) {
                    club.setLastAGMStatus(agmStatus.substring(0, 1).toUpperCase() + agmStatus.substring(1));
                    club.setAgmReportPath(rs.getString("reportPath"));
                    club.setAgmSubmissionDate(rs.getString("submittedAt"));
                } else {
                    club.setLastAGMStatus("Missing");
                }

                clubs.add(club);
            }
        } catch (SQLException e) {
            System.out.println("❌ ERROR in getAllClubs: " + e.getMessage());
            e.printStackTrace();
        }
        return clubs;
    }

    // 2. Update Status
    public boolean updateClubStatus(int clubId, String newStatus) {
        String sql = "UPDATE clubs SET status = ? WHERE clubId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, clubId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. Register a New Club & Create Advisor Account (Transaction Safe)
    public boolean registerNewClub(String clubName, String category, String cluster, int year,
            String advisorId, String advisorName, String advisorEmail) {
        boolean isSuccess = false;

        try (Connection conn = DBConnection.getConnection()) {
            // Start Transaction to ensure both User and Club are created together
            conn.setAutoCommit(false);

            try {
                // STEP A: Check if the Advisor already exists in the 'user' table
                String checkUserSql = "SELECT userId FROM user WHERE userId = ?";
                boolean userExists = false;
                try (PreparedStatement psCheck = conn.prepareStatement(checkUserSql)) {
                    psCheck.setString(1, advisorId);
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next()) {
                            userExists = true;
                        }
                    }
                }

                // STEP B: If Advisor doesn't exist, create their account
                if (!userExists) {
                    // Using a default temporary password "Temp123!"
                    String insertUserSql = "INSERT INTO user (userId, fullName, email, role, password, isActive) VALUES (?, ?, ?, 'Advisor', 'Temp123!', 1)";
                    try (PreparedStatement psUser = conn.prepareStatement(insertUserSql)) {
                        psUser.setString(1, advisorId);
                        psUser.setString(2, advisorName);
                        psUser.setString(3, advisorEmail);
                        psUser.executeUpdate();
                    }
                }

                // STEP C: Insert the new Club WITH the cluster and advisorId
                String insertClubSql = "INSERT INTO clubs (clubName, category, cluster, establishedYear, status, advisorId, logoPath) VALUES (?, ?, ?, ?, 'active', ?, 'default_logo.png')";
                try (PreparedStatement psClub = conn.prepareStatement(insertClubSql)) {
                    psClub.setString(1, clubName);
                    psClub.setString(2, category);
                    psClub.setString(3, cluster);
                    psClub.setInt(4, year);
                    psClub.setString(5, advisorId);
                    psClub.executeUpdate();
                }

                // Commit the transaction if everything succeeded
                conn.commit();
                isSuccess = true;

            } catch (SQLException e) {
                // If anything fails, rollback to prevent partial data (e.g., user created but no club)
                conn.rollback();
                System.out.println("Error Registering Club & Advisor: " + e.getMessage());
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return isSuccess;
    }

    public boolean updateClubDetails(Club club) {
        // Ensure table name matches (club or clubs)
        String sql = "UPDATE clubs SET category = ?, establishedYear = ?, mission = ?, vision = ? WHERE clubId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, club.getCategory());
            ps.setInt(2, club.getEstablishedYear());
            ps.setString(3, club.getMission());
            ps.setString(4, club.getVision());
            ps.setInt(5, club.getClubId());

            int rowsUpdated = ps.executeUpdate();

            // DEBUG: See if the update actually happened in the console
            System.out.println("DEBUG DAO: Updating Club " + club.getClubId());
            System.out.println("DEBUG DAO: Rows affected: " + rowsUpdated);

            return rowsUpdated > 0;

        } catch (SQLException e) {
            System.out.println("ERROR DAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // 5. Delete a Club
    public boolean deleteClub(int clubId) {
        String sqlMembers = "DELETE FROM club_memberships WHERE clubId = ?";
        String sqlClub = "DELETE FROM clubs WHERE clubId = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psMembers = conn.prepareStatement(sqlMembers); PreparedStatement psClub = conn.prepareStatement(sqlClub)) {

                psMembers.setInt(1, clubId);
                psMembers.executeUpdate();

                psClub.setInt(1, clubId);
                int rows = psClub.executeUpdate();

                conn.commit();
                return rows > 0;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 6. Assign a President (UPDATED: Tangkap Trigger Error & Return String)
    public String assignPresident(User user, int clubId) {
        Connection conn = null;
        PreparedStatement psDeleteOld = null;
        PreparedStatement psCreateUser = null;
        PreparedStatement psAssign = null;

        // STEP A: Generate a secure random password (10 chars)
        String tempPassword = PasswordUtil.generateRandomPassword(10);

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // 1. DELETE old president
            String sqlDeleteOld = "DELETE FROM club_memberships WHERE clubId = ? AND position = 'Pres'";
            psDeleteOld = conn.prepareStatement(sqlDeleteOld);
            psDeleteOld.setInt(1, clubId);
            psDeleteOld.executeUpdate();

            // 2. Create User (INSERT IGNORE checks for duplicates)
            String sqlCreateUser = "INSERT INTO user (userId, fullName, email, password, role, department, isActive) "
                    + "VALUES (?, ?, ?, ?, 'CHC', 'Student', 1) "
                    + "ON DUPLICATE KEY UPDATE password = ?, role = 'CHC'";

            psCreateUser = conn.prepareStatement(sqlCreateUser);
            psCreateUser.setString(1, user.getUserId());
            psCreateUser.setString(2, user.getFullName());
            psCreateUser.setString(3, user.getEmail());
            psCreateUser.setString(4, tempPassword);
            psCreateUser.setString(5, tempPassword); // Update password if exists
            psCreateUser.executeUpdate();

            // 3. Link User to Club
            int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
            String sqlAssign = "INSERT INTO club_memberships (clubId, userId, position, joinYear, isActive) VALUES (?, ?, 'Pres', ?, 1)";
            psAssign = conn.prepareStatement(sqlAssign);
            psAssign.setInt(1, clubId);
            psAssign.setString(2, user.getUserId());
            psAssign.setInt(3, currentYear);
            psAssign.executeUpdate();

            // 4. Get Club Name (Needed for the email)
            String clubName = getClubName(conn, clubId);

            // Commit the transaction
            conn.commit();

            // STEP B: Send Email Notification (Background Thread)
            new Thread(() -> {
                EmailService.sendPasswordEmail(
                        user.getEmail(),
                        user.getFullName(),
                        tempPassword,
                        "Pres", // Role
                        clubName // Club Name
                );
            }).start();

            return "SUCCESS"; // Berjaya sepenuhnya

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }

            // --- TANGKAP TRIGGER ERROR DARI SQL ---
            if (e.getSQLState() != null && e.getSQLState().equals("45000")) {
                return e.getMessage(); // Pulangkan mesej "Error: Pelajar ini sudah..." dari MySQL
            }
            // Tangkap ralat Duplicate Key biasa
            if (e.getSQLState() != null && e.getSQLState().startsWith("23")) {
                return "Ralat: Pertindihan data (Duplicate Entry). Semak semula ID Pelajar.";
            }

            return "Ralat Pangkalan Data: Gagal melantik presiden.";

        } finally {
            try {
                if (psAssign != null) {
                    psAssign.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psCreateUser != null) {
                    psCreateUser.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psDeleteOld != null) {
                    psDeleteOld.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
    }

    // 7. Remove President
    public boolean removePresident(int clubId) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "DELETE FROM club_memberships WHERE clubId = ? AND position = 'Pres'";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            ps = conn.prepareStatement(sql);
            ps.setInt(1, clubId);
            int rows = ps.executeUpdate();
            conn.commit();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) try {
                conn.rollback();
            } catch (Exception ex) {
            }
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
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
    }

    public boolean incrementReminderCount(int clubId) {
        String sql = "UPDATE clubs SET agmReminderCount = agmReminderCount + 1 WHERE clubId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean resetReminderCount(int clubId) {
        String sql = "UPDATE clubs SET agmReminderCount = 0 WHERE clubId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- HELPER: Get Club Name by ID ---
    private String getClubName(Connection conn, int clubId) {
        String sql = "SELECT clubName FROM clubs WHERE clubId = ?";
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

    // 8. Get Single Club by ID (For Dashboard Stats & Notifications)
    public Club getClubById(int clubId) {
        Club club = null;
        String sql = "SELECT * FROM clubs WHERE clubId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    club = new Club();
                    club.setClubId(rs.getInt("clubId"));
                    club.setClubName(rs.getString("clubName"));
                    club.setAgmReminderCount(rs.getInt("agmReminderCount")); // <--- Crucial for Notification
                    // ... set other fields if needed, but these are enough for the header
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return club;
    }

    // In src/java/dao/ClubDAO.java
    public Club getClubProfile(int clubId) {
        Club club = null;
        // 1. Fetch Basic Details
        String sql = "SELECT * FROM clubs WHERE clubId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clubId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                club = new Club();
                club.setClubId(rs.getInt("clubId"));
                club.setClubName(rs.getString("clubName"));
                club.setCategory(rs.getString("category"));

                // FIX: Ensure this column name matches your DB exactly (e.g. 'established_year' or 'establishedYear')
                club.setEstablishedYear(rs.getInt("establishedYear"));

                club.setStatus(rs.getString("status"));

                // Safe handling for optional text fields
                try {
                    club.setMission(rs.getString("mission"));
                } catch (Exception e) {
                }
                try {
                    club.setVision(rs.getString("vision"));
                } catch (Exception e) {
                }
                try {
                    club.setLogoPath(rs.getString("logoPath"));
                } catch (Exception e) {
                }

                // 2. Fetch Leadership Names
                // We pass the connection to avoid opening/closing it multiple times
                club.setPresidentName(getCommitteeName(conn, clubId, "Pres"));
                club.setSecretaryName(getCommitteeName(conn, clubId, "Secr"));
                club.setTreasurerName(getCommitteeName(conn, clubId, "Treas"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return club;
    }

// Helper Method to fetch names
    private String getCommitteeName(Connection conn, int clubId, String positionCode) {
        String name = "Vacant";
        // Join club_memberships with user table
        // Ensure 'Position' (capital P) matches your DB column if it is case sensitive
        String sql = "SELECT u.fullName FROM club_memberships cm "
                + "JOIN user u ON cm.userId = u.userId "
                + "WHERE cm.clubId = ? AND cm.Position = ? AND cm.isActive = 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            ps.setString(2, positionCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    name = rs.getString("fullName");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return name;
    }

    public boolean updateClubLogo(int clubId, String logoPath) {
        String sql = "UPDATE clubs SET logoPath = ? WHERE clubId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, logoPath);
            ps.setInt(2, clubId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================================
    // FUNGSI BARU: JEJAK SEJARAH KEAHLIAN PELAJAR (REQUEST EN. KHALIES)
    // ========================================================
    // 1. Tarik nama penuh pelajar
    public String getStudentNameById(String userId) {
        String sql = "SELECT fullName FROM user WHERE userId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("fullName");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 2. Tarik sejarah kelab pelajar
    public List<Map<String, Object>> getStudentMembershipHistory(String userId) {
        List<Map<String, Object>> history = new ArrayList<>();
        // Join jadual kelab dan jadual keahlian
        String sql = "SELECT c.clubName, c.cluster, cm.position, cm.joinYear, cm.isActive "
                + "FROM club_memberships cm "
                + "JOIN clubs c ON cm.clubId = c.clubId "
                + "WHERE cm.userId = ? "
                + "ORDER BY cm.isActive DESC, cm.joinYear DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("clubName", rs.getString("clubName"));
                    map.put("cluster", rs.getString("cluster"));
                    map.put("position", rs.getString("position"));
                    map.put("joinYear", rs.getInt("joinYear"));
                    map.put("isActive", rs.getInt("isActive")); // 1 = Active, 0 = Past
                    history.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return history;
    }

    // ========================================================
    // END OF ACADEMIC SESSION (TUKAR SEMUA AJK JADI ALUMNI)
    // ========================================================
    public boolean terminateAllActiveMemberships() {
        // Tukar semua yang aktif (1) jadi mantan (0)
        String sql = "UPDATE club_memberships SET isActive = 0 WHERE isActive = 1";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            int rowsAffected = ps.executeUpdate();
            System.out.println("Tamat Sesi: " + rowsAffected + " jawatan telah ditamatkan.");

            return true; // Berjaya asalkan tiada ralat SQL (walaupun 0 rows affected)
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================================
    // DAPATKAN EMAIL PRESIDEN UNTUK PENGHANTARAN E-MEL
    // ========================================================
    public String getClubPresidentEmail(int clubId) {
        String email = null;
        String sql = "SELECT u.email FROM club_memberships cm "
                + "JOIN user u ON cm.userId = u.userId "
                + "WHERE cm.clubId = ? AND cm.position = 'Pres' AND cm.isActive = 1 LIMIT 1";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    email = rs.getString("email");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return email;
    }

    // ========================================================
    // GET FULL MEMBER LIST FOR A SPECIFIC CLUB
    // ========================================================
    public List<Map<String, Object>> getClubMembersList(int clubId) {
        List<Map<String, Object>> members = new ArrayList<>();

        // Custom sort: Active members first, then order by hierarchy (Pres -> Secr -> Treas -> Member)
        String sql = "SELECT u.userId, u.fullName, u.email, cm.position, cm.joinYear, cm.isActive "
                + "FROM club_memberships cm "
                + "JOIN user u ON cm.userId = u.userId "
                + "WHERE cm.clubId = ? "
                + "ORDER BY cm.isActive DESC, "
                + "CASE cm.position "
                + "  WHEN 'Pres' THEN 1 "
                + "  WHEN 'Secr' THEN 2 "
                + "  WHEN 'Treas' THEN 3 "
                + "  ELSE 4 END ASC, "
                + "u.fullName ASC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("userId", rs.getString("userId"));
                    map.put("fullName", rs.getString("fullName"));
                    map.put("email", rs.getString("email"));
                    map.put("position", rs.getString("position"));
                    map.put("joinYear", rs.getInt("joinYear"));
                    map.put("isActive", rs.getInt("isActive"));
                    members.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return members;
    }
}
