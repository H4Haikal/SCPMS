package controller.hepa;

import dao.AuditDAO;
import model.AuditLog;
import model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// 1. ADD MULTIPLE URL PATTERNS HERE
@WebServlet(name = "AuditServlet", urlPatterns = {"/mpp/audit", "/hepa/audit"})
public class AuditServlet extends HttpServlet {

    private final AuditDAO auditDAO = new AuditDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // 2. SECURITY CHECK: Allow if user is EITHER MPP or HEPA
        if (currentUser == null || (!"MPP".equals(currentUser.getRole()) && !"HEPA".equals(currentUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        try {
            List<AuditLog> logs = auditDAO.getAllLogs();
            request.setAttribute("logs", logs);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load audit logs.");
        }

        // 3. Both roles will see the exact same beautiful Forensic Timeline UI!
        request.getRequestDispatcher("/WEB-INF/jsp/hepa/AuditLogs.jsp").forward(request, response);
    }
}
