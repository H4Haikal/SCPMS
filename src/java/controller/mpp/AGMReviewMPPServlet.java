package controller.mpp;

import dao.AGMReportDAO;
import dao.AuditDAO;
import dao.ClubDAO;
import dao.NotificationDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AGMReviewMPPServlet", urlPatterns = {"/mpp/agm"})
public class AGMReviewMPPServlet extends HttpServlet {

    private final AGMReportDAO agmDAO = new AGMReportDAO();
    private final ClubDAO clubDAO = new ClubDAO();
    private final NotificationDAO notifDAO = new NotificationDAO();
    private final AuditDAO auditDAO = new AuditDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"MPP".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // MPP only pulls reports that are 'Pending_MPP'
        request.setAttribute("allReports", agmDAO.getAGMReportsForMPP());
        request.getRequestDispatcher("/WEB-INF/jsp/mpp/AGMReviewMPP.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"MPP".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("updateStatus".equals(action)) {
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                int agmId = Integer.parseInt(request.getParameter("agmId"));
                String year = request.getParameter("year");
                String decision = request.getParameter("status"); // "accepted" or "missing"

                String remarks = request.getParameter("remarks");
                if (remarks == null) {
                    remarks = "";
                }

                // Hardcode "MPP" as the role
                boolean success = agmDAO.updateAGMStatus(agmId, clubId, decision, year, "MPP", remarks);

                if (success) {
                    auditDAO.log(user.getUserId(), "REVIEW_AGM_MPP", "AGM Report ID " + agmId + " decision: " + decision);
                    session.setAttribute("successMessage", "Report successfully " + ("accepted".equals(decision) ? "endorsed to HEPA." : "rejected."));
                } else {
                    session.setAttribute("errorMessage", "Failed to update report status.");
                }
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "System Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/mpp/agm");
    }
}
