package controller.chc;

import dao.ProposalDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "MyEventServlet", urlPatterns = {"/chc/events"})
public class MyEventServlet extends HttpServlet {

    // --------------------------------------------------------
    // FUNCTION 1: DISPLAY TABLE (GET)
    // --------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"CHC".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        ProposalDAO dao = new ProposalDAO();
        int realClubId = dao.getClubIdByUserId(user.getUserId());

        if (realClubId != -1) {
            List<Map<String, Object>> myProposals = dao.getProposalsByClub(realClubId);
            request.setAttribute("myProposals", myProposals);
        }

        request.getRequestDispatcher("/WEB-INF/jsp/chc/MyEvents.jsp").forward(request, response);
    }

    // --------------------------------------------------------
    // FUNCTION 2: CAPTURE RETRACT & DELETE ACTIONS (POST)
    // --------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"CHC".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String action = request.getParameter("action");

        // --- ACTION 1: RETRACT PROPOSAL (Revert to Draft) ---
        if ("cancel".equals(action)) {
            try {
                int proposalId = Integer.parseInt(request.getParameter("proposalId"));
                ProposalDAO dao = new ProposalDAO();
                int realClubId = dao.getClubIdByUserId(user.getUserId());

                if (realClubId != -1) {
                    boolean isSuccess = dao.updateProposalStatus(proposalId, "Draft", "Retracted by CHC for editing.");
                    if (isSuccess) {

                        // --- 1. TRACKER (AUDIT LOG) ---
                        dao.AuditDAO aDao = new dao.AuditDAO();
                        aDao.logProposalEvent(user.getUserId(), proposalId, "Proposal Retracted", "CHC retracted the proposal from review.");

                        // --- 2. NOTIFICATION ---
                        dao.NotificationDAO notifDAO = new dao.NotificationDAO();
                        notifDAO.createNotificationWithRole(realClubId, "Proposal Retracted", "You have retracted proposal #" + proposalId, "STATUS", "/chc/events", "View Drafts", "CHC");

                        session.setAttribute("successMessage", "Proposal retracted successfully. It is now saved as a Draft.");
                    } else {
                        session.setAttribute("errorMessage", "Failed to retract. It might have been processed by reviewers already.");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "System error while retracting proposal.");
            }
        } // --- ACTION 2: DELETE DRAFT ---
        else if ("deleteDraft".equals(action)) {
            try {
                int proposalId = Integer.parseInt(request.getParameter("proposalId"));
                ProposalDAO dao = new ProposalDAO();
                boolean isDeleted = dao.deleteProposal(proposalId);

                if (isDeleted) {
                    session.setAttribute("successMessage", "Draft proposal has been permanently deleted.");
                } else {
                    session.setAttribute("errorMessage", "Error: Failed to delete the draft.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "System error while deleting draft.");
            }
        }

        // Redirect back to the table after processing
        response.sendRedirect(request.getContextPath() + "/chc/events");
    }
}
