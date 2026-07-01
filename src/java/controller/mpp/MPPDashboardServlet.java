package controller.mpp;

import dao.AuditDAO;
import dao.MPPDashboardDAO;
import dao.NotificationDAO;
import dao.ProposalDAO;
import java.io.IOException;
import java.time.Year;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Notification;

@WebServlet(name = "MPPDashboardServlet", urlPatterns = {"/MPPDashboardServlet", "/dashboard"})
public class MPPDashboardServlet extends HttpServlet {

    private final MPPDashboardDAO mppDashboardDAO = new MPPDashboardDAO();
    private final AuditDAO auditDAO = new AuditDAO();
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

        // 2. Fetch Recent Activities from Audit Logs
        request.setAttribute("recentActivities", auditDAO.getRecentLogs());

        // 3. Dynamic Year Calculation
        int currentYear = Year.now().getValue();
        request.setAttribute("currentYear", currentYear);

        // 4. Fetch Statistics & Events
        request.setAttribute("upcomingEvents", mppDashboardDAO.getUpcomingEvents());
        request.setAttribute("activeClubs", mppDashboardDAO.getActiveClubs());
        request.setAttribute("totalMembers", mppDashboardDAO.getTotalMembers());
        request.setAttribute("eventsThisWeek", mppDashboardDAO.getEventsThisWeek());

        // Uncommented and updated to use a dynamic year method
        request.setAttribute("totalEventsThisYear", mppDashboardDAO.getTotalEventsByYear(currentYear));

        model.User user = (session != null) ? (model.User) session.getAttribute("user") : null;

// Safety guard fallback check: if session expired, send them back to login page
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        // 5. Action Mark Read
        String action = request.getParameter("action");
        NotificationDAO notifDAO = new NotificationDAO();
        String userId = user.getUserId();

        if ("markRead".equals(action) || "markAllRead".equals(action)) {
            notifDAO.markAllAsReadDynamic(-1, "MPP", userId);
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        List<Notification> notifications = notifDAO.getUnreadNotificationsForRole("MPP", userId);
        request.setAttribute("notifications", notifications);
        request.setAttribute("notificationCount", notifications.size());
        // 7. Forward to View
        request.getRequestDispatcher("/WEB-INF/jsp/mpp/MPPDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
