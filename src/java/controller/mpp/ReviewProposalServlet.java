package controller.mpp;

import dao.ProposalDAO;
import dao.MasterCalendarDAO;
import model.CalendarEvent;
import java.sql.Date;
import model.User;
import util.GoogleMeetUtil;
import util.ProposalTracker;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ReviewProposalServlet", urlPatterns = {"/mpp/proposals"})
public class ReviewProposalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"MPP".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        ProposalDAO dao = new ProposalDAO();
        List<Map<String, Object>> allProposals = dao.getAllProposals();

        request.setAttribute("proposals", allProposals);
        request.getRequestDispatcher("/WEB-INF/jsp/mpp/ReviewProposal.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"MPP".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String action = request.getParameter("action");
        int proposalId = Integer.parseInt(request.getParameter("proposalId"));

        ProposalDAO dao = new ProposalDAO();
        MasterCalendarDAO calendarDAO = new MasterCalendarDAO();

        model.EventItem p = dao.getProposalById3NF(proposalId);
        int clubId = p.getClubId();
        String pTitle = p.getTitle();

        // =============================================================
        // 1. ACTION: SCHEDULE PITCHING
        // =============================================================
        if ("schedule".equals(action)) {
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String meetingLink = request.getParameter("meetingLink");

            try {
                LocalDateTime parsedStart = LocalDateTime.parse(startTime);
                if (parsedStart.isBefore(LocalDateTime.now())) {
                    request.getSession().setAttribute("errorMessage", "Ralat: Tidak boleh tetapkan sesi pitching pada masa lalu!");
                    response.sendRedirect(request.getContextPath() + "/mpp/proposals");
                    return;
                }
                if (endTime == null || endTime.trim().isEmpty() || endTime.equals(startTime)) {
                    endTime = parsedStart.plusHours(1).toString();
                }
            } catch (Exception e) {
                System.err.println("Gagal parse masa: " + e.getMessage());
            }

            if (meetingLink == null || meetingLink.trim().isEmpty()) {
                try {
                    String formattedStart = startTime.length() == 16 ? startTime + ":00+08:00" : startTime + "+08:00";
                    String formattedEnd = endTime.length() == 16 ? endTime + ":00+08:00" : endTime + "+08:00";
                    meetingLink = GoogleMeetUtil.generateMeetLink("Sesi Pitching MPP: " + pTitle, formattedStart, formattedEnd);
                } catch (Exception e) {
                    System.err.println("Gagal jana Google Meet: " + e.getMessage());
                }
            }

            if (meetingLink != null && !meetingLink.isEmpty()) {
                if (dao.schedulePitching(proposalId, startTime, meetingLink)) {
                    ProposalTracker.logPitchingScheduled(user.getUserId(), proposalId, clubId, pTitle, startTime, meetingLink, null);

                    // --- SYNC WITH MASTER CALENDAR ---
                    if (startTime != null && startTime.length() >= 10) {
                        String dateOnly = startTime.substring(0, 10);
                        CalendarEvent event = new CalendarEvent();
                        event.setEventTitle("Pitching: " + p.getClubName());
                        event.setStartDate(Date.valueOf(dateOnly));
                        event.setEndDate(Date.valueOf(dateOnly));
                        event.setEventType("Others");
                        event.setDescription("Proposal: " + pTitle + "\nMeet Link: " + meetingLink);
                        calendarDAO.addEvent(event);
                    }
                    // ---------------------------------

                    request.getSession().setAttribute("successMessage", "Pitching set! Meeting link: " + meetingLink);
                } else {
                    request.getSession().setAttribute("errorMessage", "Gagal kemas kini database.");
                }
            } else {
                request.getSession().setAttribute("errorMessage", "Gagal jana link Google Meet. Token mungkin tamat tempoh. Sila semak konsol.");
            }

            // =============================================================
            // 2. ACTION: RESCHEDULE PITCHING
            // =============================================================
        } else if ("reschedule".equals(action)) {
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String meetingLink = request.getParameter("meetingLink");

            try {
                LocalDateTime parsedStart = LocalDateTime.parse(startTime);
                if (parsedStart.isBefore(LocalDateTime.now())) {
                    request.getSession().setAttribute("errorMessage", "Ralat: Tidak boleh ubah sesi pitching ke masa lalu!");
                    response.sendRedirect(request.getContextPath() + "/mpp/proposals");
                    return;
                }
                if (endTime == null || endTime.trim().isEmpty() || endTime.equals(startTime)) {
                    endTime = parsedStart.plusHours(1).toString();
                }
            } catch (Exception e) {
            }

            if (meetingLink == null || meetingLink.trim().isEmpty()) {
                try {
                    String formattedStart = startTime.length() == 16 ? startTime + ":00+08:00" : startTime + "+08:00";
                    String formattedEnd = endTime.length() == 16 ? endTime + ":00+08:00" : endTime + "+08:00";
                    meetingLink = GoogleMeetUtil.generateMeetLink("Pitching (Dikemaskini): " + pTitle, formattedStart, formattedEnd);
                } catch (Exception e) {
                }
            }

            if (meetingLink != null && !meetingLink.isEmpty()) {
                if (dao.schedulePitching(proposalId, startTime, meetingLink)) {
                    ProposalTracker.logPitchingScheduled(user.getUserId(), proposalId, clubId, pTitle, startTime, meetingLink, null);

                    // --- SYNC WITH MASTER CALENDAR ---
                    if (startTime != null && startTime.length() >= 10) {
                        String dateOnly = startTime.substring(0, 10);
                        CalendarEvent event = new CalendarEvent();
                        event.setEventTitle("Pitching (Dikemaskini): " + p.getClubName());
                        event.setStartDate(Date.valueOf(dateOnly));
                        event.setEndDate(Date.valueOf(dateOnly));
                        event.setEventType("Others");
                        event.setDescription("Proposal: " + pTitle + "\nMeet Link: " + meetingLink);
                        calendarDAO.addEvent(event);
                    }
                    // ---------------------------------

                    request.getSession().setAttribute("successMessage", "Tarikh pitching berjaya dikemaskini. Pautan baharu: " + meetingLink);
                } else {
                    request.getSession().setAttribute("errorMessage", "Gagal kemas kini database.");
                }
            } else {
                request.getSession().setAttribute("errorMessage", "Gagal jana link Google Meet.");
            }

            // =============================================================
            // 3. ACTION: ALTER PROPOSAL (3NF UPGRADE)
            // =============================================================
        } else if ("alter".equals(action)) {
            try {
                String feedback = request.getParameter("alterFeedback");
                if (feedback == null || feedback.trim().isEmpty()) {
                    feedback = request.getParameter("feedback");
                }

                String[] itemNames = request.getParameterValues("itemName[]");
                String[] itemQtys = request.getParameterValues("itemQty[]");
                String[] itemPrices = request.getParameterValues("itemPrice[]");

                java.util.List<model.ProposalBudget> newBudgets = new java.util.ArrayList<>();
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
                        newBudgets.add(new model.ProposalBudget(0, proposalId, name, qty, price, total));

                        // Append to flat string solely for the Tracker Diff Engine
                        trackerDiffString.append(name).append("|").append(qty).append("|")
                                .append(String.format("%.2f", price)).append("|")
                                .append(String.format("%.2f", total)).append("\r\n");
                    }
                }
                trackerDiffString.append("GRANDTOTAL| | |").append(String.format("%.2f", newGrandTotal));

                // CALL THE NEW 3NF DAO METHOD
                if (dao.alterProposalBudget3NF(proposalId, newGrandTotal, newBudgets)) {
                    ProposalTracker.logBudgetAlteration(user.getUserId(), proposalId, clubId, pTitle, newGrandTotal, "Altered by MPP: " + feedback, trackerDiffString.toString());
                    request.getSession().setAttribute("successMessage", "Budget successfully altered. New total is RM " + String.format("%.2f", newGrandTotal));
                } else {
                    request.getSession().setAttribute("errorMessage", "System Error: Failed to save alterations.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Error calculating new budget. Please ensure all numbers are valid.");
            }

            String referer = request.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/mpp/proposals");
            }
            return;

            // =============================================================
            // 4 & 5. ACTIONS: REJECT & APPROVE
            // =============================================================
        } else if ("reject".equals(action)) {
            String feedback = request.getParameter("rejectFeedback");
            if (feedback == null) {
                feedback = request.getParameter("feedback");
            }
            dao.updateProposalStatus(proposalId, "Rejected", "Ditolak oleh MPP: " + feedback);
            ProposalTracker.logRejection(user.getUserId(), proposalId, clubId, pTitle, feedback, "MPP", null);
            request.getSession().setAttribute("successMessage", "Proposal telah dikembalikan (Rejected).");

        } else if ("approve".equals(action)) {
            dao.updateProposalStatus(proposalId, "Pending_HEPA", "Disokong oleh MPP. Menunggu kelulusan akhir HEPA.");
            ProposalTracker.logMppEndorsement(user.getUserId(), proposalId, clubId, pTitle, null);
            request.getSession().setAttribute("successMessage", "Kertas kerja telah disokong dan dihantar ke pihak HEPA!");
        }

        response.sendRedirect(request.getContextPath() + "/mpp/proposals");
    }
}
