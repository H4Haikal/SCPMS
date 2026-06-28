package controller.common;

import dao.AGMReportDAO;
import dao.ProposalDAO;
import model.User;
import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "AGMServlet", urlPatterns = {"/common/agm"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 15 // 15MB
)
public class AGMServlet extends HttpServlet {

    private final AGMReportDAO agmDAO = new AGMReportDAO();
    private final ProposalDAO propDAO = new ProposalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"CHC".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        int clubId = propDAO.getClubIdByUserId(user.getUserId());
        request.setAttribute("userClubId", clubId);
        request.setAttribute("reports", agmDAO.getAGMReportsByClub(clubId));

        request.getRequestDispatcher("/WEB-INF/jsp/chc/UploadAGM.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"CHC".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String action = request.getParameter("action");

        if ("upload".equals(action)) {
            try {
                int clubId = Integer.parseInt(request.getParameter("clubId"));
                String year = request.getParameter("reportYear");
                Part filePart = request.getPart("reportFile");

                if (filePart != null && filePart.getSize() > 0) {
                    String uniqueFileName = "AGM_" + clubId + "_" + year + "_" + System.currentTimeMillis() + ".pdf";

                    // --- SAFE FOLDER PATH (IMMUNE TO NETBEANS WIPE) ---
                    String uploadPath = "C:" + File.separator + "SCMS_Uploads" + File.separator + "agm_reports";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs(); // create folder if it does not exist
                    }

                    // Write the file directly to C:\SCMS_Uploads\agm_reports
                    filePart.write(uploadPath + File.separator + uniqueFileName);

                    // Save ONLY the filename to the database
                    boolean success = agmDAO.submitAGMReport(clubId, year, uniqueFileName);

                    if (success) {
                        session.setAttribute("successMessage", "AGM Report for year " + year + " successfully submitted for MPP review.");
                    } else {
                        session.setAttribute("errorMessage", "Failed to update the database record.");
                    }
                } else {
                    session.setAttribute("errorMessage", "Please select a valid PDF file.");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "System Error: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/common/agm");
    }
}
