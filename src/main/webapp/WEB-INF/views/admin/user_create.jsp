<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create User - Smart Lanka CCS</title>
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

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s ease;
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .form-control:focus {
            outline: none;
            border-color: rgba(255, 255, 255, 0.4);
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.1);
        }

        .form-control option {
            background: #2c3e50;
            color: white;
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

        h3 {
            color: white;
            margin-bottom: 15px;
            font-size: 1.2em;
        }

        small {
            color: rgba(255, 255, 255, 0.7);
            font-size: 12px;
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
            <p>Create New User</p>
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
                    <li><a href="${pageContext.request.contextPath}/user?action=create" class="nav-link active">
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
                        <h2 class="card-title"><i class="fas fa-user-plus"></i> Create New User</h2>
                        <div style="display: flex; gap: 10px;">
                            <a href="${pageContext.request.contextPath}/user?action=list" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back to Users
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <% if (request.getParameter("error") != null) { %>
                        <div class="alert alert-danger">
                            <% if ("email_exists".equals(request.getParameter("error"))) { %>
                            An account with this email address already exists. Please use a different email.
                            <% } else if ("username_exists".equals(request.getParameter("error"))) { %>
                            This username is already taken. Please choose a different username.
                            <% } else if ("validation_error".equals(request.getParameter("error"))) { %>
                            Please fill in all required fields correctly.
                            <% } else { %>
                            User creation failed. Please try again.
                            <% } %>
                        </div>
                        <% } %>

                        <% if ("success".equals(request.getParameter("status"))) { %>
                        <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05));">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                                <div>
                                    <strong style="color: #10b981;">User Created Successfully!</strong>
                                    <p style="margin: 5px 0 0 0; color: #059669;">
                                        The new user has been added to the system and can now log in with their credentials.
                                    </p>
                                    <div style="margin-top: 10px;">
                                        <a href="${pageContext.request.contextPath}/user?action=list" class="btn btn-sm btn-outline-success">
                                            <i class="fas fa-users"></i> View All Users
                                        </a>
                                        <a href="${pageContext.request.contextPath}/user?action=create" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-user-plus"></i> Create Another User
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                        
                        <form action="${pageContext.request.contextPath}/user" method="post" id="createUserForm">
                            <input type="hidden" name="action" value="create">
                            
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
                                <div>
                                    <h3><i class="fas fa-info-circle"></i> Basic Information</h3>
                                    <div style="background: rgba(255,255,255,0.05); padding: 20px; border-radius: 8px;">
                                        <div class="form-group">
                                            <label for="username">Username *</label>
                                            <input type="text" id="username" name="username" class="form-control" required 
                                                   value="${param.username}" placeholder="Enter username" minlength="3">
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="email">Email Address *</label>
                                            <input type="email" id="email" name="email" class="form-control" required 
                                                   value="${param.email}" placeholder="Enter email address">
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="firstName">First Name *</label>
                                            <input type="text" id="firstName" name="firstName" class="form-control" required 
                                                   value="${param.firstName}" placeholder="Enter first name">
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="lastName">Last Name *</label>
                                            <input type="text" id="lastName" name="lastName" class="form-control" required 
                                                   value="${param.lastName}" placeholder="Enter last name">
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="phoneNumber">Phone Number *</label>
                                            <input type="tel" id="phoneNumber" name="phoneNumber" class="form-control" required 
                                                   value="${param.phoneNumber}" placeholder="Enter phone number">
                                        </div>
                                    </div>
                                </div>
                                
                                <div>
                                    <h3><i class="fas fa-user-tag"></i> Role & Settings</h3>
                                    <div style="background: rgba(255,255,255,0.05); padding: 20px; border-radius: 8px;">
                                        <div class="form-group">
                                            <label for="roleId">Role *</label>
                                            <select id="roleId" name="roleId" class="form-control" required>
                                                <option value="">Select role</option>
                                                <option value="1" ${param.roleId == '1' ? 'selected' : ''}>System Administrator</option>
                                                <option value="2" ${param.roleId == '2' ? 'selected' : ''}>Administrator</option>
                                                <option value="3" ${param.roleId == '3' ? 'selected' : ''}>Support Staff</option>
                                                <option value="4" ${param.roleId == '4' ? 'selected' : ''}>Finance Staff</option>
                                                <option value="5" ${param.roleId == '5' ? 'selected' : ''}>Manager</option>
                                                <option value="6" ${param.roleId == '6' ? 'selected' : ''}>Marketing Executive</option>
                                                <option value="7" ${param.roleId == '7' ? 'selected' : ''}>Customer</option>
                                            </select>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="employeeId">Employee ID</label>
                                            <input type="text" id="employeeId" name="employeeId" class="form-control" 
                                                   value="${param.employeeId}" placeholder="Enter employee ID (optional)">
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="isActive">Status</label>
                                            <select id="isActive" name="isActive" class="form-control">
                                                <option value="true" ${param.isActive == 'true' ? 'selected' : ''}>Active</option>
                                                <option value="false" ${param.isActive == 'false' ? 'selected' : ''}>Inactive</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div style="margin-top: 30px;">
                                <h3><i class="fas fa-key"></i> Password</h3>
                                <div style="background: rgba(255,255,255,0.05); padding: 20px; border-radius: 8px;">
                                    <div class="form-group">
                                        <label for="password">Password *</label>
                                        <input type="password" id="password" name="password" class="form-control" required 
                                               placeholder="Enter password" minlength="8">
                                        <small style="color: #cbd5e1;">Password must be at least 8 characters long</small>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="confirmPassword">Confirm Password *</label>
                                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required 
                                               placeholder="Confirm password">
                                    </div>
                                </div>
                            </div>
                            
                            <div style="margin-top: 30px; text-align: center;">
                                <button type="submit" class="btn btn-success btn-lg">
                                    <i class="fas fa-user-plus"></i> Create User
                                </button>
                                <a href="${pageContext.request.contextPath}/user?action=list" class="btn btn-secondary btn-lg">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <style>
        @keyframes slideInFromTop {
            0% {
                transform: translateY(-20px);
                opacity: 0;
            }
            100% {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.4);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(16, 185, 129, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(16, 185, 129, 0);
            }
        }
        
        .alert-success {
            animation: slideInFromTop 0.5s ease-out;
        }
        
        .alert-success:hover {
            transform: translateY(-2px);
            transition: transform 0.2s ease;
        }
    </style>
    
    <script>
        // Auto-hide alerts after 8 seconds (longer for success messages)
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const isSuccess = alert.classList.contains('alert-success');
                const hideDelay = isSuccess ? 8000 : 5000; // Success messages stay longer
                
                setTimeout(function() {
                    alert.style.transition = 'opacity 0.5s ease';
                    alert.style.opacity = '0';
                    setTimeout(function() {
                        alert.remove();
                    }, 500);
                }, hideDelay);
            });
            
            // Add success animation for success messages
            const successAlert = document.querySelector('.alert-success');
            if (successAlert) {
                successAlert.style.animation = 'slideInFromTop 0.5s ease-out';
                // Add a subtle pulse effect
                setTimeout(function() {
                    successAlert.style.boxShadow = '0 0 20px rgba(16, 185, 129, 0.3)';
                }, 100);
            }
        });
        
        // Form validation
        document.getElementById('createUserForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match. Please try again.');
                return false;
            }
            
            if (password.length < 8) {
                e.preventDefault();
                alert('Password must be at least 8 characters long.');
                return false;
            }
        });
        
        // Real-time password confirmation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (confirmPassword && password !== confirmPassword) {
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
            } else if (confirmPassword && password === confirmPassword) {
                this.classList.add('is-valid');
                this.classList.remove('is-invalid');
            } else {
                this.classList.remove('is-valid', 'is-invalid');
            }
        });
    </script>
</body>
</html>
