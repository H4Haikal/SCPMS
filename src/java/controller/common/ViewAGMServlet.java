package controller.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewAGMServlet", urlPatterns = {"/viewAGM"})
public class ViewAGMServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fileName = request.getParameter("file"); // Cth: AGM_1002_2026_12345.pdf

        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Parameter fail tiada.");
            return;
        }

        // --- SAFETY CHECK --- 
        // Kalau data lama dalam database ada "agm_reports/", kita buang.
        if (fileName.contains("/")) {
            fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
        }

        // Set path ke folder LUAR NetBeans
        String uploadPath = "C:" + File.separator + "SCMS_Uploads" + File.separator + "agm_reports";
        File pdfFile = new File(uploadPath, fileName);

        if (!pdfFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Fail tidak dijumpai di folder selamat: " + pdfFile.getAbsolutePath());
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=\"" + pdfFile.getName() + "\"");

        try (FileInputStream inStream = new FileInputStream(pdfFile); OutputStream outStream = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
        }
    }
}
