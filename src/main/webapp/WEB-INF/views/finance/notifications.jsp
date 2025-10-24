<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Notification" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - Smart Lanka CCS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }

        .container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            padding: 30px;
            margin: 0 auto;
            max-width: 1000px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e9ecef;
        }

        .header h1 {
            color: #2c3e50;
            margin: 0;
            font-size: 2rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }

        .btn-success {
            background: #27ae60;
            color: white;
        }

        .btn-success:hover {
            background: #229954;
            transform: translateY(-2px);
        }

        .notification-list {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
        }

        .notification-item {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
        }

        .notification-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        }

        .notification-item.unread {
            border-left: 4px solid #3498db;
            background: #f8f9ff;
        }

        .notification-item.read {
            opacity: 0.8;
        }

        .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 10px;
        }

        .notification-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            flex-shrink: 0;
        }

        .notification-icon.info {
            background: #e3f2fd;
            color: #1976d2;
        }

        .notification-icon.success {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .notification-icon.warning {
            background: #fff3e0;
            color: #f57c00;
        }

        .notification-icon.error {
            background: #ffebee;
            color: #d32f2f;
        }

        .notification-content {
            flex: 1;
        }

        .notification-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
            font-size: 16px;
        }

        .notification-message {
            color: #555;
            line-height: 1.5;
            margin-bottom: 10px;
        }

        .notification-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #7f8c8d;
        }

        .notification-time {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .notification-type {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 500;
            text-transform: uppercase;
        }

        .notification-type.info {
            background: #e3f2fd;
            color: #1976d2;
        }

        .notification-type.success {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .notification-type.warning {
            background: #fff3e0;
            color: #f57c00;
        }

        .notification-type.error {
            background: #ffebee;
            color: #d32f2f;
        }

        .notification-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .action-btn.mark-read {
            background: #27ae60;
            color: white;
        }

        .action-btn.mark-read:hover {
            background: #229954;
        }

        .no-notifications {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }

        .no-notifications i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .no-notifications h3 {
            margin: 0 0 10px 0;
            color: #95a5a6;
        }

        .no-notifications p {
            margin: 0;
            font-size: 14px;
        }

        .bulk-actions {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            justify-content: flex-end;
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px;
                margin: 10px;
            }
            
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .notification-header {
                flex-direction: column;
                gap: 10px;
            }
            
            .notification-meta {
                flex-direction: column;
                gap: 5px;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>
                <i class="fas fa-bell"></i>
                Notifications
            </h1>
            <div>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Bulk Actions -->
        <div class="bulk-actions">
            <button class="btn btn-success" onclick="markAllAsRead()">
                <i class="fas fa-check-double"></i> Mark All Read
            </button>
        </div>

        <!-- Notification List -->
        <div class="notification-list">
            <% 
                List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
                if (notifications == null || notifications.isEmpty()) { 
            %>
                <div class="no-notifications">
                    <i class="fas fa-bell-slash"></i>
                    <h3>No Notifications</h3>
                    <p>You don't have any notifications yet. We'll notify you when there are updates relevant to your role.</p>
                </div>
            <% } else { %>
                <% for (Notification notification : notifications) { %>
                    <div class="notification-item <%= notification.isRead() ? "read" : "unread" %>" 
                         id="notification-<%= notification.getNotificationId() %>">
                        
                        <div class="notification-header">
                            <div style="display: flex; align-items: flex-start;">
                                <div class="notification-icon <%= notification.getType() != null ? notification.getType().toLowerCase() : "info" %>">
                                    <% 
                                        String iconClass = "fas fa-info-circle";
                                        switch (notification.getType() != null ? notification.getType() : "INFO") {
                                            case "SUCCESS":
                                                iconClass = "fas fa-check-circle";
                                                break;
                                            case "WARNING":
                                                iconClass = "fas fa-exclamation-triangle";
                                                break;
                                            case "ERROR":
                                                iconClass = "fas fa-times-circle";
                                                break;
                                            case "COMPLAINT":
                                                iconClass = "fas fa-exclamation-triangle";
                                                break;
                                            case "FEEDBACK":
                                                iconClass = "fas fa-comment";
                                                break;
                                            case "FINANCE":
                                                iconClass = "fas fa-dollar-sign";
                                                break;
                                            case "ASSIGNMENT":
                                                iconClass = "fas fa-tasks";
                                                break;
                                            default:
                                                iconClass = "fas fa-info-circle";
                                                break;
                                        }
                                    %>
                                    <i class="<%= iconClass %>"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title"><%= notification.getTitle() %></div>
                                    <div class="notification-message"><%= notification.getMessage() %></div>
                                </div>
                            </div>
                            <div class="notification-type <%= notification.getType() != null ? notification.getType().toLowerCase() : "info" %>">
                                <%= notification.getType() != null ? notification.getType() : "INFO" %>
                            </div>
                        </div>
                        
                        <div class="notification-meta">
                            <div class="notification-time">
                                <i class="fas fa-clock"></i>
                                <%= new SimpleDateFormat("MMM dd, yyyy 'at' HH:mm").format(notification.getCreatedAt()) %>
                            </div>
                            <% if (!notification.isRead()) { %>
                                <span style="color: #3498db; font-weight: 500;">New</span>
                            <% } %>
                        </div>
                        
                        <% if (!notification.isRead()) { %>
                            <div class="notification-actions">
                                <button class="action-btn mark-read" onclick="markAsRead(<%= notification.getNotificationId() %>)">
                                    <i class="fas fa-check"></i> Mark as Read
                                </button>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>

    <script>
        function markAsRead(notificationId) {
            fetch('${pageContext.request.contextPath}/notifications', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=markRead&id=' + notificationId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const notificationItem = document.getElementById('notification-' + notificationId);
                    notificationItem.classList.remove('unread');
                    notificationItem.classList.add('read');
                    
                    const actions = notificationItem.querySelector('.notification-actions');
                    if (actions) {
                        actions.remove();
                    }
                    
                    const meta = notificationItem.querySelector('.notification-meta');
                    const newSpan = meta.querySelector('span');
                    if (newSpan) {
                        newSpan.remove();
                    }
                }
            })
            .catch(error => {
                console.error('Error marking notification as read:', error);
            });
        }

        function markAllAsRead() {
            fetch('${pageContext.request.contextPath}/notifications', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=markAllRead'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const notificationItems = document.querySelectorAll('.notification-item.unread');
                    notificationItems.forEach(item => {
                        item.classList.remove('unread');
                        item.classList.add('read');
                        
                        const actions = item.querySelector('.notification-actions');
                        if (actions) {
                            actions.remove();
                        }
                        
                        const meta = item.querySelector('.notification-meta');
                        const newSpan = meta.querySelector('span');
                        if (newSpan) {
                            newSpan.remove();
                        }
                    });
                }
            })
            .catch(error => {
                console.error('Error marking all notifications as read:', error);
            });
        }

        // Auto-refresh notifications every 30 seconds
        setInterval(function() {
            location.reload();
        }, 30000);
    </script>

    <%@ include file="../common/footer.jspf" %>
</body>
</html>




