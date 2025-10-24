package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.smartlanka.ccs.model.Feedback;
import lk.smartlanka.ccs.service.FeedbackService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/marketing-dashboard/*")
public class MarketingDashboardServlet extends HttpServlet {
    private FeedbackService feedbackService = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Default to dashboard
            loadMarketingDashboard(req);
            req.getRequestDispatcher("/WEB-INF/views/marketing/dashboard.jsp").forward(req, resp);
        } else {
            String action = pathInfo.substring(1); // Remove leading slash
            
            switch (action) {
                case "view-feedback-metrics":
                    loadFeedbackMetrics(req);
                    req.getRequestDispatcher("/WEB-INF/views/marketing/view_feedback_metrics.jsp").forward(req, resp);
                    break;
                    
                case "create-report":
                    req.getRequestDispatcher("/WEB-INF/views/marketing/create_report.jsp").forward(req, resp);
                    break;
                    
                case "manage-reports":
                    req.getRequestDispatcher("/WEB-INF/views/marketing/manage_reports.jsp").forward(req, resp);
                    break;
                    
                case "dashboard":
                    loadMarketingDashboard(req);
                    req.getRequestDispatcher("/WEB-INF/views/marketing/dashboard.jsp").forward(req, resp);
                    break;
                    
                case "report-view":
                    // Handle report view
                    req.getRequestDispatcher("/WEB-INF/views/marketing/report_view.jsp").forward(req, resp);
                    break;
                    
                case "report-edit":
                    // Handle report edit
                    req.getRequestDispatcher("/WEB-INF/views/marketing/report_edit.jsp").forward(req, resp);
                    break;
                    
                case "download-report":
                    // Handle CSV/PDF download
                    handleReportDownload(req, resp);
                    break;
                    
                default:
                    // Unknown action, redirect to dashboard
                    resp.sendRedirect(req.getContextPath() + "/marketing-dashboard/dashboard");
                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        
        if (pathInfo != null) {
            String action = pathInfo.substring(1);
            
            switch (action) {
                case "create-report":
                    // Handle report creation
                    resp.sendRedirect(req.getContextPath() + "/marketing-dashboard/manage-reports?status=created");
                    break;
                    
                case "update-report":
                    // Handle report update
                    resp.sendRedirect(req.getContextPath() + "/marketing-dashboard/report-view?id=" + req.getParameter("reportId") + "&status=updated");
                    break;
                    
                default:
                    resp.sendRedirect(req.getContextPath() + "/marketing-dashboard/dashboard");
                    break;
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/marketing-dashboard/dashboard");
        }
    }

    private void loadMarketingDashboard(HttpServletRequest req) {
        try {
            List<Feedback> allFeedback = feedbackService.getAllFeedback();
            List<Feedback> recentFeedback = feedbackService.getRecentFeedback(10);
            
            req.setAttribute("allFeedback", allFeedback);
            req.setAttribute("recentFeedback", recentFeedback);
            req.setAttribute("totalFeedback", allFeedback.size());
            req.setAttribute("avgRating", feedbackService.getAverageRating());
            req.setAttribute("positiveFeedback", feedbackService.getFeedbackBySentiment("POSITIVE").size());
            req.setAttribute("negativeFeedback", feedbackService.getFeedbackBySentiment("NEGATIVE").size());
        } catch (Exception e) {
            System.err.println("Database error loading marketing dashboard: " + e.getMessage());
            // Create sample data for demo purposes
            List<Feedback> sampleFeedback = createSampleMarketingFeedback();
            
            req.setAttribute("allFeedback", sampleFeedback);
            req.setAttribute("recentFeedback", sampleFeedback.size() > 10 ? sampleFeedback.subList(0, 10) : sampleFeedback);
            req.setAttribute("totalFeedback", sampleFeedback.size());
            req.setAttribute("avgRating", 4.2);
            req.setAttribute("positiveFeedback", (int) sampleFeedback.stream().filter(f -> "POSITIVE".equals(f.getSentiment())).count());
            req.setAttribute("negativeFeedback", (int) sampleFeedback.stream().filter(f -> "NEGATIVE".equals(f.getSentiment())).count());
        }
    }

    private void loadFeedbackMetrics(HttpServletRequest req) {
        // Same as dashboard but for feedback metrics page
        loadMarketingDashboard(req);
    }

    private void handleReportDownload(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String reportId = req.getParameter("id");
        String format = req.getParameter("format");
        
        if (format == null || !format.equals("csv")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Only CSV format is supported");
            return;
        }
        
        // Set response headers for CSV download
        resp.setContentType("text/csv");
        resp.setCharacterEncoding("UTF-8");
        
        String fileName = "marketing_report_" + reportId + ".csv";
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        // Generate CSV content
        PrintWriter writer = resp.getWriter();
        
        // CSV Header
        writer.println("Report ID,Title,Type,Campaign,Period,Budget,ROI,Status,Created Date,Description");
        
        // Sample data based on report ID
        String reportData = generateReportData(reportId);
        writer.println(reportData);
        
        writer.flush();
        writer.close();
    }

    private String generateReportData(String reportId) {
        switch (reportId) {
            case "1":
                return "1,Q4 2024 Campaign Analysis,Campaign Report,Holiday Marketing Campaign,Oct 1 - Dec 31 2024,15000,28%,Active,Dec 15 2024,Comprehensive analysis of holiday marketing campaign performance";
            case "2":
                return "2,Social Media Performance Report,Campaign Report,Social Media Campaign,Nov 1 - Nov 30 2024,8500,22%,Draft,Dec 10 2024,Detailed analysis of social media campaign performance";
            case "3":
                return "3,Email Marketing Analysis,Feedback Analysis,Email Campaign,Dec 1 - Dec 15 2024,5200,18%,Published,Dec 20 2024,Analysis of email marketing campaign effectiveness";
            case "4":
                return "4,Customer Acquisition Report,Monthly Summary,Acquisition Campaign,Sep 1 - Sep 30 2024,12000,12%,Archived,Oct 5 2024,Monthly summary of customer acquisition efforts";
            default:
                return reportId + ",Sample Report,General Report,Sample Campaign,Jan 1 - Dec 31 2024,10000,20%,Active,Dec 30 2024,Sample report for demonstration";
        }
    }

    // Sample data creation method for marketing dashboard
    private List<Feedback> createSampleMarketingFeedback() {
        List<Feedback> feedback = new java.util.ArrayList<>();
        
        // Sample feedback 1
        Feedback feedback1 = new Feedback();
        feedback1.setFeedbackId(3001L);
        feedback1.setCustomerId(15);
        feedback1.setRating(5);
        feedback1.setComment("Excellent service! The support team resolved my issue quickly and professionally.");
        feedback1.setSentiment("POSITIVE");
        feedback1.setComplaintId(1001L);
        feedback1.setCreatedAt(java.time.LocalDateTime.now().minusDays(1));
        feedback.add(feedback1);
        
        // Sample feedback 2
        Feedback feedback2 = new Feedback();
        feedback2.setFeedbackId(3002L);
        feedback2.setCustomerId(16);
        feedback2.setRating(4);
        feedback2.setComment("Good service overall, but response time could be improved.");
        feedback2.setSentiment("POSITIVE");
        feedback2.setComplaintId(1002L);
        feedback2.setCreatedAt(java.time.LocalDateTime.now().minusDays(2));
        feedback.add(feedback2);
        
        // Sample feedback 3
        Feedback feedback3 = new Feedback();
        feedback3.setFeedbackId(3003L);
        feedback3.setCustomerId(17);
        feedback3.setRating(2);
        feedback3.setComment("Poor experience. The issue was not resolved and I had to call multiple times.");
        feedback3.setSentiment("NEGATIVE");
        feedback3.setComplaintId(1003L);
        feedback3.setCreatedAt(java.time.LocalDateTime.now().minusDays(3));
        feedback.add(feedback3);
        
        // Sample feedback 4
        Feedback feedback4 = new Feedback();
        feedback4.setFeedbackId(3004L);
        feedback4.setCustomerId(18);
        feedback4.setRating(5);
        feedback4.setComment("Outstanding customer service! The team went above and beyond to help me.");
        feedback4.setSentiment("POSITIVE");
        feedback4.setComplaintId(0L); // Use 0 instead of null for unlinked feedback
        feedback4.setCreatedAt(java.time.LocalDateTime.now().minusDays(4));
        feedback.add(feedback4);
        
        // Sample feedback 5
        Feedback feedback5 = new Feedback();
        feedback5.setFeedbackId(3005L);
        feedback5.setCustomerId(19);
        feedback5.setRating(3);
        feedback5.setComment("Average service. Nothing special but the issue was resolved.");
        feedback5.setSentiment("NEUTRAL");
        feedback5.setComplaintId(1004L);
        feedback5.setCreatedAt(java.time.LocalDateTime.now().minusDays(5));
        feedback.add(feedback5);
        
        // Sample feedback 6
        Feedback feedback6 = new Feedback();
        feedback6.setFeedbackId(3006L);
        feedback6.setCustomerId(20);
        feedback6.setRating(4);
        feedback6.setComment("Good service with friendly staff. Would recommend to others.");
        feedback6.setSentiment("POSITIVE");
        feedback6.setComplaintId(0L); // Use 0 instead of null for unlinked feedback
        feedback6.setCreatedAt(java.time.LocalDateTime.now().minusDays(6));
        feedback.add(feedback6);
        
        // Sample feedback 7
        Feedback feedback7 = new Feedback();
        feedback7.setFeedbackId(3007L);
        feedback7.setCustomerId(21);
        feedback7.setRating(1);
        feedback7.setComment("Terrible experience. Waited for hours and still no resolution.");
        feedback7.setSentiment("NEGATIVE");
        feedback7.setComplaintId(1005L);
        feedback7.setCreatedAt(java.time.LocalDateTime.now().minusDays(7));
        feedback.add(feedback7);
        
        // Sample feedback 8
        Feedback feedback8 = new Feedback();
        feedback8.setFeedbackId(3008L);
        feedback8.setCustomerId(22);
        feedback8.setRating(5);
        feedback8.setComment("Perfect! Quick resolution and excellent communication throughout.");
        feedback8.setSentiment("POSITIVE");
        feedback8.setComplaintId(1006L);
        feedback8.setCreatedAt(java.time.LocalDateTime.now().minusDays(8));
        feedback.add(feedback8);
        
        return feedback;
    }
}
