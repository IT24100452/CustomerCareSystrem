package lk.smartlanka.ccs.model;

import java.time.LocalDateTime;

public class Feedback {
    private long feedbackId;
    private long complaintId;
    private int customerId;
    private int rating;
    private String comment;
    private String sentiment;
    private LocalDateTime submittedDate;
    private LocalDateTime createdAt;

    // Constructors
    public Feedback() {}

    public Feedback(long feedbackId, long complaintId, int customerId, int rating, String comment, String sentiment, LocalDateTime createdAt) {
        this.feedbackId = feedbackId;
        this.complaintId = complaintId;
        this.customerId = customerId;
        this.rating = rating;
        this.comment = comment;
        this.sentiment = sentiment;
        this.createdAt = createdAt;
        this.submittedDate = createdAt;
    }

    // Getters and Setters
    public long getFeedbackId() { return feedbackId; }
    public void setFeedbackId(long feedbackId) { this.feedbackId = feedbackId; }
    public long getComplaintId() { return complaintId; }
    public void setComplaintId(long complaintId) { this.complaintId = complaintId; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public String getSentiment() { return sentiment; }
    public void setSentiment(String sentiment) { this.sentiment = sentiment; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getSubmittedDate() { return submittedDate; }
    public void setSubmittedDate(LocalDateTime submittedDate) { this.submittedDate = submittedDate; }
}