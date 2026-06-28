package model;

import java.sql.Timestamp;

public class Notification {

    private int notificationId;
    private String title;
    private String message;
    private String type; // 'REMINDER', 'ANNOUNCEMENT', 'STATUS'
    private String actionLink; // e.g., "/chc/agm"
    private String actionLabel; // e.g., "Submit Report"
    private Timestamp createdAt;

    // --- GUNA INT UNTUK MATCH TINYINT(1) DB ---
    private int isRead;

    // Getters and Setters
    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getActionLink() {
        return actionLink;
    }

    public void setActionLink(String actionLink) {
        this.actionLink = actionLink;
    }

    public String getActionLabel() {
        return actionLabel;
    }

    public void setActionLabel(String actionLabel) {
        this.actionLabel = actionLabel;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // --- GETTER & SETTER BARU UNTUK isRead (INT) ---
    public int getIsRead() {
        return isRead;
    }

    public void setIsRead(int isRead) {
        this.isRead = isRead;
    }
}
