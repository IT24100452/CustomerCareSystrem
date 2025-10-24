package lk.smartlanka.ccs.service;

import lk.smartlanka.ccs.dao.NotificationDao;
import lk.smartlanka.ccs.model.Notification;

import java.time.LocalDateTime;
import java.util.List;

public class NotificationService {
    private NotificationDao dao = new NotificationDao();

    public void createNotification(Notification notification) {
        dao.create(notification);
    }

    public List<Notification> getNotificationsByUserId(int userId) {
        return dao.getByUserId(userId);
    }

    public List<Notification> getUnreadNotifications(int userId) {
        return dao.getUnreadByUserId(userId);
    }

    public int getUnreadCount(int userId) {
        return dao.getUnreadCount(userId);
    }

    public void markAsRead(long notificationId) {
        dao.markAsRead(notificationId);
    }

    public void markAllAsRead(int userId) {
        dao.markAllAsRead(userId);
    }

    public void deleteNotification(long notificationId) {
        dao.delete(notificationId);
    }

    public void deleteOldNotifications(int daysOld) {
        dao.deleteOldNotifications(daysOld);
    }

    // Helper method to create system notifications
    public void createSystemNotification(int userId, String title, String message, String type) {
        Notification notification = new Notification();
        notification.setUserId(userId);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType(type);
        notification.setRead(false);
        notification.setCreatedAt(LocalDateTime.now());
        
        createNotification(notification);
    }

    // Enhanced notification methods for different scenarios
    public void createComplaintNotification(int userId, String action, long complaintId, String complaintTitle) {
        String title = "Complaint " + action;
        String message = "Complaint #" + complaintId + " (" + complaintTitle + ") has been " + action.toLowerCase() + ".";
        String type = "INFO";
        String actionUrl = "/complaint?action=view&id=" + complaintId;
        
        Notification notification = new Notification(userId, title, message, type, "COMPLAINT", complaintId, actionUrl);
        createNotification(notification);
    }

    public void createFeedbackNotification(int userId, String action, long feedbackId) {
        String title = "Feedback " + action;
        String message = "Your feedback has been " + action.toLowerCase() + ".";
        String type = "SUCCESS";
        String actionUrl = "/feedback?action=view&id=" + feedbackId;
        
        Notification notification = new Notification(userId, title, message, type, "FEEDBACK", feedbackId, actionUrl);
        createNotification(notification);
    }

    public void createAssignmentNotification(int userId, String action, long assignmentId, String complaintTitle) {
        String title = "Assignment " + action;
        String message = "You have been " + action.toLowerCase() + " to complaint: " + complaintTitle;
        String type = "WARNING";
        String actionUrl = "/assignment?action=view&id=" + assignmentId;
        
        Notification notification = new Notification(userId, title, message, type, "ASSIGNMENT", assignmentId, actionUrl);
        createNotification(notification);
    }

    public void createFinancialReportNotification(int userId, String action, long reportId, String reportTitle) {
        String title = "Financial Report " + action;
        String message = "Financial report '" + reportTitle + "' has been " + action.toLowerCase() + ".";
        String type = "INFO";
        String actionUrl = "/finance?action=view&id=" + reportId;
        
        Notification notification = new Notification(userId, title, message, type, "FINANCIAL_REPORT", reportId, actionUrl);
        createNotification(notification);
    }

    public void createPerformanceReportNotification(int userId, String action, long reportId, String reportTitle) {
        String title = "Performance Report " + action;
        String message = "Performance report '" + reportTitle + "' has been " + action.toLowerCase() + ".";
        String type = "INFO";
        String actionUrl = "/manager?action=view&id=" + reportId;
        
        Notification notification = new Notification(userId, title, message, type, "PERFORMANCE_REPORT", reportId, actionUrl);
        createNotification(notification);
    }

    public void createMarketingReportNotification(int userId, String action, long reportId, String reportTitle) {
        String title = "Marketing Report " + action;
        String message = "Marketing report '" + reportTitle + "' has been " + action.toLowerCase() + ".";
        String type = "INFO";
        String actionUrl = "/marketing?action=view&id=" + reportId;
        
        Notification notification = new Notification(userId, title, message, type, "MARKETING_REPORT", reportId, actionUrl);
        createNotification(notification);
    }

    // Bulk notification methods
    public void notifyAllUsers(String title, String message, String type) {
        // This would typically get all user IDs from the database
        // For now, we'll implement a simplified version
        List<Integer> allUserIds = dao.getAllUserIds();
        for (Integer userId : allUserIds) {
            createSystemNotification(userId, title, message, type);
        }
    }

    public void notifyUsersByRole(int roleId, String title, String message, String type) {
        List<Integer> userIds = dao.getUserIdsByRole(roleId);
        for (Integer userId : userIds) {
            createSystemNotification(userId, title, message, type);
        }
    }
    
    /**
     * Get all notifications for admin users
     */
    public List<Notification> getAllNotifications() {
        return dao.getAllNotifications();
    }
    
    /**
     * Get all unread notifications for admin users
     */
    public List<Notification> getAllUnreadNotifications() {
        return dao.getAllUnreadNotifications();
    }
}