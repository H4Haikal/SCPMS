package controller.advisor;

import dao.ProposalDAO;
import model.EventItem;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import util.ProposalTracker;

@WebServlet("/advisor/review")
public class AdvisorReviewServlet extends HttpServlet {

    private final ProposalDAO dao = new ProposalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"Advisor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Safely check for either "id" or "proposalId"
        String idStr = request.getParameter("id");
        if (idStr == null) {
            idStr = request.getParameter("proposalId");
        }

        if (idStr == null) {
            session.setAttribute("errorMessage", "Invalid Request: Proposal ID missing.");
            response.sendRedirect(request.getContextPath() + "/advisor/pending");
            return;
        }

        try {
            int proposalId = Integer.parseInt(idStr);

            // USE NEW 3NF METHOD
            EventItem proposal = dao.getProposalById3NF(proposalId);

            if (proposal != null) {
                request.setAttribute("p", proposal);
                request.getRequestDispatcher("/WEB-INF/jsp/advisor/AdvisorReviewPage.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Proposal not found.");
                response.sendRedirect(request.getContextPath() + "/advisor/pending");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/advisor/pending");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"Advisor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Safely catch the ID regardless of which JSP form variation is rendering
        String idStr = request.getParameter("proposalId");
        if (idStr == null) {
            idStr = request.getParameter("id");
        }

        int proposalId = Integer.parseInt(idStr);
        String action = request.getParameter("action");
        String feedback = request.getParameter("feedback");

        // USE NEW 3NF METHOD TO PREVENT SQL CRASH
        EventItem p = dao.getProposalById3NF(proposalId);
        int clubId = p.getClubId();
        String pTitle = p.getTitle();
        String category = p.getClubCategory();
        
        
        if ("approve".equals(action)) {
            String nextStatus;
            String nextRole;
            String notifyLink;

            // Route based on Club Category
            if ("Academic".equalsIgnoreCase(category)) {
                nextStatus = "Pending_Faculty";
                nextRole = "Faculty";
                notifyLink = "/faculty/dashboard";
            } else {
                nextStatus = "Pending_MPP";
                nextRole = "MPP";
                notifyLink = "/mpp/proposals";
            }

            // 1. Update Database
            dao.updateProposalStatus(proposalId, nextStatus, "Supported by Advisor: " + feedback);

            // 2. UNIFIED TRACKER
            ProposalTracker.logAdvisorSupport(user.getUserId(), proposalId, clubId, pTitle, nextRole, notifyLink, null);

            session.setAttribute("successMessage", "Proposal successfully supported and forwarded to " + nextRole + ".");

        } else if ("reject".equals(action)) {
            dao.updateProposalStatus(proposalId, "Rejected", "Rejected by Advisor: " + feedback);
            ProposalTracker.logRejection(user.getUserId(), proposalId, clubId, pTitle, feedback, "Club Advisor", null);
            session.setAttribute("successMessage", "Proposal rejected and returned to CHC.");
        }

        response.sendRedirect(request.getContextPath() + "/advisor/pending");
    }
}
