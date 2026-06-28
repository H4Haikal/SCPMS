package controller.common;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UserSettingsServlet", urlPatterns = {"/user/settings"})
public class UserSettingsServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Security Check
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // 2. Refresh User Data from DB (Ensure we show latest info)
        User freshUser = userDAO.getUser(currentUser.getUserId());
        session.setAttribute("user", freshUser); // Sync session

        request.getRequestDispatcher("/WEB-INF/jsp/common/UserSettings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        String message = "";
        String error = "";

        if ("updateProfile".equals(action)) {
            // --- PROFILE UPDATE LOGIC ---
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String department = request.getParameter("faculty");

            // Call the updated DAO method
            if (userDAO.updateUserProfile(currentUser.getUserId(), fullName, phone, email, department)) {
                // Update Session
                currentUser.setFullName(fullName);
                currentUser.setPhone(phone);
                currentUser.setEmail(email);
                currentUser.setDepartment(department); // Update session object
                session.setAttribute("user", currentUser);

                message = "Profile updated successfully!";
            } else {
                error = "Failed to update profile. Database error.";
            }

        } else if ("changePassword".equals(action)) {
            // --- PASSWORD CHANGE LOGIC ---
            String currentPass = request.getParameter("currentPassword");
            String newPass = request.getParameter("newPassword");
            String confirmPass = request.getParameter("confirmPassword");

            // 1. Verify Old Password
            if (!userDAO.checkPassword(currentUser.getUserId(), currentPass)) {
                error = "Incorrect current password.";
            } // 2. Verify New Passwords Match
            else if (!newPass.equals(confirmPass)) {
                error = "New passwords do not match.";
            } // 3. Update Password
            else {
                if (userDAO.updatePassword(currentUser.getUserId(), newPass)) {
                    message = "Password changed successfully!";
                } else {
                    error = "Failed to update password.";
                }
            }
        }

        if (!message.isEmpty()) {
            request.setAttribute("message", message);
        }

        if (!error.isEmpty()) {
            request.setAttribute("error", error);
        }

        doGet(request, response);
    }
}
