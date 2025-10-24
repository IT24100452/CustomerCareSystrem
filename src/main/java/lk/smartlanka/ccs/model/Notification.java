package lk.smartlanka.ccs.model;

import java.time.LocalDateTime;

public class Notification {
    private long notificationId;
    private int userId;
    private String title;
    private String message;
    private String type; // INFO, WARNING, ERROR, SUCCESS
    private boolean isRead;
    private LocalDateTime createdAt;
    private String relatedEntityType; // COMPLAINT, FEEDBACK, ASSIGNMENT, etc.
    private long relatedEntityId;
    private String actionUrl;
    
    // Constructors
    public Notification() {}
    
    public Notification(int userId, String title, String message, String type) {
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.type = type;
        this.isRead = false;
        this.createdAt = LocalDateTime.now();
    }
    
    public Notification(int userId, String title, String message, String type, 
                       String relatedEntityType, long relatedEntityId, String actionUrl) {
        this(userId, title, message, type);
        this.relatedEntityType = relatedEntityType;
        this.relatedEntityId = relatedEntityId;
        this.actionUrl = actionUrl;
    }
    
    // Getters and Setters
    public long getNotificationId() { return notificationId; }
    public void setNotificationId(long notificationId) { this.notificationId = notificationId; }
    
    public long getId() { return notificationId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public String getRelatedEntityType() { return relatedEntityType; }
    public void setRelatedEntityType(String relatedEntityType) { this.relatedEntityType = relatedEntityType; }
    
    public long getRelatedEntityId() { return relatedEntityId; }
    public void setRelatedEntityId(long relatedEntityId) { this.relatedEntityId = relatedEntityId; }
    
    public String getActionUrl() { return actionUrl; }
    public void setActionUrl(String actionUrl) { this.actionUrl = actionUrl; }
    




















    // Helper methods
    public String getTypeClass() {
        return switch (type.toUpperCase()) {
            case "SUCCESS" -> "success";
            case "WARNING" -> "warning";
            case "ERROR" -> "error";
            default -> "info";
        };
    }
    
    public String getTypeIcon() {
        return switch (type.toUpperCase()) {
            case "SUCCESS" -> "✓";
            case "WARNING" -> "⚠";
            case "ERROR" -> "✗";
            default -> "ℹ";
        };
    }
}

