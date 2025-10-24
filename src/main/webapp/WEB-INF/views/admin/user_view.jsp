<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.smartlanka.ccs.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View User - Smart Lanka CCS</title>
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

        .alert-danger {
            background: rgba(231, 76, 60, 0.1);
            border-left-color: #e74c3c;
            color: #e74c3c;
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

        .alert-info {
            background: rgba(102, 126, 234, 0.1);
            border-left-color: #667eea;
            color: #667eea;
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

        h3 {
            color: white;
            margin-bottom: 15px;
            font-size: 1.2em;
        }

        strong {
            color: rgba(255, 255, 255, 0.9);
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
            <p>User Details</p>
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
                        <h2 class="card-title"><i class="fas fa-user"></i> User Details</h2>
                        <div style="display: flex; gap: 10px;">
                            <a href="${pageContext.request.contextPath}/user?action=edit&id=${user.userId}" class="btn btn-warning">
                                <i class="fas fa-edit"></i> Edit User
                            </a>
                            <a href="${pageContext.request.contextPath}/user?action=list" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back to Users
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <% if (request.getAttribute("user") != null) { %>
                            <% User user = (User) request.getAttribute("user"); %>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
                                <div>
                                    <h3><i class="fas fa-info-circle"></i> Basic Information</h3>
                                    <div style="background: rgba(255,255,255,0.05); padding: 20px; border-radius: 8px;">
                                        <div style="margin-bottom: 15px;">
                                            <strong>User ID:</strong> <%= user.getUserId() %>
                                        </div>
                                        <div style="margin-bottom: 15px;">
                                            <strong>Username:</strong> <%= user.getUsername() %>
                                        </div>
                                        <div style="margin-bottom: 15px;">
                                            <strong>Full Name:</strong> <%= user.getFullName() %>
                                        </div>
                                        <div style="margin-bottom: 15px;">
                                            <strong>Email:</strong> <%= user.getEmail() %>
                                        </div>
                                        <div style="margin-bottom: 15px;">
                                            <strong>Phone:</strong> <%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "Not provided" %>
                                        </div>
                                        <div style="margin-bottom: 15px;">
                                            <strong>Status:</strong> 
                                            <% if (user.isActive()) { %>
                                                <span class="badge badge-success">Active</span>
                                            <% } else { %>
                                                <span class="badge badge-danger">Inactive</span>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                                
                                <div>
                                    <h3><i class="fas fa-user-tag"></i> Role & Settings</h3>
                                    <div style="background: rgba(255,255,255,0.05); padding: 20px; border-radius: 8px;">
                                        <div style="margin-bottom: 15px;">
                                            <strong>Role:</strong> 
                                            <% 
                                                String roleName = "Unknown";
                                                String roleIcon = "fas fa-user";
                                                switch(user.getRoleId()) {
                                                    case 1: roleName = "System Administrator"; roleIcon = "fas fa-crown"; break;
                                                    case 2: roleName = "Administrator"; roleIcon = "fas fa-user-shield"; break;
                                                    case 3: roleName = "Support Staff"; roleIcon = "fas fa-user-tie"; break;
                                                    case 4: roleName = "Finance Staff"; roleIcon = "fas fa-calculator"; break;
                                                    case 5: roleName = "Manager"; roleIcon = "fas fa-chart-line"; break;
                                                    case 6: roleName = "Marketing Executive"; roleIcon = "fas fa-bullhorn"; break;
                                                    case 7: roleName = "Customer"; roleIcon = "fas fa-user"; break;
                                                }
                                            %>
                                            <span class="badge badge-info"><i class="<%= roleIcon %>"></i> <%= roleName %></span>
                                        </div>
                                        <div style="margin-bottom: 15px;">
                                            <strong>Employee ID:</strong> <%= user.getEmployeeId() != null ? user.getEmployeeId() : "Not provided" %>
                                        </div>
                                        <div style="margin-bottom: 15px;">
                                            <strong>Created:</strong> <%= user.getCreatedDate() != null ? user.getCreatedDate() : "Unknown" %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div style="margin-top: 30px;">
                                <h3><i class="fas fa-cogs"></i> Actions</h3>
                                <div style="display: flex; gap: 15px; flex-wrap: wrap;">
                                    <a href="${pageContext.request.contextPath}/user?action=edit&id=<%= user.getUserId() %>" class="btn btn-warning">
                                        <i class="fas fa-edit"></i> Edit User
                                    </a>
                                    <% if (user.isActive()) { %>
                                        <a href="${pageContext.request.contextPath}/user?action=deactivate&id=<%= user.getUserId() %>" 
                                           class="btn btn-danger" onclick="return confirm('Are you sure you want to deactivate this user?')">
                                            <i class="fas fa-user-times"></i> Deactivate User
                                        </a>
                                    <% } else { %>
                                        <a href="${pageContext.request.contextPath}/user?action=activate&id=<%= user.getUserId() %>" 
                                           class="btn btn-success" onclick="return confirm('Are you sure you want to activate this user?')">
                                            <i class="fas fa-user-check"></i> Activate User
                                        </a>
                                    <% } %>
                                    <a href="${pageContext.request.contextPath}/user?action=delete&id=<%= user.getUserId() %>" 
                                       class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this user? This action cannot be undone.')">
                                        <i class="fas fa-trash"></i> Delete User
                                    </a>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-triangle"></i> User not found or unable to load user details.
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
    </script>
</body>
</html>
