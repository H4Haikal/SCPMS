package controller.chc;

import dao.ClubDAO;
import dao.ClubDashboardDAO;
import model.User;
import java.io.File;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/chc/uploadLogo")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class UploadLogoServlet extends HttpServlet {

    private final ClubDAO clubDAO = new ClubDAO();
    private final ClubDashboardDAO dashDAO = new ClubDashboardDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        String userPosition = (session != null) ? (String) session.getAttribute("userPosition") : null;

        // 1. Security Check
        if (user == null || !"Pres".equals(userPosition)) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        Map<String, String> info = dashDAO.getClubInfo(user.getUserId());
        int clubId = Integer.parseInt(info.get("clubId"));

        try {
            Part filePart = request.getPart("clubLogo");
            if (filePart != null && filePart.getSize() > 0) {

                String fileName = "club_" + clubId + "_" + System.currentTimeMillis() + ".png";

                // --- THE CURSOR_ SERVER FIX ---
                String userHome = System.getProperty("user.home");

                // Maps to the server's "uploads/logos" directory
                String uploadPath = userHome + File.separator + "uploads" + File.separator + "logos";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Save the file permanently
                filePart.write(uploadPath + File.separator + fileName);

                // Update Database
                String dbPath = "uploads/logos/" + fileName;
                if (clubDAO.updateClubLogo(clubId, dbPath)) {
                    request.getSession().setAttribute("message", "Logo updated successfully!");
                } else {
                    request.getSession().setAttribute("error", "Failed to update database.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Upload error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/chc/profile");
    }
}
