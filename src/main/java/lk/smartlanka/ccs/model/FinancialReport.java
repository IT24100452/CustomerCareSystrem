package lk.smartlanka.ccs.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class FinancialReport {
    private long reportId;
    private String title;
    private String reportType;
    private Date periodStart;
    private Date periodEnd;
    private BigDecimal totalRevenue;
    private BigDecimal totalCosts;
    private BigDecimal netProfit;
    private BigDecimal complaintCosts;
    private BigDecimal resolutionCosts;
    private String summary;
    private int createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public FinancialReport() {}

    public FinancialReport(String title, String reportType, Date periodStart, Date periodEnd) {
        this.title = title;
        this.reportType = reportType;
        this.periodStart = periodStart;
        this.periodEnd = periodEnd;
    }

    // Getters and Setters
    public long getReportId() { return reportId; }
    public void setReportId(long reportId) { this.reportId = reportId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }

    public Date getPeriodStart() { return periodStart; }
    public void setPeriodStart(Date periodStart) { this.periodStart = periodStart; }

    public Date getPeriodEnd() { return periodEnd; }
    public void setPeriodEnd(Date periodEnd) { this.periodEnd = periodEnd; }

    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }

    public BigDecimal getTotalCosts() { return totalCosts; }
    public void setTotalCosts(BigDecimal totalCosts) { this.totalCosts = totalCosts; }

    public BigDecimal getNetProfit() { return netProfit; }
    public void setNetProfit(BigDecimal netProfit) { this.netProfit = netProfit; }

    public BigDecimal getComplaintCosts() { return complaintCosts; }
    public void setComplaintCosts(BigDecimal complaintCosts) { this.complaintCosts = complaintCosts; }

    public BigDecimal getResolutionCosts() { return resolutionCosts; }
    public void setResolutionCosts(BigDecimal resolutionCosts) { this.resolutionCosts = resolutionCosts; }

    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    // Helper methods
    public String getReportTypeDisplayName() {
        if (reportType == null) return "Unknown";
        switch (reportType.toUpperCase()) {
            case "MONTHLY": return "Monthly Report";
            case "QUARTERLY": return "Quarterly Report";
            case "ANNUAL": return "Annual Report";
            case "CUSTOM": return "Custom Period Report";
            default: return reportType;
        }
    }

    public BigDecimal calculateNetProfit() {
        if (totalRevenue != null && totalCosts != null) {
            return totalRevenue.subtract(totalCosts);
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal calculateProfitMargin() {
        if (totalRevenue != null && totalRevenue.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal profit = calculateNetProfit();
            return profit.divide(totalRevenue, 4, java.math.RoundingMode.HALF_UP).multiply(new BigDecimal("100"));
        }
        return BigDecimal.ZERO;
    }

    public String getPeriodDisplayName() {
        if (periodStart != null && periodEnd != null) {
            return periodStart.toString() + " to " + periodEnd.toString();
        }
        return "No period specified";
    }
}