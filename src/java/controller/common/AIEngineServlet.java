package controller;

import dao.AIEngineDAO;
import dao.ProposalDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AIEngineServlet", urlPatterns = {"/AIEngineAPI"})
public class AIEngineServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get inputs from the AJAX call
        String title = request.getParameter("title");
        if (title == null || title.isEmpty()) {
            title = "Untitled Program";
        }

        String date = request.getParameter("date");
        String durationStr = request.getParameter("duration");
        String paxStr = request.getParameter("pax");
        String budgetStr = request.getParameter("budget");

        String budgetDetails = request.getParameter("budgetDetails");
        if (budgetDetails == null) {
            budgetDetails = "";
        }

        String isClubFundedStr = request.getParameter("isClubFunded");
        boolean isClubFunded = true;
        if (isClubFundedStr != null && !isClubFundedStr.isEmpty()) {
            isClubFunded = Boolean.parseBoolean(isClubFundedStr);
        }

        response.setContentType("text/html;charset=UTF-8");

        if (date == null || date.isEmpty() || durationStr == null || durationStr.isEmpty()
                || paxStr == null || paxStr.isEmpty() || budgetStr == null || budgetStr.isEmpty()) {
            response.getWriter().write("<div class='text-center p-4'><i class='fas fa-keyboard fa-3x text-light mb-3'></i><p class='text-muted small mb-0'>Please fill in the <b>Date, Duration, Participants,</b> and <b>Budget</b> to start the AI analysis.</p></div>");
            return;
        }

        try {
            int duration = Integer.parseInt(durationStr);
            int pax = Integer.parseInt(paxStr);
            double budget = Double.parseDouble(budgetStr);

            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            int clubId = 0;
            if (user != null) {
                ProposalDAO pDao = new ProposalDAO();
                clubId = pDao.getClubIdByUserId(user.getUserId());
            }

            AIEngineDAO aiDao = new AIEngineDAO();

            // 1. Get the Heuristic Score and HTML
            int score = aiDao.calculateConflictScore(clubId, date, budget, budgetDetails, pax, duration, isClubFunded);
            String aiResult = aiDao.generateAIAssessment(clubId, date, duration, pax, budget, budgetDetails, isClubFunded);

            // 2. Ping the Dynamic Multi-LLM Router
            String[] aiResponse = aiDao.getDynamicAIFeedback(title, date, duration, pax, budget, budgetDetails, score);

            // Extract the Array Data
            String aiModelName = aiResponse[0]; // e.g., "Google Gemini" or "OpenAI GPT-3.5"
            String aiText = aiResponse[1];      // The actual feedback text

            // 3. Attach the Dynamic GPT box to the bottom
            String finalHtml = aiResult
                    + "<div class='mt-3 p-3 bg-white rounded border border-light shadow-sm'>"
                    + "<small class='text-primary fw-bold d-block mb-2'><i class='fas fa-sparkles me-1'></i> " + aiModelName + " Executive Summary:</small>"
                    + "<small class='text-secondary fst-italic'>\"" + aiText + "\"</small>"
                    + "</div>";

            response.getWriter().write(finalHtml);
        } catch (Exception e) {
            response.getWriter().write("<div class='alert alert-danger small border-0 shadow-sm'><i class='fas fa-times-circle me-2'></i>Error processing AI logic. Please check your inputs.</div>");
        }
    }
}
