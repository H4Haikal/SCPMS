package controller.common;

import dao.ProposalDAO;
import model.User;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "GenerateProposalServlet", urlPatterns = {"/ViewProposalHTML"})
public class GenerateProposalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        try {
            int proposalId = Integer.parseInt(request.getParameter("id"));

            ProposalDAO dao = new ProposalDAO();
            Map<String, Object> proposal = dao.getProposalById(proposalId);

            // TANGKAP KATEGORI KELAB UNTUK TEMPLATE
            String category = dao.getClubCategoryByProposalId(proposalId);

            if (proposal != null && !proposal.isEmpty()) {
                request.setAttribute("p", proposal); // Guna 'p' supaya match dengan template
                request.setAttribute("clubCategory", category); // Hantar kategori ke template

                request.getRequestDispatcher("/WEB-INF/jsp/HEPATemplate.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Ralat: Kertas kerja tidak dijumpai.");
                response.sendRedirect(request.getContextPath() + "/chc/events");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/chc/events");
        }
    }
}
