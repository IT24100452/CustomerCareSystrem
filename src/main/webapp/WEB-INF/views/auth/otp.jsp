<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>OTP Verification - Customer Care System</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f8fa;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .otp-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 350px;
        }

        .header {
            text-align: center;
            margin-bottom: 25px;
        }

        h2 {
            color: #2c3e50;
            margin: 0;
            margin-bottom: 5px;
        }

        .company-name {
            color: #3498db;
            font-size: 14px;
            margin: 0;
        }

        .info-text {
            font-size: 14px;
            color: #546e7a;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .error-message {
            background-color: #ffebee;
            border-left: 4px solid #f44336;
            color: #d32f2f;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            color: #546e7a;
            font-size: 14px;
            font-weight: 500;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }

        input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.5);
        }

        button {
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 12px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.2s;
        }

        button:hover {
            background-color: #2980b9;
        }

        .back-to-login {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
        }

        a {
            color: #3498db;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="otp-container">
    <div class="header">
        <h2>OTP Verification</h2>
        <p class="company-name">Smart Lanka Customer Care System</p>
    </div>

    <p class="info-text">We've sent a verification code to your email address. Please enter it below along with your new password.</p>

    <% if (request.getParameter("error") != null) { %>
    <div class="error-message">
        <% if ("invalidotp".equals(request.getParameter("error"))) { %>
        Invalid or expired OTP. Please try again.
        <% } %>
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/auth" method="post">
        <input type="hidden" name="action" value="verifyOtp">

        <div class="form-group">
            <label for="token">Reset Token</label>
            <input type="text" id="token" name="token" required autocomplete="off" placeholder="Enter the reset token from your email">
        </div>

        <div class="form-group">
            <label for="otp">One-Time Password</label>
            <input type="text" id="otp" name="otp" required autocomplete="off" placeholder="Enter the OTP from your email">
        </div>

        <div class="form-group">
            <label for="newPassword">New Password</label>
            <input type="password" id="newPassword" name="newPassword" required placeholder="Enter your new password" minlength="6">
        </div>

        <button type="submit">Verify & Reset Password</button>
    </form>

    <div class="back-to-login">
        <a href="${pageContext.request.contextPath}/auth/login">Back to Login</a>
    </div>
</div>
</body>
</html>