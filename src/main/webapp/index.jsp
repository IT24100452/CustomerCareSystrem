<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Smart Lanka Customer Care System" scope="request" />
<%@ include file="WEB-INF/views/common/header.jspf" %>

<c:if test="${sessionScope.userId != null}">
    <script>
        // Redirect logged-in users to their dashboard
        window.location.href = '${pageContext.request.contextPath}/dashboard';
    </script>
</c:if>

<div class="main-content">
    <!-- Hero Section -->
    <div class="hero-section" style="text-align: center; padding: 60px 20px; background: linear-gradient(135deg, #3498db, #2980b9); color: white; border-radius: 8px; margin-bottom: 40px;">
        <h1 style="font-size: 3rem; margin-bottom: 20px; font-weight: bold;">
            <i class="fas fa-headset"></i> Smart Lanka Customer Care System
        </h1>
        <p style="font-size: 1.3rem; margin-bottom: 30px; opacity: 0.9;">
            Comprehensive Customer Support Management Platform
        </p>
        <div style="display: flex; justify-content: center; gap: 20px; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-lg" style="background: white; color: #3498db; padding: 15px 30px;">
                <i class="fas fa-sign-in-alt"></i> Login
            </a>
            <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-lg" style="background: transparent; border: 2px solid white; color: white; padding: 15px 30px;">
                <i class="fas fa-user-plus"></i> Register
            </a>
        </div>
    </div>

    <!-- Features Section -->
    <div class="features-section" style="margin-bottom: 40px;">
        <h2 style="text-align: center; margin-bottom: 40px; color: #2c3e50;">
            <i class="fas fa-star"></i> Key Features
        </h2>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px;">
            <!-- Feature 1 -->
            <div class="feature-card" style="background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); text-align: center;">
                <div style="font-size: 3rem; color: #3498db; margin-bottom: 20px;">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h3 style="color: #2c3e50; margin-bottom: 15px;">Complaint Management</h3>
                <p style="color: #7f8c8d; line-height: 1.6;">
                    Submit, track, and manage customer complaints with full lifecycle support. 
                    Attach files, set priorities, and get real-time updates.
                </p>
            </div>
            
            <!-- Feature 2 -->
            <div class="feature-card" style="background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); text-align: center;">
                <div style="font-size: 3rem; color: #27ae60; margin-bottom: 20px;">
                    <i class="fas fa-star"></i>
                </div>
                <h3 style="color: #2c3e50; margin-bottom: 15px;">Feedback System</h3>
                <p style="color: #7f8c8d; line-height: 1.6;">
                    Collect and analyze customer feedback with rating systems, 
                    sentiment analysis, and comprehensive reporting.
                </p>
            </div>
            
            <!-- Feature 3 -->
            <div class="feature-card" style="background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); text-align: center;">
                <div style="font-size: 3rem; color: #f39c12; margin-bottom: 20px;">
                    <i class="fas fa-users"></i>
                </div>
                <h3 style="color: #2c3e50; margin-bottom: 15px;">Team Management</h3>
                <p style="color: #7f8c8d; line-height: 1.6;">
                    Assign complaints to team members, track performance, 
                    and manage workload distribution efficiently.
                </p>
            </div>
            
            <!-- Feature 4 -->
            <div class="feature-card" style="background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); text-align: center;">
                <div style="font-size: 3rem; color: #9b59b6; margin-bottom: 20px;">
                    <i class="fas fa-chart-bar"></i>
                </div>
                <h3 style="color: #2c3e50; margin-bottom: 15px;">Analytics & Reports</h3>
                <p style="color: #7f8c8d; line-height: 1.6;">
                    Generate comprehensive reports, track KPIs, 
                    and export data in CSV format for analysis.
                </p>
            </div>
            
            <!-- Feature 5 -->
            <div class="feature-card" style="background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); text-align: center;">
                <div style="font-size: 3rem; color: #e74c3c; margin-bottom: 20px;">
                    <i class="fas fa-bell"></i>
                </div>
                <h3 style="color: #2c3e50; margin-bottom: 15px;">Real-time Notifications</h3>
                <p style="color: #7f8c8d; line-height: 1.6;">
                    Stay updated with instant notifications for complaint updates, 
                    assignments, and important system events.
                </p>
            </div>
            
            <!-- Feature 6 -->
            <div class="feature-card" style="background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); text-align: center;">
                <div style="font-size: 3rem; color: #1abc9c; margin-bottom: 20px;">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h3 style="color: #2c3e50; margin-bottom: 15px;">Secure & Reliable</h3>
                <p style="color: #7f8c8d; line-height: 1.6;">
                    Role-based access control, secure authentication, 
                    and robust data protection for enterprise use.
                </p>
            </div>
        </div>
    </div>

    <!-- User Roles Section -->
    <div class="roles-section" style="margin-bottom: 40px;">
        <h2 style="text-align: center; margin-bottom: 40px; color: #2c3e50;">
            <i class="fas fa-user-tag"></i> User Roles
        </h2>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
            <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                <h4 style="color: #3498db; margin-bottom: 10px;"><i class="fas fa-crown"></i> System Admin</h4>
                <p style="color: #7f8c8d; font-size: 0.9rem;">Full system access and user management</p>
            </div>
            
            <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                <h4 style="color: #27ae60; margin-bottom: 10px;"><i class="fas fa-user-tie"></i> Support Staff</h4>
                <p style="color: #7f8c8d; font-size: 0.9rem;">Complaint handling and assignment management</p>
            </div>
            
            <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                <h4 style="color: #f39c12; margin-bottom: 10px;"><i class="fas fa-chart-line"></i> Manager</h4>
                <p style="color: #7f8c8d; font-size: 0.9rem;">Performance tracking and team management</p>
            </div>
            
            <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                <h4 style="color: #9b59b6; margin-bottom: 10px;"><i class="fas fa-bullhorn"></i> Marketing</h4>
                <p style="color: #7f8c8d; font-size: 0.9rem;">Feedback analysis and marketing reports</p>
            </div>
            
            <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                <h4 style="color: #e74c3c; margin-bottom: 10px;"><i class="fas fa-calculator"></i> Finance</h4>
                <p style="color: #7f8c8d; font-size: 0.9rem;">Billing issues and financial reports</p>
            </div>
            
            <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                <h4 style="color: #1abc9c; margin-bottom: 10px;"><i class="fas fa-user"></i> Customer</h4>
                <p style="color: #7f8c8d; font-size: 0.9rem;">Complaint submission and feedback</p>
            </div>
        </div>
    </div>

    <!-- Call to Action -->
    <div class="cta-section" style="text-align: center; padding: 40px; background: #f8f9fa; border-radius: 8px;">
        <h3 style="color: #2c3e50; margin-bottom: 20px;">Ready to Get Started?</h3>
        <p style="color: #7f8c8d; margin-bottom: 30px; font-size: 1.1rem;">
            Join thousands of satisfied customers using our comprehensive customer care system.
        </p>
        <div style="display: flex; justify-content: center; gap: 20px; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-success btn-lg">
                <i class="fas fa-rocket"></i> Get Started Now
            </a>
            <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary btn-lg">
                <i class="fas fa-sign-in-alt"></i> Login to Your Account
            </a>
        </div>
    </div>
</div>

<%@ include file="WEB-INF/views/common/footer.jspf" %>