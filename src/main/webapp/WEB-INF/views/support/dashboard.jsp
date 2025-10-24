<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Complaint" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Support Dashboard - Smart Lanka CCS</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
            text-align: center;
        }

        .header p {
            color: rgba(255, 255, 255, 0.9);
            text-align: center;
            font-size: 1.1em;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .stat-card i {
            font-size: 2.5em;
            margin-bottom: 10px;
            color: white;
        }

        .stat-card .number {
            font-size: 2em;
            font-weight: bold;
            color: white;
            margin-bottom: 5px;
        }

        .stat-card .label {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9em;
        }

        .dashboard-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .dashboard-header h2 {
            color: #2c3e50;
            font-size: 1.8em;
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

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .action-card {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .action-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
        }

        .action-card i {
            font-size: 2.5em;
            margin-bottom: 15px;
            color: #667eea;
        }

        .action-card h3 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 1.2em;
        }

        .action-card p {
            color: #5a6c7d;
            margin-bottom: 15px;
            font-size: 0.9em;
        }

        .action-card .btn {
            padding: 8px 16px;
            font-size: 0.9em;
        }

        .recent-complaints {
            margin-top: 30px;
        }

        .complaint-card {
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .complaint-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
        }

        .complaint-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .complaint-title {
            font-size: 1.2em;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .complaint-id {
            color: #7f8c8d;
            font-size: 0.9em;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-open {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .status-in-progress {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .status-resolved {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-closed {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .priority-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.7em;
            font-weight: 600;
            text-transform: uppercase;
            margin-left: 10px;
        }

        .priority-critical {
            background: #f8d7da;
            color: #721c24;
        }

        .priority-high {
            background: #fff3cd;
            color: #856404;
        }

        .priority-medium {
            background: #d1ecf1;
            color: #0c5460;
        }

        .priority-low {
            background: #d4edda;
            color: #155724;
        }

        .complaint-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            color: #5a6c7d;
        }

        .meta-item i {
            margin-right: 8px;
            color: #7f8c8d;
            width: 16px;
        }

        .complaint-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .complaint-actions .btn {
            padding: 6px 12px;
            font-size: 0.8em;
        }

        .navigation {
            text-align: center;
            margin-top: 30px;
        }

        .navigation a {
            color: white;
            text-decoration: none;
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
            display: inline-block;
            margin: 0 10px;
        }

        .navigation a:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .dashboard-container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .complaint-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .complaint-actions {
                width: 100%;
                justify-content: stretch;
            }
            
            .complaint-actions .btn {
                flex: 1;
                text-align: center;
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
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1><i class="fas fa-headset"></i> Support Dashboard</h1>
                    <p>Manage complaints and provide excellent customer support</p>
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
                            <span class="user-name">${sessionScope.userName != null ? sessionScope.userName : 'Support'}</span>
                            <span class="user-email">${sessionScope.userEmail != null ? sessionScope.userEmail : 'support@smartlanka.com'}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger logout-btn">Logout</a>
                    </div>
                </div>
            </div>
        </div>

        <% 
            List<Complaint> assignedComplaints = (List<Complaint>) request.getAttribute("assignedComplaints");
            List<Complaint> recentComplaints = (List<Complaint>) request.getAttribute("recentComplaints");
            int totalAssigned = assignedComplaints != null ? assignedComplaints.size() : 0;
            int openAssigned = 0;
            int resolvedAssigned = 0;
            
            if (assignedComplaints != null) {
                for (Complaint complaint : assignedComplaints) {
                    if ("OPEN".equals(complaint.getStatusCode())) {
                        openAssigned++;
                    } else if ("RESOLVED".equals(complaint.getStatusCode())) {
                        resolvedAssigned++;
                    }
                }
            }
        %>

        <div class="stats-container">
            <div class="stat-card">
                <i class="fas fa-tasks"></i>
                <div class="number"><%= totalAssigned %></div>
                <div class="label">Total Assigned</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-clock"></i>
                <div class="number"><%= openAssigned %></div>
                <div class="label">Open</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-check-circle"></i>
                <div class="number"><%= resolvedAssigned %></div>
                <div class="label">Resolved</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-chart-line"></i>
                <div class="number">85%</div>
                <div class="label">Success Rate</div>
            </div>
        </div>

        <div class="dashboard-container">
            <div class="dashboard-header">
                <h2><i class="fas fa-tachometer-alt"></i> Quick Actions</h2>
            </div>

            <div class="quick-actions">
                <div class="action-card">
                    <i class="fas fa-user-plus"></i>
                    <h3>Assign Complaints</h3>
                    <p>Assign new complaints to support team members</p>
                    <a href="${pageContext.request.contextPath}/assignment?action=assign" class="btn">
                        <i class="fas fa-plus"></i> Assign Now
                    </a>
                </div>

                <div class="action-card">
                    <i class="fas fa-search"></i>
                    <h3>Track Assigned</h3>
                    <p>Monitor the status of assigned complaints</p>
                    <a href="${pageContext.request.contextPath}/assignment?action=track" class="btn btn-secondary">
                        <i class="fas fa-eye"></i> Track Status
                    </a>
                </div>

                <div class="action-card">
                    <i class="fas fa-edit"></i>
                    <h3>Update Complaints</h3>
                    <p>Update assigned complaint details and status</p>
                    <a href="${pageContext.request.contextPath}/complaint?action=list" class="btn btn-warning">
                        <i class="fas fa-pencil-alt"></i> Update Now
                    </a>
                </div>

                <div class="action-card">
                    <i class="fas fa-trash"></i>
                    <h3>Delete Complaints</h3>
                    <p>Remove resolved or invalid complaints</p>
                    <a href="${pageContext.request.contextPath}/complaint?action=delete" class="btn btn-danger">
                        <i class="fas fa-trash-alt"></i> Delete
                    </a>
                </div>
            </div>

            <% if (recentComplaints != null && !recentComplaints.isEmpty()) { %>
                <div class="recent-complaints">
                    <h3 style="color: #2c3e50; margin-bottom: 20px;">
                        <i class="fas fa-clock"></i> Recent Assigned Complaints
                    </h3>
                    
                    <% for (Complaint complaint : recentComplaints) { %>
                        <div class="complaint-card">
                            <div class="complaint-header">
                                <div>
                                    <div class="complaint-title"><%= complaint.getTitle() %></div>
                                    <div class="complaint-id">Complaint #<%= complaint.getComplaintId() %></div>
                                </div>
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <span class="status-badge status-<%= complaint.getStatusCode().toLowerCase().replace("_", "-") %>">
                                        <%= complaint.getStatusDisplayName() %>
                                    </span>
                                    <span class="priority-badge priority-<%= complaint.getPriorityCode().toLowerCase() %>">
                                        <%= complaint.getPriorityDisplayName() %>
                                    </span>
                                </div>
                            </div>

                            <div class="complaint-meta">
                                <div class="meta-item">
                                    <i class="fas fa-tag"></i>
                                    <span><%= complaint.getIssueTypeDisplayName() %></span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-calendar"></i>
                                    <span>Submitted: <%= complaint.getSubmittedDate().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) %></span>
                                </div>
                                <% if (complaint.getLastUpdated() != null) { %>
                                    <div class="meta-item">
                                        <i class="fas fa-clock"></i>
                                        <span>Updated: <%= complaint.getLastUpdated().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) %></span>
                                    </div>
                                <% } %>
                            </div>

                            <div class="complaint-actions">
                                <a href="${pageContext.request.contextPath}/complaint?action=view&id=<%= complaint.getComplaintId() %>" class="btn">
                                    <i class="fas fa-eye"></i> View
                                </a>
                                <a href="${pageContext.request.contextPath}/complaint?action=edit&id=<%= complaint.getComplaintId() %>" class="btn btn-warning">
                                    <i class="fas fa-edit"></i> Update
                                </a>
                                <% if ("OPEN".equals(complaint.getStatusCode()) || "IN_PROGRESS".equals(complaint.getStatusCode())) { %>
                                    <a href="${pageContext.request.contextPath}/complaint?action=delete&id=<%= complaint.getComplaintId() %>" 
                                       class="btn btn-danger" 
                                       onclick="return confirm('Are you sure you want to delete this complaint?')">
                                        <i class="fas fa-trash"></i> Delete
                                    </a>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/assignment?action=assign">
                <i class="fas fa-user-plus"></i> Assign Complaints
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
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
