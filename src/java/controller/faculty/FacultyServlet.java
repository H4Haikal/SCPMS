package controller.faculty;

import dao.ProposalDAO;
import dao.NotificationDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.Notification;

@WebServlet("/faculty/dashboard")
public class FacultyServlet extends HttpServlet {

    private final ProposalDAO dao = new ProposalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"Faculty".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String action = request.getParameter("action");
        NotificationDAO notifDAO = new NotificationDAO();
        String userId = user.getUserId();

        if ("markRead".equals(action) || "markAllRead".equals(action)) {
            notifDAO.markAllAsReadDynamic(-1, "Faculty", userId);
            response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
            return;
        }

        List<Map<String, Object>> facultyProposals = dao.getProposalsForFaculty();

        request.setAttribute("proposalsCount", facultyProposals.size());
        request.setAttribute("facultyProposals", facultyProposals);
        List<Notification> notifications = notifDAO.getUnreadNotificationsForRole("Faculty", userId);
        request.setAttribute("notifications", notifications);
        request.setAttribute("notificationCount", notifications.size());
        request.getRequestDispatcher("/WEB-INF/jsp/faculty/FacultyDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. EXTRACT SESSION AND USER PROFILE CONTEXT (Fixes the "User not found" error)
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Safety guard fallback check: if session expired or user isn't Faculty, send to login
        if (user == null || !"Faculty".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // 2. EXTRACT INBOUND PARAMETERS
        int proposalId = Integer.parseInt(request.getParameter("proposalId"));
        String action = request.getParameter("action");
        String feedback = request.getParameter("feedback");
        String source = request.getParameter("source");

        // 3. INITIALIZE DATA ACCESS OBJECTS
        int clubId = dao.getClubIdByProposalId(proposalId);
        String pTitle = (String) dao.getProposalById(proposalId).get("title");
        NotificationDAO notifDAO = new NotificationDAO();

        // 4. WORKFLOW ROUTING DECISION MATRIX
        // OPTION A: Faculty chooses to support and forward to HEPA
        if ("approve".equals(action) || "approve_hepa".equals(action)) {
            dao.updateProposalStatus(proposalId, "Pending_HEPA", "Faculty Endorsed: Content Verified. Pending HEPA Budget.");

            // Use the unified tracker to handle user-isolated notifications properly
            util.ProposalTracker.logFacultyEndorsement(user.getUserId(), proposalId, clubId, pTitle, null);

            request.getSession().setAttribute("successMessage", "Proposal has been successfully verified and forwarded to HEPA.");

            // OPTION B: Faculty chooses to grant FULL FINAL APPROVAL immediately (Bypass HEPA)
        } else if ("approve_final".equals(action)) {
            dao.updateProposalStatus(proposalId, "Approved", "Kelulusan penuh diberikan oleh Fakulti (Bypass HEPA).");

            // Use the unified tracker for final approval
            util.ProposalTracker.logFacultyFinalApproval(user.getUserId(), proposalId, clubId, pTitle);

            request.getSession().setAttribute("successMessage", "Kertas kerja akademik telah mendapat Kelulusan Penuh (Final Approval)!");

            // OPTION C: Faculty Rejects
        } else if ("reject".equals(action)) {
            String finalFeedback = (feedback != null && !feedback.trim().isEmpty()) ? feedback : "Please review the academic format/content.";
            dao.updateProposalStatus(proposalId, "Rejected", "Rejected by Faculty: " + finalFeedback);

            // Use the unified tracker for consistency
            util.ProposalTracker.logRejection(user.getUserId(), proposalId, clubId, pTitle, finalFeedback, "Faculty", null);

            request.getSession().setAttribute("successMessage", "Proposal has been rejected and returned to the student.");
        }

        // 5. REDIRECT BASED ON ORIGIN SOURCE PANEL
        if ("all".equals(source)) {
            response.sendRedirect(request.getContextPath() + "/faculty/proposals");
        } else {
            response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
        }
    }

}
