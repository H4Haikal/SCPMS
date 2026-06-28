package controller.mpp;

import dao.AGMReportDAO;
import dao.AuditDAO;
import dao.ClubDAO;
import dao.NotificationDAO;
import model.Club;
import model.User;
import util.EmailService;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/mpp/club")
public class ClubMPPServlet extends HttpServlet {

    private final ClubDAO clubDAO = new ClubDAO();
    private final NotificationDAO notifDAO = new NotificationDAO();
    private final AGMReportDAO agmDAO = new AGMReportDAO();
    private final AuditDAO auditDAO = new AuditDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || (!"MPP".equals(user.getRole()) && !"HEPA".equals(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        List<Club> clubs = clubDAO.getAllClubs();
        request.setAttribute("clubs", clubs);
        request.getRequestDispatcher("/WEB-INF/jsp/mpp/ClubListMPP.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (session == null || currentUser == null || (!"MPP".equals(currentUser.getRole()) && !"HEPA".equals(currentUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String adminId = currentUser.getUserId();
        String action = request.getParameter("action");
        boolean success = false;
        String message = "";
        String errorMessage = "";

        try {
            if ("editDetails".equals(action)) {
                Club club = new Club();
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                club.setClubId(clubId);
                club.setClubName(request.getParameter("clubName"));
                club.setCategory(request.getParameter("category"));
                club.setEstablishedYear(Integer.parseInt(request.getParameter("establishedYear")));

                success = clubDAO.updateClubDetails(club);

                if (success) {
                    auditDAO.log(adminId, "EDIT_CLUB", "Updated details for Club ID " + clubId);
                    message = "Club details updated!";
                } else {
                    errorMessage = "Update failed.";
                }

            } else if ("delete".equals(action)) {
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                success = clubDAO.deleteClub(clubId);

                if (success) {
                    auditDAO.log(adminId, "DELETE_CLUB", "Permanently deleted Club ID " + clubId);
                    message = "Club deleted successfully.";
                } else {
                    errorMessage = "Failed to delete club. It might have related events.";
                }

            } else if ("assignPresident".equals(action)) {
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                String studentId = request.getParameter("userId");

                User newPres = new User();
                newPres.setUserId(studentId);
                newPres.setFullName(request.getParameter("fullName"));
                newPres.setEmail(request.getParameter("email"));

                String result = clubDAO.assignPresident(newPres, clubId);

                if ("SUCCESS".equals(result)) {
                    auditDAO.log(adminId, "ASSIGN_PRESIDENT", "Assigned " + studentId + " as President of Club " + clubId);
                    message = "President assigned successfully! Login credentials emailed.";
                } else {
                    errorMessage = result;
                }

            } else if ("removePresident".equals(action)) {
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                success = clubDAO.removePresident(clubId);

                if (success) {
                    auditDAO.log(adminId, "REMOVE_PRESIDENT", "Removed President from Club ID " + clubId);
                    message = "President removed successfully. The position is now VACANT.";
                } else {
                    errorMessage = "Failed to remove president. Please try again.";
                }

                // ==========================================
                // LOGIK HANTAR PERINGATAN (LOCENG + E-MEL)
                // ==========================================
            } else if ("remindAGM".equals(action)) {
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                String year = request.getParameter("year");
                if (year == null) {
                    year = "2026";
                }

                String alertTitle = "AMARAN: Laporan AGM Tertunggak!";
                String alertMsg = "Sila muat naik laporan Mesyuarat Agung Tahunan (AGM) bagi tahun " + year + " dengan segera bagi mengelakkan kelab digantung dari beroperasi.";

                // 1. Tembak Loceng (Guna fungsi standard NotificationDAO supaya pasti keluar di Topbar)
                boolean sentNotif = notifDAO.createNotification(clubId, alertTitle, alertMsg, "REMINDER", "/common/agm", "Hantar Sekarang");

                // 2. Tembak E-mel Sebenar ke Presiden Kelab
                String clubEmail = clubDAO.getClubPresidentEmail(clubId);
                Club clubInfo = clubDAO.getClubProfile(clubId);

                if (clubEmail != null && !clubEmail.isEmpty() && clubInfo != null) {
                    EmailService.sendGeneralNotification(clubEmail, clubInfo.getPresidentName(), alertTitle, alertMsg);
                }

                if (sentNotif) {
                    clubDAO.incrementReminderCount(clubId);
                    auditDAO.log(adminId, "SEND_REMINDER", "Sent AGM Reminder to Club ID " + clubId);
                    message = "Peringatan berjaya dihantar ke notifikasi kelab dan e-mel Presiden!";
                } else {
                    errorMessage = "Gagal memproses peringatan.";
                }

                // ==========================================
                // LOGIK SEMAKAN (TERIMA / TOLAK)
                // ==========================================
            } else if ("reviewAGM".equals(action)) {
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                String decision = request.getParameter("decision"); // 'accepted' atau 'missing'
                String role = currentUser.getRole();

                // TANGKAP REMARKS: Alasan penolakan dari modal
                String remarks = request.getParameter("remarks");
                if (remarks == null) {
                    remarks = ""; // Elak null pointer jika diterima (Accepted)
                }

                String agmIdStr = request.getParameter("agmId");
                int agmId = (agmIdStr != null && !agmIdStr.isEmpty()) ? Integer.parseInt(agmIdStr) : 0;

                String year = request.getParameter("year");
                if (year == null) {
                    year = "2026";
                }

                // Panggil DAO dengan 6 PARAMETER (Termasuk remarks)
                success = agmDAO.updateAGMStatus(agmId, clubId, decision, year, role, remarks);

                // Tentukan nextStatus untuk tujuan mesej e-mel dan loceng
                String nextStatus = "Missing";
                if ("accepted".equalsIgnoreCase(decision)) {
                    nextStatus = "MPP".equals(role) ? "Pending_HEPA" : "Accepted";
                }

                if (success) {
                    // Tembak Loceng & E-mel kemaskini status kepada Kelab
                    String notifTitle = "Status Laporan AGM Dikemaskini";
                    String notifMsg = "Laporan AGM kelab anda kini berstatus: " + nextStatus.toUpperCase();

                    // Jika ditolak, tambah info sebab penolakan dalam mesej
                    if ("Missing".equals(nextStatus) && !remarks.isEmpty()) {
                        notifMsg += ". Sebab: " + remarks;
                    }

                    // Guna createNotificationWithRole supaya CHC nampak di dashboard
                    notifDAO.createNotificationWithRole(clubId, notifTitle, notifMsg, "STATUS", "/common/agm", "Lihat Status", "CHC");

                    String clubEmail = clubDAO.getClubPresidentEmail(clubId);
                    Club clubInfo = clubDAO.getClubProfile(clubId);
                    if (clubEmail != null && !clubEmail.isEmpty() && clubInfo != null) {
                        EmailService.sendGeneralNotification(clubEmail, clubInfo.getPresidentName(), notifTitle, notifMsg);
                    }

                    if ("accepted".equalsIgnoreCase(decision)) {
                        clubDAO.resetReminderCount(clubId);
                    }
                    auditDAO.log(adminId, "REVIEW_AGM", "AGM Report for Club " + clubId + " was marked as " + nextStatus);
                    String statusMsg = "accepted".equalsIgnoreCase(decision) ? "Diterima / Disokong" : "Ditolak";
                    message = "Laporan AGM " + statusMsg + " dengan jayanya.";
                } else {
                    errorMessage = "Gagal mengemaskini status. Sila pastikan kelab telah menghantar laporan.";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "System Error: " + e.getMessage();
        }

        if (!message.isEmpty()) {
            request.setAttribute("message", message);
        }
        if (!errorMessage.isEmpty()) {
            request.setAttribute("errorMessage", errorMessage);
        }

        doGet(request, response);
    }
}
