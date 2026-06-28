package controller.chc;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ServeImage")
public class ServeImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("file");

        // 1. If no file is requested, serve the default logo from the web folder
        if (fileName == null || fileName.isEmpty() || fileName.equals("default_logo.png")) {
            request.getRequestDispatcher("/images/default_logo.png").forward(request, response);
            return;
        }

        // 2. Point to the external folder
        String userHome = System.getProperty("user.home");
        String filePath = userHome + File.separator + "SCPMS_Uploads" + File.separator + "Logos" + File.separator + fileName;

        File imageFile = new File(filePath);

        // 3. If the external file is missing, fallback to the default web logo
        if (!imageFile.exists()) {
            request.getRequestDispatcher("/images/default_logo.png").forward(request, response);
            return;
        }

        // 4. Serve the actual external image
        response.setContentType(getServletContext().getMimeType(imageFile.getName()));
        response.setContentLength((int) imageFile.length());

        try (FileInputStream in = new FileInputStream(imageFile); OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
