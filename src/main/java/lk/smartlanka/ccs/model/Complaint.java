package lk.smartlanka.ccs.model;

import java.time.LocalDateTime;
import java.util.List;

public class Complaint {
    private long complaintId;
    private int customerId;
    private String title;
    private String description;
    private String issueTypeCode;
    private String priorityCode;
    private String statusCode;
    private LocalDateTime submittedDate;
    private LocalDateTime lastUpdated;
    private int assignedTo;
    private String resolution;
    private int assigneeId;
    private LocalDateTime resolvedDate;
    private List<Attachment> attachments;
    private String customerName; // For display purposes
    
    // Constructors
    public Complaint() {}
    
    public Complaint(int customerId, String title, String description, String issueTypeCode, String priorityCode) {
        this.customerId = customerId;
        this.title = title;
        this.description = description;
        this.issueTypeCode = issueTypeCode;
        this.priorityCode = priorityCode;
        this.statusCode = "OPEN";
        this.submittedDate = LocalDateTime.now();
        this.lastUpdated = LocalDateTime.now();
    }
    
    // Getters/Setters
    public long getComplaintId() { return complaintId; }
    public void setComplaintId(long complaintId) { this.complaintId = complaintId; }
    
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getIssueTypeCode() { return issueTypeCode; }
    public void setIssueTypeCode(String issueTypeCode) { this.issueTypeCode = issueTypeCode; }
    
    public String getPriorityCode() { return priorityCode; }
    public void setPriorityCode(String priorityCode) { this.priorityCode = priorityCode; }
    
    public String getStatusCode() { return statusCode; }
    public void setStatusCode(String statusCode) { this.statusCode = statusCode; }
    
    public LocalDateTime getSubmittedDate() { return submittedDate; }
    public void setSubmittedDate(LocalDateTime submittedDate) { this.submittedDate = submittedDate; }
    
    public LocalDateTime getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(LocalDateTime lastUpdated) { this.lastUpdated = lastUpdated; }
    
    public int getAssignedTo() { return assignedTo; }
    public void setAssignedTo(int assignedTo) { this.assignedTo = assignedTo; }
    
    public String getResolution() { return resolution; }
    public void setResolution(String resolution) { this.resolution = resolution; }

    public int getAssigneeId() { return assigneeId; }
    public void setAssigneeId(int assigneeId) { this.assigneeId = assigneeId; }
    
    public LocalDateTime getResolvedDate() { return resolvedDate; }
    public void setResolvedDate(LocalDateTime resolvedDate) { this.resolvedDate = resolvedDate; }
    





















    // Helper methods
    public String getStatusDisplayName() {
        return switch (statusCode) {
            case "OPEN" -> "Open";
            case "IN_PROGRESS" -> "In Progress";
            case "RESOLVED" -> "Resolved";
            case "CLOSED" -> "Closed";
            case "CANCELLED" -> "Cancelled";
            default -> statusCode;
        };
    }
    
    public String getPriorityDisplayName() {
        return switch (priorityCode) {
            case "LOW" -> "Low";
            case "MEDIUM" -> "Medium";
            case "HIGH" -> "High";
            case "CRITICAL" -> "Critical";
            default -> priorityCode;
        };
    }
    
    public String getIssueTypeDisplayName() {
        return switch (issueTypeCode) {
            case "TECHNICAL" -> "Technical Issue";
            case "BILLING" -> "Billing Issue";
            case "SERVICE" -> "Service Issue";
            case "COMPLAINT" -> "General Complaint";
            case "FEATURE_REQUEST" -> "Feature Request";
            default -> issueTypeCode;
        };
    }

}