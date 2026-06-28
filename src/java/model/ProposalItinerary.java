package model;

public class ProposalItinerary {

    private int itineraryId;
    private int proposalId;
    private String day;
    private String time;
    private String activity;

    public ProposalItinerary() {
    }

    public ProposalItinerary(int itineraryId, int proposalId, String day, String time, String activity) {
        this.itineraryId = itineraryId;
        this.proposalId = proposalId;
        this.day = day;
        this.time = time;
        this.activity = activity;
    }

    public int getItineraryId() {
        return itineraryId;
    }

    public void setItineraryId(int itineraryId) {
        this.itineraryId = itineraryId;
    }

    public int getProposalId() {
        return proposalId;
    }

    public void setProposalId(int proposalId) {
        this.proposalId = proposalId;
    }

    public String getDay() {
        return day;
    }

    public void setDay(String day) {
        this.day = day;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getActivity() {
        return activity;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }
}
