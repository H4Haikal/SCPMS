package controller.chc;

import dao.ClubDashboardDAO;
import dao.ClubMembershipDAO;
import dao.NotificationDAO;
import dao.ProposalDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Notification;

@WebServlet(name = "ClubDashboardServlet", urlPatterns = {"/ClubDashboardServlet"})
public class ClubDashboardServlet extends HttpServlet {

    private final ClubDashboardDAO dashboardDAO = new ClubDashboardDAO();
    private final ClubMembershipDAO memberDAO = new ClubMembershipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"CHC".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        ProposalDAO dao = new ProposalDAO();
        int realClubId = dao.getClubIdByUserId(user.getUserId());

        // --- MARK NOTIFICATIONS READ ---
        String action = request.getParameter("action");
        NotificationDAO notifDAO = new NotificationDAO();
        String userId = user.getUserId();

        if ("markRead".equals(action) || "markAllRead".equals(action)) {
            notifDAO.markAllAsReadDynamic(realClubId, "CHC", userId);
            response.sendRedirect(request.getContextPath() + "/ClubDashboardServlet");
            return;
        }

        request.setAttribute("clubId", realClubId);

        // --- 1. CLUB INFO & NOTIFICATIONS ---
        String clubName = (realClubId != -1) ? dao.getClubNameById(realClubId) : "Unknown Club";
        request.setAttribute("clubName", clubName);

        if (realClubId != -1) {
            // Fetch notifications using NotificationDAO instead of ProposalDAO (dao)
            List<Notification> notifications = notifDAO.getUnreadNotifications(realClubId, userId);
            request.setAttribute("notifications", notifications);
            request.setAttribute("notificationCount", notifications.size());
        }

        // --- 2. MEMBERSHIP STATS ---
        Map<String, String> clubInfo = dashboardDAO.getClubInfo(user.getUserId());
        if (!clubInfo.isEmpty()) {
            int clubId = Integer.parseInt(clubInfo.get("clubId"));
            List<Map<String, String>> members = memberDAO.getMembers(clubId);
            long committeeCount = members.stream()
                    .filter(m -> !m.get("position").equals("Member") && !m.get("position").equals("Committee"))
                    .count();
            request.setAttribute("club", clubInfo);
            request.setAttribute("memberCount", members.size());
            request.setAttribute("committeeCount", committeeCount);
        }

        // --- 3. PROPOSAL LIFECYCLE ANALYTICS (NEW!) ---
        if (realClubId != -1) {
            request.setAttribute("pStats", dao.getClubDashboardStats(realClubId));
            request.setAttribute("recentProposals", dao.getRecentClubProposals(realClubId));
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/jsp/chc/ClubDashboard.jsp").forward(request, response);
    }
}
