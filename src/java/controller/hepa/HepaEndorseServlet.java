package controller.hepa;

import dao.ProposalDAO;
import dao.NotificationDAO;
import model.User;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/hepa/endorse")
public class HepaEndorseServlet extends HttpServlet {

    private final ProposalDAO dao = new ProposalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("hepaProposals", dao.getProposalsForHEPA());
        request.getRequestDispatcher("/WEB-INF/jsp/hepa/HepaEndorse.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int proposalId = Integer.parseInt(request.getParameter("proposalId"));
        String action = request.getParameter("action");
        int clubId = dao.getClubIdByProposalId(proposalId);

        NotificationDAO notifDAO = new NotificationDAO();

        if ("approve".equals(action)) {
            dao.updateProposalStatus(proposalId, "Approved", "Final endorsement granted by HEPA.");

            // Trigger Email & Loceng
            notifDAO.createNotificationWithRole(clubId, "Proposal Officially Endorsed!", "Congratulations! HEPA has officially endorsed your event proposal.", "STATUS", "/chc/events", "View Details", "CHC");
            notifDAO.createNotificationWithRole(clubId, "Proposal Endorsed", "HEPA has successfully endorsed a proposal you verified.", "STATUS", "/mpp/proposals", "View Record", "MPP");

            request.getSession().setAttribute("successMessage", "Proposal officially endorsed!");
        } else if ("reject".equals(action)) {
            dao.updateProposalStatus(proposalId, "Rejected", "Rejected by HEPA.");
            notifDAO.createNotificationWithRole(clubId, "Proposal Rejected by HEPA", "Your proposal was rejected during final endorsement.", "WARNING", "/chc/events", "View Details", "CHC");
            request.getSession().setAttribute("errorMessage", "Proposal rejected.");
        }

        response.sendRedirect(request.getContextPath() + "/hepa/endorse");
    }
}
