package lk.smartlanka.ccs.model;

import java.sql.Timestamp;
import java.util.Date;

public class Assignment {
    private long assignmentId;
    private long complaintId;
    private int assignedTo;
    private int assignedBy;
    private Timestamp deadline;
    private String notes;
    private Timestamp createdAt;

    // Constructors
    public Assignment() {}

    public Assignment(long assignmentId, long complaintId, int assignedTo, int assignedBy, Timestamp deadline, String notes, Timestamp createdAt) {
        this.assignmentId = assignmentId;
        this.complaintId = complaintId;
        this.assignedTo = assignedTo;
        this.assignedBy = assignedBy;
        this.deadline = deadline;
        this.notes = notes;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public long getAssignmentId() { return assignmentId; }
    public void setAssignmentId(long assignmentId) { this.assignmentId = assignmentId; }
    public long getComplaintId() { return complaintId; }
    public void setComplaintId(long complaintId) { this.complaintId = complaintId; }
    public int getAssignedTo() { return assignedTo; }
    public void setAssignedTo(int assignedTo) { this.assignedTo = assignedTo; }
    public int getAssignedBy() { return assignedBy; }
    public void setAssignedBy(int assignedBy) { this.assignedBy = assignedBy; }
    public Timestamp getDeadline() { return deadline; }
    public void setDeadline(Timestamp deadline) { this.deadline = deadline; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}