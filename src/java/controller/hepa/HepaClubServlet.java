package controller.hepa;

import dao.ClubDAO;
import model.Club;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "HepaClubServlet", urlPatterns = {"/hepa/club"})
public class HepaClubServlet extends HttpServlet {

    private ClubDAO clubDAO;

    @Override
    public void init() {
        clubDAO = new ClubDAO();
    }

    // =========================================================
    // GET: PAPARKAN SENARAI KELAB & KAD DRILL-DOWN + Carian Pelajar
    // =========================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("HEPA")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // --- Ciri Baru: Semak Sejarah Pelajar ---
        String searchUserId = request.getParameter("searchUserId");
        if (searchUserId != null && !searchUserId.trim().isEmpty()) {
            String studentName = clubDAO.getStudentNameById(searchUserId.trim());

            if (studentName != null) {
                List<Map<String, Object>> history = clubDAO.getStudentMembershipHistory(searchUserId.trim());
                request.setAttribute("studentHistory", history);
                request.setAttribute("searchedName", studentName);
            } else {
                request.setAttribute("searchError", "Student ID not found in the system.");
            }
            request.setAttribute("searchedId", searchUserId.trim());
        }
        // ----------------------------------------

        // Tarik semua kelab dari database
        List<Club> clubs = clubDAO.getAllClubs();
        request.setAttribute("clubs", clubs);

        request.getRequestDispatcher("/WEB-INF/jsp/hepa/ClubListHepa.jsp").forward(request, response);
    }

    // =========================================================
    // POST: PROSES ARAHAN CRUD (REGISTER, UPDATE, DELETE, ASSIGN)
    // =========================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        try {
            if ("register".equals(action)) {
                // 1. DAFTAR KELAB BARU & LANTIK ADVISOR (UPDATED)

                // A. Tangkap Data Kelab
                String clubName = request.getParameter("clubName");
                String category = request.getParameter("category");
                String cluster = request.getParameter("cluster");
                int establishedYear = Integer.parseInt(request.getParameter("establishedYear"));

                // B. Tangkap Data Advisor
                String advisorId = request.getParameter("advisorId");
                String advisorName = request.getParameter("advisorName");
                String advisorEmail = request.getParameter("advisorEmail");

                // C. Panggil method DAO yang baru (Transaction Safe)
                boolean success = clubDAO.registerNewClub(clubName, category, cluster, establishedYear, advisorId, advisorName, advisorEmail);

                if (success) {
                    // D. Hantar E-mel Kata Laluan Sementara kepada Advisor secara Background (Async)
                    // Perlu isytihar 'final' supaya boleh masuk ke dalam thread berasingan
                    final String fAdvisorEmail = advisorEmail;
                    final String fAdvisorName = advisorName;
                    final String fClubName = clubName;
                    String tempPassword = util.PasswordUtil.generateRandomPassword(10);
                    
                    new Thread(() -> {
                        util.EmailService.sendPasswordEmail(
                                fAdvisorEmail,
                                fAdvisorName,
                                tempPassword, // Kata laluan sementara
                                "Advisor",
                                fClubName
                        );
                    }).start();

                    session.setAttribute("message", "Club '" + clubName + "' created and Advisor assigned successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to register club. Check for duplicate Club Names or Staff IDs.");
                }

            } else if ("updateStatus".equals(action)) {
                // 2. TUKAR STATUS (Active/Suspended/Inactive)
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                String newStatus = request.getParameter("status");

                boolean updated = clubDAO.updateClubStatus(clubId, newStatus);
                if (updated) {
                    session.setAttribute("message", "Club status updated to " + newStatus.toUpperCase() + ".");
                } else {
                    session.setAttribute("errorMessage", "Failed to update club status.");
                }

            } else if ("editDetails".equals(action)) {
                // 3. KEMAS KINI MAKLUMAT RASMI KELAB
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                Club existingClub = clubDAO.getClubProfile(clubId);

                if (existingClub != null) {
                    existingClub.setClubName(request.getParameter("clubName"));
                    existingClub.setCategory(request.getParameter("category"));
                    existingClub.setCluster(request.getParameter("cluster"));
                    existingClub.setEstablishedYear(Integer.parseInt(request.getParameter("establishedYear")));

                    boolean updated = clubDAO.updateClubDetails(existingClub);
                    if (updated) {
                        session.setAttribute("message", "Official club details updated successfully.");
                    } else {
                        session.setAttribute("errorMessage", "Database error: Failed to save changes.");
                    }
                }

            } else if ("assignPresident".equals(action)) {
                // 4. LANTIK PRESIDEN BARU
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                model.User newUser = new model.User();
                newUser.setUserId(request.getParameter("userId"));
                newUser.setFullName(request.getParameter("fullName"));
                newUser.setEmail(request.getParameter("email"));

                String result = clubDAO.assignPresident(newUser, clubId);
                if ("SUCCESS".equals(result)) {
                    session.setAttribute("message", "President successfully assigned. System has generated an account and temporary password.");
                } else {
                    session.setAttribute("errorMessage", result);
                }

            } else if ("removePresident".equals(action)) {
                // 5. BUANG PRESIDEN
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                boolean removed = clubDAO.removePresident(clubId);
                if (removed) {
                    session.setAttribute("message", "President removed. Position is now Vacant.");
                } else {
                    session.setAttribute("errorMessage", "Failed to remove president.");
                }

            } else if ("delete".equals(action)) {
                // 6. PADAM KELAB (PURGE)
                int clubId = Integer.parseInt(request.getParameter("clubId"));

                boolean deleted = clubDAO.deleteClub(clubId);
                if (deleted) {
                    session.setAttribute("message", "Club and all associated records have been permanently purged.");
                } else {
                    session.setAttribute("errorMessage", "Deletion failed. Ensure no pending transactions are tied to this club.");
                }

            } else if ("endSession".equals(action)) {
                // 7. BUTANG NUKLEAR: TAMATKAN SESI AKADEMIK
                boolean terminated = clubDAO.terminateAllActiveMemberships();
                if (terminated) {
                    session.setAttribute("message", "Academic session successfully ended! All current club committees have been demoted to Alumni and their access revoked.");
                } else {
                    session.setAttribute("errorMessage", "Failed to terminate session due to a database error.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "A system error occurred: " + e.getMessage());
        }

        // Selepas selesai proses, redirect semula ke halaman yang sama
        response.sendRedirect(request.getContextPath() + "/hepa/club");
    }
}
