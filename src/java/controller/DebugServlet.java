package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.DBConnection;

@WebServlet(name = "DebugServlet", urlPatterns = {"/debug"})
public class DebugServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>System Diagnostic</title>");
            out.println("<style>");
            out.println("body{font-family:monospace; padding:20px; background-color:#f8f9fa;}");
            out.println(".success{color:#198754; font-weight:bold;} .fail{color:#dc3545; font-weight:bold;}");
            out.println("table {border-collapse: collapse; width: 100%; background-color: white;}");
            out.println("th {background-color: #343a40; color: white; padding: 10px; text-align: left;}");
            out.println("td {border: 1px solid #dee2e6; padding: 8px;}");
            out.println("tr:nth-child(even) {background-color: #f2f2f2;}");
            out.println(".badge {background-color: #0d6efd; color: white; padding: 2px 6px; border-radius: 4px; font-size: 12px;}");
            out.println("</style>");
            out.println("</head><body>");
            out.println("<h2>🔍 System & Database Diagnostic Tool</h2>");

            // 1. TEST CONNECTION
            out.println("<h3>1. Testing Connection...</h3>");
            try (Connection conn = DBConnection.getConnection()) {
                if (conn != null) {
                    out.println("<p class='success'>✅ Connection Successful!</p>");
                    out.println("<p><strong>Connected to Database Name:</strong> " + conn.getCatalog() + "</p>");
                    out.println("<p><strong>DB URL:</strong> " + conn.getMetaData().getURL() + "</p>");

                    // 2. LIST ALL USERS WITH CLUB INFO
                    out.println("<hr><h3>2. Listing ALL Users (with Club Info):</h3>");
                    out.println("<table><tr><th>User ID</th><th>Email</th><th>Password</th><th>Role</th><th>Active?</th><th>Club (As Member/CHC)</th><th>Club (As Advisor)</th></tr>");

                    // SQL yang dinaik taraf untuk menarik nama kelab dari jadual club_memberships dan clubs
                    String sql = "SELECT u.userId, u.email, u.password, u.role, u.isActive, "
                            + "(SELECT GROUP_CONCAT(c.clubName SEPARATOR ', ') FROM club_memberships cm JOIN clubs c ON cm.clubId = c.clubId WHERE cm.userId = u.userId AND cm.isActive = 1) AS memberClubs, "
                            + "(SELECT GROUP_CONCAT(c.clubName SEPARATOR ', ') FROM clubs c WHERE c.advisorId = u.userId) AS advisorClubs "
                            + "FROM user u ORDER BY u.role, u.userId";

                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    boolean foundUsers = false;
                    while (rs.next()) {
                        foundUsers = true;

                        String memberClubs = rs.getString("memberClubs");
                        String advisorClubs = rs.getString("advisorClubs");
                        boolean isActive = rs.getBoolean("isActive");

                        out.println("<tr>");
                        out.println("<td>" + rs.getString("userId") + "</td>");
                        out.println("<td>" + rs.getString("email") + "</td>");
                        out.println("<td>" + rs.getString("password") + "</td>");
                        out.println("<td><span class='badge'>" + rs.getString("role") + "</span></td>");
                        out.println("<td>" + (isActive ? "<span class='success'>TRUE</span>" : "<span class='fail'>FALSE</span>") + "</td>");

                        // Paparkan kelab ahli (Jika null, papar sengkang)
                        out.println("<td>" + (memberClubs != null ? "<strong>" + memberClubs + "</strong>" : "<span style='color:grey'>-</span>") + "</td>");

                        // Paparkan kelab seliaan penasihat
                        out.println("<td>" + (advisorClubs != null ? "<strong>" + advisorClubs + "</strong>" : "<span style='color:grey'>-</span>") + "</td>");

                        out.println("</tr>");
                    }
                    out.println("</table>");

                    if (!foundUsers) {
                        out.println("<h3 class='fail'>❌ TABLE IS EMPTY! No users found.</h3>");
                        out.println("<p>You are connected to the DB, but the 'user' table has no rows.</p>");
                    }

                    // 3. TEST SPECIFIC LOGIN
                    out.println("<hr><h3>3. Testing Login for 'admin@test.com' / '123'</h3>");
                    String testSql = "SELECT * FROM user WHERE email = ? AND password = ?";
                    PreparedStatement ps2 = conn.prepareStatement(testSql);
                    ps2.setString(1, "admin@test.com");
                    ps2.setString(2, "123");
                    ResultSet rs2 = ps2.executeQuery();

                    if (rs2.next()) {
                        boolean isActive = rs2.getBoolean("isActive");
                        if (isActive) {
                            out.println("<h3 class='success'>✅ LOGIN SHOULD WORK! User found and Active.</h3>");
                        } else {
                            out.println("<h3 class='fail'>❌ User Found, but isActive is FALSE.</h3>");
                        }
                    } else {
                        out.println("<h3 class='fail'>❌ LOGIN FAILED: Email/Password combination not found in this DB.</h3>");
                    }

                } else {
                    out.println("<h3 class='fail'>❌ Connection object is NULL.</h3>");
                }
            } catch (Exception e) {
                out.println("<h3 class='fail'>❌ EXCEPTION THROWN</h3>");
                out.println("<pre>");
                e.printStackTrace(out);
                out.println("</pre>");
            }

            out.println("</body></html>");
        }
    }
}
