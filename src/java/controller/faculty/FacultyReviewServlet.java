package controller.faculty;

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

@WebServlet("/faculty/review")
public class FacultyReviewServlet extends HttpServlet {

    private final ProposalDAO dao = new ProposalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"Faculty".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String proposalIdStr = request.getParameter("id");

        if (proposalIdStr != null && !proposalIdStr.isEmpty()) {
            try {
                int proposalId = Integer.parseInt(proposalIdStr);

                // USE 3NF FETCH METHOD
                EventItem proposal = dao.getProposalById3NF(proposalId);

                if (proposal != null) {
                    request.setAttribute("p", proposal);
                    request.getRequestDispatcher("/WEB-INF/jsp/faculty/FacultyReview.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid Proposal ID format: " + proposalIdStr);
            }
        }
        request.getSession().setAttribute("errorMessage", "Proposal not found or invalid ID.");
        response.sendRedirect(request.getContextPath() + "/faculty/proposals");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"Faculty".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String action = request.getParameter("action");
        int proposalId = Integer.parseInt(request.getParameter("proposalId"));

        // USE 3NF FETCH METHOD
        EventItem p = dao.getProposalById3NF(proposalId);
        int clubId = p.getClubId();
        String pTitle = p.getTitle();

        // -------------------------------------------------------------
        // 1. ACTION: ALTER PROPOSAL (3NF UPGRADE)
        // -------------------------------------------------------------
        if ("alter".equals(action)) {
            try {
                String feedback = request.getParameter("alterFeedback");
                if (feedback == null || feedback.trim().isEmpty()) {
                    feedback = request.getParameter("feedback");
                }

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
                    ProposalTracker.logFacultyBudgetAlteration(user.getUserId(), proposalId, clubId, pTitle, newGrandTotal, feedback, trackerDiffString.toString());
                    request.getSession().setAttribute("successMessage", "Bajet berjaya diubah. Jumlah baru: RM " + String.format("%.2f", newGrandTotal));
                } else {
                    request.getSession().setAttribute("errorMessage", "Ralat Sistem: Gagal menyimpan perubahan bajet.");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "Ralat mengira bajet. Pastikan nombor sah.");
            }

            response.sendRedirect(request.getContextPath() + "/faculty/review?id=" + proposalId);
            return;

            // -------------------------------------------------------------
            // 2. REJECT PROPOSAL
            // -------------------------------------------------------------
        } else if ("reject".equals(action)) {
            String feedback = request.getParameter("rejectFeedback");
            dao.updateProposalStatus(proposalId, "Rejected", "Ditolak oleh Fakulti: " + feedback);
            ProposalTracker.logRejection(user.getUserId(), proposalId, clubId, pTitle, feedback, "Faculty", null);
            request.getSession().setAttribute("successMessage", "Kertas kerja telah ditolak.");

            // -------------------------------------------------------------
            // 3. ENDORSE TO HEPA
            // -------------------------------------------------------------
        } else if ("approve_hepa".equals(action)) {
            dao.updateProposalStatus(proposalId, "Pending_HEPA", "Disokong oleh Fakulti. Menunggu kelulusan akhir HEPA.");
            ProposalTracker.logFacultyEndorsement(user.getUserId(), proposalId, clubId, pTitle, null);
            request.getSession().setAttribute("successMessage", "Kertas kerja disokong dan dipanjangkan ke HEPA!");

            // -------------------------------------------------------------
            // 4. FINAL APPROVAL (BYPASS HEPA)
            // -------------------------------------------------------------
        } else if ("approve_final".equals(action)) {
            dao.updateProposalStatus(proposalId, "Approved", "Diluluskan sepenuhnya oleh Fakulti.");
            ProposalTracker.logFacultyFinalApproval(user.getUserId(), proposalId, clubId, pTitle);
            request.getSession().setAttribute("successMessage", "Kertas kerja telah mendapat Kelulusan Penuh (Final Approval)!");
        }

        response.sendRedirect(request.getContextPath() + "/faculty/proposals");
    }
}
