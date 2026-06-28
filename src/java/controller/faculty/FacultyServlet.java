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
        if ("markRead".equals(action)) {
            dao.markAllNotificationsAsReadForFaculty();
            response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
            return;
        }

        List<Map<String, Object>> facultyProposals = dao.getProposalsForFaculty();

        request.setAttribute("proposalsCount", facultyProposals.size());
        request.setAttribute("facultyProposals", facultyProposals);
        request.setAttribute("notifications", dao.getNotificationsForFaculty());
        request.setAttribute("notificationCount", dao.getUnreadNotificationCountForFaculty());

        request.getRequestDispatcher("/WEB-INF/jsp/faculty/FacultyDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int proposalId = Integer.parseInt(request.getParameter("proposalId"));
        String action = request.getParameter("action");
        String feedback = request.getParameter("feedback");
        String source = request.getParameter("source");

        int clubId = dao.getClubIdByProposalId(proposalId);
        String pTitle = (String) dao.getProposalById(proposalId).get("title");

        NotificationDAO notifDAO = new NotificationDAO(); // GUNA NOTIFDAO

        if ("approve".equals(action)) {
            dao.updateProposalStatus(proposalId, "Pending_HEPA", "Faculty Endorsed: Content Verified. Pending HEPA Budget.");

            notifDAO.createNotificationWithRole(clubId, "Academic Proposal: Budget Clearance Needed",
                    "Faculty has endorsed '" + pTitle + "'. Please review the budget.",
                    "STATUS", "/hepa/endorse", "Review", "HEPA");

            notifDAO.createNotificationWithRole(clubId, "Faculty Approved",
                    "Your proposal '" + pTitle + "' content has been verified and sent to HEPA.",
                    "STATUS", "/chc/events", "View", "CHC");

            request.getSession().setAttribute("successMessage", "Proposal has been successfully verified and forwarded to HEPA.");
        } else if ("reject".equals(action)) {
            String finalFeedback = (feedback != null && !feedback.trim().isEmpty()) ? feedback : "Please review the academic format/content.";
            dao.updateProposalStatus(proposalId, "Rejected", "Rejected by Faculty: " + finalFeedback);

            notifDAO.createNotificationWithRole(clubId, "Faculty Rejected",
                    "Your proposal '" + pTitle + "' content has been rejected. Feedback: " + finalFeedback,
                    "STATUS", "/chc/events", "View", "CHC");

            request.getSession().setAttribute("successMessage", "Proposal has been rejected and returned to the student.");
        }

        if ("all".equals(source)) {
            response.sendRedirect(request.getContextPath() + "/faculty/proposals");
        } else {
            response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
        }
    }
}
