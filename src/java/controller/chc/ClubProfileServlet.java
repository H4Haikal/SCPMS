package controller.chc;

import dao.ClubDAO;
import dao.ClubDashboardDAO;
import model.Club;
import model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "ClubProfileServlet", urlPatterns = {"/chc/profile"})
public class ClubProfileServlet extends HttpServlet {

    private final ClubDAO clubDAO = new ClubDAO();
    private final ClubDashboardDAO dashDAO = new ClubDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // 1. Fetch info directly from DB (Includes Position now)
        Map<String, String> info = dashDAO.getClubInfo(user.getUserId());

        if (info.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ClubDashboardServlet");
            return;
        }

        int clubId = Integer.parseInt(info.get("clubId"));

        // Retrieve and trim position to remove any hidden database spaces
        String userPosition = info.get("position");
        if (userPosition != null) {
            userPosition = userPosition.trim();
        }

        // 2. Fetch Club Data
        Club myClub = clubDAO.getClubProfile(clubId);

        // 3. Pass to JSP
        request.setAttribute("club", myClub);
        request.setAttribute("userPosition", userPosition);

        request.getRequestDispatcher("/WEB-INF/jsp/chc/ClubProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Capture the data
        String mission = request.getParameter("mission");
        String vision = request.getParameter("vision");
        String category = request.getParameter("category");
        String estYearStr = request.getParameter("estYear");
        String clubIdStr = request.getParameter("clubId");

        // 2. DEBUG: Check NetBeans Output Window!
        System.out.println("--- POST DEBUG START ---");
        System.out.println("Club ID: " + clubIdStr);
        System.out.println("Mission: " + mission);
        System.out.println("Vision: " + vision);
        System.out.println("--- POST DEBUG END ---");

        if (clubIdStr == null || clubIdStr.isEmpty()) {
            request.setAttribute("error", "Error: Club ID is missing.");
            doGet(request, response);
            return;
        }

        // 3. Prepare the object
        Club c = new Club();
        c.setClubId(Integer.parseInt(clubIdStr));
        c.setCategory(category);
        c.setEstablishedYear(Integer.parseInt(estYearStr));
        c.setMission(mission);
        c.setVision(vision);

        // 4. Update Database
        if (clubDAO.updateClubDetails(c)) {
            request.setAttribute("message", "Profile updated successfully!");
        } else {
            request.setAttribute("error", "Database Error: Could not save changes.");
        }

        doGet(request, response);
    }
}
