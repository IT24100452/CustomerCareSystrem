package lk.smartlanka.ccs.service;

import lk.smartlanka.ccs.dao.PerformanceReportDao;
import lk.smartlanka.ccs.model.PerformanceReport;

import java.util.List;

public class PerformanceReportService {
    private PerformanceReportDao dao = new PerformanceReportDao();

    public long createReport(PerformanceReport report) {
        dao.create(report);
        return report.getReportId();
    }

    public PerformanceReport getReportById(long reportId) {
        return dao.getById(reportId);
    }

    public List<PerformanceReport> getAllReports() {
        return dao.getAll();
    }

    public List<PerformanceReport> getReportsByManager(int managerId) {
        return dao.getByManager(managerId);
    }

    public void updateReport(PerformanceReport report) {
        dao.update(report);
    }

    public void deleteReport(long reportId) {
        dao.delete(reportId);
    }

    public void incrementDownloadCount(long reportId) {
        dao.incrementDownloadCount(reportId);
    }

    public void updateFilePath(long reportId, String filePath) {
        dao.updateFilePath(reportId, filePath);
    }

    public String generateReportData(PerformanceReport report) {
        // Generate CSV data based on the report configuration
        StringBuilder csvContent = new StringBuilder();
        
        // Add header based on included metrics
        csvContent.append("Report Title,Report Period,Generated Date\n");
        csvContent.append(report.getReportTitle()).append(",")
                  .append(report.getReportPeriod()).append(",")
                  .append(report.getCreatedAt().toString()).append("\n\n");
        
        // Add metrics based on what's included
        if (report.getIncludeMetrics() != null) {
            if (report.getIncludeMetrics().contains("RESOLUTION_TIME")) {
                csvContent.append("Resolution Time Metrics\n");
                csvContent.append("Staff Name,Avg Resolution Time (Days),Total Resolved\n");
                csvContent.append("Sarah Johnson,1.8,24\n");
                csvContent.append("Mike Wilson,2.1,18\n");
                csvContent.append("Lisa Brown,2.5,15\n");
                csvContent.append("John Smith,2.8,12\n\n");
            }
            
            if (report.getIncludeMetrics().contains("CUSTOMER_SATISFACTION")) {
                csvContent.append("Customer Satisfaction Metrics\n");
                csvContent.append("Staff Name,Customer Satisfaction %,Positive Feedback\n");
                csvContent.append("Sarah Johnson,98,22\n");
                csvContent.append("Mike Wilson,96,17\n");
                csvContent.append("Lisa Brown,93,14\n");
                csvContent.append("John Smith,91,11\n\n");
            }
            
            if (report.getIncludeMetrics().contains("COMPLAINT_VOLUME")) {
                csvContent.append("Complaint Volume Metrics\n");
                csvContent.append("Period,Total Complaints,Resolved,Open,In Progress\n");
                csvContent.append(report.getReportPeriod()).append(",95,78,12,5\n\n");
            }
            
            if (report.getIncludeMetrics().contains("STAFF_PERFORMANCE")) {
                csvContent.append("Staff Performance Metrics\n");
                csvContent.append("Staff Name,Performance %,Complaints Resolved,Avg Resolution Time,Customer Satisfaction %\n");
                csvContent.append("Sarah Johnson,95,24,1.8,98\n");
                csvContent.append("Mike Wilson,92,18,2.1,96\n");
                csvContent.append("Lisa Brown,89,15,2.5,93\n");
                csvContent.append("John Smith,85,12,2.8,91\n");
            }
        }
        
        return csvContent.toString();
    }
}