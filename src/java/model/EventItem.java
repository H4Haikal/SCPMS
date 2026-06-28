package model;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class EventItem {

    // 1. Core Database Fields (from eventproposal table)
    private int proposalId;
    private int clubId;
    private String proposalType;
    private String createdBy; // userId of the student who created it
    private String title;
    private String description;
    private String objective;
    private String sdgImpact;
    private String sdgReason;
    private String eriskFile;
    private String mppMinutesFile;
    private String hepaRemark;
    private Date proposedDate;
    private Date endDate;
    private int duration;
    private int participantUmt;
    private int participantStaff;
    private int participantPublic;
    private String participantOtherDesc;
    private int estimateParticipant;
    private double estimateBudget;
    private boolean isBudgetAltered;
    private String status;
    private Integer conflictScore; // Integer instead of int so it can be null
    private String aiSuggestion;
    private Date createdAt;
    private Date updatedAt;
    private String feedback;
    private String venue;
    private String targetAudience;
    private Date pitchingDate;
    private String pitchingLocation;
    private String budgetDetails;
    private boolean isClubFunded = true;// Defaults to true



    // 2. Helper Fields (Usually populated via SQL JOINs for the UI)
    private String clubName;

    // 3. The New 3NF Relational Lists (Replacing the old flat strings)
    private List<ProposalBudget> budgets = new ArrayList<>();
    private List<ProposalCommittee> committees = new ArrayList<>();
    private List<ProposalItinerary> itineraries = new ArrayList<>();

    // --- Empty Constructor ---
    public EventItem() {
    }

    // --- Getters and Setters ---
    public int getProposalId() {
        return proposalId;
    }

    public void setProposalId(int proposalId) {
        this.proposalId = proposalId;
    }

    public int getClubId() {
        return clubId;
    }

    public void setClubId(int clubId) {
        this.clubId = clubId;
    }

    public String getProposalType() {
        return proposalType;
    }

    public void setProposalType(String proposalType) {
        this.proposalType = proposalType;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getObjective() {
        return objective;
    }

    public void setObjective(String objective) {
        this.objective = objective;
    }

    public String getSdgImpact() {
        return sdgImpact;
    }

    public void setSdgImpact(String sdgImpact) {
        this.sdgImpact = sdgImpact;
    }

    public String getSdgReason() {
        return sdgReason;
    }

    public void setSdgReason(String sdgReason) {
        this.sdgReason = sdgReason;
    }

    public String getEriskFile() {
        return eriskFile;
    }

    public void setEriskFile(String eriskFile) {
        this.eriskFile = eriskFile;
    }

    public String getMppMinutesFile() {
        return mppMinutesFile;
    }

    public void setMppMinutesFile(String mppMinutesFile) {
        this.mppMinutesFile = mppMinutesFile;
    }

    public String getHepaRemark() {
        return hepaRemark;
    }

    public void setHepaRemark(String hepaRemark) {
        this.hepaRemark = hepaRemark;
    }

    public Date getProposedDate() {
        return proposedDate;
    }

    public void setProposedDate(Date proposedDate) {
        this.proposedDate = proposedDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public int getParticipantUmt() {
        return participantUmt;
    }

    public void setParticipantUmt(int participantUmt) {
        this.participantUmt = participantUmt;
    }

    public int getParticipantStaff() {
        return participantStaff;
    }

    public void setParticipantStaff(int participantStaff) {
        this.participantStaff = participantStaff;
    }

    public int getParticipantPublic() {
        return participantPublic;
    }

    public void setParticipantPublic(int participantPublic) {
        this.participantPublic = participantPublic;
    }

    public String getParticipantOtherDesc() {
        return participantOtherDesc;
    }

    public void setParticipantOtherDesc(String participantOtherDesc) {
        this.participantOtherDesc = participantOtherDesc;
    }

    public int getEstimateParticipant() {
        return estimateParticipant;
    }

    public void setEstimateParticipant(int estimateParticipant) {
        this.estimateParticipant = estimateParticipant;
    }

    public double getEstimateBudget() {
        return estimateBudget;
    }

    public void setEstimateBudget(double estimateBudget) {
        this.estimateBudget = estimateBudget;
    }

    public boolean isBudgetAltered() {
        return isBudgetAltered;
    }

    public void setBudgetAltered(boolean isBudgetAltered) {
        this.isBudgetAltered = isBudgetAltered;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getConflictScore() {
        return conflictScore;
    }

    public void setConflictScore(Integer conflictScore) {
        this.conflictScore = conflictScore;
    }

    public String getAiSuggestion() {
        return aiSuggestion;
    }

    public void setAiSuggestion(String aiSuggestion) {
        this.aiSuggestion = aiSuggestion;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public String getVenue() {
        return venue;
    }

    public void setVenue(String venue) {
        this.venue = venue;
    }

    public String getTargetAudience() {
        return targetAudience;
    }

    public void setTargetAudience(String targetAudience) {
        this.targetAudience = targetAudience;
    }

    public Date getPitchingDate() {
        return pitchingDate;
    }

    public void setPitchingDate(Date pitchingDate) {
        this.pitchingDate = pitchingDate;
    }

    public String getPitchingLocation() {
        return pitchingLocation;
    }

    public void setPitchingLocation(String pitchingLocation) {
        this.pitchingLocation = pitchingLocation;
    }

    public String getClubName() {
        return clubName;
    }

    public void setClubName(String clubName) {
        this.clubName = clubName;
    }

    // --- 3NF List Getters and Setters ---
    public List<ProposalBudget> getBudgets() {
        return budgets;
    }

    public void setBudgets(List<ProposalBudget> budgets) {
        this.budgets = budgets;
    }

    public List<ProposalCommittee> getCommittees() {
        return committees;
    }

    public void setCommittees(List<ProposalCommittee> committees) {
        this.committees = committees;
    }

    public List<ProposalItinerary> getItineraries() {
        return itineraries;
    }

    public void setItineraries(List<ProposalItinerary> itineraries) {
        this.itineraries = itineraries;
    }

    private String clubCategory;

    public String getClubCategory() {
        return clubCategory;
    }

    public void setClubCategory(String clubCategory) {
        this.clubCategory = clubCategory;
    }

    public String getBudgetDetails() {
        return budgetDetails;
    }

    public void setBudgetDetails(String budgetDetails) {
        this.budgetDetails = budgetDetails;
    }

    public boolean isClubFunded() {
        return isClubFunded;
    }

    public void setClubFunded(boolean isClubFunded) {
        this.isClubFunded = isClubFunded;
    }
    
    
}
