<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Notification" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - Smart Lanka CCS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            text-align: center;
        }

        .header h1 {
            color: white;
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .header p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1em;
        }

        .dashboard-container {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 20px;
            min-height: 100vh;
        }

        .sidebar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 20px;
            height: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .main-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .nav-menu {
            list-style: none;
        }

        .nav-menu li {
            margin-bottom: 10px;
        }

        .nav-menu a {
            display: block;
            padding: 12px 15px;
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .nav-menu a:hover,
        .nav-menu a.active {
            background: rgba(255, 255, 255, 0.1);
            border-left-color: #667eea;
            color: #ffffff;
        }

        .nav-menu i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .user-info {
            border-top: 1px solid rgba(255, 255, 255, 0.2);
            padding-top: 20px;
            margin-top: 20px;
        }

        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            font-weight: bold;
            margin: 0 auto 10px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.35);
        }

        .user-name {
            text-align: center;
            font-weight: 600;
            margin-bottom: 5px;
            color: white;
        }

        .user-role {
            text-align: center;
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.9rem;
        }

        .card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .card-header {
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            padding-bottom: 15px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: white;
            margin: 0;
        }

        .card-body {
            padding: 0;
        }

        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6 0%, #7f8c8d 100%);
        }

        .btn-secondary:hover {
            box-shadow: 0 10px 20px rgba(149, 165, 166, 0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
        }

        .btn-success:hover {
            box-shadow: 0 10px 20px rgba(39, 174, 96, 0.3);
        }

        .btn-warning {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
        }

        .btn-warning:hover {
            box-shadow: 0 10px 20px rgba(243, 156, 18, 0.3);
        }

        .btn-danger {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        }

        .btn-danger:hover {
            box-shadow: 0 10px 20px rgba(231, 76, 60, 0.3);
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
        }

        .btn-lg {
            padding: 15px 30px;
            font-size: 16px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 10px;
            border-left: 4px solid;
        }

        .alert-success {
            background: rgba(39, 174, 96, 0.1);
            border-left-color: #27ae60;
            color: #27ae60;
        }

        .alert-warning {
            background: rgba(243, 156, 18, 0.1);
            border-left-color: #f39c12;
            color: #f39c12;
        }

        .alert-danger {
            background: rgba(231, 76, 60, 0.1);
            border-left-color: #e74c3c;
            color: #e74c3c;
        }

        .alert-info {
            background: rgba(102, 126, 234, 0.1);
            border-left-color: #667eea;
            color: #667eea;
        }

        .notifications-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .notification-item {
            display: flex;
            align-items: center;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            border-left: 4px solid #3498db;
            transition: all 0.3s ease;
        }

        .notification-item.unread {
            background: rgba(52, 152, 219, 0.1);
            border-left-color: #e74c3c;
        }

        .notification-item.read {
            opacity: 0.7;
        }

        .notification-icon {
            margin-right: 15px;
            font-size: 1.5em;
        }

        .notification-content {
            flex: 1;
        }

        .notification-title {
            font-weight: bold;
            color: #fff;
            margin-bottom: 5px;
        }

        .notification-message {
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 10px;
        }

        .notification-meta {
            display: flex;
            gap: 15px;
            font-size: 0.9em;
            color: rgba(255, 255, 255, 0.6);
        }

        .notification-type {
            background: rgba(52, 152, 219, 0.2);
            padding: 2px 8px;
            border-radius: 4px;
        }

        .notification-actions {
            display: flex;
            gap: 5px;
        }

        .notification-item:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        @media (max-width: 768px) {
            .dashboard-container {
                grid-template-columns: 1fr;
            }
            
            .sidebar {
                order: 2;
            }
            
            .main-content {
                order: 1;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 10px;
            }
            
            .main-content {
                padding: 15px;
            }
            
            .btn {
                padding: 8px 16px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-headset"></i> Smart Lanka Customer Care System</h1>
            <p>Notifications</p>
        </div>
        
        <div class="dashboard-container">
            <div class="sidebar">
                <div class="user-info">
                    <div class="user-avatar">
                        <i class="fas fa-crown"></i>
                    </div>
                    <div class="user-name">${sessionScope.userName != null ? sessionScope.userName : 'Admin'}</div>
                    <div class="user-role">Administrator</div>
                </div>
                
                <ul class="nav-menu">
                    <li><a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/user?action=list" class="nav-link">
                        <i class="fas fa-users"></i> Manage Users
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/user?action=create" class="nav-link">
                        <i class="fas fa-user-plus"></i> Create User
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/notifications" class="nav-link active">
                        <i class="fas fa-bell"></i> Notifications
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/auth/logout" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a></li>
                </ul>
            </div>
            
            <div class="main-content">
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title"><i class="fas fa-bell"></i> System Notifications</h2>
                        <div style="display: flex; gap: 10px;">
                            <button onclick="markAllAsRead()" class="btn btn-primary">
                                <i class="fas fa-check-double"></i> Mark All as Read
                            </button>
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back to Dashboard
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <% 
                            List<Notification> notifications = null;
                            try {
                                notifications = (List<Notification>) request.getAttribute("notifications");
                            } catch (Exception e) {
                                // Handle any errors gracefully
                            }
                        %>
                        
                        <% if (notifications != null && !notifications.isEmpty()) { %>
                            <!-- Notification Statistics -->
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px;">
                                <div style="background: rgba(52, 152, 219, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                    <div style="font-size: 2em; color: #3498db; margin-bottom: 10px;">
                                        <i class="fas fa-bell"></i>
                                    </div>
                                    <div style="font-size: 1.5em; font-weight: bold; color: #fff;"><%= notifications.size() %></div>
                                    <div style="color: #cbd5e1;">Total Notifications</div>
                                </div>
                                <div style="background: rgba(231, 76, 60, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                    <div style="font-size: 2em; color: #e74c3c; margin-bottom: 10px;">
                                        <i class="fas fa-exclamation-circle"></i>
                                    </div>
                                    <div style="font-size: 1.5em; font-weight: bold; color: #fff;">
                                        <%= notifications.stream().filter(n -> !n.isRead()).count() %>
                                    </div>
                                    <div style="color: #cbd5e1;">Unread</div>
                                </div>
                                <div style="background: rgba(39, 174, 96, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                    <div style="font-size: 2em; color: #27ae60; margin-bottom: 10px;">
                                        <i class="fas fa-check-circle"></i>
                                    </div>
                                    <div style="font-size: 1.5em; font-weight: bold; color: #fff;">
                                        <%= notifications.stream().filter(n -> n.isRead()).count() %>
                                    </div>
                                    <div style="color: #cbd5e1;">Read</div>
                                </div>
                            </div>
                            
                            <div class="notifications-list">
                                <% for (Notification notification : notifications) { %>
                                    <div class="notification-item <%= notification.isRead() ? "read" : "unread" %>" id="notification-<%= notification.getId() %>">
                                        <div class="notification-icon">
                                            <% 
                                                String iconClass = "fas fa-info-circle";
                                                String iconColor = "#3498db";
                                                String notificationType = notification.getType() != null ? notification.getType() : "INFO";
                                                switch(notificationType) {
                                                    case "SYSTEM": iconClass = "fas fa-cog"; iconColor = "#9b59b6"; break;
                                                    case "COMPLAINT": iconClass = "fas fa-exclamation-triangle"; iconColor = "#e74c3c"; break;
                                                    case "FEEDBACK": iconClass = "fas fa-comment"; iconColor = "#f39c12"; break;
                                                    case "USER": iconClass = "fas fa-user"; iconColor = "#2ecc71"; break;
                                                    case "ASSIGNMENT": iconClass = "fas fa-tasks"; iconColor = "#34495e"; break;
                                                }
                                            %>
                                            <i class="<%= iconClass %>" style="color: <%= iconColor %>;"></i>
                                        </div>
                                        <div class="notification-content">
                                            <div class="notification-title"><%= notification.getTitle() != null ? notification.getTitle() : "Notification" %></div>
                                            <div class="notification-message"><%= notification.getMessage() != null ? notification.getMessage() : "No message" %></div>
                                            <div class="notification-meta">
                                                <span class="notification-type"><%= notificationType %></span>
                                                <span class="notification-user" style="background: rgba(52, 152, 219, 0.2); color: #3498db; padding: 2px 8px; border-radius: 4px; font-size: 0.8em;">
                                                    User ID: <%= notification.getUserId() %>
                                                </span>
                                                <span class="notification-time"><%= notification.getCreatedAt() != null ? notification.getCreatedAt() : "Unknown" %></span>
                                            </div>
                                        </div>
                                        <div class="notification-actions">
                                            <% if (!notification.isRead()) { %>
                                                <button onclick="markAsRead(<%= notification.getId() %>)" class="btn btn-sm btn-success" title="Mark as Read">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            <% } %>
                                            <button onclick="deleteNotification(<%= notification.getId() %>)" class="btn btn-sm btn-danger" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <!-- Show sample notifications for testing -->
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px;">
                                <div style="background: rgba(52, 152, 219, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                    <div style="font-size: 2em; color: #3498db; margin-bottom: 10px;">
                                        <i class="fas fa-bell"></i>
                                    </div>
                                    <div style="font-size: 1.5em; font-weight: bold; color: #fff;">3</div>
                                    <div style="color: #cbd5e1;">Total Notifications</div>
                                </div>
                                <div style="background: rgba(231, 76, 60, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                    <div style="font-size: 2em; color: #e74c3c; margin-bottom: 10px;">
                                        <i class="fas fa-exclamation-circle"></i>
                                    </div>
                                    <div style="font-size: 1.5em; font-weight: bold; color: #fff;">2</div>
                                    <div style="color: #cbd5e1;">Unread</div>
                                </div>
                                <div style="background: rgba(39, 174, 96, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                    <div style="font-size: 2em; color: #27ae60; margin-bottom: 10px;">
                                        <i class="fas fa-check-circle"></i>
                                    </div>
                                    <div style="font-size: 1.5em; font-weight: bold; color: #fff;">1</div>
                                    <div style="color: #cbd5e1;">Read</div>
                                </div>
                            </div>
                            
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i> No notifications found in database. Showing sample notifications for testing.
                            </div>
                            
                            <!-- Sample notifications for testing -->
                            <div class="notifications-list">
                                <div class="notification-item unread" id="notification-1">
                                    <div class="notification-icon">
                                        <i class="fas fa-user" style="color: #2ecc71;"></i>
                                    </div>
                                    <div class="notification-content">
                                        <div class="notification-title">New User Created</div>
                                        <div class="notification-message">A new user has been created in the system.</div>
                                        <div class="notification-meta">
                                            <span class="notification-type">USER</span>
                                            <span class="notification-time">2024-01-15 10:30:00</span>
                                        </div>
                                    </div>
                                    <div class="notification-actions">
                                        <button onclick="markAsRead(1)" class="btn btn-sm btn-success" title="Mark as Read">
                                            <i class="fas fa-check"></i>
                                        </button>
                                        <button onclick="deleteNotification(1)" class="btn btn-sm btn-danger" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                                
                                <div class="notification-item unread" id="notification-2">
                                    <div class="notification-icon">
                                        <i class="fas fa-exclamation-triangle" style="color: #e74c3c;"></i>
                                    </div>
                                    <div class="notification-content">
                                        <div class="notification-title">System Maintenance</div>
                                        <div class="notification-message">Scheduled system maintenance will occur tonight from 2:00 AM to 4:00 AM.</div>
                                        <div class="notification-meta">
                                            <span class="notification-type">SYSTEM</span>
                                            <span class="notification-time">2024-01-15 09:15:00</span>
                                        </div>
                                    </div>
                                    <div class="notification-actions">
                                        <button onclick="markAsRead(2)" class="btn btn-sm btn-success" title="Mark as Read">
                                            <i class="fas fa-check"></i>
                                        </button>
                                        <button onclick="deleteNotification(2)" class="btn btn-sm btn-danger" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                                
                                <div class="notification-item read" id="notification-3">
                                    <div class="notification-icon">
                                        <i class="fas fa-comment" style="color: #f39c12;"></i>
                                    </div>
                                    <div class="notification-content">
                                        <div class="notification-title">Feedback Received</div>
                                        <div class="notification-message">New feedback has been submitted by a customer.</div>
                                        <div class="notification-meta">
                                            <span class="notification-type">FEEDBACK</span>
                                            <span class="notification-time">2024-01-14 16:45:00</span>
                                        </div>
                                    </div>
                                    <div class="notification-actions">
                                        <button onclick="deleteNotification(3)" class="btn btn-sm btn-danger" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    alert.style.transition = 'opacity 0.5s ease';
                    alert.style.opacity = '0';
                    setTimeout(function() {
                        alert.remove();
                    }, 500);
                }, 5000);
            });
        });
        
        // Mark notification as read
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
                    const notificationElement = document.getElementById('notification-' + notificationId);
                    notificationElement.classList.remove('unread');
                    notificationElement.classList.add('read');
                    updateUnreadCount();
                }
            })
            .catch(error => console.error('Error:', error));
        }
        
        // Mark all notifications as read
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
                    document.querySelectorAll('.notification-item').forEach(item => {
                        item.classList.remove('unread');
                        item.classList.add('read');
                    });
                    updateUnreadCount();
                }
            })
            .catch(error => console.error('Error:', error));
        }
        
        // Delete notification
        function deleteNotification(notificationId) {
            if (confirm('Are you sure you want to delete this notification?')) {
                fetch('${pageContext.request.contextPath}/notifications', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=delete&id=' + notificationId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById('notification-' + notificationId).remove();
                        updateUnreadCount();
                    }
                })
                .catch(error => console.error('Error:', error));
            }
        }
        
        // Update unread count (placeholder - would need to update UI elements)
        function updateUnreadCount() {
            // This would typically update a badge or counter in the UI
            console.log('Unread count updated');
        }
    </script>
    
    <style>
        .notifications-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .notification-item {
            display: flex;
            align-items: center;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            border-left: 4px solid #3498db;
            transition: all 0.3s ease;
        }
        
        .notification-item.unread {
            background: rgba(52, 152, 219, 0.1);
            border-left-color: #e74c3c;
        }
        
        .notification-item.read {
            opacity: 0.7;
        }
        
        .notification-icon {
            margin-right: 15px;
            font-size: 1.5em;
        }
        
        .notification-content {
            flex: 1;
        }
        
        .notification-title {
            font-weight: bold;
            color: #fff;
            margin-bottom: 5px;
        }
        
        .notification-message {
            color: #cbd5e1;
            margin-bottom: 10px;
        }
        
        .notification-meta {
            display: flex;
            gap: 15px;
            font-size: 0.9em;
            color: #94a3b8;
        }
        
        .notification-type {
            background: rgba(52, 152, 219, 0.2);
            padding: 2px 8px;
            border-radius: 4px;
        }
        
        .notification-actions {
            display: flex;
            gap: 5px;
        }
        
        .notification-item:hover {
            background: rgba(255, 255, 255, 0.1);
        }
    </style>
</body>
</html>
