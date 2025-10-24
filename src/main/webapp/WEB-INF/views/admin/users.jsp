<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Smart Lanka CCS</title>
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

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .table th,
        .table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .table th {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
        }

        .table td {
            color: rgba(255, 255, 255, 0.9);
        }

        .table tbody tr:hover {
            background: rgba(255, 255, 255, 0.05);
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        .badge {
            display: inline-block;
            padding: 4px 8px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            border-radius: 3px;
            letter-spacing: 0.5px;
        }

        .badge-success {
            background: rgba(39, 174, 96, 0.2);
            color: #27ae60;
        }

        .badge-warning {
            background: rgba(243, 156, 18, 0.2);
            color: #f39c12;
        }

        .badge-danger {
            background: rgba(231, 76, 60, 0.2);
            color: #e74c3c;
        }

        .badge-info {
            background: rgba(102, 126, 234, 0.2);
            color: #667eea;
        }

        .badge-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.7);
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
            
            .table {
                font-size: 12px;
            }
            
            .table th,
            .table td {
                padding: 8px;
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
        .notification-icon-container {
            position: relative;
        }
        
        .notification-link {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            color: #fff;
            text-decoration: none;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .notification-link:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: scale(1.05);
        }
        
        .notification-link i {
            font-size: 1.2em;
        }
        
        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #e74c3c;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7em;
            font-weight: bold;
            min-width: 20px;
            padding: 2px;
        }
        
        .notification-badge.has-notifications {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        
        .user-profile-header {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-profile-header .user-info {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }
        
        .user-profile-header .user-name {
            font-weight: bold;
            color: #fff;
        }
        
        .user-profile-header .user-email {
            font-size: 0.9em;
            color: #cbd5e1;
        }
        
        .logout-btn {
            padding: 8px 16px;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1><i class="fas fa-headset"></i> Smart Lanka Customer Care System</h1>
                    <p>User Management</p>
                </div>
                <div style="display: flex; align-items: center; gap: 20px;">
                    <div class="notification-icon-container">
                        <a href="${pageContext.request.contextPath}/notifications" class="notification-link" title="View Notifications">
                            <i class="fas fa-bell"></i>
                            <span class="notification-badge" id="notification-count">0</span>
                        </a>
                    </div>
                    <div class="user-profile-header">
                        <div class="user-info">
                            <span class="user-name">${sessionScope.userName != null ? sessionScope.userName : 'Admin'}</span>
                            <span class="user-email">${sessionScope.userEmail != null ? sessionScope.userEmail : 'admin@smartlanka.com'}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger logout-btn">Logout</a>
                    </div>
                </div>
            </div>
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
                    <li><a href="${pageContext.request.contextPath}/user?action=list" class="nav-link active">
                        <i class="fas fa-users"></i> Manage Users
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/user?action=create" class="nav-link">
                        <i class="fas fa-user-plus"></i> Create User
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/notifications" class="nav-link">
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
                        <h2 class="card-title"><i class="fas fa-users"></i> User Management</h2>
                        <div style="display: flex; gap: 10px;">
                            <a href="${pageContext.request.contextPath}/user?action=create" class="btn btn-success">
                                <i class="fas fa-user-plus"></i> Create New User
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back to Dashboard
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <% if ("success".equals(request.getParameter("status"))) { %>
                        <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px;">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                                <div>
                                    <strong style="color: #10b981;">User Created Successfully!</strong>
                                    <p style="margin: 5px 0 0 0; color: #059669;">
                                        The new user has been added to the system and can now log in with their credentials.
                                    </p>
                                </div>
                            </div>
                        </div>
                        <% } %>
                        
                        <% if ("deleted".equals(request.getParameter("status"))) { %>
                        <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px;">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                                <div>
                                    <strong style="color: #10b981;">User Deleted Successfully!</strong>
                                    <p style="margin: 5px 0 0 0; color: #059669;">
                                        The user has been permanently removed from the system.
                                    </p>
                                </div>
                            </div>
                        </div>
                        <% } %>
                        
                        <% if (request.getAttribute("users") != null) { %>
                            <% List<User> users = (List<User>) request.getAttribute("users"); %>
                            
                            <!-- Statistics Cards -->
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px;">
                                <div style="background: rgba(52, 152, 219, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                    <div style="font-size: 2em; color: #3498db; margin-bottom: 10px;">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <div style="font-size: 1.5em; font-weight: bold; color: #fff;"><%= users.size() %></div>
                                    <div style="color: #cbd5e1;">Total Users</div>
                                </div>
                                <div style="background: rgba(39, 174, 96, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                    <div style="font-size: 2em; color: #27ae60; margin-bottom: 10px;">
                                        <i class="fas fa-user-check"></i>
                                    </div>
                                    <div style="font-size: 1.5em; font-weight: bold; color: #fff;">
                                        <%= users.stream().filter(u -> u.isActive()).count() %>
                                    </div>
                                    <div style="color: #cbd5e1;">Active Users</div>
                                </div>
                                <div style="background: rgba(243, 156, 18, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                    <div style="font-size: 2em; color: #f39c12; margin-bottom: 10px;">
                                        <i class="fas fa-user-tag"></i>
                                    </div>
                                    <div style="font-size: 1.5em; font-weight: bold; color: #fff;">
                                        <%= users.stream().filter(u -> u.getRoleId() == 7).count() %>
                                    </div>
                                    <div style="color: #cbd5e1;">Customers</div>
                                </div>
                                <div style="background: rgba(231, 76, 60, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                    <div style="font-size: 2em; color: #e74c3c; margin-bottom: 10px;">
                                        <i class="fas fa-user-shield"></i>
                                    </div>
                                    <div style="font-size: 1.5em; font-weight: bold; color: #fff;">
                                        <%= users.stream().filter(u -> u.getRoleId() == 1 || u.getRoleId() == 2).count() %>
                                    </div>
                                    <div style="color: #cbd5e1;">Admins</div>
                                </div>
                            </div>
                            
                            <% if (users.isEmpty()) { %>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle"></i> No users found. <a href="${pageContext.request.contextPath}/user?action=create">Create the first user</a>
                                </div>
                            <% } else { %>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Username</th>
                                                <th>Full Name</th>
                                                <th>Email</th>
                                                <th>Role</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (User user : users) { %>
                                            <tr>
                                                <td><%= user.getUserId() %></td>
                                                <td><%= user.getUsername() %></td>
                                                <td><%= user.getFullName() %></td>
                                                <td><%= user.getEmail() %></td>
                                                <td>
                                                    <% 
                                                        String roleName = "Unknown";
                                                        switch(user.getRoleId()) {
                                                            case 1: roleName = "System Admin"; break;
                                                            case 2: roleName = "Admin"; break;
                                                            case 3: roleName = "Support Staff"; break;
                                                            case 4: roleName = "Finance Staff"; break;
                                                            case 5: roleName = "Manager"; break;
                                                            case 6: roleName = "Marketing Executive"; break;
                                                            case 7: roleName = "Customer"; break;
                                                        }
                                                    %>
                                                    <span class="badge badge-info"><%= roleName %></span>
                                                </td>
                                                <td>
                                                    <% if (user.isActive()) { %>
                                                        <span class="badge badge-success">Active</span>
                                                    <% } else { %>
                                                        <span class="badge badge-danger">Inactive</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <div style="display: flex; gap: 5px;">
                                                        <a href="${pageContext.request.contextPath}/user?action=view&id=<%= user.getUserId() %>" 
                                                           class="btn btn-sm btn-primary" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/user?action=edit&id=<%= user.getUserId() %>" 
                                                           class="btn btn-sm btn-warning" title="Edit User">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/user?action=delete&id=<%= user.getUserId() %>" 
                                                           class="btn btn-sm btn-danger" title="Delete User"
                                                           onclick="return confirm('Are you sure you want to delete user <%= user.getUsername() %>? This action cannot be undone.')">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <div style="margin-top: 20px; padding: 15px; background: rgba(255,255,255,0.05); border-radius: 8px;">
                                    <h4><i class="fas fa-info-circle"></i> User Statistics</h4>
                                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; margin-top: 10px;">
                                        <div style="text-align: center;">
                                            <div style="font-size: 2rem; color: #6366f1;"><%= users.size() %></div>
                                            <div style="color: #cbd5e1;">Total Users</div>
                                        </div>
                                        <div style="text-align: center;">
                                            <div style="font-size: 2rem; color: #10b981;">
                                                <%= users.stream().filter(User::isActive).count() %>
                                            </div>
                                            <div style="color: #cbd5e1;">Active Users</div>
                                        </div>
                                        <div style="text-align: center;">
                                            <div style="font-size: 2rem; color: #f59e0b;">
                                                <%= users.stream().filter(u -> u.getRoleId() == 7).count() %>
                                            </div>
                                            <div style="color: #cbd5e1;">Customers</div>
                                        </div>
                                        <div style="text-align: center;">
                                            <div style="font-size: 2rem; color: #ef4444;">
                                                <%= users.stream().filter(u -> u.getRoleId() == 1 || u.getRoleId() == 2).count() %>
                                            </div>
                                            <div style="color: #cbd5e1;">Admins</div>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        <% } else { %>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle"></i> Unable to load users. Please try again.
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
        
        
        // Add active class to current nav item
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const navLinks = document.querySelectorAll('.nav-link');
            navLinks.forEach(function(link) {
                if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                    link.classList.add('active');
                }
            });
        });
        
        // Load notification count
        function loadNotificationCount() {
            fetch('${pageContext.request.contextPath}/notifications?action=count')
                .then(response => response.json())
                .then(data => {
                    const badge = document.getElementById('notification-count');
                    if (badge) {
                        badge.textContent = data.count;
                        if (data.count > 0) {
                            badge.style.display = 'block';
                            badge.classList.add('has-notifications');
                        } else {
                            badge.style.display = 'none';
                            badge.classList.remove('has-notifications');
                        }
                    }
                })
                .catch(error => {
                    console.log('Could not load notification count:', error);
                });
        }
        
        // Load notification count on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadNotificationCount();
            
            // Refresh notification count every 30 seconds
            setInterval(loadNotificationCount, 30000);
        });
    </script>
</body>
</html>
