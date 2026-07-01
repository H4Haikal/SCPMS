package controller.common;

import dao.NotificationDAO;
import dao.ProposalDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Menyokong pautan baru (/notifications) dan pautan lama kau (/markNotificationsRead)
@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications", "/markNotificationsRead"})
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String path = request.getServletPath(); // Untuk check kalau guna URL lama

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        String referer = request.getHeader("Referer");

        // Keselamatan: Jika tiada user, tendang balik
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        NotificationDAO notifDAO = new NotificationDAO();
        String role = user.getRole();
        String userId = user.getUserId(); // Extracted from session context wrapper

        // CIRI BARU 1: CLICK INDIVIDUAL NOTIFICATION
        if ("read".equals(action)) {
            try {
                int notifId = Integer.parseInt(request.getParameter("id"));
                String redirectUrl = request.getParameter("redirect");

                // Isolate updates to only mark it read for this active user account context
                notifDAO.markAsRead(notifId, userId);

                if (redirectUrl != null && !redirectUrl.trim().isEmpty() && !redirectUrl.equals("null")) {
                    if (!redirectUrl.startsWith("/")) {
                        redirectUrl = "/" + redirectUrl;
                    }
                    response.sendRedirect(request.getContextPath() + redirectUrl);
                    return;
                }
            } catch (Exception e) {
                System.err.println("Ralat klik notifikasi individu: " + e.getMessage());
            }
            response.sendRedirect(referer != null ? referer : request.getContextPath());
            return;
        }

// CIRI BARU 2: MARK ALL AS READ
        // Inside your NotificationServlet.java doGet method:
        if ("markAllRead".equals(action) || "/markNotificationsRead".equals(path)) {
            int realClubId = -1;
            ProposalDAO propDAO = new ProposalDAO();

            if ("CHC".equals(role)) {
                realClubId = propDAO.getClubIdByUserId(userId);
                // REMOVED: propDAO.markAllNotificationsAsRead(realClubId); 
                // This old method is broken because it looks for the deleted 'isRead' column.
            }

            // This method now handles EVERYTHING cleanly by inserting read states into 
            // the user_notification_status table for this specific user ID!
            notifDAO.markAllAsReadDynamic(realClubId, role, userId);

            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/ClubDashboardServlet");
            return; // Ensure execution stops here to avoid falling into other conditions
        }

    }
}
