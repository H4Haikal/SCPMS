package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import util.DBConnection;
import model.EventItem;
import model.ProposalBudget;
import model.ProposalCommittee;
import model.ProposalItinerary;
import java.sql.Statement;

public class ProposalDAO {

    private AIEngineDAO aiEngine = new AIEngineDAO();

    // --------------------------------------------------------
    // NEW 3NF FUNCTION: SAVE PROPOSAL WITH TRANSACTION
    // --------------------------------------------------------
    public boolean insertProposal3NF(EventItem p) {
        String sqlMain = "INSERT INTO eventproposal (clubId, createdBy, proposalType, title, description, proposedDate, endDate, duration, "
                + "participantUmt, participantStaff, participantPublic, participantOtherDesc, estimateParticipant, estimateBudget, "
                + "conflictScore, aiSuggestion, venue, targetAudience, Status, objective, sdgImpact, sdgReason, budgetDetails, isClubFunded) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // START TRANSACTION

            // 1. Insert Main Proposal
            int generatedProposalId = -1;
            try (PreparedStatement psMain = conn.prepareStatement(sqlMain, Statement.RETURN_GENERATED_KEYS)) {
                psMain.setInt(1, p.getClubId());
                psMain.setString(2, p.getCreatedBy());
                psMain.setString(3, p.getProposalType());
                psMain.setString(4, p.getTitle());
                psMain.setString(5, p.getDescription());
                psMain.setDate(6, p.getProposedDate() != null ? new java.sql.Date(p.getProposedDate().getTime()) : null);
                psMain.setDate(7, p.getEndDate() != null ? new java.sql.Date(p.getEndDate().getTime()) : null);
                psMain.setInt(8, p.getDuration());
                psMain.setInt(9, p.getParticipantUmt());
                psMain.setInt(10, p.getParticipantStaff());
                psMain.setInt(11, p.getParticipantPublic());
                psMain.setString(12, p.getParticipantOtherDesc());
                psMain.setInt(13, p.getEstimateParticipant());
                psMain.setDouble(14, p.getEstimateBudget());
                psMain.setObject(15, p.getConflictScore());
                psMain.setString(16, p.getAiSuggestion());
                psMain.setString(17, p.getVenue());
                psMain.setString(18, p.getTargetAudience());
                psMain.setString(19, p.getStatus());
                psMain.setString(20, p.getObjective());
                psMain.setString(21, p.getSdgImpact());
                psMain.setString(22, p.getSdgReason());
                psMain.setString(23, p.getBudgetDetails());
                psMain.setBoolean(24, p.isClubFunded()); // SAVES THE YES/NO HERE

                psMain.executeUpdate();

                try (ResultSet rsKeys = psMain.getGeneratedKeys()) {
                    if (rsKeys.next()) {
                        generatedProposalId = rsKeys.getInt(1);
                    } else {
                        throw new SQLException("Failed to get generated Proposal ID.");
                    }
                }
            }

            // 2. Insert Budgets
            if (p.getBudgets() != null && !p.getBudgets().isEmpty()) {
                String sqlBudget = "INSERT INTO proposal_budgets (proposalId, itemName, quantity, unitPrice, totalPrice) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement psB = conn.prepareStatement(sqlBudget)) {
                    for (ProposalBudget b : p.getBudgets()) {
                        psB.setInt(1, generatedProposalId);
                        psB.setString(2, b.getItemName());
                        psB.setInt(3, b.getQuantity());
                        psB.setDouble(4, b.getUnitPrice());
                        psB.setDouble(5, b.getTotalPrice());
                        psB.addBatch();
                    }
                    psB.executeBatch();
                }
            }

