package model;

public class ProposalCommittee {
    private int committeeId;
    private int proposalId;
    private String matricNo;
    private String name;
    private String role;

    public ProposalCommittee() {}

    public ProposalCommittee(int committeeId, int proposalId, String matricNo, String name, String role) {
        this.committeeId = committeeId;
        this.proposalId = proposalId;
        this.matricNo = matricNo;
        this.name = name;
        this.role = role;
    }

    public int getCommitteeId() { return committeeId; }
    public void setCommitteeId(int committeeId) { this.committeeId = committeeId; }

    public int getProposalId() { return proposalId; }
    public void setProposalId(int proposalId) { this.proposalId = proposalId; }

    public String getMatricNo() { return matricNo; }
    public void setMatricNo(String matricNo) { this.matricNo = matricNo; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}