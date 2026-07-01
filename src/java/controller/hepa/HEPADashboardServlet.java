package controller.hepa;

import dao.ClubDAO;
import dao.ProposalDAO;
import model.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/hepa/dashboard")
public class HEPADashboardServlet extends HttpServlet {

    private final ProposalDAO pDao = new ProposalDAO();
    private final ClubDAO cDao = new ClubDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Sekuriti: Hanya HEPA sahaja yang boleh masuk
        if (user == null || !"HEPA".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Ambil semua proposal untuk dikira metriknya
        List<Map<String, Object>> allProposals = pDao.getAllProposals();

        int pendingHepaCount = 0;
        int approvedCount = 0;
        double totalApprovedBudget = 0.0;

        List<Map<String, Object>> pendingProposals = new ArrayList<>();

        // Pengiraan Metrik & Penapisan secara Auto
        if (allProposals != null) {
            for (Map<String, Object> p : allProposals) {
                String status = (String) p.get("status");
                if ("Pending_HEPA".equals(status)) {
                    pendingHepaCount++;
                    pendingProposals.add(p); // Asingkan yang perlukan tindakan HEPA
                } else if ("Approved".equals(status)) {
                    approvedCount++;
                    // Kira jumlah bajet yang telah diluluskan oleh universiti
                    if (p.get("budget") != null) {
                        totalApprovedBudget += ((Number) p.get("budget")).doubleValue();
                    }
                }
            }
        }

        // Hantar Metrik ke Paparan (JSP)
        request.setAttribute("pendingHepaCount", pendingHepaCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("totalApprovedBudget", totalApprovedBudget);
        request.setAttribute("activeClubsCount", cDao.getAllClubs().size()); // Andaikan ini menarik semua kelab

        // Hantar senarai tindakan kepada HEPA
        request.setAttribute("pendingProposals", pendingProposals);

        // Masukkan import dao.NotificationDAO; di bahagian atas fail
        // 1. Initialize our modern notification tracker
        dao.NotificationDAO notifDAO = new dao.NotificationDAO();
        String userId = user.getUserId(); // Get the logged-in HEPA administrator's unique ID

// 2. Fetch user-isolated notifications directly from the case-insensitive role tracking table
        java.util.List<model.Notification> notifications = notifDAO.getUnreadNotificationsForRole("HEPA", userId);

// 3. Set attributes cleanly to perfectly match what your topbar dropdown template expects
        request.setAttribute("notifications", notifications);
        request.setAttribute("notificationCount", notifications.size());

        request.getRequestDispatcher("/WEB-INF/jsp/hepa/HEPADashboard.jsp").forward(request, response);
    }
}
