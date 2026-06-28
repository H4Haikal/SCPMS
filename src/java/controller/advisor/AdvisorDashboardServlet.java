package controller.advisor;

import dao.ProposalDAO;
import dao.NotificationDAO;
import model.Notification;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/advisor/dashboard")
public class AdvisorDashboardServlet extends HttpServlet {

    private final ProposalDAO dao = new ProposalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"Advisor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // --- TANGKAP ACTION MARK READ ---
        String action = request.getParameter("action");
        if ("markRead".equals(action)) {
            dao.markAllNotificationsAsReadForAdvisor(user.getUserId());
            response.sendRedirect(request.getContextPath() + "/advisor/dashboard");
            return;
        }

        // --- TARIK DATA PROPOSAL PENDING ---
        request.setAttribute("pendingProposals", dao.getPendingProposalsForAdvisor(user.getUserId(), "submitted", "DESC"));

        // --- TARIK DATA NOTIFIKASI (CLUB-SPECIFIC FIX) ---
        int realClubIdForAdvisor = dao.getClubIdByAdvisorId(user.getUserId());
        request.setAttribute("notifications", dao.getClubNotificationsForAdvisor(realClubIdForAdvisor));
        request.setAttribute("notificationCount", dao.getUnreadNotificationCountForAdvisor(realClubIdForAdvisor));

        request.getRequestDispatcher("/WEB-INF/jsp/advisor/Dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"Advisor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        int proposalId = Integer.parseInt(request.getParameter("proposalId"));
        String action = request.getParameter("action");
        String feedback = request.getParameter("feedback");

        int clubId = dao.getClubIdByProposalId(proposalId);
        Map<String, Object> proposal = dao.getProposalById(proposalId);
        String pTitle = (String) proposal.get("title");

        if ("approve".equals(action)) {
            String category = dao.getClubCategoryByProposalId(proposalId);
            String nextStatus;
            String nextRole;
            String notifyLink;

            // Routing: Academic -> Faculty, Non-Academic -> MPP
            if ("Academic".equalsIgnoreCase(category)) {
                nextStatus = "Pending_Faculty";
                nextRole = "Faculty";
                notifyLink = "/faculty/dashboard";
            } else {
                nextStatus = "Pending_MPP";
                nextRole = "MPP";
                notifyLink = "/mpp/proposals";
            }

            dao.updateProposalStatus(proposalId, nextStatus, "Supported by Advisor: " + feedback);

            // USE UNIFIED TRACKER
            util.ProposalTracker.logAdvisorSupport(user.getUserId(), proposalId, clubId, pTitle, nextRole, notifyLink, null);

        } else {
            dao.updateProposalStatus(proposalId, "Rejected", "Rejected by Advisor: " + feedback);

            // USE UNIFIED TRACKER
            util.ProposalTracker.logRejection(user.getUserId(), proposalId, clubId, pTitle, feedback, "Club Advisor", null);
        }

        response.sendRedirect("dashboard");
    }
}
