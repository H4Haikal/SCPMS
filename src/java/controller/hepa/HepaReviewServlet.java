package controller.hepa;

import dao.ProposalDAO;
import model.EventItem;
import model.ProposalBudget;
import model.User;
import util.ProposalTracker;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/hepa/review")
public class HepaReviewServlet extends HttpServlet {

    private final ProposalDAO dao = new ProposalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"HEPA".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // SAFE ID CATCHER (Checks for both "id" and "proposalId")
        String proposalIdStr = request.getParameter("id");
        if (proposalIdStr == null || proposalIdStr.isEmpty()) {
            proposalIdStr = request.getParameter("proposalId");
        }

        if (proposalIdStr != null && !proposalIdStr.isEmpty()) {
            try {
                int proposalId = Integer.parseInt(proposalIdStr);

                // USE NEW 3NF METHOD
                EventItem proposal = dao.getProposalById3NF(proposalId);

                if (proposal != null) {
                    request.setAttribute("p", proposal);
                    request.getRequestDispatcher("/WEB-INF/jsp/hepa/HepaReview.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid ID: " + proposalIdStr);
            }
        }
        session.setAttribute("errorMessage", "Proposal not found.");
        response.sendRedirect(request.getContextPath() + "/hepa/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"HEPA".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String action = request.getParameter("action");

        // SAFE ID CATCHER
        String proposalIdStr = request.getParameter("proposalId");
        if (proposalIdStr == null || proposalIdStr.isEmpty()) {
            proposalIdStr = request.getParameter("id");
        }
        int proposalId = Integer.parseInt(proposalIdStr);

        // USE NEW 3NF METHOD
        EventItem p = dao.getProposalById3NF(proposalId);
        int clubId = p.getClubId();
        String pTitle = p.getTitle();

        // 1. ALTER BUDGET BY HEPA (3NF UPGRADE)
        if ("alter".equals(action)) {
            try {
                String feedback = request.getParameter("alterFeedback");
                String[] itemNames = request.getParameterValues("itemName[]");
                String[] itemQtys = request.getParameterValues("itemQty[]");
                String[] itemPrices = request.getParameterValues("itemPrice[]");

                List<ProposalBudget> newBudgets = new ArrayList<>();
                StringBuilder trackerDiffString = new StringBuilder();
                double newGrandTotal = 0.0;

                if (itemNames != null) {
                    for (int i = 0; i < itemNames.length; i++) {
                        String name = itemNames[i].trim();
                        if (name.isEmpty()) {
                            continue;
                        }

                        int qty = Integer.parseInt(itemQtys[i]);
                        double price = Double.parseDouble(itemPrices[i]);
                        double total = qty * price;
                        newGrandTotal += total;

                        // Add to 3NF List
                        newBudgets.add(new ProposalBudget(0, proposalId, name, qty, price, total));

                        // Append to flat string solely for the Tracker Diff Engine
                        trackerDiffString.append(name).append("|").append(qty).append("|")
                                .append(String.format("%.2f", price)).append("|")
                                .append(String.format("%.2f", total)).append("\r\n");
                    }
                }
                trackerDiffString.append("GRANDTOTAL| | |").append(String.format("%.2f", newGrandTotal));

                // CALL THE NEW 3NF DAO METHOD
                if (dao.alterProposalBudget3NF(proposalId, newGrandTotal, newBudgets)) {
                    ProposalTracker.logHepaBudgetAlteration(user.getUserId(), proposalId, clubId, pTitle, newGrandTotal, feedback, trackerDiffString.toString());
                    session.setAttribute("successMessage", "Final budget adjustments saved: RM " + String.format("%.2f", newGrandTotal));
                } else {
                    session.setAttribute("errorMessage", "Error saving budget.");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Invalid numbers in budget.");
            }
            response.sendRedirect(request.getContextPath() + "/hepa/review?id=" + proposalId);
            return;

            // 2. REJECT PROPOSAL
        } else if ("reject".equals(action)) {
            String feedback = request.getParameter("rejectFeedback");
            dao.updateProposalStatus(proposalId, "Rejected", "Rejected by HEPA: " + feedback);
            ProposalTracker.logRejection(user.getUserId(), proposalId, clubId, pTitle, feedback, "HEPA", null);
            session.setAttribute("successMessage", "Proposal has been officially rejected.");

            // 3. FINAL APPROVAL
        } else if ("approve".equals(action)) {
            dao.updateProposalStatus(proposalId, "Approved", "Official HEPA Approval Granted.");
            ProposalTracker.logHepaFinalApproval(user.getUserId(), proposalId, clubId, pTitle);
            session.setAttribute("successMessage", "Success! The proposal is fully approved. The official PDF is now ready.");
        }

        response.sendRedirect(request.getContextPath() + "/hepa/dashboard");
    }
}
