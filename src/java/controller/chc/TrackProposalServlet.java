package controller.chc;

import dao.AuditDAO;
import dao.ProposalDAO;
import model.User;
import model.AuditLog;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "TrackProposalServlet", urlPatterns = {"/chc/track"})
public class TrackProposalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"CHC".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        int proposalId = Integer.parseInt(request.getParameter("id"));

        ProposalDAO pDao = new ProposalDAO();
        AuditDAO aDao = new AuditDAO();

        // Get Proposal Details
        model.EventItem proposal = pDao.getProposalById3NF(proposalId);
// Get Timeline History
        List<AuditLog> timeline = aDao.getProposalTimeline(proposalId);

        request.setAttribute("p", proposal);
        request.setAttribute("timeline", timeline);

        request.getRequestDispatcher("/WEB-INF/jsp/chc/TrackProposal.jsp").forward(request, response);
    }
}
//Paling latest buat