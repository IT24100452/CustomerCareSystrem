<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Smart Lanka CCS</title>
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
            padding: 20px 0;
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

        .main-content {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            width: 100%;
            max-width: 500px;
        }

        .card-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .card-title {
            color: white;
            font-size: 1.8em;
            margin: 0;
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

        .btn-lg {
            padding: 15px 30px;
            font-size: 1.1em;
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

        .divider {
            text-align: center;
            margin: 20px 0;
            padding: 20px 0;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
        }

        .divider p {
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 10px;
        }

        small {
            color: rgba(255, 255, 255, 0.7);
            font-size: 12px;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .card {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-user-plus"></i> Create New Account</h1>
            <p>Smart Lanka Customer Care System</p>
        </div>
        
        <div class="main-content">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title"><i class="fas fa-user-circle"></i> Account Registration</h2>
                </div>
                <div class="card-body">
                    <p style="color: rgba(255, 255, 255, 0.8); margin-bottom: 20px; line-height: 1.5;">
                        Please fill in the information below to create your account. All fields are required.
                    </p>

                    <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger">
                        <% if ("email_exists".equals(request.getParameter("error"))) { %>
                        <i class="fas fa-exclamation-circle"></i> An account with this email already exists.
                        <% } else if ("validation".equals(request.getParameter("error"))) { %>
                        <i class="fas fa-exclamation-circle"></i> Please fill in all required fields correctly.
                        <% } else if ("password_mismatch".equals(request.getParameter("error"))) { %>
                        <i class="fas fa-exclamation-circle"></i> Passwords do not match. Please try again.
                        <% } else if ("server_error".equals(request.getParameter("error"))) { %>
                        <i class="fas fa-exclamation-circle"></i> An error occurred while creating your account. Please try again.
                        <% } %>
                    </div>
                    <% } %>

                    <% if ("success".equals(request.getParameter("status"))) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> Account created successfully! You can now login with your credentials.
                    </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/auth" method="post" id="registerForm">
                        <input type="hidden" name="action" value="register">

                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" id="firstName" name="firstName" class="form-control" required 
                                   placeholder="Enter your first name" value="<%= request.getParameter("firstName") != null ? request.getParameter("firstName") : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="lastName">Last Name</label>
                            <input type="text" id="lastName" name="lastName" class="form-control" required 
                                   placeholder="Enter your last name" value="<%= request.getParameter("lastName") != null ? request.getParameter("lastName") : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control" required 
                                   placeholder="Enter your email address" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" class="form-control" required 
                                   placeholder="Enter your phone number" value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="userType">Account Type</label>
                            <select id="userType" name="userType" class="form-control" required>
                                <option value="">Select account type</option>
                                <option value="CUSTOMER" <%= "CUSTOMER".equals(request.getParameter("userType")) ? "selected" : "" %>>Customer</option>
                                <option value="SUPPORT_STAFF" <%= "SUPPORT_STAFF".equals(request.getParameter("userType")) ? "selected" : "" %>>Support Staff</option>
                                <option value="MANAGER" <%= "MANAGER".equals(request.getParameter("userType")) ? "selected" : "" %>>Manager</option>
                                <option value="MARKETING_EXECUTIVE" <%= "MARKETING_EXECUTIVE".equals(request.getParameter("userType")) ? "selected" : "" %>>Marketing Executive</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" class="form-control" required 
                                   placeholder="Enter your password" minlength="6">
                            <small style="color: #94a3b8; font-size: 12px;">Password must be at least 6 characters long</small>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required 
                                   placeholder="Confirm your password">
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">
                            <i class="fas fa-user-plus"></i> Create Account
                        </button>
                    </form>

                    <div style="text-align: center; margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-secondary">
                            <i class="fas fa-sign-in-alt"></i> Back to Login
                        </a>
                    </div>
                    
                    <div class="divider">
                        <p>Already have an account?</p>
                        <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-success">
                            <i class="fas fa-sign-in-alt"></i> Login Here
                        </a>
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

            // Password confirmation validation
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            const form = document.getElementById('registerForm');

            function validatePassword() {
                if (password.value !== confirmPassword.value) {
                    confirmPassword.setCustomValidity('Passwords do not match');
                    confirmPassword.style.borderColor = '#e74c3c';
                } else {
                    confirmPassword.setCustomValidity('');
                    confirmPassword.style.borderColor = 'rgba(255,255,255,0.08)';
                }
            }

            password.addEventListener('change', validatePassword);
            confirmPassword.addEventListener('keyup', validatePassword);

            // Form submission validation
            form.addEventListener('submit', function(e) {
                if (password.value !== confirmPassword.value) {
                    e.preventDefault();
                    alert('Passwords do not match. Please check and try again.');
                    return false;
                }
            });
        });
    </script>
</body>
</html>