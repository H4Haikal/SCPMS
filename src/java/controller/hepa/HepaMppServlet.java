package controller.hepa;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;
import util.EmailService;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "HepaMppServlet", urlPatterns = {"/hepa/mpp"})
public class HepaMppServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("HEPA")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<User> mppList = userDAO.getMPPList();
        request.setAttribute("mppList", mppList);

        request.getRequestDispatcher("/WEB-INF/jsp/hepa/ManageMPP.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        try {
            if ("assignMPP".equals(action)) {
                User newUser = new User();
                newUser.setUserId(request.getParameter("userId"));
                newUser.setFullName(request.getParameter("fullName"));
                newUser.setEmail(request.getParameter("email"));
                newUser.setDepartment(request.getParameter("department")); // Pilihan
                newUser.setPortfolio(request.getParameter("portfolio"));

                String tempPass = PasswordUtil.generateRandomPassword(10);
                String result = userDAO.assignMPP(newUser, tempPass);

                if ("SUCCESS".equals(result)) {
                    // Hantar E-mel (Run in background thread)
                    new Thread(() -> {
                        EmailService.sendPasswordEmail(newUser.getEmail(), newUser.getFullName(), tempPass, "MPP", "Majlis Perwakilan Pelajar (MPP)");
                    }).start();

                    session.setAttribute("message", "Student successfully appointed to MPP. A temporary password has been emailed.");
                } else {
                    session.setAttribute("errorMessage", result);
                }

                // ... logik assignMPP ...
            } else if ("editMPP".equals(action)) {
                // KEMAS KINI MAKLUMAT MPP
                User mppToUpdate = new User();
                mppToUpdate.setUserId(request.getParameter("userId"));
                mppToUpdate.setFullName(request.getParameter("fullName"));
                mppToUpdate.setDepartment(request.getParameter("department"));
                mppToUpdate.setPortfolio(request.getParameter("portfolio"));

                boolean updated = userDAO.updateMPPDetails(mppToUpdate);
                if (updated) {
                    session.setAttribute("message", "MPP profile updated successfully.");
                } else {
                    session.setAttribute("errorMessage", "Failed to update MPP details.");
                }

            } else if ("removeMPP".equals(action)) {
                // ... logik removeMPP sedia ada ...
                String userId = request.getParameter("userId");
                boolean removed = userDAO.removeMPP(userId);
                if (removed) {
                    session.setAttribute("message", "MPP role revoked. User has been demoted to standard Student.");
                } else {
                    session.setAttribute("errorMessage", "Failed to revoke MPP role.");
                }

            } else if ("endSession".equals(action)) {
                int count = userDAO.endMPPSession();
                if (count >= 0) {
                    session.setAttribute("message", "MPP Academic Session Ended! " + count + " members have been demoted to Students.");
                } else {
                    session.setAttribute("errorMessage", "Failed to execute End Session.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "System Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/hepa/mpp");
    }
}
