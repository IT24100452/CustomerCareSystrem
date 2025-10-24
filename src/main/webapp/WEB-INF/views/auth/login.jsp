<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Smart Lanka CCS</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            width: 100%;
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
            max-width: 400px;
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
            <h1><i class="fas fa-headset"></i> Smart Lanka Customer Care System</h1>
            <p>Please login to continue</p>
        </div>
        
        <div class="main-content">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title"><i class="fas fa-sign-in-alt"></i> Login</h2>
                </div>
                <div class="card-body">
                    <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger">
                        <% if ("invalid".equals(request.getParameter("error"))) { %>
                        Invalid email or password. Please try again.
                        <% } else if ("nouser".equals(request.getParameter("error"))) { %>
                        No account found with this email address.
                        <% } %>
                    </div>
                    <% } %>

                    <% if ("reset".equals(request.getParameter("success"))) { %>
                    <div class="alert alert-success">
                        Password reset successful. Please login with your new password.
                    </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/auth" method="post">
                        <input type="hidden" name="action" value="login">

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control" required autocomplete="email" placeholder="Enter your email">
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" class="form-control" required placeholder="Enter your password">
                        </div>

                        <button type="submit" class="btn btn-lg" style="width: 100%;">
                            <i class="fas fa-sign-in-alt"></i> Login
                        </button>
                    </form>

                    <div style="text-align: center; margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/auth/reset" class="btn btn-secondary">
                            <i class="fas fa-key"></i> Forgot Password?
                        </a>
                    </div>
                    
                    <div class="divider">
                        <p>Don't have an account?</p>
                        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-success">
                            <i class="fas fa-user-plus"></i> Create New Account
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
        });
    </script>
</body>
</html>