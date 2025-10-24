package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.smartlanka.ccs.model.MarketingReport;
import lk.smartlanka.ccs.model.Feedback;
import lk.smartlanka.ccs.service.MarketingReportService;
import lk.smartlanka.ccs.service.FeedbackService;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MarketingServlet extends HttpServlet {
    private MarketingReportService reportService = new MarketingReportService();
    private FeedbackService feedbackService = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("dashboard".equals(action)) {
                // Show marketing dashboard with feedback data
                try {
                    List<Feedback> recentFeedback = feedbackService.getAllFeedback();
                    req.setAttribute("recentFeedback", recentFeedback);
                    req.setAttribute("totalFeedback", recentFeedback.size());
                    
                    // Calculate feedback sentiment analysis
                    int positiveCount = 0;
                    int negativeCount = 0;
                    int neutralCount = 0;
                    
                    for (Feedback feedback : recentFeedback) {
                        if (feedback.getSentiment() != null) {
                            switch (feedback.getSentiment().toLowerCase()) {
                                case "positive":
                                    positiveCount++;
                                    break;
                                case "negative":
                                    negativeCount++;
                                    break;
                                case "neutral":
                                default:
                                    neutralCount++;
                                    break;
                            }
                        } else {
                            neutralCount++;
                        }
                    }
                    
                    req.setAttribute("positiveFeedback", positiveCount);
                    req.setAttribute("negativeFeedback", negativeCount);
                    req.setAttribute("neutralFeedback", neutralCount);
                    
                } catch (Exception e) {
                    System.err.println("[MarketingServlet] Error loading feedback data: " + e.getMessage());
                    req.setAttribute("recentFeedback", new ArrayList<>());
                    req.setAttribute("totalFeedback", 0);
                    req.setAttribute("positiveFeedback", 0);
                    req.setAttribute("negativeFeedback", 0);
                    req.setAttribute("neutralFeedback", 0);
                }
                req.getRequestDispatcher("/WEB-INF/views/marketing/dashboard.jsp").forward(req, resp);
            } else if ("reports".equals(action)) {
                // Show marketing reports management page with dynamic data
                int marketingExecutiveId = (Integer) req.getSession().getAttribute("userId");
                System.out.println("[MarketingServlet] Loading reports for marketing executive ID: " + marketingExecutiveId);
                List<MarketingReport> reports;
                
                try {
                    reports = reportService.getReportsByMarketingExecutive(marketingExecutiveId);
                    System.out.println("[MarketingServlet] Successfully loaded " + (reports != null ? reports.size() : 0) + " reports from database");
                } catch (Exception e) {
                    System.err.println("[MarketingServlet] Database error loading reports: " + e.getMessage());
                    e.printStackTrace();
                    reports = createSampleReports(marketingExecutiveId);
                    System.out.println("[MarketingServlet] Using sample data: " + reports.size() + " reports");
                }
                
                req.setAttribute("reports", reports);
                req.getRequestDispatcher("/WEB-INF/views/marketing/manage_reports.jsp").forward(req, resp);
            } else if ("create".equals(action)) {
                // Show create report form
                req.getRequestDispatcher("/WEB-INF/views/marketing/create_report.jsp").forward(req, resp);
            } else if ("view".equals(action)) {
                // View specific report
                long reportId = Long.parseLong(req.getParameter("id"));
                MarketingReport report;
                
                try {
                    report = reportService.getReportById(reportId);
                } catch (Exception e) {
                    System.err.println("[MarketingServlet] Database error loading report: " + e.getMessage());
                    report = createSampleReport(reportId);
                }
                
                req.setAttribute("report", report);
                req.getRequestDispatcher("/WEB-INF/views/marketing/report_view.jsp").forward(req, resp);
            } else if ("edit".equals(action)) {
                // Edit specific report
                long reportId = Long.parseLong(req.getParameter("id"));
                MarketingReport report;
                
                try {
                    report = reportService.getReportById(reportId);
                } catch (Exception e) {
                    System.err.println("[MarketingServlet] Database error loading report for edit: " + e.getMessage());
                    report = createSampleReport(reportId);
                }
                
                req.setAttribute("report", report);
                req.getRequestDispatcher("/WEB-INF/views/marketing/report_edit.jsp").forward(req, resp);
            } else if ("download".equals(action)) {
                // Download specific report
                long reportId = Long.parseLong(req.getParameter("id"));
                downloadSpecificReport(req, resp, reportId);
            } else if ("delete".equals(action)) {
                // Delete specific report
                long reportId = Long.parseLong(req.getParameter("id"));
                deleteReport(req, resp, reportId);
            } else {
                // Default to dashboard
                req.getRequestDispatcher("/WEB-INF/views/marketing/dashboard.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            System.err.println("Error in MarketingServlet doGet: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dashboard?error=marketing_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        try {
            if ("create".equals(action)) {
                // Handle report creation
                createMarketingReport(req, resp);
            } else if ("update".equals(action)) {
                // Handle report update
                updateMarketingReport(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/marketing?action=reports&error=invalid_action");
            }
        } catch (Exception e) {
            System.err.println("Error in MarketingServlet doPost: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/marketing?action=reports&error=server_error");
        }
    }

    private void createMarketingReport(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String type = req.getParameter("type");
        String periodStartStr = req.getParameter("periodStart");
        String periodEndStr = req.getParameter("periodEnd");
        String description = req.getParameter("description");
        
        // Validate required fields
        if (type == null || type.trim().isEmpty() ||
            periodStartStr == null || periodStartStr.trim().isEmpty() ||
            periodEndStr == null || periodEndStr.trim().isEmpty() ||
            description == null || description.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/marketing?action=create&error=validation_error");
            return;
        }
        
        try {
            int marketingExecutiveId = (Integer) req.getSession().getAttribute("userId");
            
            MarketingReport report = new MarketingReport(marketingExecutiveId, type, 
                                                       Date.valueOf(periodStartStr), 
                                                       Date.valueOf(periodEndStr), 
                                                       description.trim());
            
            long reportId = reportService.createReport(report);
            resp.sendRedirect(req.getContextPath() + "/marketing?action=reports&status=created&id=" + reportId);
        } catch (Exception e) {
            System.err.println("Error creating marketing report: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/marketing?action=create&error=server_error");
        }
    }

    private void updateMarketingReport(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        long reportId = Long.parseLong(req.getParameter("reportId"));
        String type = req.getParameter("type");
        String periodStartStr = req.getParameter("periodStart");
        String periodEndStr = req.getParameter("periodEnd");
        String description = req.getParameter("description");
        
        // Validate required fields
        if (type == null || type.trim().isEmpty() ||
            periodStartStr == null || periodStartStr.trim().isEmpty() ||
            periodEndStr == null || periodEndStr.trim().isEmpty() ||
            description == null || description.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/marketing?action=edit&id=" + reportId + "&error=validation_error");
            return;
        }
        
        try {
            MarketingReport report = new MarketingReport();
            report.setReportId(reportId);
            report.setType(type);
            report.setPeriodStart(Date.valueOf(periodStartStr));
            report.setPeriodEnd(Date.valueOf(periodEndStr));
            report.setDescription(description.trim());
            
            reportService.updateReport(report);
            resp.sendRedirect(req.getContextPath() + "/marketing?action=reports&status=updated&id=" + reportId);
        } catch (Exception e) {
            System.err.println("Error updating marketing report: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/marketing?action=edit&id=" + reportId + "&error=server_error");
        }
    }

    private void downloadSpecificReport(HttpServletRequest req, HttpServletResponse resp, long reportId) throws IOException {
        try {
            MarketingReport report = reportService.getReportById(reportId);
            if (report == null) {
                resp.sendRedirect(req.getContextPath() + "/marketing?action=reports&error=report_not_found");
                return;
            }
            
            // Set response headers for CSV download
            resp.setContentType("text/csv");
            resp.setHeader("Content-Disposition", "attachment; filename=\"marketing_report_" + reportId + ".csv\"");
            
            // Generate CSV content based on the report configuration
            String csvContent = reportService.generateReportData(report);
            resp.getWriter().write(csvContent);
        } catch (Exception e) {
            System.err.println("Error downloading report: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/marketing?action=reports&error=download_error");
        }
    }

    private void deleteReport(HttpServletRequest req, HttpServletResponse resp, long reportId) throws IOException {
        try {
            reportService.deleteReport(reportId);
            resp.sendRedirect(req.getContextPath() + "/marketing?action=reports&status=deleted&id=" + reportId);
        } catch (Exception e) {
            System.err.println("Error deleting report: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/marketing?action=reports&error=delete_error");
        }
    }

    // Sample data creation methods for demo purposes
    private List<MarketingReport> createSampleReports(int marketingExecutiveId) {
        List<MarketingReport> reports = new ArrayList<>();
        
        MarketingReport report1 = new MarketingReport(marketingExecutiveId, "CAMPAIGN", 
                                                    Date.valueOf("2024-10-01"), Date.valueOf("2024-10-31"), 
                                                    "Q4 2024 Product Launch Campaign Analysis");
        report1.setReportId(1);
        report1.setCreatedAt(java.sql.Timestamp.valueOf(LocalDateTime.now().minusDays(15)));
        reports.add(report1);
        
        MarketingReport report2 = new MarketingReport(marketingExecutiveId, "ANALYTICS", 
                                                    Date.valueOf("2024-11-01"), Date.valueOf("2024-11-30"), 
                                                    "November 2024 Website Analytics Report");
        report2.setReportId(2);
        report2.setCreatedAt(java.sql.Timestamp.valueOf(LocalDateTime.now().minusDays(10)));
        reports.add(report2);
        
        MarketingReport report3 = new MarketingReport(marketingExecutiveId, "SOCIAL_MEDIA", 
                                                    Date.valueOf("2024-12-01"), Date.valueOf("2024-12-15"), 
                                                    "December 2024 Social Media Performance");
        report3.setReportId(3);
        report3.setCreatedAt(java.sql.Timestamp.valueOf(LocalDateTime.now().minusDays(5)));
        reports.add(report3);
        
        MarketingReport report4 = new MarketingReport(marketingExecutiveId, "EMAIL_MARKETING", 
                                                    Date.valueOf("2024-11-15"), Date.valueOf("2024-12-15"), 
                                                    "Holiday Email Marketing Campaign Results");
        report4.setReportId(4);
        report4.setCreatedAt(java.sql.Timestamp.valueOf(LocalDateTime.now().minusDays(3)));
        reports.add(report4);
        
        return reports;
    }
    
    private MarketingReport createSampleReport(long reportId) {
        MarketingReport report = new MarketingReport(1, "CAMPAIGN", 
                                                   Date.valueOf("2024-12-01"), Date.valueOf("2024-12-31"), 
                                                   "Sample Marketing Report for Demonstration");
        report.setReportId(reportId);
        report.setCreatedAt(java.sql.Timestamp.valueOf(LocalDateTime.now()));
        return report;
    }
}
