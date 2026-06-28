package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for establishing database connection
 * Database: club_management (MySQL)
 * Used throughout the project for all DAO classes
 */
public class DBConnection {

    // Update these values according to your MySQL setup
    private static final String URL = "jdbc:mysql://localhost:3307/umt_clubsphere_dev?useSSL=false&serverTimezone=Asia/Kuala_Lumpur";
    private static final String USERNAME = "root";          // Change if you use a different MySQL user
    private static final String PASSWORD = "";              // Put your MySQL password here (leave empty if none)

    /**
     * Returns a connection to the database
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Load MySQL JDBC driver (required for older JDBC versions)
            // For MySQL Connector/J 8.x, this is optional but safe to keep
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    /**
     * Test method to verify connection (optional - you can run this once)
     */
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("Database connection successful!");
                System.out.println("Connected to: " + conn.getCatalog());
            }
        } catch (SQLException e) {
            System.err.println("Connection failed!");
            e.printStackTrace();
        }
    }
}