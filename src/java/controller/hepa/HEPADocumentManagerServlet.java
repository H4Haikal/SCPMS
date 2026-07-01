package controller.hepa;

import dao.ProposalDAO;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import model.User;

@WebServlet(name = "HEPADocumentManagerServlet", urlPatterns = {"/hepa/documents"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class HEPADocumentManagerServlet extends HttpServlet {

    // Define the persistent root folder from CURSOR_ admin
    private final String UPLOAD_ROOT = System.getProperty("user.home") + File.separator + "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"HEPA".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        ProposalDAO dao = new ProposalDAO();
        Map<String, List<Map<String, Object>>> groupedDocs = dao.getGroupedSystemDocuments();
        request.setAttribute("groupedDocs", groupedDocs);

        request.getRequestDispatcher("/WEB-INF/jsp/hepa/DocumentManager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        ProposalDAO dao = new ProposalDAO();

        // ==========================================
        // ACTION: DELETE DOCUMENT 
        // ==========================================
        if ("delete".equals(action)) {
            int docId = Integer.parseInt(request.getParameter("docId"));

            // 1. Get path from DB and delete physical file from persistent folder
            String dbPath = dao.getSystemDocumentPath(docId); // e.g., "uploads/documents/filename.pdf"
            if (dbPath != null) {
                // Construct absolute path using our persistent UPLOAD_ROOT
                String fullPath = UPLOAD_ROOT + File.separator + dbPath.replace("uploads/", "");
                File fileToDelete = new File(fullPath);
                if (fileToDelete.exists()) {
                    fileToDelete.delete();
                }
            }

            // 2. Delete from database
            dao.deleteSystemDocument(docId);
            request.getSession().setAttribute("successMsg", "Document successfully deleted.");
            response.sendRedirect(request.getContextPath() + "/hepa/documents");
            return;
        }

        // ==========================================
        // ACTION: UPLOAD DOCUMENT 
        // ==========================================
        String title = request.getParameter("docTitle");
        String existingCategory = request.getParameter("existingCategory");
        String newCategory = request.getParameter("newCategory");

        String finalCategory = (newCategory != null && !newCategory.trim().isEmpty()) ? newCategory.trim() : existingCategory;

        Part filePart = request.getPart("documentFile");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        fileName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9.-]", "_");

        // Target persistent directory: /home/user/uploads/documents/
        String uploadPath = UPLOAD_ROOT + File.separator + "documents";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String savePath = uploadPath + File.separator + fileName;
        filePart.write(savePath);

        // Store path in DB relative to the uploads folder as expected by your system
        String dbFilePath = "uploads/documents/" + fileName;

        long sizeInBytes = filePart.getSize();
        String fileSizeStr = (sizeInBytes / 1024) + " KB";
        if (sizeInBytes > 1024 * 1024) {
            fileSizeStr = String.format("%.2f MB", (double) sizeInBytes / (1024 * 1024));
        }

        String fileType = fileName.toLowerCase().endsWith(".pdf") ? "pdf" : "word";

        dao.insertSystemDocument(finalCategory, title, dbFilePath, "HEPA Admin", fileSizeStr, fileType);

        request.getSession().setAttribute("successMsg", "Document uploaded successfully under '" + finalCategory + "'!");
        response.sendRedirect(request.getContextPath() + "/hepa/documents");
    }
}
