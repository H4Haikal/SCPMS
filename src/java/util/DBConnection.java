package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // SAFELY CALLING FROM CONFIG.JAVA
    private static final String URL = Config.DB_URL;
    private static final String USERNAME = Config.DB_USERNAME;
    private static final String PASSWORD = Config.DB_PASSWORD;

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