            // 3. Insert Committees
            if (p.getCommittees() != null && !p.getCommittees().isEmpty()) {
                String sqlComm = "INSERT INTO proposal_committees (proposalId, matricNo, name, role) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psC = conn.prepareStatement(sqlComm)) {
                    for (ProposalCommittee c : p.getCommittees()) {
                        psC.setInt(1, generatedProposalId);
                        psC.setString(2, c.getMatricNo());
                        psC.setString(3, c.getName());
                        psC.setString(4, c.getRole());
                        psC.addBatch();
                    }
                    psC.executeBatch();
                }
            }

            // 4. Insert Itineraries
            if (p.getItineraries() != null && !p.getItineraries().isEmpty()) {
                String sqlItin = "INSERT INTO proposal_itineraries (proposalId, day, time, activity) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psI = conn.prepareStatement(sqlItin)) {
                    for (ProposalItinerary i : p.getItineraries()) {
                        psI.setInt(1, generatedProposalId);
                        psI.setString(2, i.getDay());
                        psI.setString(3, i.getTime());
                        psI.setString(4, i.getActivity());
                        psI.addBatch();
                    }
                    psI.executeBatch();
                }
            }

            conn.commit(); // SAVE EVERYTHING!
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public int getClubIdByUserId(String userId) {
        String sql = "SELECT clubId FROM club_memberships WHERE userId = ? AND isActive = 1 LIMIT 1";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("clubId");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Map<String, Object>> getProposalsByClub(int clubId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM eventproposal WHERE clubId = ? ORDER BY proposalId DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("proposalId", rs.getInt("proposalId"));
                    map.put("title", rs.getString("title"));
                    map.put("updatedAt", rs.getTimestamp("updatedAt"));
                    map.put("budget", rs.getDouble("estimateBudget"));
                    map.put("status", rs.getString("Status"));
                    map.put("createdAt", rs.getTimestamp("createdAt"));

                    String feedback = rs.getString("feedback");
                    map.put("feedback", feedback != null ? feedback : "");

                    map.put("pitchingDate", rs.getTimestamp("pitchingDate"));
                    map.put("pitchingLocation", rs.getString("pitchingLocation"));

                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --------------------------------------------------------
    // NEW 3NF FUNCTION: UPDATE EXISTING PROPOSAL (DRAFTS)
    // --------------------------------------------------------
    public boolean updateProposal3NF(EventItem p) {
        String sqlMain = "UPDATE eventproposal SET proposalType=?, title=?, description=?, proposedDate=?, endDate=?, duration=?, "
                + "participantUmt=?, participantStaff=?, participantPublic=?, participantOtherDesc=?, estimateParticipant=?, "
                + "estimateBudget=?, venue=?, targetAudience=?, Status=?, objective=?, sdgImpact=?, sdgReason=?, conflictScore=?, aiSuggestion=?, budgetDetails=?, isClubFunded=? "
                + "WHERE proposalId=?";

        Connection conn = null;
        try {
            conn = util.DBConnection.getConnection();
            conn.setAutoCommit(false); // START TRANSACTION

            // 1. Update Main Proposal
            try (PreparedStatement psMain = conn.prepareStatement(sqlMain)) {
                psMain.setString(1, p.getProposalType());
                psMain.setString(2, p.getTitle());
                psMain.setString(3, p.getDescription());
                psMain.setDate(4, p.getProposedDate() != null ? new java.sql.Date(p.getProposedDate().getTime()) : null);
                psMain.setDate(5, p.getEndDate() != null ? new java.sql.Date(p.getEndDate().getTime()) : null);
                psMain.setInt(6, p.getDuration());
                psMain.setInt(7, p.getParticipantUmt());
                psMain.setInt(8, p.getParticipantStaff());
                psMain.setInt(9, p.getParticipantPublic());
                psMain.setString(10, p.getParticipantOtherDesc());
                psMain.setInt(11, p.getEstimateParticipant());
                psMain.setDouble(12, p.getEstimateBudget());
                psMain.setString(13, p.getVenue());
                psMain.setString(14, p.getTargetAudience());
                psMain.setString(15, p.getStatus());
                psMain.setString(16, p.getObjective());
                psMain.setString(17, p.getSdgImpact());
                psMain.setString(18, p.getSdgReason());
                psMain.setObject(19, p.getConflictScore());
                psMain.setString(20, p.getAiSuggestion());
                psMain.setString(21, p.getBudgetDetails());
                psMain.setBoolean(22, p.isClubFunded());

                psMain.setInt(23, p.getProposalId());

                psMain.executeUpdate();
            }

            // 2. CLEAR OLD LISTS (Safest way to handle dynamically removed rows)
            try (Statement stmt = conn.createStatement()) {
                stmt.addBatch("DELETE FROM proposal_budgets WHERE proposalId = " + p.getProposalId());
                stmt.addBatch("DELETE FROM proposal_committees WHERE proposalId = " + p.getProposalId());
                stmt.addBatch("DELETE FROM proposal_itineraries WHERE proposalId = " + p.getProposalId());
                stmt.executeBatch();
            }

            // 3. Insert New Budgets
            if (p.getBudgets() != null && !p.getBudgets().isEmpty()) {
                String sqlBudget = "INSERT INTO proposal_budgets (proposalId, itemName, quantity, unitPrice, totalPrice) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement psB = conn.prepareStatement(sqlBudget)) {
                    for (ProposalBudget b : p.getBudgets()) {
                        psB.setInt(1, p.getProposalId());
                        psB.setString(2, b.getItemName());
                        psB.setInt(3, b.getQuantity());
                        psB.setDouble(4, b.getUnitPrice());
                        psB.setDouble(5, b.getTotalPrice());
                        psB.addBatch();
                    }
                    psB.executeBatch();
                }
            }

            // 4. Insert New Committees
            if (p.getCommittees() != null && !p.getCommittees().isEmpty()) {
                String sqlComm = "INSERT INTO proposal_committees (proposalId, matricNo, name, role) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psC = conn.prepareStatement(sqlComm)) {
                    for (ProposalCommittee c : p.getCommittees()) {
                        psC.setInt(1, p.getProposalId());
                        psC.setString(2, c.getMatricNo());
                        psC.setString(3, c.getName());
                        psC.setString(4, c.getRole());
                        psC.addBatch();
                    }
                    psC.executeBatch();
                }
            }

            // 5. Insert New Itineraries
            if (p.getItineraries() != null && !p.getItineraries().isEmpty()) {
                String sqlItin = "INSERT INTO proposal_itineraries (proposalId, day, time, activity) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psI = conn.prepareStatement(sqlItin)) {
                    for (ProposalItinerary i : p.getItineraries()) {
                        psI.setInt(1, p.getProposalId());
                        psI.setString(2, i.getDay());
                        psI.setString(3, i.getTime());
                        psI.setString(4, i.getActivity());
                        psI.addBatch();
                    }
                    psI.executeBatch();
                }
            }

            conn.commit(); // SAVE EVERYTHING!
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } // UNDO ON FAIL
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public boolean cancelProposal(int proposalId, int clubId) {
        String sql = "UPDATE eventproposal SET Status = 'Cancelled' WHERE proposalId = ? AND clubId = ? AND (Status = 'submitted' OR Status = 'Submitted')";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, proposalId);
            ps.setInt(2, clubId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getAllProposals() {
        List<Map<String, Object>> proposals = new ArrayList<>();

        String sql = "SELECT p.*, c.clubName, u.fullName, u.email "
                + "FROM eventproposal p "
                + "JOIN clubs c ON p.clubId = c.clubId "
                + "LEFT JOIN `user` u ON p.createdBy = u.userId "
                + "WHERE p.Status IN ('Pending_MPP', 'Meeting_Scheduled', 'Approved', 'Rejected', 'Pending_Hepa') "
                + "ORDER BY p.createdAt DESC";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql); java.sql.ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("proposalId", rs.getInt("proposalId"));
                map.put("clubId", rs.getInt("clubId"));
                map.put("feedback", rs.getString("feedback"));
                map.put("clubName", rs.getString("clubName"));
                map.put("title", rs.getString("title"));
                map.put("proposedDate", rs.getDate("proposedDate"));
                map.put("budget", rs.getDouble("estimateBudget"));
                map.put("status", rs.getString("Status"));
                map.put("conflictScore", rs.getInt("conflictScore"));
                map.put("pitchingDate", rs.getTimestamp("pitchingDate"));
                map.put("pitchingLocation", rs.getString("pitchingLocation"));
                // Add these inside your while (rs.next()) loop:
                map.put("createdAt", rs.getTimestamp("createdAt"));
                map.put("updatedAt", rs.getTimestamp("updatedAt"));

                String fullName = rs.getString("fullName");
                String email = rs.getString("email");
                map.put("creatorName", fullName != null ? fullName : "Club Rep");
                map.put("creatorEmail", email != null ? email : "No Email");
                map.put("venue", rs.getString("venue"));
                map.put("targetAudience", rs.getString("targetAudience"));

                String dateStr = rs.getString("proposedDate");
                int duration = rs.getInt("duration");
                int pax = rs.getInt("estimateParticipant");
                double budget = rs.getDouble("estimateBudget");
                int clubId = rs.getInt("clubId");
                boolean isClubFunded = rs.getBoolean("isClubFunded");

                String aiReport = aiEngine.generateAIAssessment(clubId, dateStr, duration, pax, budget, "", isClubFunded);
                map.put("aiSuggestion", aiReport);

                proposals.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return proposals;
    }

    public Map<String, Object> getProposalById(int proposalId) {
        Map<String, Object> map = new java.util.HashMap<>();

        String sql = "SELECT p.*, c.clubName, c.category, "
                + "u_student.fullName AS studentName, "
                + "u_advisor.fullName AS advisorName "
                + "FROM eventproposal p "
                + "JOIN clubs c ON p.clubId = c.clubId "
                + "LEFT JOIN user u_student ON p.createdBy = u_student.userId "
                + "LEFT JOIN user u_advisor ON c.advisorId = u_advisor.userId "
                + "WHERE p.proposalId = ?";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, proposalId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    map.put("proposalId", rs.getInt("proposalId"));
                    map.put("clubId", rs.getInt("clubId"));
                    map.put("proposalType", rs.getString("proposalType")); // NEW
                    map.put("title", rs.getString("title"));
                    map.put("description", rs.getString("description"));
                    map.put("budget", rs.getDouble("estimateBudget"));
                    map.put("status", rs.getString("Status"));

                    map.put("proposedDate", rs.getDate("proposedDate"));
                    map.put("endDate", rs.getDate("endDate")); // NEW
                    map.put("duration", rs.getInt("duration"));

                    map.put("participantUmt", rs.getInt("participantUmt"));       // NEW
                    map.put("participantStaff", rs.getInt("participantStaff"));   // NEW
                    map.put("participantPublic", rs.getInt("participantPublic")); // NEW
                    map.put("estimateParticipant", rs.getInt("estimateParticipant"));

                    map.put("venue", rs.getString("venue"));
                    map.put("targetAudience", rs.getString("targetAudience"));
                    map.put("clubName", rs.getString("clubName"));
                    map.put("feedback", rs.getString("feedback"));
                    map.put("pitchingDate", rs.getTimestamp("pitchingDate"));
                    map.put("pitchingLocation", rs.getString("pitchingLocation"));
                    map.put("conflictScore", rs.getInt("conflictScore"));
                    map.put("hepaRemark", rs.getString("hepaRemark"));
                    String studentName = rs.getString("studentName");
                    String advisorName = rs.getString("advisorName");
                    map.put("studentName", (studentName != null) ? studentName : "PENGARAH PROGRAM");
                    map.put("advisorName", (advisorName != null) ? advisorName : "PENASIHAT KELAB");

                    map.put("objective", rs.getString("objective"));
                    map.put("sdgImpact", rs.getString("sdgImpact"));
                    map.put("sdgReason", rs.getString("sdgReason"));
                    map.put("tentative", rs.getString("tentative"));
                    map.put("committee", rs.getString("committee"));
                    map.put("budgetDetails", rs.getString("budgetDetails"));
                    map.put("eriskFile", rs.getString("eriskFile"));
                    map.put("mppMinutesFile", rs.getString("mppMinutesFile"));
                    map.put("isBudgetAltered", rs.getBoolean("isBudgetAltered"));
                    map.put("originalBudgetDetails", rs.getString("originalBudgetDetails"));

                    String dateStr = (map.get("proposedDate") != null) ? map.get("proposedDate").toString() : null;
                    int durationVal = (int) map.get("duration");
                    int paxVal = (int) map.get("estimateParticipant");
                    double budgetVal = (double) map.get("budget");
                    int currentClubId = (int) map.get("clubId");
                    boolean isClubFunded = rs.getBoolean("isClubFunded");

                    if (dateStr != null) {
                        String aiReport = aiEngine.generateAIAssessment(currentClubId, dateStr, durationVal, paxVal, budgetVal, "", isClubFunded);
                        map.put("aiSuggestion", aiReport);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // --------------------------------------------------------
    // NEW 3NF FUNCTION: FETCH PROPOSAL AND ALL ITS LISTS
    // --------------------------------------------------------
    public EventItem getProposalById3NF(int proposalId) {
        EventItem p = null;
        String sqlMain = "SELECT p.*, c.clubName, c.category AS clubCategory, u.fullName AS studentName "
                + "FROM eventproposal p "
                + "JOIN clubs c ON p.clubId = c.clubId "
                + "LEFT JOIN user u ON p.createdBy = u.userId "
                + "WHERE p.proposalId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlMain)) {
            ps.setInt(1, proposalId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new EventItem();
                    p.setProposalId(rs.getInt("proposalId"));
                    p.setClubId(rs.getInt("clubId"));
                    p.setClubName(rs.getString("clubName"));
                    p.setClubCategory(rs.getString("clubCategory"));
                    p.setCreatedBy(rs.getString("studentName"));
                    p.setProposalType(rs.getString("proposalType"));
                    p.setTitle(rs.getString("title"));
                    p.setDescription(rs.getString("description"));
                    p.setProposedDate(rs.getDate("proposedDate"));
                    p.setEndDate(rs.getDate("endDate"));
                    p.setDuration(rs.getInt("duration"));
                    p.setParticipantUmt(rs.getInt("participantUmt"));
                    p.setParticipantStaff(rs.getInt("participantStaff"));
                    p.setParticipantPublic(rs.getInt("participantPublic"));
                    p.setParticipantOtherDesc(rs.getString("participantOtherDesc"));
                    p.setEstimateParticipant(rs.getInt("estimateParticipant"));
                    p.setEstimateBudget(rs.getDouble("estimateBudget"));
                    p.setVenue(rs.getString("venue"));
                    p.setTargetAudience(rs.getString("targetAudience"));
                    p.setStatus(rs.getString("Status"));
                    p.setObjective(rs.getString("objective"));
                    p.setSdgImpact(rs.getString("sdgImpact"));
                    p.setSdgReason(rs.getString("sdgReason"));
                    p.setConflictScore(rs.getInt("conflictScore"));
                    p.setAiSuggestion(rs.getString("aiSuggestion"));
                    p.setBudgetAltered(rs.getBoolean("budgetAltered"));
                    p.setEriskFile(rs.getString("eriskFile"));
                    p.setMppMinutesFile(rs.getString("mppMinutesFile"));
                    p.setHepaRemark(rs.getString("hepaRemark"));
                    p.setBudgetDetails(rs.getString("budgetDetails"));
                    p.setClubFunded(rs.getBoolean("isClubFunded"));

                    // Fetch Budgets
                    String sqlB = "SELECT * FROM proposal_budgets WHERE proposalId = ?";
                    try (PreparedStatement psB = conn.prepareStatement(sqlB)) {
                        psB.setInt(1, proposalId);
                        try (ResultSet rsB = psB.executeQuery()) {
                            while (rsB.next()) {
                                p.getBudgets().add(new ProposalBudget(
                                        rsB.getInt("budgetId"), rsB.getInt("proposalId"), rsB.getString("itemName"),
                                        rsB.getInt("quantity"), rsB.getDouble("unitPrice"), rsB.getDouble("totalPrice")
                                ));
                            }
                        }
                    }

                    // Fetch Committees
                    String sqlC = "SELECT * FROM proposal_committees WHERE proposalId = ?";
                    try (PreparedStatement psC = conn.prepareStatement(sqlC)) {
                        psC.setInt(1, proposalId);
                        try (ResultSet rsC = psC.executeQuery()) {
                            while (rsC.next()) {
                                p.getCommittees().add(new ProposalCommittee(
                                        rsC.getInt("committeeId"), rsC.getInt("proposalId"), rsC.getString("matricNo"),
                                        rsC.getString("name"), rsC.getString("role")
                                ));
                            }
                        }
                    }

                    // Fetch Itineraries
                    String sqlI = "SELECT * FROM proposal_itineraries WHERE proposalId = ?";
                    try (PreparedStatement psI = conn.prepareStatement(sqlI)) {
                        psI.setInt(1, proposalId);
                        try (ResultSet rsI = psI.executeQuery()) {
                            while (rsI.next()) {
                                p.getItineraries().add(new ProposalItinerary(
                                        rsI.getInt("itineraryId"), rsI.getInt("proposalId"), rsI.getString("day"),
                                        rsI.getString("time"), rsI.getString("activity")
                                ));
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    // --------------------------------------------------------
    // ALTER BUDGET (3NF UPGRADE)
    // --------------------------------------------------------
    public boolean alterProposalBudget3NF(int proposalId, double newGrandTotal, java.util.List<model.ProposalBudget> newBudgets) {
        Connection conn = null;
        try {
            conn = util.DBConnection.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // 1. Update main eventproposal table (Update estimateBudget and flag budgetAltered)
            String sqlUpdate = "UPDATE eventproposal SET estimateBudget = ?, budgetAltered = 1 WHERE proposalId = ?";
            try (PreparedStatement psUp = conn.prepareStatement(sqlUpdate)) {
                psUp.setDouble(1, newGrandTotal);
                psUp.setInt(2, proposalId);
                psUp.executeUpdate();
            }

            // 2. Wipe the old budget items
            String sqlDel = "DELETE FROM proposal_budgets WHERE proposalId = ?";
            try (PreparedStatement psDel = conn.prepareStatement(sqlDel)) {
                psDel.setInt(1, proposalId);
                psDel.executeUpdate();
            }

            // 3. Insert the newly altered budget items
            String sqlIns = "INSERT INTO proposal_budgets (proposalId, itemName, quantity, unitPrice, totalPrice) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement psIns = conn.prepareStatement(sqlIns)) {
                for (model.ProposalBudget b : newBudgets) {
                    psIns.setInt(1, proposalId);
                    psIns.setString(2, b.getItemName());
                    psIns.setInt(3, b.getQuantity());
                    psIns.setDouble(4, b.getUnitPrice());
                    psIns.setDouble(5, b.getTotalPrice());
                    psIns.addBatch();
                }
                psIns.executeBatch();
            }

            conn.commit(); // Save all changes
            return true;
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (java.sql.SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (java.sql.SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public boolean updateProposalStatus(int proposalId, String status, String feedback) {
        String sql = "UPDATE eventproposal SET Status = ?, feedback = ? WHERE proposalId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, feedback);
            ps.setInt(3, proposalId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getClubNotifications(int clubId) {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE clubId = ? AND targetRole IN ('All', 'CHC') ORDER BY createdAt DESC";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new java.util.HashMap<>();
                    map.put("notificationId", rs.getInt("notificationId"));
                    map.put("title", rs.getString("title"));
                    map.put("message", rs.getString("message"));
                    map.put("type", rs.getString("type"));
                    map.put("actionLink", rs.getString("actionLink"));
                    map.put("actionLabel", rs.getString("actionLabel"));
                    map.put("isRead", rs.getInt("isRead"));
                    map.put("createdAt", rs.getTimestamp("createdAt"));
                    list.add(map);
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getUnreadNotificationCount(int clubId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM notifications WHERE clubId = ? AND isRead = 0 AND targetRole IN ('All', 'CHC')";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int getClubIdByProposalId(int proposalId) {
        String sql = "SELECT clubId FROM eventproposal WHERE proposalId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, proposalId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("clubId");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void createNotification(int clubId, String title, String message, String type, String actionLink) {
        String sql = "INSERT INTO notifications (clubId, title, message, type, actionLink, actionLabel, isRead) "
                + "VALUES (?, ?, ?, ?, ?, 'Lihat', 0)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            ps.setString(2, title);
            ps.setString(3, message);
            ps.setString(4, type);
            ps.setString(5, actionLink);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String getClubNameById(int clubId) {
        String sql = "SELECT clubName FROM clubs WHERE clubId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("clubName");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Unknown Club";
    }

    public boolean markAllNotificationsAsRead(int clubId) {
        boolean isSuccess = false;
        String sql = "UPDATE notifications SET isRead = 1 WHERE clubId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public boolean deleteProposal(int proposalId) {
        String sql = "DELETE FROM eventproposal WHERE proposalId = ? AND Status = 'Draft'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, proposalId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void createNotificationWithRole(int clubId, String title, String message, String type, String actionLink, String role) {
        createNotificationWithRole(clubId, title, message, type, actionLink, "Lihat", role);
    }

    public void createNotificationWithRole(int clubId, String title, String message, String type, String actionLink, String actionLabel, String role) {
        String sql = "INSERT INTO notifications (clubId, title, message, type, actionLink, actionLabel, targetRole, isRead) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 0)";

        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            ps.setString(2, title);
            ps.setString(3, message);
            ps.setString(4, type);
            ps.setString(5, actionLink);
            ps.setString(6, actionLabel);
            ps.setString(7, role);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Map<String, Object>> getPendingProposalsForAdvisor(String advisorId, String sortBy, String order) {
        List<Map<String, Object>> list = new ArrayList<>();
        String orderByClause = "p.createdAt DESC";
        if ("date".equals(sortBy)) {
            orderByClause = "p.proposedDate " + order;
        } else if ("score".equals(sortBy)) {
            orderByClause = "p.conflictScore " + order;
        } else if ("club".equals(sortBy)) {
            orderByClause = "c.clubName " + order;
        } else if ("submitted".equals(sortBy)) {
            orderByClause = "p.createdAt " + order;
        }

        String sql = "SELECT p.*, c.clubName FROM eventproposal p "
                + "JOIN clubs c ON p.clubId = c.clubId "
                + "WHERE c.advisorId = ? AND p.Status = 'Pending_Advisor' "
                + "ORDER BY " + orderByClause;

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, advisorId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("proposalId", rs.getInt("proposalId"));
                    map.put("clubName", rs.getString("clubName"));
                    map.put("title", rs.getString("title"));
                    map.put("proposedDate", rs.getDate("proposedDate"));
                    map.put("budget", rs.getDouble("estimateBudget"));
                    map.put("status", rs.getString("Status"));
                    map.put("conflictScore", rs.getInt("conflictScore"));
                    map.put("createdAt", rs.getTimestamp("createdAt"));
                    map.put("duration", rs.getInt("duration"));
                    map.put("venue", rs.getString("venue"));
                    map.put("targetAudience", rs.getString("targetAudience"));
                    map.put("estimateParticipant", rs.getInt("estimateParticipant"));
                    map.put("description", rs.getString("description"));

                    String dateStr = rs.getString("proposedDate");
                    int duration = rs.getInt("duration");
                    int pax = rs.getInt("estimateParticipant");
                    double budget = rs.getDouble("estimateBudget");
                    int clubId = rs.getInt("clubId");
                    boolean isClubFunded = rs.getBoolean("isClubFunded");

                    String aiReport = aiEngine.generateAIAssessment(clubId, dateStr, duration, pax, budget, "", isClubFunded);
                    map.put("aiSuggestion", aiReport);

                    list.add(map);
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public String getClubCategoryByProposalId(int proposalId) {
        String category = "Non-Academic";
        String sql = "SELECT c.category FROM eventproposal p JOIN clubs c ON p.clubId = c.clubId WHERE p.proposalId = ?";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, proposalId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    category = rs.getString("category");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return category;
    }

    public int getClubIdByAdvisorId(String advisorId) {
        String sql = "SELECT clubId FROM clubs WHERE advisorId = ? LIMIT 1";
        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, advisorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("clubId");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Map<String, Object>> getClubNotificationsForAdvisor(int clubId) {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE clubId = ? AND targetRole IN ('All', 'Advisor') ORDER BY createdAt DESC";
        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new java.util.HashMap<>();
                    map.put("notificationId", rs.getInt("notificationId"));
                    map.put("title", rs.getString("title"));
                    map.put("message", rs.getString("message"));
                    map.put("type", rs.getString("type"));
                    map.put("actionLink", rs.getString("actionLink"));
                    map.put("actionLabel", rs.getString("actionLabel"));
                    map.put("isRead", rs.getInt("isRead"));
                    map.put("createdAt", rs.getTimestamp("createdAt"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getUnreadNotificationCountForAdvisor(int clubId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM notifications WHERE clubId = ? AND isRead = 0 AND targetRole IN ('All', 'Advisor')";
        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<Map<String, Object>> getAllProposalsForAdvisor(String advisorId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.*, c.clubName FROM eventproposal p "
                + "JOIN clubs c ON p.clubId = c.clubId "
                + "WHERE c.advisorId = ? "
                + "ORDER BY p.createdAt DESC";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, advisorId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("proposalId", rs.getInt("proposalId"));
                    map.put("clubId", rs.getInt("clubId"));
                    map.put("clubName", rs.getString("clubName"));
                    map.put("title", rs.getString("title"));
                    map.put("description", rs.getString("description"));
                    map.put("proposedDate", rs.getDate("proposedDate"));
                    map.put("budget", rs.getDouble("estimateBudget"));
                    map.put("status", rs.getString("Status"));
                    map.put("conflictScore", rs.getInt("conflictScore"));
                    map.put("createdAt", rs.getTimestamp("createdAt"));
                    map.put("updatedAt", rs.getTimestamp("updatedAt"));

                    String dateStr = rs.getString("proposedDate");
                    int duration = rs.getInt("duration");
                    int pax = rs.getInt("estimateParticipant");
                    double budget = rs.getDouble("estimateBudget");
                    int clubId = rs.getInt("clubId");
                    boolean isClubFunded = rs.getBoolean("isClubFunded");

                    String aiReport = aiEngine.generateAIAssessment(clubId, dateStr, duration, pax, budget, "", isClubFunded);
                    map.put("aiSuggestion", aiReport);

                    list.add(map);
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean schedulePitching(int proposalId, String pitchingDate, String meetLink) {
        boolean isSuccess = false;
        try (java.sql.Connection conn = util.DBConnection.getConnection()) {
            String formattedDate = pitchingDate;
            if (formattedDate != null && formattedDate.contains("T")) {
                formattedDate = formattedDate.replace("T", " ");
                if (formattedDate.length() == 16) {
                    formattedDate += ":00";
                }
            }

            String feedbackMsg = "PITCHING SCHEDULED.\nTarikh & Masa: " + formattedDate + "\nLink/Lokasi: " + meetLink;
            String sql = "UPDATE eventproposal SET Status = 'Meeting_Scheduled', pitchingDate = ?, pitchingLocation = ?, feedback = ? WHERE proposalId = ?";

            try (java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, formattedDate);
                ps.setString(2, meetLink);
                ps.setString(3, feedbackMsg);
                ps.setInt(4, proposalId);

                if (ps.executeUpdate() > 0) {
                    isSuccess = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public List<Map<String, Object>> getNotificationsForMPP() {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE targetRole = 'MPP' ORDER BY createdAt DESC";
        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("notificationId", rs.getInt("notificationId"));
                map.put("title", rs.getString("title"));
                map.put("message", rs.getString("message"));
                map.put("type", rs.getString("type"));
                map.put("actionLink", rs.getString("actionLink"));
                map.put("isRead", rs.getInt("isRead"));
                map.put("createdAt", rs.getTimestamp("createdAt"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getUnreadNotificationCountForMPP() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM notifications WHERE targetRole = 'MPP' AND isRead = 0";
        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public boolean markAllNotificationsAsReadForMPP() {
        boolean isSuccess = false;
        String sql = "UPDATE notifications SET isRead = 1 WHERE targetRole = 'MPP'";
        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (ps.executeUpdate() > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public List<Map<String, Object>> getNotificationsForHEPA() {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE targetRole = 'HEPA' ORDER BY createdAt DESC";
        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("notificationId", rs.getInt("notificationId"));
                map.put("title", rs.getString("title"));
                map.put("message", rs.getString("message"));
                map.put("type", rs.getString("type"));
                map.put("actionLink", rs.getString("actionLink"));
                map.put("isRead", rs.getInt("isRead"));
                map.put("createdAt", rs.getTimestamp("createdAt"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getUnreadNotificationCountForHEPA() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM notifications WHERE targetRole = 'HEPA' AND isRead = 0";
        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public void markAllNotificationsAsReadForHEPA() {
        String sql = "UPDATE notifications SET isRead = 1 WHERE targetRole = 'HEPA'";
        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Map<String, Object>> getProposalsForHEPA() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.*, c.clubName, u.fullName "
                + "FROM eventproposal p "
                + "JOIN clubs c ON p.clubId = c.clubId "
                + "JOIN `user` u ON p.createdBy = u.userId "
                + "WHERE p.Status IN ('Pending_HEPA', 'Approved', 'Rejected') "
                + "ORDER BY FIELD(p.Status, 'Pending_HEPA', 'Approved', 'Rejected'), p.updatedAt DESC";

        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("proposalId", rs.getInt("proposalId"));
                map.put("clubName", rs.getString("clubName"));
                map.put("title", rs.getString("title"));
                map.put("budget", rs.getDouble("estimateBudget"));
                map.put("status", rs.getString("Status"));
                map.put("feedback", rs.getString("feedback"));
                map.put("updatedAt", rs.getTimestamp("updatedAt"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Integer> getHEPAStats() {
        Map<String, Integer> stats = new HashMap<>();
        String sqlPending = "SELECT COUNT(*) FROM eventproposal WHERE Status = 'Pending_HEPA'";
        String sqlApproved = "SELECT COUNT(*) FROM eventproposal WHERE Status = 'Approved'";
        String sqlTotalClubs = "SELECT COUNT(*) FROM clubs";

        try (Connection conn = util.DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sqlPending); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("pendingEndorse", rs.getInt(1));
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlApproved); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalApproved", rs.getInt(1));
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlTotalClubs); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalClubs", rs.getInt(1));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<Map<String, Object>> getAllClubsForHEPA() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM clubs ORDER BY category, clubName";
        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("clubId", rs.getInt("clubId"));
                map.put("clubName", rs.getString("clubName"));
                map.put("category", rs.getString("category"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getAllProposalsForReporting() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.*, c.clubName, c.category, c.cluster, u.fullName "
                + "FROM eventproposal p "
                + "JOIN clubs c ON p.clubId = c.clubId "
                + "LEFT JOIN `user` u ON p.createdBy = u.userId "
                + "ORDER BY p.createdAt DESC";

        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("proposalId", rs.getInt("proposalId"));
                map.put("clubName", rs.getString("clubName"));
                map.put("category", rs.getString("category"));

                String clusterVal = rs.getString("cluster");
                map.put("cluster", (clusterVal != null) ? clusterVal : "Umum");

                map.put("title", rs.getString("title"));
                map.put("proposedDate", rs.getDate("proposedDate"));
                map.put("budget", rs.getDouble("estimateBudget"));
                map.put("status", rs.getString("Status"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getProposalsForFaculty() {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT p.*, c.clubName FROM eventproposal p "
                + "JOIN clubs c ON p.clubId = c.clubId "
                + "WHERE p.Status = 'Pending_Faculty' ORDER BY p.createdAt DESC";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql); java.sql.ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("proposalId", rs.getInt("proposalId"));
                map.put("clubName", rs.getString("clubName"));
                map.put("title", rs.getString("title"));
                map.put("budget", rs.getDouble("estimateBudget"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getNotificationsForFaculty() {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE targetRole = 'Faculty' ORDER BY createdAt DESC";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql); java.sql.ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("notificationId", rs.getInt("notificationId"));
                map.put("title", rs.getString("title"));
                map.put("message", rs.getString("message"));
                map.put("type", rs.getString("type"));
                map.put("actionLink", rs.getString("actionLink"));
                map.put("isRead", rs.getInt("isRead"));
                map.put("createdAt", rs.getTimestamp("createdAt"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getUnreadNotificationCountForFaculty() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM notifications WHERE targetRole = 'Faculty' AND isRead = 0";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql); java.sql.ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public void markAllNotificationsAsReadForFaculty() {
        String sql = "UPDATE notifications SET isRead = 1 WHERE targetRole = 'Faculty'";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Map<String, Object>> getAllProposalsForFacultyReports() {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT p.*, c.clubName, c.category FROM eventproposal p "
                + "JOIN clubs c ON p.clubId = c.clubId "
                + "WHERE c.category = 'Academic' "
                + "ORDER BY p.updatedAt DESC";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql); java.sql.ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("proposalId", rs.getInt("proposalId"));
                map.put("clubName", rs.getString("clubName"));
                map.put("title", rs.getString("title"));
                map.put("budget", rs.getDouble("estimateBudget"));
                map.put("status", rs.getString("Status"));
                map.put("proposedDate", rs.getDate("proposedDate"));
                map.put("updatedAt", rs.getTimestamp("updatedAt"));
                map.put("conflictScore", rs.getInt("conflictScore"));
                map.put("createdAt", rs.getTimestamp("createdAt"));
                map.put("updatedAt", rs.getTimestamp("updatedAt"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void markAllNotificationsAsReadForAdvisor(String advisorId) {
        String sql = "UPDATE notifications n "
                + "JOIN clubs c ON n.clubId = c.clubId "
                + "SET n.isRead = 1 "
                + "WHERE n.targetRole = 'Advisor' AND c.advisorId = ?";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, advisorId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --------------------------------------------------------
    // FUNCTION TO SAVE E-RISK FILE PATH (ADVISOR)
    // --------------------------------------------------------
    public boolean updateERiskFilePath(int proposalId, String filePath) {
        String sql = "UPDATE eventproposal SET eriskFile = ? WHERE proposalId = ?";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, filePath);
            ps.setInt(2, proposalId);
            return ps.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --------------------------------------------------------
    // FUNCTION FOR HEPA FINAL EVALUATION
    // --------------------------------------------------------
    public boolean updateHepaReview(int proposalId, String status, String hepaRemark) {
        String sql = "UPDATE eventproposal SET status = ?, hepaRemark = ? WHERE proposalId = ?";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, hepaRemark);
            ps.setInt(3, proposalId);
            return ps.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --------------------------------------------------------
    // FUNCTION TO SAVE MPP MEETING MINUTES FILE PATH
    // --------------------------------------------------------
    public boolean updateMPPMinutesFilePath(int proposalId, String filePath) {
        String sql = "UPDATE eventproposal SET mppMinutesFile = ? WHERE proposalId = ?";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, filePath);
            ps.setInt(2, proposalId);
            return ps.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --------------------------------------------------------
    // FUNCTION TO ALTER PROPOSAL BUDGET DETAILS & TOTAL
    // --------------------------------------------------------
    public boolean alterProposalBudget(int proposalId, double newGrandTotal, String newBudgetString, String feedback) {
        String sql = "UPDATE eventproposal SET "
                + "originalBudgetDetails = COALESCE(originalBudgetDetails, budgetDetails), "
                + "estimateBudget = ?, budgetDetails = ?, isBudgetAltered = 1, feedback = ? "
                + "WHERE proposalId = ?";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, newGrandTotal);
            ps.setString(2, newBudgetString);
            ps.setString(3, feedback);
            ps.setInt(4, proposalId);
            return ps.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getLatestProposalIdByClub(int clubId) {
        int latestId = -1;
        String sql = "SELECT MAX(proposalId) AS latestId FROM eventproposal WHERE clubId = ?";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    latestId = rs.getInt("latestId");
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return latestId;
    }

    public java.util.Map<String, Object> getClubDashboardStats(int clubId) {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        stats.put("total", 0);
        stats.put("pending", 0);
        stats.put("approved", 0);
        stats.put("funds", 0.0);

        String sql = "SELECT "
                + "COUNT(*) AS total, "
                + "SUM(CASE WHEN Status LIKE 'Pending%' THEN 1 ELSE 0 END) AS pending, "
                + "SUM(CASE WHEN Status = 'Approved' THEN 1 ELSE 0 END) AS approved, "
                + "SUM(CASE WHEN Status = 'Approved' THEN estimateBudget ELSE 0 END) AS funds "
                + "FROM eventproposal WHERE clubId = ?";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("total", rs.getInt("total"));
                    stats.put("pending", rs.getInt("pending"));
                    stats.put("approved", rs.getInt("approved"));
                    stats.put("funds", rs.getDouble("funds"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public java.util.List<model.EventItem> getRecentClubProposals(int clubId) {
        java.util.List<model.EventItem> list = new java.util.ArrayList<>();
        String sql = "SELECT proposalId, title, proposedDate, estimateBudget, Status FROM eventproposal WHERE clubId = ? ORDER BY proposalId DESC LIMIT 5";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.EventItem p = new model.EventItem();
                    p.setProposalId(rs.getInt("proposalId"));
                    p.setTitle(rs.getString("title"));
                    p.setProposedDate(rs.getDate("proposedDate"));
                    p.setEstimateBudget(rs.getDouble("estimateBudget"));
                    p.setStatus(rs.getString("Status"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getRemainingAnnualBudget(int clubId) {
        String sql = "SELECT SUM(estimateBudget) AS usedBudget FROM eventproposal WHERE clubId = ? AND Status IN ('Approved', 'Completed') AND YEAR(proposedDate) = YEAR(CURDATE())";
        double usedBudget = 0;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usedBudget = rs.getDouble("usedBudget");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Math.max(0, 1000.0 - usedBudget); // RM 1,000 is the hard limit
    }

    // --------------------------------------------------------
    // DIRECTORY FUNCTION: GET HIGH COMMITTEE (CHC)
    // --------------------------------------------------------
    public List<Map<String, Object>> getClubCHC(int clubId) {
        List<Map<String, Object>> list = new ArrayList<>();

        // Exact match for your DB: u.userId, u.department, cm.Position
        String sql = "SELECT u.userId, u.fullName, u.email, u.phone, u.department, cm.Position "
                + "FROM user u "
                + "JOIN club_memberships cm ON u.userId = cm.userId "
                + "WHERE cm.clubId = ? AND cm.Position != 'Member' AND cm.isActive = 1 "
                + "ORDER BY FIELD(cm.Position, 'Pres', 'Vice Pres', 'Secr', 'Treas'), u.fullName";

        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();

                    // In your system, userId IS the matric number (e.g., S70622)
                    map.put("matricNo", rs.getString("userId"));
                    map.put("fullName", rs.getString("fullName"));
                    map.put("email", rs.getString("email"));

                    // Format the DB ENUM into full words for the UI
                    String pos = rs.getString("Position");
                    if ("Pres".equals(pos)) {
                        pos = "President";
                    } else if ("Secr".equals(pos)) {
                        pos = "Secretary";
                    } else if ("Treas".equals(pos)) {
                        pos = "Treasurer";
                    }
                    map.put("role", pos);

                    // Fetch phone and department safely
                    String phone = rs.getString("phone");
                    map.put("phone", (phone != null && !phone.trim().isEmpty()) ? phone : "N/A");
                    map.put("faculty", rs.getString("department") != null ? rs.getString("department") : "UMT Student");

                    // Fallback for UI (Since semester isn't tracked in DB)
                    map.put("semester", "Active");

                    list.add(map);
                }
            }
        } catch (Exception e) {
            System.err.println("Error fetching CHC List: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // --------------------------------------------------------
    // DIRECTORY FUNCTION: GET GENERAL MEMBERS
    // --------------------------------------------------------
    public List<Map<String, Object>> getClubMembers(int clubId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT u.userId, u.fullName, u.email, u.department "
                + "FROM user u "
                + "JOIN club_memberships cm ON u.userId = cm.userId "
                + "WHERE cm.clubId = ? AND cm.Position = 'Member' AND cm.isActive = 1 "
                + "ORDER BY u.fullName ASC";

        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("matricNo", rs.getString("userId"));
                    map.put("fullName", rs.getString("fullName"));
                    map.put("faculty", rs.getString("department") != null ? rs.getString("department") : "UMT Student");
                    list.add(map);
                }
            }
        } catch (Exception e) {
            System.err.println("Error fetching Member List: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // --------------------------------------------------------
    // DIRECTORY FUNCTION: UNION (ALL MEMBERS & CHC)
    // --------------------------------------------------------
    public List<Map<String, Object>> getAllClubMembers(int clubId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT u.userId, u.fullName, u.email, u.department, cm.Position "
                + "FROM user u "
                + "JOIN club_memberships cm ON u.userId = cm.userId "
                + "WHERE cm.clubId = ? AND cm.isActive = 1 "
                + "ORDER BY u.fullName ASC";

        try (Connection conn = util.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("matricNo", rs.getString("userId"));
                    map.put("fullName", rs.getString("fullName"));
                    map.put("faculty", rs.getString("department") != null ? rs.getString("department") : "UMT Student");

                    // Format the Role
                    String pos = rs.getString("Position");
                    if ("Pres".equals(pos)) {
                        pos = "President";
                    } else if ("Secr".equals(pos)) {
                        pos = "Secretary";
                    } else if ("Treas".equals(pos)) {
                        pos = "Treasurer";
                    } else if ("Member".equals(pos)) {
                        pos = "Member";
                    }
                    map.put("role", pos);

                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // --------------------------------------------------------
    // FETCH DYNAMIC SYSTEM DOCUMENTS (Grouped by Category)
    // --------------------------------------------------------
    public Map<String, List<Map<String, Object>>> getGroupedSystemDocuments() {
        // LinkedHashMap keeps the categories in alphabetical order
        Map<String, List<Map<String, Object>>> groupedDocs = new java.util.LinkedHashMap<>();

        // Fetch all documents, sorted by Category first, then by newest
        String sql = "SELECT * FROM system_documents ORDER BY category ASC, updatedAt DESC";

        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql); java.sql.ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String category = rs.getString("category");

                Map<String, Object> doc = new java.util.HashMap<>();
                doc.put("docId", rs.getInt("docId"));
                doc.put("title", rs.getString("title"));
                doc.put("filePath", rs.getString("filePath"));
                doc.put("fileType", rs.getString("fileType"));
                doc.put("fileSize", rs.getString("fileSize"));
                doc.put("updatedAt", rs.getTimestamp("updatedAt"));

                // If the category doesn't exist in the map yet, create a new list for it
                groupedDocs.computeIfAbsent(category, k -> new java.util.ArrayList<>()).add(doc);
            }
        } catch (Exception e) {
            System.err.println("Error fetching grouped documents: " + e.getMessage());
            e.printStackTrace();
        }
        return groupedDocs;
    }
}
