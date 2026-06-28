package controller.chc;

import dao.ClubDashboardDAO;
import dao.ClubMembershipDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ClubMembershipServlet", urlPatterns = {"/chc/members"})
public class ClubMembershipServlet extends HttpServlet {

    private final ClubDashboardDAO dashboardDAO = new ClubDashboardDAO();
    private final ClubMembershipDAO memberDAO = new ClubMembershipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Auth Check
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"CHC".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // 2. Get Club ID
        Map<String, String> clubInfo = dashboardDAO.getClubInfo(user.getUserId());
        if (clubInfo.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/club_dashboard?error=NoClub");
            return;
        }
        int clubId = Integer.parseInt(clubInfo.get("clubId"));

        // 3. Get Members List
        List<Map<String, String>> members = memberDAO.getMembers(clubId);
        request.setAttribute("members", members);
        request.setAttribute("clubName", clubInfo.get("clubName"));

        // 4. Forward
        request.getRequestDispatcher("/WEB-INF/jsp/chc/ClubMembers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        String currentUserPosition = (String) session.getAttribute("userPosition");

        Map<String, String> clubInfo = dashboardDAO.getClubInfo(currentUser.getUserId());
        int clubId = Integer.parseInt(clubInfo.get("clubId"));

        String action = request.getParameter("action");
        String targetUserId = request.getParameter("userId");
        String targetFullName = request.getParameter("fullName");
        String position = request.getParameter("position");
        String email = request.getParameter("email");

        String message = "";
        String error = "";

        if ("add".equals(action)) {
            if (targetUserId != null && !targetUserId.trim().isEmpty() && targetFullName != null) {
                String result = memberDAO.addMember(clubId, targetUserId, targetFullName, position, email);

                if ("SUCCESS".equals(result)) {
                    message = "Member " + targetFullName + " added successfully as " + position + "!";
                } else {
                    error = "Failed: " + result;
                }
            } else {
                error = "Student ID and Name are required.";
            }
        } else if ("remove".equals(action)) {
            if (memberDAO.removeMember(clubId, targetUserId)) {
                message = "Member removed.";
            } else {
                error = "Failed to remove member.";
            }
        } else if ("updateRole".equals(action)) {
            // Quick update security: Only President can use quick-update dropdown
            if (!"Pres".equals(currentUserPosition)) {
                error = "Unauthorized: Only the President can change roles.";
            } else if (memberDAO.updatePosition(clubId, targetUserId, position)) {
                message = "Role updated to " + position;
            } else {
                error = "Failed to update role.";
            }
        } else if ("edit".equals(action)) {
            String phone = request.getParameter("phone");

            // 1. Fetch current database data to compare before updating
            User existingData = memberDAO.getMemberById(targetUserId);

            if (existingData != null) {
                String oldPosition = existingData.getRole();
                String oldEmail = existingData.getEmail();

                // --- SECURITY CHECK 1: Position Change ---
                // If position in form is different from DB, check if logged-in user is President
                if (position != null && !position.equals(oldPosition)) {
                    if (!"Pres".equals(currentUserPosition)) {
                        request.setAttribute("error", "Unauthorized: Only the President can change member roles.");
                        doGet(request, response);
                        return;
                    }
                }

                // --- SECURITY CHECK 2: Email Change ---
                // Only allow editing email if the target user is the one currently logged in
                if (email != null && !email.equals(oldEmail)) {
                    if (!targetUserId.equals(currentUser.getUserId())) {
                        request.setAttribute("error", "Unauthorized: You can only update your own login email.");
                        doGet(request, response);
                        return;
                    }
                }

                // 2. If checks pass, proceed to update details
                if (memberDAO.updateMemberDetails(clubId, targetUserId, targetFullName, phone, position, email)) {
                    message = "Details for " + targetFullName + " updated successfully.";
                } else {
                    error = "Failed to update member details.";
                }
            } else {
                error = "Member not found.";
            }
        }

        if (!message.isEmpty()) {
            request.setAttribute("message", message);
        }
        if (!error.isEmpty()) {
            request.setAttribute("error", error);
        }

        doGet(request, response);
    }
}
