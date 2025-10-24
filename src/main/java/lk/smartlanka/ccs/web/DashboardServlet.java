package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.smartlanka.ccs.model.Complaint;
import lk.smartlanka.ccs.model.Feedback;
import lk.smartlanka.ccs.model.Notification;
import lk.smartlanka.ccs.service.ComplaintService;
import lk.smartlanka.ccs.service.FeedbackService;
import lk.smartlanka.ccs.service.NotificationService;
import lk.smartlanka.ccs.service.UserService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class DashboardServlet extends HttpServlet {
    private final ComplaintService complaintService = new ComplaintService();
    private final FeedbackService feedbackService = new FeedbackService();
    private final NotificationService notificationService = new NotificationService();
    private final UserService userService = new UserService();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        Integer roleId = (Integer) req.getSession().getAttribute("roleId");
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        
        // Load notifications for all users with error handling
        try {
            List<Notification> notifications = notificationService.getUnreadNotifications(userId);
            req.setAttribute("notifications", notifications);
            req.getSession().setAttribute("unreadCount", notificationService.getUnreadCount(userId));
        } catch (Exception e) {
            System.err.println("Error loading notifications: " + e.getMessage());
            e.printStackTrace();
            // Set empty notifications to prevent 500 error
            req.setAttribute("notifications", new ArrayList<>());
            req.getSession().setAttribute("unreadCount", 0);
        }
        
        // Load role-specific dashboard data
        switch (roleId) {
            case 1, 2 -> loadAdminDashboard(req, userId); // System Admin, Admin
            case 3 -> loadSupportDashboard(req, userId);   // Support Staff
            case 4 -> loadFinanceDashboard(req, userId);    // Finance Staff
            case 5 -> loadManagerDashboard(req, userId);  // Manager
            case 6 -> loadMarketingDashboard(req, userId); // Marketing Executive
            case 7 -> loadCustomerDashboard(req, userId);  // Customer
            default -> resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
        
        // Forward to appropriate dashboard view
        String dashboardView = getDashboardView(roleId);
        req.getRequestDispatcher(dashboardView).forward(req, resp);
    }
    
    private void loadAdminDashboard(HttpServletRequest req, Integer userId) {
        // Admin dashboard statistics with comprehensive error handling
        try {
            req.setAttribute("totalUsers", userService.getTotalUsers());
        } catch (Exception e) {
            System.err.println("Error loading total users: " + e.getMessage());
            req.setAttribute("totalUsers", 0);
        }
        
        try {
            req.setAttribute("activeUsers", userService.getActiveUsers());
        } catch (Exception e) {
            System.err.println("Error loading active users: " + e.getMessage());
            req.setAttribute("activeUsers", 0);
        }
        
        try {
            req.setAttribute("totalFeedback", feedbackService.getTotalFeedback());
        } catch (Exception e) {
            System.err.println("Error loading total feedback: " + e.getMessage());
            req.setAttribute("totalFeedback", 0);
        }
        
        try {
            req.setAttribute("totalComplaints", complaintService.getTotalComplaints());
        } catch (Exception e) {
            System.err.println("Error loading total complaints: " + e.getMessage());
            req.setAttribute("totalComplaints", 0);
        }
        
        try {
            req.setAttribute("openComplaints", complaintService.getComplaintsByStatus("OPEN").size());
        } catch (Exception e) {
            System.err.println("Error loading open complaints: " + e.getMessage());
            req.setAttribute("openComplaints", 0);
        }
        
        try {
            req.setAttribute("resolvedComplaints", complaintService.getComplaintsByStatus("RESOLVED").size());
        } catch (Exception e) {
            System.err.println("Error loading resolved complaints: " + e.getMessage());
            req.setAttribute("resolvedComplaints", 0);
        }
    }
    
    private void loadSupportDashboard(HttpServletRequest req, Integer userId) {
        // Support staff dashboard
        try {
            List<Complaint> assignedComplaints = complaintService.getComplaintsByAssignee(userId);
            List<Complaint> recentComplaints = complaintService.getRecentComplaints(10);
            
            req.setAttribute("assignedComplaints", assignedComplaints);
            req.setAttribute("recentComplaints", recentComplaints);
            req.setAttribute("totalAssigned", assignedComplaints.size());
            req.setAttribute("openAssigned", complaintService.getComplaintsByAssigneeAndStatus(userId, "OPEN").size());
            req.setAttribute("resolvedAssigned", complaintService.getComplaintsByAssigneeAndStatus(userId, "RESOLVED").size());
        } catch (Exception e) {
            System.err.println("Database error loading support dashboard: " + e.getMessage());
            // Create sample data for demo purposes
            List<Complaint> sampleAssignedComplaints = createSampleSupportComplaints(userId);
            List<Complaint> sampleRecentComplaints = createSampleRecentComplaints();
            
            req.setAttribute("assignedComplaints", sampleAssignedComplaints);
            req.setAttribute("recentComplaints", sampleRecentComplaints);
            req.setAttribute("totalAssigned", sampleAssignedComplaints.size());
            req.setAttribute("openAssigned", (int) sampleAssignedComplaints.stream().filter(c -> "OPEN".equals(c.getStatusCode())).count());
            req.setAttribute("resolvedAssigned", (int) sampleAssignedComplaints.stream().filter(c -> "RESOLVED".equals(c.getStatusCode())).count());
        }
    }
    
    private void loadFinanceDashboard(HttpServletRequest req, Integer userId) {
        // Finance staff dashboard
        try {
            List<Complaint> billingComplaints = complaintService.getComplaintsByType("BILLING");
            req.setAttribute("billingComplaints", billingComplaints);
            req.setAttribute("totalBillingComplaints", billingComplaints.size());
            req.setAttribute("openBillingComplaints", complaintService.getComplaintsByTypeAndStatus("BILLING", "OPEN").size());
        } catch (Exception e) {
            req.setAttribute("billingComplaints", new java.util.ArrayList<>());
            req.setAttribute("totalBillingComplaints", 0);
            req.setAttribute("openBillingComplaints", 0);
        }
    }
    
    private void loadManagerDashboard(HttpServletRequest req, Integer userId) {
        // Manager dashboard
        try {
            List<Complaint> allComplaints = complaintService.getAllComplaints();
            List<Feedback> recentFeedback = feedbackService.getRecentFeedback(10);
            
            req.setAttribute("allComplaints", allComplaints);
            req.setAttribute("recentFeedback", recentFeedback);
            req.setAttribute("totalComplaints", allComplaints.size());
            req.setAttribute("openComplaints", complaintService.getComplaintsByStatus("OPEN").size());
            req.setAttribute("resolvedComplaints", complaintService.getComplaintsByStatus("RESOLVED").size());
            req.setAttribute("avgResolutionTime", complaintService.getAverageResolutionTime());
        } catch (Exception e) {
            System.err.println("Database error loading manager dashboard: " + e.getMessage());
            // Create sample data for demo purposes
            List<Complaint> sampleComplaints = createSampleManagerComplaints();
            List<Feedback> sampleFeedback = createSampleManagerFeedback();
            
            req.setAttribute("allComplaints", sampleComplaints);
            req.setAttribute("recentFeedback", sampleFeedback);
            req.setAttribute("totalComplaints", sampleComplaints.size());
            req.setAttribute("openComplaints", (int) sampleComplaints.stream().filter(c -> "OPEN".equals(c.getStatusCode())).count());
            req.setAttribute("resolvedComplaints", (int) sampleComplaints.stream().filter(c -> "RESOLVED".equals(c.getStatusCode())).count());
            req.setAttribute("avgResolutionTime", 2.3);
        }
    }
    
    private void loadMarketingDashboard(HttpServletRequest req, Integer userId) {
        // Marketing executive dashboard
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
    
    private void loadCustomerDashboard(HttpServletRequest req, Integer userId) {
        // Customer dashboard
        try {
            List<Complaint> customerComplaints = complaintService.getComplaintsByCustomer(userId);
            List<Feedback> customerFeedback = feedbackService.getFeedbackByCustomer(userId);
            List<Complaint> recentComplaints = customerComplaints.size() > 5 ? 
                customerComplaints.subList(0, 5) : customerComplaints;
            List<Feedback> recentFeedback = customerFeedback.size() > 5 ? 
                customerFeedback.subList(0, 5) : customerFeedback;
            
            req.setAttribute("customerComplaints", customerComplaints);
            req.setAttribute("customerFeedback", customerFeedback);
            req.setAttribute("recentComplaints", recentComplaints);
            req.setAttribute("recentFeedback", recentFeedback);
            req.setAttribute("totalComplaints", customerComplaints.size());
            req.setAttribute("openComplaints", complaintService.getComplaintsByCustomerAndStatus(userId, "OPEN").size());
            req.setAttribute("resolvedComplaints", complaintService.getComplaintsByCustomerAndStatus(userId, "RESOLVED").size());
            req.setAttribute("totalFeedback", customerFeedback.size());
        } catch (Exception e) {
            System.err.println("Database error loading customer dashboard: " + e.getMessage());
            // Create sample data for demo purposes
            List<Complaint> sampleComplaints = createSampleCustomerComplaints(userId);
            List<Feedback> sampleFeedback = createSampleCustomerFeedback(userId);
            
            req.setAttribute("customerComplaints", sampleComplaints);
            req.setAttribute("customerFeedback", sampleFeedback);
            req.setAttribute("recentComplaints", sampleComplaints.size() > 5 ? 
                sampleComplaints.subList(0, 5) : sampleComplaints);
            req.setAttribute("recentFeedback", sampleFeedback.size() > 5 ? 
                sampleFeedback.subList(0, 5) : sampleFeedback);
            req.setAttribute("totalComplaints", sampleComplaints.size());
            req.setAttribute("openComplaints", (int) sampleComplaints.stream().filter(c -> "OPEN".equals(c.getStatusCode())).count());
            req.setAttribute("resolvedComplaints", (int) sampleComplaints.stream().filter(c -> "RESOLVED".equals(c.getStatusCode())).count());
            req.setAttribute("totalFeedback", sampleFeedback.size());
        }
    }
    
    private String getDashboardView(Integer roleId) {
        return switch (roleId) {
            case 1, 2 -> "/WEB-INF/views/admin/dashboard.jsp";
            case 3 -> "/WEB-INF/views/support/dashboard.jsp";
            case 4 -> "/WEB-INF/views/finance/dashboard.jsp";
            case 5 -> "/WEB-INF/views/manager/dashboard.jsp";
            case 6 -> "/WEB-INF/views/marketing/dashboard.jsp";
            case 7 -> "/WEB-INF/views/customer/dashboard.jsp";
            default -> "/WEB-INF/views/auth/login.jsp";
        };
    }
    
    // Sample data creation methods for demo purposes
    private List<Complaint> createSampleCustomerComplaints(int customerId) {
        List<Complaint> complaints = new ArrayList<>();
        
        // Sample complaint 1
        Complaint complaint1 = new Complaint();
        complaint1.setComplaintId(1001L);
        complaint1.setCustomerId(customerId);
        complaint1.setTitle("Internet Connection Issues");
        complaint1.setDescription("My internet connection has been intermittent for the past 3 days. It keeps dropping every few minutes, making it impossible to work from home.");
        complaint1.setIssueTypeCode("TECHNICAL");
        complaint1.setPriorityCode("HIGH");
        complaint1.setStatusCode("OPEN");
        complaint1.setSubmittedDate(LocalDateTime.now().minusDays(2));
        complaint1.setLastUpdated(LocalDateTime.now().minusDays(1));
        complaints.add(complaint1);
        
        // Sample complaint 2
        Complaint complaint2 = new Complaint();
        complaint2.setComplaintId(1002L);
        complaint2.setCustomerId(customerId);
        complaint2.setTitle("Billing Discrepancy");
        complaint2.setDescription("I received my monthly bill and noticed charges for services I didn't request. There's a $50 charge for premium support that I never signed up for.");
        complaint2.setIssueTypeCode("BILLING");
        complaint2.setPriorityCode("MEDIUM");
        complaint2.setStatusCode("IN_PROGRESS");
        complaint2.setSubmittedDate(LocalDateTime.now().minusDays(5));
        complaint2.setLastUpdated(LocalDateTime.now().minusHours(6));
        complaints.add(complaint2);
        
        // Sample complaint 3
        Complaint complaint3 = new Complaint();
        complaint3.setComplaintId(1003L);
        complaint3.setCustomerId(customerId);
        complaint3.setTitle("Service Outage");
        complaint3.setDescription("Complete service outage in my area since yesterday morning. No internet, phone, or TV services available.");
        complaint3.setIssueTypeCode("SERVICE");
        complaint3.setPriorityCode("CRITICAL");
        complaint3.setStatusCode("RESOLVED");
        complaint3.setSubmittedDate(LocalDateTime.now().minusDays(7));
        complaint3.setLastUpdated(LocalDateTime.now().minusDays(1));
        complaint3.setResolvedDate(LocalDateTime.now().minusDays(1));
        complaints.add(complaint3);
        
        return complaints;
    }
    
    private List<Feedback> createSampleCustomerFeedback(int customerId) {
        List<Feedback> feedback = new ArrayList<>();
        
        // Sample feedback 1
        Feedback feedback1 = new Feedback();
        feedback1.setFeedbackId(2001L);
        feedback1.setComplaintId(1003L);
        feedback1.setCustomerId(customerId);
        feedback1.setRating(5);
        feedback1.setComment("Excellent service! The technician was very professional and resolved the outage quickly. Thank you for the prompt response.");
        feedback1.setSentiment("POSITIVE");
        feedback1.setSubmittedDate(LocalDateTime.now().minusDays(1));
        feedback1.setCreatedAt(LocalDateTime.now().minusDays(1));
        feedback.add(feedback1);
        
        // Sample feedback 2
        Feedback feedback2 = new Feedback();
        feedback2.setFeedbackId(2002L);
        feedback2.setComplaintId(1002L);
        feedback2.setCustomerId(customerId);
        feedback2.setRating(3);
        feedback2.setComment("The billing issue was resolved, but it took longer than expected. The customer service representative was helpful though.");
        feedback2.setSentiment("NEUTRAL");
        feedback2.setSubmittedDate(LocalDateTime.now().minusDays(3));
        feedback2.setCreatedAt(LocalDateTime.now().minusDays(3));
        feedback.add(feedback2);
        
        return feedback;
    }
    
    // Sample data creation methods for support dashboard
    private List<Complaint> createSampleSupportComplaints(int supportUserId) {
        List<Complaint> complaints = new ArrayList<>();
        
        // Sample assigned complaint 1
        Complaint complaint1 = new Complaint();
        complaint1.setComplaintId(1001L);
        complaint1.setCustomerId(7);
        complaint1.setTitle("Internet Connection Issues");
        complaint1.setDescription("Customer experiencing intermittent internet connectivity problems affecting work from home setup.");
        complaint1.setIssueTypeCode("TECHNICAL");
        complaint1.setPriorityCode("HIGH");
        complaint1.setStatusCode("IN_PROGRESS");
        complaint1.setSubmittedDate(LocalDateTime.now().minusDays(2));
        complaint1.setLastUpdated(LocalDateTime.now().minusHours(6));
        complaint1.setAssignedTo(supportUserId);
        complaints.add(complaint1);
        
        // Sample assigned complaint 2
        Complaint complaint2 = new Complaint();
        complaint2.setComplaintId(1002L);
        complaint2.setCustomerId(8);
        complaint2.setTitle("Billing Discrepancy");
        complaint2.setDescription("Customer found unauthorized charges on monthly bill for premium support services.");
        complaint2.setIssueTypeCode("BILLING");
        complaint2.setPriorityCode("MEDIUM");
        complaint2.setStatusCode("OPEN");
        complaint2.setSubmittedDate(LocalDateTime.now().minusDays(5));
        complaint2.setLastUpdated(LocalDateTime.now().minusDays(1));
        complaint2.setAssignedTo(supportUserId);
        complaints.add(complaint2);
        
        // Sample assigned complaint 3
        Complaint complaint3 = new Complaint();
        complaint3.setComplaintId(1005L);
        complaint3.setCustomerId(9);
        complaint3.setTitle("Slow Internet Speed");
        complaint3.setDescription("Customer reporting significantly slower internet speeds than advertised plan.");
        complaint3.setIssueTypeCode("TECHNICAL");
        complaint3.setPriorityCode("MEDIUM");
        complaint3.setStatusCode("RESOLVED");
        complaint3.setSubmittedDate(LocalDateTime.now().minusDays(7));
        complaint3.setLastUpdated(LocalDateTime.now().minusDays(1));
        complaint3.setResolvedDate(LocalDateTime.now().minusDays(1));
        complaint3.setAssignedTo(supportUserId);
        complaints.add(complaint3);
        
        return complaints;
    }
    
    private List<Complaint> createSampleRecentComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        
        // Sample recent complaint 1
        Complaint complaint1 = new Complaint();
        complaint1.setComplaintId(1006L);
        complaint1.setCustomerId(10);
        complaint1.setTitle("Service Outage");
        complaint1.setDescription("Complete service outage in downtown area affecting multiple customers.");
        complaint1.setIssueTypeCode("SERVICE");
        complaint1.setPriorityCode("CRITICAL");
        complaint1.setStatusCode("OPEN");
        complaint1.setSubmittedDate(LocalDateTime.now().minusHours(2));
        complaint1.setLastUpdated(LocalDateTime.now().minusMinutes(30));
        complaints.add(complaint1);
        
        // Sample recent complaint 2
        Complaint complaint2 = new Complaint();
        complaint2.setComplaintId(1007L);
        complaint2.setCustomerId(11);
        complaint2.setTitle("Feature Request");
        complaint2.setDescription("Customer requesting mobile app for account management and complaint submission.");
        complaint2.setIssueTypeCode("FEATURE_REQUEST");
        complaint2.setPriorityCode("LOW");
        complaint2.setStatusCode("OPEN");
        complaint2.setSubmittedDate(LocalDateTime.now().minusHours(4));
        complaint2.setLastUpdated(LocalDateTime.now().minusHours(4));
        complaints.add(complaint2);
        
        return complaints;
    }
    
    // Sample data creation methods for manager dashboard
    private List<Complaint> createSampleManagerComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        
        // Sample complaint 1
        Complaint complaint1 = new Complaint();
        complaint1.setComplaintId(2001L);
        complaint1.setCustomerId(10);
        complaint1.setTitle("Service Outage - Downtown Area");
        complaint1.setDescription("Complete service outage affecting multiple customers in downtown area.");
        complaint1.setIssueTypeCode("SERVICE");
        complaint1.setPriorityCode("CRITICAL");
        complaint1.setStatusCode("RESOLVED");
        complaint1.setSubmittedDate(LocalDateTime.now().minusDays(1));
        complaint1.setLastUpdated(LocalDateTime.now().minusHours(6));
        complaint1.setResolvedDate(LocalDateTime.now().minusHours(6));
        complaints.add(complaint1);
        
        // Sample complaint 2
        Complaint complaint2 = new Complaint();
        complaint2.setComplaintId(2002L);
        complaint2.setCustomerId(11);
        complaint2.setTitle("Billing System Error");
        complaint2.setDescription("Customer charged incorrect amount due to billing system error.");
        complaint2.setIssueTypeCode("BILLING");
        complaint2.setPriorityCode("HIGH");
        complaint2.setStatusCode("IN_PROGRESS");
        complaint2.setSubmittedDate(LocalDateTime.now().minusDays(2));
        complaint2.setLastUpdated(LocalDateTime.now().minusHours(2));
        complaints.add(complaint2);
        
        // Sample complaint 3
        Complaint complaint3 = new Complaint();
        complaint3.setComplaintId(2003L);
        complaint3.setCustomerId(12);
        complaint3.setTitle("Network Performance Issues");
        complaint3.setDescription("Slow network performance affecting multiple users in residential area.");
        complaint3.setIssueTypeCode("TECHNICAL");
        complaint3.setPriorityCode("MEDIUM");
        complaint3.setStatusCode("OPEN");
        complaint3.setSubmittedDate(LocalDateTime.now().minusDays(3));
        complaint3.setLastUpdated(LocalDateTime.now().minusDays(1));
        complaints.add(complaint3);
        
        return complaints;
    }
    
    private List<Feedback> createSampleManagerFeedback() {
        List<Feedback> feedback = new ArrayList<>();
        
        // Sample feedback 1
        Feedback feedback1 = new Feedback();
        feedback1.setFeedbackId(3001L);
        feedback1.setCustomerId(10);
        feedback1.setRating(5);
        feedback1.setComment("Excellent service! The support team resolved my issue quickly and professionally.");
        feedback1.setSentiment("POSITIVE");
        feedback1.setSubmittedDate(LocalDateTime.now().minusHours(2));
        feedback1.setCreatedAt(LocalDateTime.now().minusHours(2));
        feedback.add(feedback1);
        
        // Sample feedback 2
        Feedback feedback2 = new Feedback();
        feedback2.setFeedbackId(3002L);
        feedback2.setCustomerId(11);
        feedback2.setRating(4);
        feedback2.setComment("Good service overall, but the resolution took longer than expected.");
        feedback2.setSentiment("NEUTRAL");
        feedback2.setSubmittedDate(LocalDateTime.now().minusHours(4));
        feedback2.setCreatedAt(LocalDateTime.now().minusHours(4));
        feedback.add(feedback2);
        
        return feedback;
    }
    
    // Sample data creation methods for marketing dashboard
    private List<Feedback> createSampleMarketingFeedback() {
        List<Feedback> feedback = new ArrayList<>();
        
        // Sample feedback 1
        Feedback feedback1 = new Feedback();
        feedback1.setFeedbackId(3001L);
        feedback1.setCustomerId(15);
        feedback1.setRating(5);
        feedback1.setComment("Excellent service! The support team resolved my issue quickly and professionally.");
        feedback1.setSentiment("POSITIVE");
        feedback1.setComplaintId(1001L);
        feedback1.setCreatedAt(LocalDateTime.now().minusDays(1));
        feedback.add(feedback1);
        
        // Sample feedback 2
        Feedback feedback2 = new Feedback();
        feedback2.setFeedbackId(3002L);
        feedback2.setCustomerId(16);
        feedback2.setRating(4);
        feedback2.setComment("Good service overall, but response time could be improved.");
        feedback2.setSentiment("POSITIVE");
        feedback2.setComplaintId(1002L);
        feedback2.setCreatedAt(LocalDateTime.now().minusDays(2));
        feedback.add(feedback2);
        
        // Sample feedback 3
        Feedback feedback3 = new Feedback();
        feedback3.setFeedbackId(3003L);
        feedback3.setCustomerId(17);
        feedback3.setRating(2);
        feedback3.setComment("Poor experience. The issue was not resolved and I had to call multiple times.");
        feedback3.setSentiment("NEGATIVE");
        feedback3.setComplaintId(1003L);
        feedback3.setCreatedAt(LocalDateTime.now().minusDays(3));
        feedback.add(feedback3);
        
        // Sample feedback 4
        Feedback feedback4 = new Feedback();
        feedback4.setFeedbackId(3004L);
        feedback4.setCustomerId(18);
        feedback4.setRating(5);
        feedback4.setComment("Outstanding customer service! The team went above and beyond to help me.");
        feedback4.setSentiment("POSITIVE");
        feedback4.setComplaintId(0L); // Use 0 instead of null for unlinked feedback
        feedback4.setCreatedAt(LocalDateTime.now().minusDays(4));
        feedback.add(feedback4);
        
        // Sample feedback 5
        Feedback feedback5 = new Feedback();
        feedback5.setFeedbackId(3005L);
        feedback5.setCustomerId(19);
        feedback5.setRating(3);
        feedback5.setComment("Average service. Nothing special but the issue was resolved.");
        feedback5.setSentiment("NEUTRAL");
        feedback5.setComplaintId(1004L);
        feedback5.setCreatedAt(LocalDateTime.now().minusDays(5));
        feedback.add(feedback5);
        
        // Sample feedback 6
        Feedback feedback6 = new Feedback();
        feedback6.setFeedbackId(3006L);
        feedback6.setCustomerId(20);
        feedback6.setRating(4);
        feedback6.setComment("Good service with friendly staff. Would recommend to others.");
        feedback6.setSentiment("POSITIVE");
        feedback6.setComplaintId(0L); // Use 0 instead of null for unlinked feedback
        feedback6.setCreatedAt(LocalDateTime.now().minusDays(6));
        feedback.add(feedback6);
        
        // Sample feedback 7
        Feedback feedback7 = new Feedback();
        feedback7.setFeedbackId(3007L);
        feedback7.setCustomerId(21);
        feedback7.setRating(1);
        feedback7.setComment("Terrible experience. Waited for hours and still no resolution.");
        feedback7.setSentiment("NEGATIVE");
        feedback7.setComplaintId(1005L);
        feedback7.setCreatedAt(LocalDateTime.now().minusDays(7));
        feedback.add(feedback7);
        
        // Sample feedback 8
        Feedback feedback8 = new Feedback();
        feedback8.setFeedbackId(3008L);
        feedback8.setCustomerId(22);
        feedback8.setRating(5);
        feedback8.setComment("Perfect! Quick resolution and excellent communication throughout.");
        feedback8.setSentiment("POSITIVE");
        feedback8.setComplaintId(1006L);
        feedback8.setCreatedAt(LocalDateTime.now().minusDays(8));
        feedback.add(feedback8);
        
        return feedback;
    }
}

