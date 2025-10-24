<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Complaint" %>
<%@ page import="lk.smartlanka.ccs.model.Feedback" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - Smart Lanka CCS</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            max-width: 1400px;
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
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
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

        .charts-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .chart-card {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
        }

        .chart-card h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            text-align: center;
            font-size: 1.3em;
        }

        .chart-container {
            position: relative;
            height: 300px;
        }

        .performance-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .performance-card {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
        }

        .performance-card h4 {
            color: #2c3e50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .performance-card h4 i {
            margin-right: 10px;
            color: #667eea;
        }

        .staff-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e1e8ed;
        }

        .staff-item:last-child {
            border-bottom: none;
        }

        .staff-name {
            font-weight: 600;
            color: #2c3e50;
        }

        .staff-metrics {
            display: flex;
            gap: 15px;
            font-size: 0.9em;
        }

        .metric {
            text-align: center;
        }

        .metric-value {
            font-weight: bold;
            color: #667eea;
        }

        .metric-label {
            color: #7f8c8d;
            font-size: 0.8em;
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

        .recent-activity {
            margin-top: 30px;
        }

        .activity-item {
            display: flex;
            align-items: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 10px;
            border-left: 4px solid #667eea;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #667eea;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .activity-meta {
            color: #7f8c8d;
            font-size: 0.9em;
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
            
            .charts-container {
                grid-template-columns: 1fr;
            }
            
            .performance-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1><i class="fas fa-chart-line"></i> Manager Dashboard</h1>
                    <p>Track staff performance and manage performance reports</p>
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
                            <span class="user-name">${sessionScope.userName != null ? sessionScope.userName : 'Manager'}</span>
                            <span class="user-email">${sessionScope.userEmail != null ? sessionScope.userEmail : 'manager@smartlanka.com'}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger logout-btn">Logout</a>
                    </div>
                </div>
            </div>
        </div>

        <% 
            List<Complaint> allComplaints = (List<Complaint>) request.getAttribute("allComplaints");
            List<Feedback> recentFeedback = (List<Feedback>) request.getAttribute("recentFeedback");
            int totalComplaints = allComplaints != null ? allComplaints.size() : 0;
            int openComplaints = 0;
            int resolvedComplaints = 0;
            double avgResolutionTime = 0;
            
            if (allComplaints != null) {
                for (Complaint complaint : allComplaints) {
                    if ("OPEN".equals(complaint.getStatusCode())) {
                        openComplaints++;
                    } else if ("RESOLVED".equals(complaint.getStatusCode())) {
                        resolvedComplaints++;
                    }
                }
            }
            
            // Sample performance data
            int totalStaff = 8;
            int activeStaff = 7;
            double avgPerformance = 87.5;
            int reportsGenerated = 12;
        %>

        <div class="stats-container">
            <div class="stat-card">
                <i class="fas fa-users"></i>
                <div class="number"><%= totalStaff %></div>
                <div class="label">Total Staff</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-user-check"></i>
                <div class="number"><%= activeStaff %></div>
                <div class="label">Active Staff</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-chart-bar"></i>
                <div class="number"><%= avgPerformance %>%</div>
                <div class="label">Avg Performance</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-file-alt"></i>
                <div class="number"><%= reportsGenerated %></div>
                <div class="label">Reports Generated</div>
            </div>
        </div>

        <div class="dashboard-container">
            <div class="dashboard-header">
                <h2><i class="fas fa-tachometer-alt"></i> Quick Actions</h2>
            </div>

            <div class="quick-actions">
                <div class="action-card">
                    <i class="fas fa-chart-line"></i>
                    <h3>Track Performance</h3>
                    <p>Monitor staff performance with detailed analytics and visualizations</p>
                    <a href="${pageContext.request.contextPath}/manager?action=performance" class="btn">
                        <i class="fas fa-eye"></i> View Performance
                    </a>
                </div>

                <div class="action-card">
                    <i class="fas fa-file-alt"></i>
                    <h3>Performance Reports</h3>
                    <p>Create, update, and manage performance reports</p>
                    <a href="${pageContext.request.contextPath}/manager?action=reports" class="btn btn-success">
                        <i class="fas fa-plus"></i> Manage Reports
                    </a>
                </div>

                <div class="action-card">
                    <i class="fas fa-download"></i>
                    <h3>Download Reports</h3>
                    <p>Export performance reports as CSV files</p>
                    <a href="${pageContext.request.contextPath}/manager?action=download" class="btn btn-warning">
                        <i class="fas fa-download"></i> Download CSV
                    </a>
                </div>
            </div>

            <!-- Performance Charts -->
            <div class="charts-container">
                <div class="chart-card">
                    <h3><i class="fas fa-chart-pie"></i> Complaint Resolution Distribution</h3>
                    <div class="chart-container">
                        <canvas id="resolutionChart"></canvas>
                    </div>
                </div>

                <div class="chart-card">
                    <h3><i class="fas fa-chart-bar"></i> Staff Performance Trends</h3>
                    <div class="chart-container">
                        <canvas id="performanceChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Staff Performance Overview -->
            <div class="performance-grid">
                <div class="performance-card">
                    <h4><i class="fas fa-star"></i> Top Performers</h4>
                    <div class="staff-item">
                        <div class="staff-name">Sarah Johnson</div>
                        <div class="staff-metrics">
                            <div class="metric">
                                <div class="metric-value">95%</div>
                                <div class="metric-label">Performance</div>
                            </div>
                            <div class="metric">
                                <div class="metric-value">24</div>
                                <div class="metric-label">Resolved</div>
                            </div>
                        </div>
                    </div>
                    <div class="staff-item">
                        <div class="staff-name">Mike Wilson</div>
                        <div class="staff-metrics">
                            <div class="metric">
                                <div class="metric-value">92%</div>
                                <div class="metric-label">Performance</div>
                            </div>
                            <div class="metric">
                                <div class="metric-value">18</div>
                                <div class="metric-label">Resolved</div>
                            </div>
                        </div>
                    </div>
                    <div class="staff-item">
                        <div class="staff-name">Lisa Brown</div>
                        <div class="staff-metrics">
                            <div class="metric">
                                <div class="metric-value">89%</div>
                                <div class="metric-label">Performance</div>
                            </div>
                            <div class="metric">
                                <div class="metric-value">15</div>
                                <div class="metric-label">Resolved</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="performance-card">
                    <h4><i class="fas fa-clock"></i> Resolution Time Analysis</h4>
                    <div class="staff-item">
                        <div class="staff-name">Average Resolution Time</div>
                        <div class="staff-metrics">
                            <div class="metric">
                                <div class="metric-value">2.3</div>
                                <div class="metric-label">Days</div>
                            </div>
                        </div>
                    </div>
                    <div class="staff-item">
                        <div class="staff-name">Fastest Resolution</div>
                        <div class="staff-metrics">
                            <div class="metric">
                                <div class="metric-value">0.5</div>
                                <div class="metric-label">Days</div>
                            </div>
                        </div>
                    </div>
                    <div class="staff-item">
                        <div class="staff-name">Longest Resolution</div>
                        <div class="staff-metrics">
                            <div class="metric">
                                <div class="metric-value">7.2</div>
                                <div class="metric-label">Days</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="recent-activity">
                <h3 style="color: #2c3e50; margin-bottom: 20px;">
                    <i class="fas fa-history"></i> Recent Activity
                </h3>
                
                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">Performance Report Generated</div>
                        <div class="activity-meta">Monthly performance report for November 2024 created • 2 hours ago</div>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">Staff Performance Updated</div>
                        <div class="activity-meta">Sarah Johnson's performance metrics updated • 4 hours ago</div>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="fas fa-download"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">Report Downloaded</div>
                        <div class="activity-meta">Q3 Performance Report exported as CSV • 1 day ago</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/manager?action=performance">
                <i class="fas fa-chart-line"></i> Performance Tracking
            </a>
            <a href="${pageContext.request.contextPath}/manager?action=reports">
                <i class="fas fa-file-alt"></i> Reports
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Complaint Resolution Chart
        const resolutionCtx = document.getElementById('resolutionChart').getContext('2d');
        new Chart(resolutionCtx, {
            type: 'doughnut',
            data: {
                labels: ['Resolved', 'In Progress', 'Open'],
                datasets: [{
                    data: [<%= resolvedComplaints %>, 5, <%= openComplaints %>],
                    backgroundColor: [
                        '#27ae60',
                        '#f39c12',
                        '#e74c3c'
                    ],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            usePointStyle: true
                        }
                    }
                }
            }
        });

        // Staff Performance Chart
        const performanceCtx = document.getElementById('performanceChart').getContext('2d');
        new Chart(performanceCtx, {
            type: 'bar',
            data: {
                labels: ['Sarah', 'Mike', 'Lisa', 'John', 'Emma', 'David'],
                datasets: [{
                    label: 'Performance %',
                    data: [95, 92, 89, 85, 88, 82],
                    backgroundColor: [
                        '#667eea',
                        '#764ba2',
                        '#f093fb',
                        '#f5576c',
                        '#4facfe',
                        '#00f2fe'
                    ],
                    borderWidth: 0,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        ticks: {
                            callback: function(value) {
                                return value + '%';
                            }
                        }
                    }
                }
            }
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
