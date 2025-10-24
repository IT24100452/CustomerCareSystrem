package lk.smartlanka.ccs.model;

import java.sql.Date;
import java.sql.Timestamp;

public class MarketingReport {
    private long reportId;
    private int generatedBy;
    private String type;
    private Date periodStart;
    private Date periodEnd;
    private String description;
    private Timestamp createdAt;

    // Constructors
    public MarketingReport() {}

    public MarketingReport(int generatedBy, String type, Date periodStart, Date periodEnd, String description) {
        this.generatedBy = generatedBy;
        this.type = type;
        this.periodStart = periodStart;
        this.periodEnd = periodEnd;
        this.description = description;
    }

    // Getters
    public long getReportId() { return reportId; }
    public int getGeneratedBy() { return generatedBy; }
    public String getType() { return type; }
    public Date getPeriodStart() { return periodStart; }
    public Date getPeriodEnd() { return periodEnd; }
    public String getDescription() { return description; }
    public Timestamp getCreatedAt() { return createdAt; }

    // Setters
    public void setReportId(long reportId) { this.reportId = reportId; }
    public void setGeneratedBy(int generatedBy) { this.generatedBy = generatedBy; }
    public void setType(String type) { this.type = type; }
    public void setPeriodStart(Date periodStart) { this.periodStart = periodStart; }
    public void setPeriodEnd(Date periodEnd) { this.periodEnd = periodEnd; }
    public void setDescription(String description) { this.description = description; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }




















    // Helper methods
    public String getTypeDisplayName() {
        if (type == null) return "Unknown";
        switch (type) {
            case "CAMPAIGN": return "Campaign Report";
            case "ANALYTICS": return "Analytics Report";
            case "SOCIAL_MEDIA": return "Social Media Report";
            case "EMAIL_MARKETING": return "Email Marketing Report";
            case "CUSTOMER_ANALYSIS": return "Customer Analysis Report";
            default: return type;
        }
    }

    public String getPeriodDisplay() {
        if (periodStart == null || periodEnd == null) return "No period set";
        return periodStart.toString() + " to " + periodEnd.toString();
    }

    @Override
    public String toString() {
        return "MarketingReport{" +
                "reportId=" + reportId +
                ", generatedBy=" + generatedBy +
                ", type='" + type + '\'' +
                ", periodStart=" + periodStart +
                ", periodEnd=" + periodEnd +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}