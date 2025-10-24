package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.smartlanka.ccs.model.Notification;
import lk.smartlanka.ccs.service.NotificationService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class NotificationServlet extends HttpServlet {
    private final NotificationService notificationService = new NotificationService();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        Integer roleId = (Integer) req.getSession().getAttribute("roleId");
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        
        if ("count".equals(action)) {
            resp.setContentType("application/json");
            PrintWriter out = resp.getWriter();
            try {
                int count = notificationService.getUnreadCount(userId);
                out.print("{\"count\": " + count + "}");
            } catch (Exception e) {
                out.print("{\"count\": 0}");
            }
            return;
        }
        
        // Load notifications for all actions except count
        List<Notification> notifications = new java.util.ArrayList<>();
        try {
            if ("unread".equals(action)) {
                if (roleId == 1 || roleId == 2) {
                    // Admin users see all unread notifications
                    notifications = notificationService.getAllUnreadNotifications();
                } else {
                    // Other users see only their own unread notifications
                    notifications = notificationService.getUnreadNotifications(userId);
                }
            } else {
                if (roleId == 1 || roleId == 2) {
                    // Admin users see all notifications
                    notifications = notificationService.getAllNotifications();
                } else {
                    // Other users see only their own notifications
                    notifications = notificationService.getNotificationsByUserId(userId);
                }
            }
        } catch (Exception e) {
            System.err.println("Error loading notifications: " + e.getMessage());
            e.printStackTrace();
            notifications = new java.util.ArrayList<>();
        }
        
        req.setAttribute("notifications", notifications);
        
        // Forward to role-appropriate notification page
        String notificationView = getNotificationView(roleId);
        req.getRequestDispatcher(notificationView).forward(req, resp);
    }
    
    private String getNotificationView(Integer roleId) {
        return switch (roleId) {
            case 1, 2 -> "/WEB-INF/views/admin/notifications.jsp";     // Admin
            case 3 -> "/WEB-INF/views/support/notifications.jsp";      // Support
            case 4 -> "/WEB-INF/views/finance/notifications.jsp";      // Finance
            case 5 -> "/WEB-INF/views/manager/notifications.jsp";      // Manager
            case 6 -> "/WEB-INF/views/marketing/notifications.jsp";    // Marketing
            case 7 -> "/WEB-INF/views/customer/notifications.jsp";     // Customer
            default -> "/WEB-INF/views/admin/notifications.jsp";       // Default to admin
        };
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        
        if ("markRead".equals(action)) {
            long notificationId = Long.parseLong(req.getParameter("id"));
            notificationService.markAsRead(notificationId);
            resp.setContentType("application/json");
            PrintWriter out = resp.getWriter();
            out.print("{\"success\": true}");
        } else if ("markAllRead".equals(action)) {
            notificationService.markAllAsRead(userId);
            resp.setContentType("application/json");
            PrintWriter out = resp.getWriter();
            out.print("{\"success\": true}");
        } else if ("delete".equals(action)) {
            long notificationId = Long.parseLong(req.getParameter("id"));
            notificationService.deleteNotification(notificationId);
            resp.setContentType("application/json");
            PrintWriter out = resp.getWriter();
            out.print("{\"success\": true}");
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
}

