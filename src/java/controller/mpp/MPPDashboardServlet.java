package controller.mpp;

import dao.AuditDAO;
import dao.MPPDashboardDAO;
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

@WebServlet(name = "MPPDashboardServlet", urlPatterns = {"/MPPDashboardServlet", "/dashboard"})
public class MPPDashboardServlet extends HttpServlet {

    // DAO for Stats (Active Clubs, Members, etc.)
    private final MPPDashboardDAO mppDashboardDAO = new MPPDashboardDAO();

    // DAO for Recent Activities (Audit Trail)
    private final AuditDAO auditDAO = new AuditDAO();

    // DAO for Notifications & Proposals
    private final ProposalDAO dao = new ProposalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Security Check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("LoginServlet");
            return;
        }
        // ----------------------------------------

        // 2. Fetch Recent Activities from Audit Logs
        request.setAttribute("recentActivities", auditDAO.getRecentLogs());

        // 3. Fetch Statistics & Events
        request.setAttribute("upcomingEvents", mppDashboardDAO.getUpcomingEvents());
        request.setAttribute("activeClubs", mppDashboardDAO.getActiveClubs());
        request.setAttribute("totalMembers", mppDashboardDAO.getTotalMembers());
        request.setAttribute("eventsThisWeek", mppDashboardDAO.getEventsThisWeek());
//        request.setAttribute("totalEvents2025", mppDashboardDAO.getTotalEvents2025());

        // --- 4. TANGKAP ACTION MARK READ UNTUK MPP ---
        String action = request.getParameter("action");

        if ("markRead".equals(action)) {
            // Kita guna method khas MPP untuk mark as read
            dao.markAllNotificationsAsReadForMPP();
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // --- 5. TARIK DATA NOTIFIKASI MPP ---
        // Panggil fungsi khas MPP yang baca targetRole = 'MPP'
        List<Map<String, Object>> notifications = dao.getNotificationsForMPP();
        int unreadCount = dao.getUnreadNotificationCountForMPP();

        request.setAttribute("notifications", notifications);
        request.setAttribute("notificationCount", unreadCount);

        // 6. Forward to the view
        request.getRequestDispatcher("/WEB-INF/jsp/mpp/MPPDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
