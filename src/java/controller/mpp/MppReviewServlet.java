package controller.mpp;

import dao.ProposalDAO;
import model.EventItem;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "MppReviewServlet", urlPatterns = {"/mpp/review"})
public class MppReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"MPP".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        try {
            int proposalId = Integer.parseInt(request.getParameter("id"));
            ProposalDAO dao = new ProposalDAO();

            // FETCH THE 3NF OBJECT
            EventItem proposal = dao.getProposalById3NF(proposalId);

            if (proposal != null) {
                request.setAttribute("p", proposal);
                request.getRequestDispatcher("/WEB-INF/jsp/mpp/MppReviewPage.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Proposal not found.");
                response.sendRedirect(request.getContextPath() + "/mpp/proposals");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/mpp/proposals");
        }
    }
}
