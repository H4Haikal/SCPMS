package model;

public class ActivityItem {
    private String title;
    private String description;
    private String timeAgo;

    public ActivityItem(String title, String description, String timeAgo) {
        this.title = title;
        this.description = description;
        this.timeAgo = timeAgo;
    }

    // Getters
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getTimeAgo() { return timeAgo; }
}