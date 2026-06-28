package controller.auth;

import dao.UserDAO;
import util.EmailService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String email = request.getParameter("email");

        if ("requestOTP".equals(action)) {
            String otp = String.valueOf((int) (Math.random() * 900000) + 100000);
            if (userDAO.saveOTP(email, otp)) {
                EmailService.sendOTPEmail(email, otp);
                request.setAttribute("email", email);
                request.setAttribute("step", "verify");
            } else {
                request.setAttribute("error", "Email not found in our system.");
            }
        } else if ("verifyOTP".equals(action)) {
            String otp = request.getParameter("otp");
            if (userDAO.verifyOTP(email, otp)) {
                request.setAttribute("email", email);
                request.setAttribute("step", "reset");
            } else {
                request.setAttribute("email", email);
                request.setAttribute("step", "verify");
                request.setAttribute("error", "Invalid or expired OTP.");
            }
        } else if ("resetPassword".equals(action)) {
            String pass = request.getParameter("password");
            if (userDAO.resetPassword(email, pass)) {
                request.setAttribute("message", "Password reset successful. Please login.");
                request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
                return;
            }
        }
        request.getRequestDispatcher("/WEB-INF/jsp/forgotPassword.jsp").forward(request, response);
    }
}
