package controller.advisor;

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

@WebServlet(name = "ClubDirectoryServlet", urlPatterns = {"/advisor/directory"})
public class ClubDirectoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Security check: Only Advisors can access this page
        if (user == null || !"Advisor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        try {
            ProposalDAO dao = new ProposalDAO();

            // 1. Get the club ID for this advisor
            int clubId = dao.getClubIdByAdvisorId(user.getUserId());

            if (clubId != -1) {
                // NEW: Fetch and set the club name directly as a request attribute
                String clubName = dao.getClubNameById(clubId);
                request.setAttribute("clubName", clubName);

                // 2. Fetch the two lists from the database
                List<Map<String, Object>> chcList = dao.getClubCHC(clubId);
                List<Map<String, Object>> memberList = dao.getClubMembers(clubId);
                List<Map<String, Object>> allList = dao.getAllClubMembers(clubId);

                // 3. Pass data to the JSP
                request.setAttribute("chcList", chcList);
                request.setAttribute("memberList", memberList);
                request.setAttribute("allList", allList);

                // 1. Initialize our modern notification DAO
                NotificationDAO notifDAO = new NotificationDAO();
                String userId = user.getUserId(); // Get the advisor's logged-in unique ID

                // 2. Fetch the advisor's specific club ID dynamically if not already available
                int realClubIdForAdvisor = dao.getClubIdByAdvisorId(userId);

                // 3. Query unread alerts directly from the user-isolated tracking table
                java.util.List<Notification> notifications = notifDAO.getUnreadNotifications(realClubIdForAdvisor, userId);

                // 4. Set attributes cleanly to match what topbar.jsp expects
                request.setAttribute("notifications", notifications);
                request.setAttribute("notificationCount", notifications.size());

            }

            // 4. Forward to the new JSP page we just created
            request.getRequestDispatcher("/WEB-INF/jsp/advisor/ClubDirectory.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading club directory.");
            response.sendRedirect(request.getContextPath() + "/advisor/dashboard");
        }
    }
}
