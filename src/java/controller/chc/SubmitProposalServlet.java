package controller.chc;

import dao.ProposalDAO;
import dao.AIEngineDAO;
import model.EventItem;
import model.ProposalBudget;
import model.ProposalCommittee;
import model.ProposalItinerary;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "SubmitProposalServlet", urlPatterns = {"/SubmitProposalServlet"})
public class SubmitProposalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"CHC".equals(user.getRole())) {
            response.sendRedirect("LoginServlet");
            return;
        }

        try {
            ProposalDAO dao = new ProposalDAO();
            int clubId = dao.getClubIdByUserId(user.getUserId());
            double remainingBudget = dao.getRemainingAnnualBudget(clubId);
            request.setAttribute("remainingBudget", remainingBudget);
        } catch (Exception e) {
            request.setAttribute("remainingBudget", 1000.00);
        }

        request.getRequestDispatcher("/WEB-INF/jsp/chc/SubmitProposal.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"CHC".equals(user.getRole())) {
            response.sendRedirect("LoginServlet");
            return;
        }

        try {
            ProposalDAO dao = new ProposalDAO();
            int realClubId = dao.getClubIdByUserId(user.getUserId());

            if (realClubId == -1) {
                session.setAttribute("errorMessage", "Error: You are not associated with any active club.");
                response.sendRedirect("ClubDashboardServlet");
                return;
            }

            // =================================================================================
            // 1. EXTRACT MAIN PROPOSAL DATA AND BUILD EVENTITEM
            // =================================================================================
            EventItem p = new EventItem();
            p.setClubId(realClubId);
            p.setCreatedBy(user.getUserId());
            p.setProposalType(request.getParameter("proposalType"));
            p.setTitle(request.getParameter("title"));
            p.setDescription(request.getParameter("description"));

            String proposedDateStr = request.getParameter("proposedDate");
            if (proposedDateStr != null && !proposedDateStr.trim().isEmpty()) {
                p.setProposedDate(java.sql.Date.valueOf(proposedDateStr));
            }

            String endDateStr = request.getParameter("endDate");
            if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                p.setEndDate(java.sql.Date.valueOf(endDateStr));
            }

            p.setVenue(request.getParameter("venue"));
            p.setTargetAudience(request.getParameter("targetAudience"));
            p.setParticipantOtherDesc(request.getParameter("participantOtherDesc"));
            p.setObjective(request.getParameter("objective"));
            p.setSdgImpact(request.getParameter("sdgImpact"));
            p.setSdgReason(request.getParameter("sdgReason"));

            p.setDuration(parseIntSafe(request.getParameter("duration")));
            p.setParticipantUmt(parseIntSafe(request.getParameter("participantUmt")));
            p.setParticipantStaff(parseIntSafe(request.getParameter("participantStaff")));
            p.setParticipantPublic(parseIntSafe(request.getParameter("participantPublic")));
            p.setEstimateParticipant(parseIntSafe(request.getParameter("estimateParticipant")));
            p.setEstimateBudget(parseDoubleSafe(request.getParameter("estimateBudget")));

            // Inside your Add/Save Proposal Controller (Before inserting into DB):
            double yuran = Double.parseDouble(request.getParameter("budgetYuran"));
            double ptj = Double.parseDouble(request.getParameter("budgetPtj"));
            double luar = Double.parseDouble(request.getParameter("budgetLuar"));

