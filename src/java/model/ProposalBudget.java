package model;

public class ProposalBudget {

    private int budgetId;
    private int proposalId;
    private String itemName;
    private int quantity;
    private double unitPrice;
    private double totalPrice;

    // Empty Constructor
    public ProposalBudget() {
    }

    // Full Constructor
    public ProposalBudget(int budgetId, int proposalId, String itemName, int quantity, double unitPrice, double totalPrice) {
        this.budgetId = budgetId;
        this.proposalId = proposalId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
    }

    // --- Getters and Setters ---
    public int getBudgetId() {
        return budgetId;
    }

    public void setBudgetId(int budgetId) {
        this.budgetId = budgetId;
    }

    public int getProposalId() {
        return proposalId;
    }

    public void setProposalId(int proposalId) {
        this.proposalId = proposalId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }
}
