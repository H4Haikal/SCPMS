package controller.auth;

import dao.UserDAO;
import dao.ClubDashboardDAO;
import model.User;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet", "/logout", "/forgot-password"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticate(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            session.setAttribute("isTemp", user.getIsTempPassword());

            if (user.getIsTempPassword() == 1) {
                response.sendRedirect(request.getContextPath() + "/user/settings?tab=security&alert=force");
                return;
            }

            // KESELAMATAN: Buang space tersembunyi & pastikan huruf besar
            String safeRole = user.getRole() != null ? user.getRole().trim().toUpperCase() : "UNKNOWN";

            if ("MPP".equals(safeRole)) {
                response.sendRedirect("MPPDashboardServlet");
            } else if ("HEPA".equals(safeRole)) {
                response.sendRedirect(request.getContextPath() + "/hepa/dashboard");
            } else if ("FACULTY".equals(safeRole)) {
                response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
            } else if ("CHC".equals(safeRole)) {
                ClubDashboardDAO dashDAO = new ClubDashboardDAO();
                Map<String, String> info = dashDAO.getClubInfo(user.getUserId());
                if (!info.isEmpty()) {
                    session.setAttribute("userPosition", info.get("position"));
                }
                response.sendRedirect("ClubDashboardServlet");
            } else {
                // KOD BARU: Tendang penceroboh atau role tak dikenali balik ke Login!
                session.invalidate(); // Matikan terus sesi dia
                request.setAttribute("errorMessage", "Access Denied: You do not have an active administrative role.");
                request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password!");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        if ("/forgot-password".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/jsp/forgotPassword.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            if (user.getIsTempPassword() == 1) {
                response.sendRedirect(request.getContextPath() + "/user/settings?tab=security&alert=force");
                return;
            }

            // KESELAMATAN: Buang space tersembunyi & pastikan huruf besar
            String safeRole = user.getRole() != null ? user.getRole().trim().toUpperCase() : "UNKNOWN";

            if ("MPP".equals(safeRole)) {
                response.sendRedirect("MPPDashboardServlet");
            } else if ("HEPA".equals(safeRole)) {
                response.sendRedirect(request.getContextPath() + "/hepa/dashboard");
            } else if ("FACULTY".equals(safeRole)) {
                response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
            } else if ("CHC".equals(safeRole)) {
                response.sendRedirect("ClubDashboardServlet");
            } else {
                // Tendang balik ke login kalau cuba masuk via URL secara direct tapi role salah
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
            }
            return;
        }
        request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
    }
}
