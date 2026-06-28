package controller.mpp;

import dao.ProposalDAO;
import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "UploadMPPMinutesServlet", urlPatterns = {"/UploadMPPMinutesServlet"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB maximum file size
        maxRequestSize = 1024 * 1024 * 15 // 15MB maximum request size
)
public class UploadMPPMinutesServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int proposalId = Integer.parseInt(request.getParameter("proposalId"));
            Part filePart = request.getPart("mppMinutesFile");

            if (filePart == null || filePart.getSize() == 0) {
                session.setAttribute("errorMessage", "Please select a valid file.");
                response.sendRedirect(request.getContextPath() + "/mpp/review?id=" + proposalId);
                return;
            }

            // Sanitize file name and create unique path
            String originalFileName = filePart.getSubmittedFileName();
            String safeFileName = originalFileName.replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
            String fileName = "PROPOSAL_" + proposalId + "_MINUTES_" + safeFileName;

            // Define upload folder inside 'uploads/mpp_minutes'
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "mpp_minutes";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Save the file to the server
            filePart.write(uploadPath + File.separator + fileName);

            // Update database
            String dbPath = "uploads/mpp_minutes/" + fileName;
            ProposalDAO dao = new ProposalDAO();
            boolean success = dao.updateMPPMinutesFilePath(proposalId, dbPath);

            if (success) {
                session.setAttribute("successMessage", "Meeting Minutes uploaded successfully!");
            } else {
                session.setAttribute("errorMessage", "File uploaded but failed to update database.");
            }

            response.sendRedirect(request.getContextPath() + "/mpp/review?id=" + proposalId);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "System Error: Failed to upload meeting minutes.");
            response.sendRedirect(request.getContextPath() + "/mpp/dashboard");
        }
    }
}
