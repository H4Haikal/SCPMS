package controller.hepa;

import dao.AGMReportDAO;
import dao.AuditDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AGMManagementHEPAServlet", urlPatterns = {"/hepa/agm"})
public class AGMManagementHEPAServlet extends HttpServlet {

    private final AGMReportDAO agmDAO = new AGMReportDAO();
    private final AuditDAO auditDAO = new AuditDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"HEPA".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // HEPA pulls reports that are Pending_HEPA, Accepted, and Missing
        request.setAttribute("allReports", agmDAO.getAGMReportsForHEPA());
        request.getRequestDispatcher("/WEB-INF/jsp/hepa/AGMManagementHEPA.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"HEPA".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("updateStatus".equals(action)) {
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                int agmId = Integer.parseInt(request.getParameter("agmId"));
                String year = request.getParameter("year");
                String decision = request.getParameter("status");

                String remarks = request.getParameter("remarks");
                if (remarks == null) {
                    remarks = "";
                }

                // Hardcode "HEPA" as the role
                boolean success = agmDAO.updateAGMStatus(agmId, clubId, decision, year, "HEPA", remarks);

                if (success) {
                    auditDAO.log(user.getUserId(), "APPROVE_AGM_HEPA", "AGM Report ID " + agmId + " decision: " + decision);
                    session.setAttribute("successMessage", "AGM report final decision has been recorded successfully.");
                } else {
                    session.setAttribute("errorMessage", "Failed to update final status.");
                }
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "System Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/hepa/agm");
    }
}
