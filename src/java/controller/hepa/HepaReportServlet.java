package controller.hepa;

import dao.ProposalDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/hepa/reports")
public class HepaReportServlet extends HttpServlet {

    private final ProposalDAO dao = new ProposalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"HEPA".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Ambil SEMUA proposal untuk pelaporan komprehensif
        List<Map<String, Object>> allProposals = dao.getAllProposalsForReporting();

        request.setAttribute("allProposals", allProposals);
        request.getRequestDispatcher("/WEB-INF/jsp/hepa/HepaReport.jsp").forward(request, response);
    }
}
