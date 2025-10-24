package lk.smartlanka.ccs.model;

import java.time.LocalDateTime;

public class PerformanceReport {
    private long reportId;
    private int generatedBy;
    private String reportTitle;
    private String reportType;
    private String reportPeriod;
    private String reportFormat;
    private String reportDescription;
    private String includeMetrics;
    private int downloadCount;
    private LocalDateTime createdAt;

    // Constructors
    public PerformanceReport() {}

    public PerformanceReport(int generatedBy, String reportTitle, String reportType, 
                           String reportPeriod, String reportFormat, String reportDescription, 
                           String includeMetrics) {
        this.generatedBy = generatedBy;
        this.reportTitle = reportTitle;
        this.reportType = reportType;
        this.reportPeriod = reportPeriod;
        this.reportFormat = reportFormat;
        this.reportDescription = reportDescription;
        this.includeMetrics = includeMetrics;
    }

    // Getters and Setters
    public long getReportId() {
        return reportId;
    }

    public void setReportId(long reportId) {
        this.reportId = reportId;
    }

    public int getGeneratedBy() {
        return generatedBy;
    }

    public void setGeneratedBy(int generatedBy) {
        this.generatedBy = generatedBy;
    }

    public String getReportTitle() {
        return reportTitle;
    }

    public void setReportTitle(String reportTitle) {
        this.reportTitle = reportTitle;
    }

    public String getReportType() {
        return reportType;
    }

    public void setReportType(String reportType) {
        this.reportType = reportType;
    }

    public String getReportPeriod() {
        return reportPeriod;
    }

    public void setReportPeriod(String reportPeriod) {
        this.reportPeriod = reportPeriod;
    }

    public String getReportFormat() {
        return reportFormat;
    }

    public void setReportFormat(String reportFormat) {
        this.reportFormat = reportFormat;
    }

    public String getReportDescription() {
        return reportDescription;
    }

    public void setReportDescription(String reportDescription) {
        this.reportDescription = reportDescription;
    }

    public String getIncludeMetrics() {
        return includeMetrics;
    }

    public void setIncludeMetrics(String includeMetrics) {
        this.includeMetrics = includeMetrics;
    }

    public void setFilePath(String filePath) {
    }

    public int getDownloadCount() {
        return downloadCount;
    }

    public void setDownloadCount(int downloadCount) {
        this.downloadCount = downloadCount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
    }


















    // Helper methods
    public String getReportTypeDisplayName() {
        if (reportType == null) return "Unknown";
        switch (reportType) {
            case "MONTHLY": return "Monthly";
            case "QUARTERLY": return "Quarterly";
            case "ANNUAL": return "Annual";
            case "CUSTOM": return "Custom";
            default: return reportType;
        }
    }

    public String getReportFormatDisplayName() {
        if (reportFormat == null) return "Unknown";
        switch (reportFormat) {
            case "PDF": return "PDF Document";
            case "CSV": return "CSV Spreadsheet";
            case "EXCEL": return "Excel Workbook";
            case "HTML": return "HTML Report";
            default: return reportFormat;
        }
    }

    @Override
    public String toString() {
        return "PerformanceReport{" +
                "reportId=" + reportId +
                ", generatedBy=" + generatedBy +
                ", reportTitle='" + reportTitle + '\'' +
                ", reportType='" + reportType + '\'' +
                ", reportPeriod='" + reportPeriod + '\'' +
                ", reportFormat='" + reportFormat + '\'' +
                ", downloadCount=" + downloadCount +
                ", createdAt=" + createdAt +
                '}';
    }
}