package controller.advisor;

import dao.ProposalDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "AdvisorDocumentationServlet", urlPatterns = {"/advisor/documentation"})
public class AdvisorDocumentationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Security check
        if (user == null || !"Advisor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        try {
            ProposalDAO dao = new ProposalDAO();

            // Fetch the dynamically grouped documents map
            Map<String, List<Map<String, Object>>> groupedDocs = dao.getGroupedSystemDocuments();

            // Pass it to the JSP
            request.setAttribute("groupedDocs", groupedDocs);

            request.getRequestDispatcher("/WEB-INF/jsp/advisor/AdvisorDocumentation.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/advisor/dashboard");
        }
    }
}
