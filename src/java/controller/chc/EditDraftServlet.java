package controller.chc;

import dao.ProposalDAO;
import model.EventItem;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "EditDraftServlet", urlPatterns = {"/EditDraftServlet"})
public class EditDraftServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Security check
        if (user == null || !"CHC".equals(user.getRole())) {
            response.sendRedirect("LoginServlet");
            return;
        }

        try {
            int proposalId = Integer.parseInt(request.getParameter("id"));
            ProposalDAO dao = new ProposalDAO();

            // Fetch the fully built 3NF Object (Includes the Budget, Committee, and Itinerary Lists)
            EventItem draft = dao.getProposalById3NF(proposalId);

            if (draft != null) {
                // NEW: Calculate the remaining budget for this specific club
                double remainingBudget = dao.getRemainingAnnualBudget(draft.getClubId());
                request.setAttribute("remainingBudget", remainingBudget);

                // Send the object to the JSP
                request.setAttribute("draft", draft);
                request.setAttribute("isEditMode", true);
                request.getRequestDispatcher("/WEB-INF/jsp/chc/SubmitProposal.jsp").forward(request, response);

            } else {
                session.setAttribute("errorMessage", "Draft not found or has been deleted.");
                response.sendRedirect(request.getContextPath() + "/chc/events");
            }

        } catch (NumberFormatException e) {
            System.out.println("Invalid ID Format in EditDraftServlet.");
            session.setAttribute("errorMessage", "Invalid Proposal ID.");
            response.sendRedirect(request.getContextPath() + "/chc/events");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "System Error occurred while opening the draft.");
            response.sendRedirect(request.getContextPath() + "/chc/events");
        }
    }
}