// Flatten into a clean parsable string: "Yuran_Val ||| Ptj_Val ||| Luar_Val"
            String compoundBudgetDetails = yuran + "|||" + ptj + "|||" + luar;
            p.setBudgetDetails(compoundBudgetDetails);

            // CATCH THE YES/NO CLUB FUNDING VALUE
            String isClubFundedStr = request.getParameter("isClubFunded");
            boolean isFunded = (isClubFundedStr == null || "true".equalsIgnoreCase(isClubFundedStr));
            p.setClubFunded(isFunded);

            // --- STATUS ROUTING LOGIC (UNTOUCHED) ---
            String actionType = request.getParameter("actionType");
            String currentStatus = request.getParameter("currentStatus");
            String proposalStatus = "Draft";

            if ("submit".equals(actionType)) {
                if ("Approved_Condition".equals(currentStatus)) {
                    proposalStatus = "Pending_HEPA";
                } else {
                    proposalStatus = "Pending_Advisor";
                }
            }
            p.setStatus(proposalStatus);

            // --- AI CONFLICT SCORE & SUGGESTION CALCULATION ---
            if ("Submitted".equalsIgnoreCase(proposalStatus) || "Pending_Advisor".equalsIgnoreCase(proposalStatus)) {
                AIEngineDAO aiEngine = new AIEngineDAO();

                // 1. Calculate the Score (UPDATED WITH p.isClubFunded())
                int conflictScore = aiEngine.calculateConflictScore(realClubId, proposedDateStr, p.getEstimateBudget(), p.getBudgetDetails(), p.getEstimateParticipant(), p.getDuration(), p.isClubFunded());
                p.setConflictScore(conflictScore);

                // 2. Generate the Detailed HTML Report (UPDATED WITH p.isClubFunded())
                String aiSuggestion = aiEngine.generateAIAssessment(realClubId, proposedDateStr, p.getDuration(), p.getEstimateParticipant(), p.getEstimateBudget(), p.getBudgetDetails(), p.isClubFunded());
                p.setAiSuggestion(aiSuggestion);

            } else {
                p.setConflictScore(0);
                p.setAiSuggestion("");
            }

            // =================================================================================
            // 2. EXTRACT 3NF ARRAYS AND POPULATE LISTS
            // =================================================================================
            // A. Budgets
            String[] itemNames = request.getParameterValues("itemName[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] unitPrices = request.getParameterValues("unitPrice[]");
            String[] totalPrices = request.getParameterValues("totalPrice[]");

            if (itemNames != null) {
                for (int i = 0; i < itemNames.length; i++) {
                    if (itemNames[i] != null && !itemNames[i].trim().isEmpty()) {
                        ProposalBudget b = new ProposalBudget();
                        b.setItemName(itemNames[i]);
                        b.setQuantity(parseIntSafe(quantities[i]));
                        b.setUnitPrice(parseDoubleSafe(unitPrices[i]));
                        b.setTotalPrice(parseDoubleSafe(totalPrices[i]));
                        p.getBudgets().add(b);
                    }
                }
            }

            // B. Committees
            String[] matricNos = request.getParameterValues("matricNo[]");
            String[] commNames = request.getParameterValues("commName[]");
            String[] roles = request.getParameterValues("role[]");

            if (matricNos != null) {
                for (int i = 0; i < matricNos.length; i++) {
                    if (matricNos[i] != null && !matricNos[i].trim().isEmpty()) {
                        ProposalCommittee c = new ProposalCommittee();
                        c.setMatricNo(matricNos[i]);
                        c.setName(commNames[i]);
                        c.setRole(roles[i]);
                        p.getCommittees().add(c);
                    }
                }
            }

            // C. Itineraries
            String[] days = request.getParameterValues("day[]");
            String[] times = request.getParameterValues("time[]");
            String[] activities = request.getParameterValues("activity[]");

            if (days != null) {
                for (int i = 0; i < days.length; i++) {
                    if (days[i] != null && !days[i].trim().isEmpty()) {
                        ProposalItinerary itin = new ProposalItinerary();
                        itin.setDay(days[i]);
                        itin.setTime(times[i]);
                        itin.setActivity(activities[i]);
                        p.getItineraries().add(itin);
                    }
                }
            }

            // =================================================================================
            // 3. EXECUTE DAO (INSERT OR UPDATE)
            // =================================================================================
            boolean isSuccess = false;
            int activeProposalId = -1;

            String isEditMode = request.getParameter("isEditMode");
            String proposalIdStr = request.getParameter("proposalId");

            if ("true".equals(isEditMode) && proposalIdStr != null && !proposalIdStr.isEmpty()) {
                activeProposalId = Integer.parseInt(proposalIdStr);
                p.setProposalId(activeProposalId);
                isSuccess = dao.updateProposal3NF(p);
            } else {
                isSuccess = dao.insertProposal3NF(p);
                if (isSuccess) {
                    activeProposalId = dao.getLatestProposalIdByClub(realClubId);
                }
            }

            // =================================================================================
            // 4. NOTIFICATION & TRACKER (UNTOUCHED)
            // =================================================================================
            if (isSuccess) {
                if ("draft".equals(actionType)) {
                    session.setAttribute("successMessage", "Draft successfully updated and saved.");
                } else {
                    session.setAttribute("successMessage", "Proposal submitted! Waiting for Advisor's approval.");

                    if (activeProposalId != -1) {
                        util.ProposalTracker.logSubmission(user.getUserId(), activeProposalId, realClubId, p.getTitle(), null);
                    }
                }
            } else {
                session.setAttribute("errorMessage", "System Error: Failed to process the proposal.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "System Error: Please ensure all data formats are correct.");
        }

        response.sendRedirect(request.getContextPath() + "/chc/events");
    }

    // Helper functions for safe parsing
    private int parseIntSafe(String val) {
        try {
            return (val != null && !val.isEmpty()) ? Integer.parseInt(val) : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private double parseDoubleSafe(String val) {
        try {
            return (val != null && !val.isEmpty()) ? Double.parseDouble(val) : 0.0;
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }
}
