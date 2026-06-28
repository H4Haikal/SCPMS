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

@WebServlet("/advisor/pending")
public class AdvisorPendingServlet extends HttpServlet {

    private final ProposalDAO dao = new ProposalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"Advisor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        List<Map<String, Object>> proposals = dao.getAllProposalsForAdvisor(user.getUserId());
        request.setAttribute("proposals", proposals);

        NotificationDAO notifDAO = new NotificationDAO();
        List<Notification> notifications = notifDAO.getUnreadNotificationsForRole("Advisor");
        // --- TARIK DATA NOTIFIKASI (CLUB-SPECIFIC FIX) ---
        int realClubIdForAdvisor = dao.getClubIdByAdvisorId(user.getUserId());
        request.setAttribute("notifications", dao.getClubNotificationsForAdvisor(realClubIdForAdvisor));
        request.setAttribute("notificationCount", dao.getUnreadNotificationCountForAdvisor(realClubIdForAdvisor));
        
        request.getRequestDispatcher("/WEB-INF/jsp/advisor/PendingProposals.jsp").forward(request, response);
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
            String nextStatus = "Academic".equalsIgnoreCase(category) ? "Pending_Faculty" : "Pending_MPP";
            String nextRole = "Academic".equalsIgnoreCase(category) ? "Faculty" : "MPP";
            String notifyLink = "Academic".equalsIgnoreCase(category) ? "/faculty/dashboard" : "/mpp/proposals";

            dao.updateProposalStatus(proposalId, nextStatus, "Supported by Advisor: " + (feedback != null ? feedback : "No feedback"));

            // ---> GUNA TRACKER (Mencetuskan Notifikasi & E-mel Automatik) <---
            util.ProposalTracker.logAdvisorSupport(user.getUserId(), proposalId, clubId, pTitle, nextRole, notifyLink, null);

            request.getSession().setAttribute("successMessage", "Proposal supported and forwarded!");

        } else if ("reject".equals(action)) {
            dao.updateProposalStatus(proposalId, "Rejected", "Rejected by Advisor: " + feedback);

            // ---> GUNA TRACKER (Mencetuskan Notifikasi & E-mel Automatik) <---
            util.ProposalTracker.logRejection(user.getUserId(), proposalId, clubId, pTitle, feedback, "Club Advisor", null);

            request.getSession().setAttribute("successMessage", "Proposal has been rejected.");
        }

        response.sendRedirect("pending");
    }
}
