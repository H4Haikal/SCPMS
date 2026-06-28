package util;

import dao.AuditDAO;
import dao.NotificationDAO;

public class ProposalTracker {

    private static final AuditDAO aDao = new AuditDAO();
    private static final NotificationDAO notifDAO = new NotificationDAO();

    // ==========================================
    // 1. CHC SUBMITS PROPOSAL
    // ==========================================
    public static void logSubmission(String userId, int proposalId, int clubId, String pTitle, String advisorEmail) {
        aDao.logProposalEvent(userId, proposalId, "Proposal Submitted", "Draft finalized and submitted to Club Advisor.");
        notifDAO.createNotificationWithRole(clubId, "New Proposal Submitted", "Sila semak kertas kerja baharu: " + pTitle, "STATUS", "/advisor/pending", "Review Now", "Advisor");
        notifDAO.createNotificationWithRole(clubId, "Proposal Submitted", "Kertas kerja anda '" + pTitle + "' telah berjaya dihantar kepada Penasihat.", "STATUS", "/chc/track?id=" + proposalId, "Track Status", "CHC");
    }

    // ==========================================
    // 2. ADVISOR SUPPORTS PROPOSAL
    // ==========================================
    public static void logAdvisorSupport(String userId, int proposalId, int clubId, String pTitle, String nextRole, String notifyLink, String chcEmail) {
        aDao.logProposalEvent(userId, proposalId, "Advisor Supported", "Advisor verified and forwarded to " + nextRole + ".");
        notifDAO.createNotificationWithRole(clubId, "Proposal Supported", "Penasihat telah menyokong kertas kerja: " + pTitle, "STATUS", "/chc/track?id=" + proposalId, "Track Status", "CHC");
        // Gunakan notifyLink yang betul (pastikan notifyLink dari servlet adalah /hepa/review?id=X atau /mpp/review?id=X)
        notifDAO.createNotificationWithRole(clubId, "Pending " + nextRole + " Review", "Satu kertas kerja baharu memerlukan semakan anda.", "STATUS", notifyLink, "Review Now", nextRole);
    }

    // ==========================================
    // 3. REJECTED
    // ==========================================
    public static void logRejection(String userId, int proposalId, int clubId, String pTitle, String feedback, String roleRejecting, String chcEmail) {
        aDao.logProposalEvent(userId, proposalId, "Proposal Rejected", roleRejecting + " returned the proposal. Reason: " + feedback);
        notifDAO.createNotificationWithRole(clubId, "Proposal Requires Amendment", "Kertas kerja '" + pTitle + "' dikembalikan oleh " + roleRejecting + ".\nUlasan: " + feedback, "STATUS", "/chc/track?id=" + proposalId, "View Feedback", "CHC");
    }

    // ==========================================
    // 4. MPP SCHEDULES PITCHING
    // ==========================================
    public static void logPitchingScheduled(String userId, int proposalId, int clubId, String pTitle, String startTime, String meetingLink, String chcEmail) {
        aDao.logProposalEvent(userId, proposalId, "Pitching Scheduled", "Meeting set for " + startTime.replace("T", " ") + ".");
        notifDAO.createNotificationWithRole(clubId, "Pitching Scheduled", "Sesi pembentangan (Pitching) bagi kertas kerja '" + pTitle + "' telah dijadualkan pada: " + startTime.replace("T", " "), "STATUS", "/chc/track?id=" + proposalId, "View Link", "CHC");
    }

    // ==========================================
    // 5. MPP ALTERS BUDGET (WITH SNAPSHOT)
    // ==========================================
    public static void logBudgetAlteration(String userId, int proposalId, int clubId, String pTitle, double newTotal, String feedback, String budgetDetails) {
        String safeFeedback = (feedback != null && !feedback.trim().isEmpty()) ? feedback : "Penyelarasan bajet dibuat oleh pihak MPP.";
        String desc = "MPP telah menyunting jadual bajet kepada RM " + String.format("%.2f", newTotal) + ".\nSebab: " + safeFeedback + "^" + budgetDetails;

        aDao.logProposalEvent(userId, proposalId, "Budget Altered (MPP)", desc);
        notifDAO.createNotificationWithRole(clubId, "Bajet Proposal Diubah", "MPP telah menyunting jadual bajet untuk '" + pTitle + "'.", "STATUS", "/chc/track?id=" + proposalId, "Semak", "CHC");
    }

    // ==========================================
    // 6. MPP ENDORSES TO HEPA (Fixed URL)
    // ==========================================
    public static void logMppEndorsement(String userId, int proposalId, int clubId, String pTitle, String chcEmail) {
        aDao.logProposalEvent(userId, proposalId, "MPP Endorsed", "MPP endorsed the proposal and forwarded to HEPA.");
        notifDAO.createNotificationWithRole(clubId, "MPP Endorsed", "MPP telah memperakui kertas kerja. Menunggu kelulusan HEPA.", "STATUS", "/chc/track?id=" + proposalId, "Track Status", "CHC");
        // FIX: Tukar ke /hepa/review?id=
        notifDAO.createNotificationWithRole(clubId, "Pending HEPA Approval", "Satu kertas kerja baharu menunggu kelulusan akhir.", "STATUS", "/hepa/review?id=" + proposalId, "Review Now", "HEPA");
    }

