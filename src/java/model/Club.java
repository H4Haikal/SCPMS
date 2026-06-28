package model;

public class Club {

    private int clubId;
    private String clubName;
    private String category;
    private String logoPath;
    private int establishedYear;
    private String status;
    private String lastAGMStatus;
    private String presidentName;
    private String secretaryName;
    private String treasurerName;
    private String agmReportPath;
    private String agmSubmissionDate;
    private int agmReminderCount;
    private String description;
    private String mission, vision;
    private String cluster;

    // Getters and Setters
    public int getClubId() {
        return clubId;
    }

    public void setClubId(int clubId) {
        this.clubId = clubId;
    }

    public String getClubName() {
        return clubName;
    }

    public void setClubName(String clubName) {
        this.clubName = clubName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getLogoPath() {
        return logoPath;
    }

    public void setLogoPath(String logoPath) {
        this.logoPath = logoPath;
    }

    public int getEstablishedYear() {
        return establishedYear;
    }

    public void setEstablishedYear(int establishedYear) {
        this.establishedYear = establishedYear;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getLastAGMStatus() {
        return lastAGMStatus;
    }

    public void setLastAGMStatus(String lastAGMStatus) {
        this.lastAGMStatus = lastAGMStatus;
    }

    public String getPresidentName() {
        return presidentName != null ? presidentName : "Vacant";
    }

    public void setPresidentName(String presidentName) {
        this.presidentName = presidentName;
    }

    public String getSecretaryName() {
        return secretaryName != null ? secretaryName : "Vacant";
    }

    public void setSecretaryName(String secretaryName) {
        this.secretaryName = secretaryName;
    }

    public String getTreasurerName() {
        return treasurerName != null ? treasurerName : "Vacant";
    }

    public void setTreasurerName(String treasurerName) {
        this.treasurerName = treasurerName;
    }

    // === NEW GETTERS & SETTERS ===
    public String getAgmReportPath() {
        return agmReportPath;
    }

    public void setAgmReportPath(String agmReportPath) {
        this.agmReportPath = agmReportPath;
    }

    public String getAgmSubmissionDate() {
        return agmSubmissionDate;
    }

    public void setAgmSubmissionDate(String agmSubmissionDate) {
        this.agmSubmissionDate = agmSubmissionDate;
    }

    public int getAgmReminderCount() {
        return agmReminderCount;
    }

    public void setAgmReminderCount(int agmReminderCount) {
        this.agmReminderCount = agmReminderCount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getMission() {
        return mission;
    }

    public void setMission(String mission) {
        this.mission = mission;
    }

    public String getVision() {
        return vision;
    }

    public void setVision(String vision) {
        this.vision = vision;
    }

    public String getCluster() {
        return cluster;
    }

    public void setCluster(String cluster) {
        this.cluster = cluster;
    }

}
