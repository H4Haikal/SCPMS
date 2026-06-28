package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.User;
import util.DBConnection;

public class UserDAO {

    public User authenticate(String email, String password) {
        User user = null;

        // SQL ini akan tarik maklumat pengguna DAN kira berapa jumlah JAWATAN AKTIF yang dia pegang sekarang
        String sql = "SELECT u.*, "
                + "(SELECT COUNT(*) FROM club_memberships cm WHERE cm.userId = u.userId AND cm.isActive = 1) AS activeRolesCount "
                + "FROM user u "
                + "WHERE u.email = ? AND u.password = ?";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {

                    // 1. SEMAKAN UMUM: Adakah akaun ini telah digantung oleh HEPA?
                    int userIsActive = rs.getInt("isActive");
                    if (userIsActive == 0) {
                        // Jika nak lontar error ke Servlet, kau kena ubah return type atau throw exception.
                        // Cara mudah: kembalikan null, tapi kita ubah mesej di Servlet nanti. (Atau biar je null untuk tunjuk "Invalid").
                        System.out.println("Login ditolak: Akaun digantung.");
                        return null;
                    }

                    String role = rs.getString("role");
                    int activeRolesCount = rs.getInt("activeRolesCount");

                    // =======================================================
                    // 2. SEKATAN MANTAN AJK (Permintaan En. Khalies)
                    // Jika peranan (role) adalah CHC (Majlis Tertinggi) atau MPP,
                    // mereka WAJIB ada sekurang-kurangnya 1 rekod aktif dalam jadual kelab.
                    // =======================================================
                    if (("CHC".equals(role)) && activeRolesCount == 0) {
                        System.out.println("Login ditolak: Sesi " + role + " telah tamat (Tiada rekod aktif).");
                        return null; // Halang masuk!
                    }

                    // 3. JIKA LULUS SEMUA SEKATAN, BENARKAN LOGIN
                    user = new User();
                    user.setUserId(rs.getString("userId"));
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(role);

                    // Ambil isTempPassword kalau kau guna (tengok struktur database kau)
                    try {
                        user.setIsTempPassword(rs.getInt("isTempPassword"));
                    } catch (Exception e) {
                        // Abaikan jika column ni takde dalam jadual 'user' kau
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Ralat Pangkalan Data (Login): " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }

// Helper method to debug WHY it failed
    private void checkIfEmailExists(String email) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT * FROM User WHERE email = ?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                System.out.println("DEBUG: Email exists! Password or isActive status might be wrong.");
                System.out.println("DEBUG: DB Password: " + rs.getString("password"));
                System.out.println("DEBUG: DB isActive: " + rs.getBoolean("isActive"));
            } else {
                System.out.println("DEBUG: Email does NOT exist in the database.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Save OTP to user table
    public boolean saveOTP(String email, String otp) {
        String sql = "UPDATE user SET otp_code = ?, otp_expiry = DATE_ADD(NOW(), INTERVAL 10 MINUTE) WHERE email = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, otp);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

// Verify OTP
    public boolean verifyOTP(String email, String otp) {
        String sql = "SELECT * FROM user WHERE email = ? AND otp_code = ? AND otp_expiry > NOW()";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            return false;
        }
    }

// Reset Password
    public boolean resetPassword(String email, String newPassword) {
        String sql = "UPDATE user SET password = ?, isTempPassword = 0, otp_code = NULL WHERE email = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword); // Use PasswordUtil.hash if you have hashing
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean updatePassword(String userId, String newPassword) {
        // We update the password AND flip the isTempPassword flag to 0
        String sql = "UPDATE user SET password = ?, isTempPassword = 0 WHERE userId = ?";

        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword); // Hash this if you have a PasswordUtil
            ps.setString(2, userId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 1. Update Profile Info (Name, Phone, Email)
    public boolean updateUserProfile(String userId, String fullName, String phone, String email, String department) {
        // Added 'department = ?' to the query
        String sql = "UPDATE user SET fullName = ?, phone = ?, email = ?, department = ? WHERE userId = ?";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, department); // Set the department value
            ps.setString(5, userId);

            return ps.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

// 2. Check Password (For security verification)
    public boolean checkPassword(String userId, String inputPassword) {
        String sql = "SELECT password FROM user WHERE userId = ?";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbPass = rs.getString("password");
                    return dbPass.equals(inputPassword); // Use hashing check if you use hashes
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// --- GET USER BY ID (For Refreshing Session Data) ---
    public model.User getUser(String userId) {
        model.User user = null;
        String sql = "SELECT * FROM user WHERE userId = ?";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);

            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new model.User();
                    user.setUserId(rs.getString("userId"));
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                    user.setDepartment(rs.getString("department"));
                    user.setIsTempPassword(rs.getInt("isTempPassword"));

                    // Don't set password here for security, just the profile info
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public User authenticateUser(String email, String password) {
        User user = null;

        // SQL ni akan tarik data user DAN semak sama ada dia ada jawatan aktif tak sekarang ni
        String sql = "SELECT u.*, "
                + "(SELECT COUNT(*) FROM club_memberships cm WHERE cm.userId = u.userId AND cm.isActive = 1) AS activeClubCount "
                + "FROM user u "
                + "WHERE u.email = ? AND u.password = ?";

        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Semak status aktif akaun secara umum dulu
                    int userIsActive = rs.getInt("isActive");
                    if (userIsActive == 0) {
                        throw new Exception("Akaun anda telah dinyahaktifkan oleh HEPA.");
                    }

                    String role = rs.getString("role");
                    int activeClubCount = rs.getInt("activeClubCount");

                    // =======================================================
                    // SEKATAN EN. KHALIES: CHC MESTI ADA JAWATAN AKTIF
                    // =======================================================
                    if ("CHC".equals(role) && activeClubCount == 0) {
                        throw new Exception("Akses Ditolak: Sesi anda sebagai Majlis Tertinggi Kelab (CHC) telah tamat.");
                    }

                    // Kalau MPP ada jadual keahlian sendiri, boleh tambah logik sama.
                    // Kalau MPP guna 'isActive' di jadual 'user', yang atas tu (userIsActive == 0) dah cukup.
                    // Jika lepas semua sekatan, benarkan masuk
                    user = new User();
                    user.setUserId(rs.getString("userId"));
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(role);
                    // Set data lain yang kau perlukan...
                }
            }
        } catch (Exception e) {
            System.out.println("Login Error: " + e.getMessage());
            // Kau boleh passing mesej error ni balik ke skrin Login.jsp
        }
        return user;
    }

    // ========================================================
    // PENGURUSAN MPP OLEH HEPA
    // ========================================================
    // 1. Tarik senarai semua MPP
    public java.util.List<User> getMPPList() {
        java.util.List<User> mppList = new java.util.ArrayList<>();
        String sql = "SELECT * FROM user WHERE role = 'MPP' ORDER BY fullName ASC";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql); java.sql.ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getString("userId"));
                u.setFullName(rs.getString("fullName"));
                u.setEmail(rs.getString("email"));
                u.setDepartment(rs.getString("department"));

                // --- Tangkap Portfolio ---
                try {
                    u.setPortfolio(rs.getString("portfolio"));
                } catch (Exception e) {
                }

                mppList.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mppList;
    }

    // 2. Lantik Pelajar Menjadi MPP beserta PORTFOLIO
    public String assignMPP(User user, String tempPassword) {
        String sql = "INSERT INTO user (userId, fullName, email, password, role, department, isActive, isTempPassword, portfolio) "
                + "VALUES (?, ?, ?, ?, 'MPP', ?, 1, 1, ?) "
                + "ON DUPLICATE KEY UPDATE role = 'MPP', isActive = 1, portfolio = ?";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUserId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, tempPassword);
            ps.setString(5, user.getDepartment() != null ? user.getDepartment() : "Student");
            ps.setString(6, user.getPortfolio()); // Portfolio untuk akaun baru
            ps.setString(7, user.getPortfolio()); // Portfolio untuk akaun lama yg di-upgrade

            ps.executeUpdate();
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return "Database Error: " + e.getMessage();
        }
    }

    // 3. Pecat / Turunkan Pangkat MPP Individu
    public boolean removeMPP(String userId) {
        // Kita tak buang akaun, kita cuma jadikan dia pelajar biasa semula
        String sql = "UPDATE user SET role = 'Student' WHERE userId = ? AND role = 'MPP'";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. BUTANG NUKLEAR MPP: Tamatkan Sesi MPP Sepenuhnya
    public int endMPPSession() {
        // Semua MPP diturunkan pangkat serentak menjadi Student
        String sql = "UPDATE user SET role = 'Student' WHERE role = 'MPP'";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            return ps.executeUpdate(); // Pulangkan jumlah baris (ahli) yang diubah
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    // 5. Kemas kini Maklumat Profil MPP (Edit)
    public boolean updateMPPDetails(User user) {
        String sql = "UPDATE user SET fullName = ?, department = ?, portfolio = ? WHERE userId = ? AND role = 'MPP'";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getDepartment());
            ps.setString(3, user.getPortfolio());
            ps.setString(4, user.getUserId()); // Cari guna Matric No

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