    // ==========================================
    // 8. FACULTY ENDORSES TO HEPA (Fixed URL)
    // ==========================================
    public static void logFacultyEndorsement(String userId, int proposalId, int clubId, String pTitle, String chcEmail) {
        aDao.logProposalEvent(userId, proposalId, "Faculty Endorsed", "Fakulti menyokong kertas kerja ini kepada HEPA.");
        notifDAO.createNotificationWithRole(clubId, "Fakulti Endorsed", "Fakulti memperakui kertas kerja. Menunggu kelulusan HEPA.", "STATUS", "/chc/track?id=" + proposalId, "Track Status", "CHC");
        // FIX: Tukar ke /hepa/review?id=
        notifDAO.createNotificationWithRole(clubId, "Pending HEPA Approval", "Satu kertas kerja Akademik menunggu kelulusan akhir.", "STATUS", "/hepa/review?id=" + proposalId, "Review Now", "HEPA");
    }

    // ==========================================
    // 9. FACULTY FINAL APPROVAL (BYPASS HEPA)
    // ==========================================
    public static void logFacultyFinalApproval(String userId, int proposalId, int clubId, String pTitle) {
        aDao.logProposalEvent(userId, proposalId, "Approved by Faculty", "Kelulusan penuh diberikan oleh Fakulti.");
        notifDAO.createNotificationWithRole(clubId, "Kertas Kerja Diluluskan!", "Tahniah! Fakulti telah meluluskan sepenuhnya kertas kerja '" + pTitle + "'.", "STATUS", "/chc/track?id=" + proposalId, "Lihat", "CHC");
        notifDAO.createNotificationWithRole(clubId, "Kertas Kerja Kelab Diluluskan", "Fakulti telah meluluskan kertas kerja kelab seliaan anda.", "STATUS", "/advisor/dashboard", "Lihat", "Advisor");
    }

    // ==========================================
    // 10. FACULTY ALTERS BUDGET (WITH SNAPSHOT)
    // ==========================================
    public static void logFacultyBudgetAlteration(String userId, int proposalId, int clubId, String pTitle, double newTotal, String feedback, String budgetDetails) {
        String safeFeedback = (feedback != null && !feedback.trim().isEmpty()) ? feedback : "Penyelarasan bajet dibuat oleh pihak Fakulti.";
        String desc = "Fakulti telah menukar bajet kertas kerja kepada RM " + String.format("%.2f", newTotal) + ".\nSebab: " + safeFeedback + "^" + budgetDetails;

        aDao.logProposalEvent(userId, proposalId, "Budget Altered (Faculty)", desc);
        notifDAO.createNotificationWithRole(clubId, "Bajet Diubah oleh Fakulti", "Fakulti telah menukar bajet untuk '" + pTitle + "'.", "STATUS", "/chc/track?id=" + proposalId, "Semak", "CHC");
    }

    // ==========================================
    // 11. HEPA FINAL APPROVAL
    // ==========================================
    public static void logHepaFinalApproval(String userId, int proposalId, int clubId, String pTitle) {
        aDao.logProposalEvent(userId, proposalId, "Approved by HEPA", "Tahniah! HEPA telah meluluskan kertas kerja ini secara rasmi.");
        notifDAO.createNotificationWithRole(clubId, "Kertas Kerja Diluluskan Penuh!", "Tahniah! Kertas kerja '" + pTitle + "' diluluskan akhir oleh HEPA.", "STATUS", "/chc/track?id=" + proposalId, "Lihat", "CHC");
        notifDAO.createNotificationWithRole(clubId, "Kelulusan Akhir HEPA", "Kertas kerja kelab seliaan anda telah diluluskan sepenuhnya.", "STATUS", "/advisor/dashboard", "Lihat", "Advisor");
    }

    // ==========================================
    // 12. HEPA ALTERS BUDGET (WITH SNAPSHOT)
    // ==========================================
    public static void logHepaBudgetAlteration(String userId, int proposalId, int clubId, String pTitle, double newTotal, String feedback, String budgetDetails) {
        String safeFeedback = (feedback != null && !feedback.trim().isEmpty()) ? feedback : "Pemotongan bajet muktamad dibuat oleh pihak HEPA.";
        String desc = "Pihak HEPA telah mengubah bajet akhir kepada RM " + String.format("%.2f", newTotal) + ".\nAlasan: " + safeFeedback + "^" + budgetDetails;

        aDao.logProposalEvent(userId, proposalId, "Budget Altered (HEPA)", desc);
        notifDAO.createNotificationWithRole(clubId, "Semakan Bajet HEPA", "Pihak HEPA telah mengubah bajet untuk '" + pTitle + "'.", "STATUS", "/chc/track?id=" + proposalId, "Semak", "CHC");
    }
}
