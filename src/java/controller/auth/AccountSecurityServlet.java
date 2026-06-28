package controller.auth;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AccountSecurityServlet")
public class AccountSecurityServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String action = request.getParameter("action");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if ("forceChangePassword".equals(action)) {
            // 1. Validate Passwords
            if (newPassword == null || !newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match!");
                request.getRequestDispatcher("/ClubDashboardServlet").forward(request, response);
                return;
            }

            // 2. Update Database via DAO
            // This method must set password and set isTempPassword = 0
            if (userDAO.updatePassword(currentUser.getUserId(), newPassword)) {

                // 3. Update the Session so the popup disappears immediately
                session.setAttribute("isTemp", 0);

                // 4. Redirect to dashboard with success message
                response.sendRedirect(request.getContextPath() + "/ClubDashboardServlet?msg=SecurityUpdated");
            } else {
                request.setAttribute("error", "Database error. Please try again.");
                request.getRequestDispatcher("/ClubDashboardServlet").forward(request, response);
            }
        }
    }
}
