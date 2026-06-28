package controller.advisor;

import dao.ProposalDAO;
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

@WebServlet(name = "UploadERiskServlet", urlPatterns = {"/UploadERiskServlet"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB maximum file size
        maxRequestSize = 1024 * 1024 * 15 // 15MB maximum request size
)
public class UploadERiskServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            int proposalId = Integer.parseInt(request.getParameter("proposalId"));

            // Dapatkan fail yang di-upload
            Part filePart = request.getPart("eriskFile");
            if (filePart == null || filePart.getSize() == 0) {
                session.setAttribute("errorMessage", "Please select a valid file.");
                response.sendRedirect(request.getContextPath() + "/advisor/review?id=" + proposalId);
                return;
            }

            // Dapatkan nama fail asal & bersihkan nama fail dari sebarang space/simbol pelik
            String originalFileName = getSubmittedFileName(filePart);
            String safeFileName = originalFileName.replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
            String fileName = "PROPOSAL_" + proposalId + "_ERISK_" + safeFileName;

            // Setup folder "uploads/erisk" dalam server
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "erisk";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs(); // Buat folder kalau belum wujud
            }

            // Tulis/Save fail ke dalam folder server
            String savePath = uploadPath + File.separator + fileName;
            filePart.write(savePath);

            // Simpan path relatif ke dalam database
            String dbPath = "uploads/erisk/" + fileName;
            ProposalDAO dao = new ProposalDAO();
            boolean success = dao.updateERiskFilePath(proposalId, dbPath);

            if (success) {
                session.setAttribute("successMessage", "E-Risk Document uploaded successfully!");
            } else {
                session.setAttribute("errorMessage", "File uploaded but failed to update database.");
            }

            // Return ke page review
            response.sendRedirect(request.getContextPath() + "/advisor/review?id=" + proposalId);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "System Error: Failed to upload document.");
            response.sendRedirect(request.getContextPath() + "/advisor/dashboard");
        }
    }

    // Helper method untuk dapatkan nama fail
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown_file";
    }
}
