package controller.hepa;

import dao.ClubDAO;
import model.Club;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "HepaClubMembersServlet", urlPatterns = {"/hepa/clubMembers"})
public class HepaClubMembersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        // Security Check
        if (role == null || !role.equals("HEPA")) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String clubIdStr = request.getParameter("clubId");

        if (clubIdStr != null && !clubIdStr.trim().isEmpty()) {
            try {
                int clubId = Integer.parseInt(clubIdStr);
                ClubDAO clubDAO = new ClubDAO();

                // Fetch the club details (for the page header)
                Club club = clubDAO.getClubProfile(clubId);

                // Fetch the list of members
                List<Map<String, Object>> members = clubDAO.getClubMembersList(clubId);

                if (club != null) {
                    request.setAttribute("club", club);
                    request.setAttribute("members", members);
                    request.getRequestDispatcher("/WEB-INF/jsp/hepa/ClubMembers.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid Club ID format: " + clubIdStr);
            }
        }

        // If clubId is missing or invalid, bounce them back to the club list
        session.setAttribute("errorMessage", "Club not found or invalid ID.");
        response.sendRedirect(request.getContextPath() + "/hepa/club");
    }
}
