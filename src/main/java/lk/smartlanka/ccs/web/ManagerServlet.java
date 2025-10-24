package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.smartlanka.ccs.model.Complaint;
import lk.smartlanka.ccs.model.Feedback;
import lk.smartlanka.ccs.model.PerformanceReport;
import lk.smartlanka.ccs.service.ComplaintService;
import lk.smartlanka.ccs.service.FeedbackService;
import lk.smartlanka.ccs.service.PerformanceReportService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ManagerServlet extends HttpServlet {
    private ComplaintService complaintService = new ComplaintService();
    private FeedbackService feedbackService = new FeedbackService();
    private PerformanceReportService reportService = new PerformanceReportService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("performance".equals(action)) {
                // Show performance tracking page
                req.getRequestDispatcher("/WEB-INF/views/manager/performance_tracking.jsp").forward(req, resp);
            } else if ("reports".equals(action)) {
                // Show performance reports management page with dynamic data
                int managerId = (Integer) req.getSession().getAttribute("userId");
                System.out.println("[ManagerServlet] Loading reports for manager ID: " + managerId);
                List<PerformanceReport> reports;
                
                try {
                    reports = reportService.getReportsByManager(managerId);
                    System.out.println("[ManagerServlet] Successfully loaded " + (reports != null ? reports.size() : 0) + " reports from database");
                } catch (Exception e) {
                    System.err.println("[ManagerServlet] Database error loading reports: " + e.getMessage());
                    e.printStackTrace();
                    reports = createSampleReports(managerId);
                    System.out.println("[ManagerServlet] Using sample data: " + reports.size() + " reports");
                }
                
                req.setAttribute("reports", reports);
                req.getRequestDispatcher("/WEB-INF/views/manager/performance_reports.jsp").forward(req, resp);
            } else if ("download".equals(action)) {
                // Show download page or handle CSV download
                handleCsvDownload(req, resp);
            } else if ("viewReport".equals(action)) {
                // View specific report
                long reportId = Long.parseLong(req.getParameter("id"));
                PerformanceReport report;
                
                try {
                    report = reportService.getReportById(reportId);
                } catch (Exception e) {
                    System.err.println("Database error loading report: " + e.getMessage());
                    report = createSampleReport(reportId);
                }
                
                req.setAttribute("report", report);
                req.getRequestDispatcher("/WEB-INF/views/manager/report_view.jsp").forward(req, resp);
            } else if ("editReport".equals(action)) {
                // Edit specific report
                long reportId = Long.parseLong(req.getParameter("id"));
                PerformanceReport report;
                
                try {
                    report = reportService.getReportById(reportId);
                } catch (Exception e) {
                    System.err.println("Database error loading report for edit: " + e.getMessage());
                    report = createSampleReport(reportId);
                }
                
                req.setAttribute("report", report);
                req.getRequestDispatcher("/WEB-INF/views/manager/report_edit.jsp").forward(req, resp);
            } else if ("downloadReport".equals(action)) {
                // Download specific report
                long reportId = Long.parseLong(req.getParameter("id"));
                downloadSpecificReport(req, resp, reportId);
            } else if ("deleteReport".equals(action)) {
                // Delete specific report
                long reportId = Long.parseLong(req.getParameter("id"));
                deleteReport(req, resp, reportId);
            } else {
                // Default to performance tracking
                req.getRequestDispatcher("/WEB-INF/views/manager/performance_tracking.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            System.err.println("Error in ManagerServlet doGet: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dashboard?error=manager_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        try {
            if ("createReport".equals(action)) {
                // Handle report creation
                createPerformanceReport(req, resp);
            } else if ("updateReport".equals(action)) {
                // Handle report update
                updatePerformanceReport(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/manager?action=reports&error=invalid_action");
            }
        } catch (Exception e) {
            System.err.println("Error in ManagerServlet doPost: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/manager?action=reports&error=server_error");
        }
    }

    private void handleCsvDownload(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // Set response headers for CSV download
        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment; filename=\"performance_report_" + 
                     LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) + ".csv\"");

        // Generate CSV content
        StringBuilder csvContent = new StringBuilder();
        csvContent.append("Staff Name,Performance %,Complaints Resolved,Avg Resolution Time (Days),Customer Satisfaction %\n");
        csvContent.append("Sarah Johnson,95,24,1.8,98\n");
        csvContent.append("Mike Wilson,92,18,2.1,96\n");
        csvContent.append("Lisa Brown,89,15,2.5,93\n");
        csvContent.append("John Smith,85,12,2.8,91\n");
        csvContent.append("Emma Davis,88,16,2.2,94\n");
        csvContent.append("David Lee,82,10,3.1,89\n");

        resp.getWriter().write(csvContent.toString());
    }

    private void downloadSpecificReport(HttpServletRequest req, HttpServletResponse resp, long reportId) throws IOException {
        try {
            PerformanceReport report = reportService.getReportById(reportId);
            if (report == null) {
                resp.sendRedirect(req.getContextPath() + "/manager?action=reports&error=report_not_found");
                return;
            }
            
            // Increment download count
            reportService.incrementDownloadCount(reportId);
            
            // Set response headers for CSV download
            resp.setContentType("text/csv");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + report.getReportTitle().replaceAll("[^a-zA-Z0-9]", "_") + ".csv\"");
            
            // Generate CSV content based on the report configuration
            String csvContent = reportService.generateReportData(report);
            resp.getWriter().write(csvContent);
        } catch (Exception e) {
            System.err.println("Error downloading report: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/manager?action=reports&error=download_error");
        }
    }

    private void deleteReport(HttpServletRequest req, HttpServletResponse resp, long reportId) throws IOException {
        try {
            reportService.deleteReport(reportId);
            resp.sendRedirect(req.getContextPath() + "/manager?action=reports&status=deleted&id=" + reportId);
        } catch (Exception e) {
            System.err.println("Error deleting report: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/manager?action=reports&error=delete_error");
        }
    }

    private void createPerformanceReport(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String reportTitle = req.getParameter("reportTitle");
        String reportType = req.getParameter("reportType");
        String reportPeriod = req.getParameter("reportPeriod");
        String reportFormat = req.getParameter("reportFormat");
        String reportDescription = req.getParameter("reportDescription");
        String[] includeMetrics = req.getParameterValues("includeMetrics");
        
        // Validate required fields
        if (reportTitle == null || reportTitle.trim().isEmpty() ||
            reportType == null || reportType.trim().isEmpty() ||
            reportPeriod == null || reportPeriod.trim().isEmpty() ||
            reportFormat == null || reportFormat.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/manager?action=reports&error=validation_error");
            return;
        }
        
        try {
            int managerId = (Integer) req.getSession().getAttribute("userId");
            String metricsString = includeMetrics != null ? String.join(",", includeMetrics) : "";
            
            PerformanceReport report = new PerformanceReport(managerId, reportTitle.trim(), reportType, 
                                                           reportPeriod.trim(), reportFormat, 
                                                           reportDescription != null ? reportDescription.trim() : "", 
                                                           metricsString);
            
            long reportId = reportService.createReport(report);
            resp.sendRedirect(req.getContextPath() + "/manager?action=reports&status=created&id=" + reportId);
        } catch (Exception e) {
            System.err.println("Error creating performance report: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/manager?action=reports&error=server_error");
        }
    }

    private void updatePerformanceReport(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        long reportId = Long.parseLong(req.getParameter("reportId"));
        String reportTitle = req.getParameter("reportTitle");
        String reportType = req.getParameter("reportType");
        String reportPeriod = req.getParameter("reportPeriod");
        String reportFormat = req.getParameter("reportFormat");
        String reportDescription = req.getParameter("reportDescription");
        String[] includeMetrics = req.getParameterValues("includeMetrics");
        
        // Validate required fields
        if (reportTitle == null || reportTitle.trim().isEmpty() ||
            reportType == null || reportType.trim().isEmpty() ||
            reportPeriod == null || reportPeriod.trim().isEmpty() ||
            reportFormat == null || reportFormat.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/manager?action=editReport&id=" + reportId + "&error=validation_error");
            return;
        }
        
        try {
            String metricsString = includeMetrics != null ? String.join(",", includeMetrics) : "";
            
            PerformanceReport report = new PerformanceReport();
            report.setReportId(reportId);
            report.setReportTitle(reportTitle.trim());
            report.setReportType(reportType);
            report.setReportPeriod(reportPeriod.trim());
            report.setReportFormat(reportFormat);
            report.setReportDescription(reportDescription != null ? reportDescription.trim() : "");
            report.setIncludeMetrics(metricsString);
            
            reportService.updateReport(report);
            resp.sendRedirect(req.getContextPath() + "/manager?action=reports&status=updated&id=" + reportId);
        } catch (Exception e) {
            System.err.println("Error updating performance report: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/manager?action=editReport&id=" + reportId + "&error=server_error");
        }
    }

    // Sample data creation methods for demo purposes
    private List<PerformanceReport> createSampleReports(int managerId) {
        List<PerformanceReport> reports = new ArrayList<>();
        
        PerformanceReport report1 = new PerformanceReport(managerId, "Q4 2024 Performance Report", "QUARTERLY", 
                                                        "Q4 2024", "PDF", 
                                                        "Comprehensive quarterly performance analysis covering staff productivity, customer satisfaction metrics, and resolution time trends.",
                                                        "RESOLUTION_TIME,CUSTOMER_SATISFACTION,COMPLAINT_VOLUME,STAFF_PERFORMANCE");
        report1.setReportId(1);
        report1.setDownloadCount(12);
        report1.setCreatedAt(LocalDateTime.now().minusDays(15));
        reports.add(report1);
        
        PerformanceReport report2 = new PerformanceReport(managerId, "November 2024 Monthly Report", "MONTHLY", 
                                                        "November 2024", "CSV", 
                                                        "Monthly performance summary with detailed staff metrics, customer feedback analysis, and operational efficiency indicators.",
                                                        "RESOLUTION_TIME,CUSTOMER_SATISFACTION,STAFF_PERFORMANCE");
        report2.setReportId(2);
        report2.setDownloadCount(8);
        report2.setCreatedAt(LocalDateTime.now().minusDays(30));
        reports.add(report2);
        
        PerformanceReport report3 = new PerformanceReport(managerId, "2024 Annual Performance Review", "ANNUAL", 
                                                        "2024", "EXCEL", 
                                                        "Comprehensive annual performance analysis including year-over-year comparisons, trend analysis, and strategic recommendations.",
                                                        "RESOLUTION_TIME,CUSTOMER_SATISFACTION,COMPLAINT_VOLUME,STAFF_PERFORMANCE");
        report3.setReportId(3);
        report3.setDownloadCount(5);
        report3.setCreatedAt(LocalDateTime.now().minusDays(10));
        reports.add(report3);
        
        PerformanceReport report4 = new PerformanceReport(managerId, "Customer Satisfaction Analysis", "CUSTOM", 
                                                        "Oct-Nov 2024", "HTML", 
                                                        "Specialized report focusing on customer satisfaction trends, feedback analysis, and service quality improvements.",
                                                        "CUSTOMER_SATISFACTION");
        report4.setReportId(4);
        report4.setDownloadCount(15);
        report4.setCreatedAt(LocalDateTime.now().minusDays(20));
        reports.add(report4);
        
        return reports;
    }
    
    private PerformanceReport createSampleReport(long reportId) {
        PerformanceReport report = new PerformanceReport(1, "Sample Performance Report", "MONTHLY", 
                                                        "December 2024", "PDF", 
                                                        "This is a sample performance report for demonstration purposes.",
                                                        "RESOLUTION_TIME,CUSTOMER_SATISFACTION,STAFF_PERFORMANCE");
        report.setReportId(reportId);
        report.setDownloadCount(0);
        report.setCreatedAt(LocalDateTime.now());
        return report;
    }
}
