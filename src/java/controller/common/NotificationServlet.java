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

        // =======================================================
        // CIRI BARU 1: KLIK NOTIFIKASI INDIVIDU (BUKA PAUTAN)
        // =======================================================
        if ("read".equals(action)) {
            try {
                int notifId = Integer.parseInt(request.getParameter("id"));
                String redirectUrl = request.getParameter("redirect");

                // Kemas kini database (isRead = 1)
                notifDAO.markAsRead(notifId);

                // Bawa pengguna ke halaman sebenar berdasarkan Action Link
                if (redirectUrl != null && !redirectUrl.trim().isEmpty() && !redirectUrl.equals("null")) {

                    // --- MAGIK SAFETY CHECK DI SINI ---
                    // Kalau link tu tak bermula dengan '/', kita letakkan '/' supaya tak jadi /scmscommon
                    if (!redirectUrl.startsWith("/")) {
                        redirectUrl = "/" + redirectUrl;
                    }

                    response.sendRedirect(request.getContextPath() + redirectUrl);
                    return;
                }
            } catch (Exception e) {
                System.err.println("Ralat klik notifikasi individu: " + e.getMessage());
            }

            // Fallback kalau tak ada redirect url
            response.sendRedirect(referer != null ? referer : request.getContextPath());
            return;
        }

        // =======================================================
        // CIRI ASAL + BARU 2: TANDAKAN SEMUA SEBAGAI DIBACA
        // =======================================================
        if ("markAllRead".equals(action) || "/markNotificationsRead".equals(path)) {

            int realClubId = -1; // Default
            ProposalDAO propDAO = new ProposalDAO();

            // KEKALKAN CIRI ASAL: Cari clubId menggunakan ProposalDAO untuk role CHC
            if ("CHC".equals(role)) {
                realClubId = propDAO.getClubIdByUserId(user.getUserId());

                if (realClubId != -1) {
                    // Panggil fungsi asal kau dalam ProposalDAO (Kekal tak diubah)
                    propDAO.markAllNotificationsAsRead(realClubId);
                }
            }

            // CIRI BARU: Panggil fungsi NotificationDAO untuk sokong Role lain (HEPA, MPP)
            // Walaupun realClubId -1, fungsi ni tetap akan reset notifikasi ikut targetRole
            notifDAO.markAllAsReadDynamic(realClubId, role);

            // Redirect balik ke tempat asal (Kekalkan ciri asal kau)
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/ClubDashboardServlet");
        }
    }
}
