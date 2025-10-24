<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Complaint" %>
<%@ page import="lk.smartlanka.ccs.model.Feedback" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard - Smart Lanka CCS</title>
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-icon {
            font-size: 3rem;
            margin-bottom: 15px;
            opacity: 0.8;
            color: white;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: white;
            margin-bottom: 5px;
        }

        .stat-label {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
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
            
            .stats-grid {
                grid-template-columns: 1fr;
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
        
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        
        .action-card {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 25px;
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .action-card:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }
        
        .action-card i {
            font-size: 2.5em;
            margin-bottom: 15px;
            display: block;
        }
        
        .action-card h3 {
            margin: 0 0 10px 0;
            color: #fff;
        }
        
        .action-card p {
            color: #cbd5e1;
            margin: 0 0 20px 0;
            font-size: 0.9em;
        }
        
        .action-card .btn {
            width: 100%;
        }
        
        .recent-items {
            margin-top: 30px;
        }
        
        .recent-items h3 {
            color: #fff;
            margin-bottom: 20px;
        }
        
        .item-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .item-card {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            padding: 20px;
            border-left: 4px solid #3498db;
        }
        
        .item-card.complaint {
            border-left-color: #e74c3c;
        }
        
        .item-card.feedback {
            border-left-color: #f39c12;
        }
        
        .item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .item-title {
            font-weight: bold;
            color: #fff;
        }
        
        .item-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: bold;
  }

  .status-open {
            background: rgba(231, 76, 60, 0.2);
            color: #e74c3c;
  }

  .status-resolved {
            background: rgba(39, 174, 96, 0.2);
            color: #27ae60;
        }
        
        .status-pending {
            background: rgba(243, 156, 18, 0.2);
            color: #f39c12;
        }
        
        .item-meta {
            color: #cbd5e1;
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
                    <p>Customer Dashboard</p>
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
                            <span class="user-name">${sessionScope.userName != null ? sessionScope.userName : 'Customer'}</span>
                            <span class="user-email">${sessionScope.userEmail != null ? sessionScope.userEmail : 'customer@smartlanka.com'}</span>
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
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="user-name">${sessionScope.userName != null ? sessionScope.userName : 'Customer'}</div>
                    <div class="user-role">Customer</div>
                </div>
                
                <ul class="nav-menu">
                    <li><a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/complaint?action=create" class="nav-link">
                        <i class="fas fa-plus-circle"></i> Submit Complaint
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/complaint?action=list" class="nav-link">
                        <i class="fas fa-list"></i> My Complaints
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/feedback?action=create" class="nav-link">
                        <i class="fas fa-comment-plus"></i> Submit Feedback
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/feedback?action=list" class="nav-link">
                        <i class="fas fa-comments"></i> My Feedback
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/complaint?action=track" class="nav-link">
                        <i class="fas fa-search"></i> Track Complaint Status
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
                        <h2 class="card-title"><i class="fas fa-tachometer-alt"></i> Customer Dashboard</h2>
                    </div>
                    <div class="card-body">
                        <!-- Statistics -->
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px;">
                            <div style="background: rgba(231, 76, 60, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                <div style="font-size: 2em; color: #e74c3c; margin-bottom: 10px;">
                                    <i class="fas fa-exclamation-triangle"></i>
                                </div>
                                <div style="font-size: 1.5em; font-weight: bold; color: #fff;">${totalComplaints != null ? totalComplaints : 0}</div>
                                <div style="color: #cbd5e1;">Total Complaints</div>
                            </div>
                            <div style="background: rgba(243, 156, 18, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                <div style="font-size: 2em; color: #f39c12; margin-bottom: 10px;">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div style="font-size: 1.5em; font-weight: bold; color: #fff;">${openComplaints != null ? openComplaints : 0}</div>
                                <div style="color: #cbd5e1;">Open Complaints</div>
                            </div>
                            <div style="background: rgba(39, 174, 96, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                <div style="font-size: 2em; color: #27ae60; margin-bottom: 10px;">
                                    <i class="fas fa-check-circle"></i>
      </div>
                                <div style="font-size: 1.5em; font-weight: bold; color: #fff;">${resolvedComplaints != null ? resolvedComplaints : 0}</div>
                                <div style="color: #cbd5e1;">Resolved Complaints</div>
      </div>
                            <div style="background: rgba(52, 152, 219, 0.1); padding: 20px; border-radius: 8px; text-align: center;">
                                <div style="font-size: 2em; color: #3498db; margin-bottom: 10px;">
                                    <i class="fas fa-comment"></i>
      </div>
                                <div style="font-size: 1.5em; font-weight: bold; color: #fff;">${totalFeedback != null ? totalFeedback : 0}</div>
                                <div style="color: #cbd5e1;">Total Feedback</div>
      </div>
    </div>
                        
                        <!-- Quick Actions -->
                        <div class="quick-actions">
                            <div class="action-card">
                                <i class="fas fa-plus-circle" style="color: #e74c3c;"></i>
                                <h3>Submit Complaint</h3>
                                <p>Report an issue or problem you're experiencing</p>
                                <a href="${pageContext.request.contextPath}/complaint?action=create" class="btn btn-danger">
                                    <i class="fas fa-plus"></i> Submit Now
                                </a>
                            </div>
                            
                            <div class="action-card">
                                <i class="fas fa-list" style="color: #3498db;"></i>
                                <h3>View Complaints</h3>
                                <p>See all your submitted complaints and their status</p>
                                <a href="${pageContext.request.contextPath}/complaint?action=list" class="btn btn-primary">
                                    <i class="fas fa-eye"></i> View All
                                </a>
                            </div>
                            
                            <div class="action-card">
                                <i class="fas fa-comment-plus" style="color: #f39c12;"></i>
                                <h3>Submit Feedback</h3>
                                <p>Share your experience and suggestions</p>
                                <a href="${pageContext.request.contextPath}/feedback?action=create" class="btn btn-warning">
                                    <i class="fas fa-plus"></i> Submit Now
                                </a>
                            </div>
                            
                            <div class="action-card">
                                <i class="fas fa-comments" style="color: #9b59b6;"></i>
                                <h3>View Feedback</h3>
                                <p>Review all your submitted feedback</p>
                                <a href="${pageContext.request.contextPath}/feedback?action=list" class="btn btn-secondary">
                                    <i class="fas fa-eye"></i> View All
                                </a>
                            </div>
                            
                            <div class="action-card">
                                <i class="fas fa-search" style="color: #2ecc71;"></i>
                                <h3>Track Complaint Status</h3>
                                <p>Monitor the status of your complaint submissions</p>
                                <a href="${pageContext.request.contextPath}/complaint?action=track" class="btn btn-success">
                                    <i class="fas fa-search"></i> Track Now
                                </a>
                            </div>
                            
                            <div class="action-card">
                                <i class="fas fa-bell" style="color: #34495e;"></i>
                                <h3>Notifications</h3>
                                <p>Check your latest notifications and updates</p>
                                <a href="${pageContext.request.contextPath}/notifications" class="btn btn-info">
                                    <i class="fas fa-bell"></i> View All
      </a>
    </div>
  </div>

                        <!-- Recent Items -->
                        <div class="recent-items">
                            <h3><i class="fas fa-history"></i> Recent Activity</h3>
                            <div class="item-list">
                                <% if (request.getAttribute("recentComplaints") != null) { %>
                                    <% List<Complaint> recentComplaints = (List<Complaint>) request.getAttribute("recentComplaints"); %>
                                    <% for (Complaint complaint : recentComplaints) { %>
                                        <div class="item-card complaint">
                                            <div class="item-header">
                                                <div class="item-title">Complaint #<%= complaint.getComplaintId() %></div>
                                                <div class="item-status status-<%= complaint.getStatusCode().toLowerCase() %>">
                                                    <%= complaint.getStatusDisplayName() %>
                                                </div>
                                            </div>
                                            <div class="item-meta">
                                                <%= complaint.getDescription() != null && complaint.getDescription().length() > 100 ? 
                                                    complaint.getDescription().substring(0, 100) + "..." : 
                                                    complaint.getDescription() != null ? complaint.getDescription() : "No description" %>
                                            </div>
                                        </div>
                                    <% } %>
                                <% } %>
                                
                                <% if (request.getAttribute("recentFeedback") != null) { %>
                                    <% List<Feedback> recentFeedback = (List<Feedback>) request.getAttribute("recentFeedback"); %>
                                    <% for (Feedback feedback : recentFeedback) { %>
                                        <div class="item-card feedback">
                                            <div class="item-header">
                                                <div class="item-title">Feedback #<%= feedback.getFeedbackId() %></div>
                                                <div class="item-status status-pending">
                                                    Submitted
                                                </div>
                                            </div>
                                            <div class="item-meta">
                                                <%= feedback.getComment() != null && feedback.getComment().length() > 100 ? 
                                                    feedback.getComment().substring(0, 100) + "..." : 
                                                    feedback.getComment() != null ? feedback.getComment() : "No comments" %>
                                            </div>
  </div>
                                    <% } %>
                                <% } %>
                                
                                <% if ((request.getAttribute("recentComplaints") == null || ((List<?>) request.getAttribute("recentComplaints")).isEmpty()) && 
                                      (request.getAttribute("recentFeedback") == null || ((List<?>) request.getAttribute("recentFeedback")).isEmpty())) { %>
                                    <div class="item-card">
                                        <div class="item-title">No recent activity</div>
                                        <div class="item-meta">Start by submitting a complaint or feedback to see your activity here.</div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
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