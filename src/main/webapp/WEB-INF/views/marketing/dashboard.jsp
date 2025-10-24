<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Feedback" %>
<%@ page import="lk.smartlanka.ccs.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Marketing Executive Dashboard - Smart Lanka CCS</title>
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

        .user-info {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .user-info .user-details {
            color: white;
        }

        .user-info .user-details h3 {
            margin-bottom: 5px;
            font-size: 1.2em;
        }

        .user-info .user-details p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9em;
        }

        .notification-icon {
            position: relative;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .notification-icon:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.1);
        }

        .notification-icon i {
            color: white;
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
            font-size: 0.7em;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .card h3 {
      color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.3em;
            display: flex;
            align-items: center;
        }

        .card h3 i {
            margin-right: 10px;
            color: #667eea;
        }

        .stat-card {
            text-align: center;
        }

        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 10px;
        }

        .stat-label {
            color: #7f8c8d;
            font-size: 1em;
            margin-bottom: 15px;
        }

        .stat-change {
            font-size: 0.9em;
            padding: 5px 10px;
            border-radius: 15px;
            font-weight: 600;
        }

        .stat-change.positive {
            background: #d4edda;
            color: #155724;
        }

        .stat-change.negative {
            background: #f8d7da;
            color: #721c24;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
    }

    .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
            padding: 15px 20px;
      border: none;
            border-radius: 10px;
            font-size: 1em;
            font-weight: 600;
      cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
    }

    .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
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

        .btn-info {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
        }

        .btn-info:hover {
            box-shadow: 0 10px 20px rgba(52, 152, 219, 0.3);
        }

        .btn-danger {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        }

        .btn-danger:hover {
            box-shadow: 0 10px 20px rgba(231, 76, 60, 0.3);
        }

        .btn i {
            margin-right: 8px;
        }

        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .chart-container h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            text-align: center;
            font-size: 1.4em;
        }

        .chart-wrapper {
            position: relative;
            height: 300px;
        }

        .recent-activity {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .recent-activity h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 1.4em;
        }

        .activity-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border: 1px solid #e1e8ed;
            border-radius: 10px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }

        .activity-item:hover {
            background: #f8f9fa;
            border-color: #667eea;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 1.2em;
        }

        .activity-icon.feedback {
            background: #e8f5e8;
            color: #27ae60;
        }

        .activity-icon.report {
            background: #e3f2fd;
            color: #3498db;
        }

        .activity-icon.metric {
            background: #fff3e0;
            color: #f39c12;
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .activity-description {
            color: #7f8c8d;
            font-size: 0.9em;
        }

        .activity-time {
            color: #95a5a6;
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
            padding: 12px 25px;
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

        .rating-stars {
            color: #f39c12;
            font-size: 1.2em;
        }

        .sentiment-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 600;
        }

        .sentiment-positive {
            background: #d4edda;
            color: #155724;
        }

        .sentiment-negative {
            background: #f8d7da;
            color: #721c24;
        }

        .sentiment-neutral {
            background: #d1ecf1;
            color: #0c5460;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
            
            .quick-actions {
                grid-template-columns: 1fr;
            }
            
            .user-info {
                flex-direction: column;
                text-align: center;
            }
    }
  </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-chart-line"></i> Marketing Executive Dashboard</h1>
            <p>Customer feedback analytics and marketing campaign insights</p>
        </div>

        <div class="user-info">
            <div class="user-details">
                <h3><i class="fas fa-user-tie"></i> Marketing Executive</h3>
                <p>Welcome back! Here's your marketing overview for today.</p>
            </div>
            <div class="notification-icon" onclick="window.location.href='${pageContext.request.contextPath}/notifications'">
                <i class="fas fa-bell"></i>
                <div class="notification-badge" id="notificationCount">0</div>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="dashboard-grid">
            <div class="card stat-card">
                <h3><i class="fas fa-comments"></i> Total Feedback</h3>
                <div class="stat-number"><%= request.getAttribute("totalFeedback") != null ? request.getAttribute("totalFeedback") : "0" %></div>
                <div class="stat-label">Customer Reviews</div>
                <div class="stat-change positive">+12% this month</div>
            </div>

            <div class="card stat-card">
                <h3><i class="fas fa-star"></i> Average Rating</h3>
                <div class="stat-number"><%= request.getAttribute("avgRating") != null ? String.format("%.1f", request.getAttribute("avgRating")) : "0.0" %></div>
                <div class="stat-label">Out of 5.0</div>
                <div class="stat-change positive">+0.3 this month</div>
            </div>

            <div class="card stat-card">
                <h3><i class="fas fa-thumbs-up"></i> Positive Feedback</h3>
                <div class="stat-number"><%= request.getAttribute("positiveFeedback") != null ? request.getAttribute("positiveFeedback") : "0" %></div>
                <div class="stat-label">Happy Customers</div>
                <div class="stat-change positive">+8% this month</div>
            </div>

            <div class="card stat-card">
                <h3><i class="fas fa-thumbs-down"></i> Negative Feedback</h3>
                <div class="stat-number"><%= request.getAttribute("negativeFeedback") != null ? request.getAttribute("negativeFeedback") : "0" %></div>
                <div class="stat-label">Issues to Address</div>
                <div class="stat-change negative">-5% this month</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="card">
            <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/marketing?action=reports" class="btn btn-success">
                    <i class="fas fa-file-alt"></i> Manage Reports
                </a>
                <a href="${pageContext.request.contextPath}/marketing?action=create" class="btn btn-warning">
                    <i class="fas fa-plus"></i> Create Report
                </a>
                <a href="${pageContext.request.contextPath}/marketing?action=dashboard" class="btn btn-info">
                    <i class="fas fa-chart-bar"></i> View Analytics
                </a>
            </div>
        </div>

        <!-- Feedback Sentiment Chart -->
        <div class="chart-container">
            <h3><i class="fas fa-chart-pie"></i> Customer Feedback Sentiment Analysis</h3>
            <div class="chart-wrapper">
                <canvas id="sentimentChart"></canvas>
            </div>
        </div>

        <!-- Recent Feedback Activity -->
        <div class="recent-activity">
            <h3><i class="fas fa-clock"></i> Recent Customer Feedback</h3>
            <%
                List<Feedback> recentFeedback = (List<Feedback>) request.getAttribute("recentFeedback");
                if (recentFeedback != null && !recentFeedback.isEmpty()) {
                    for (int i = 0; i < Math.min(recentFeedback.size(), 5); i++) {
                        Feedback feedback = recentFeedback.get(i);
            %>
            <div class="activity-item">
                <div class="activity-icon feedback">
                    <i class="fas fa-comment"></i>
                </div>
                <div class="activity-content">
                    <div class="activity-title">
                        Customer Feedback - Rating: 
                        <span class="rating-stars">
                            <% for (int j = 0; j < feedback.getRating(); j++) { %>
                                <i class="fas fa-star"></i>
                            <% } %>
                        </span>
                    </div>
                    <div class="activity-description">
                        <%= feedback.getComment() != null && feedback.getComment().length() > 100 ? 
                            feedback.getComment().substring(0, 100) + "..." : 
                            (feedback.getComment() != null ? feedback.getComment() : "No comment") %>
                    </div>
                    <div class="activity-time">
                        Sentiment: 
                        <span class="sentiment-badge sentiment-<%= feedback.getSentiment() != null ? feedback.getSentiment().toLowerCase() : "neutral" %>">
                            <%= feedback.getSentiment() != null ? feedback.getSentiment() : "NEUTRAL" %>
                        </span>
                        • <%= feedback.getCreatedAt() != null ? feedback.getCreatedAt().toString().substring(0, 10) : "Recently" %>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="activity-item">
                <div class="activity-icon feedback">
                    <i class="fas fa-comment"></i>
                </div>
                <div class="activity-content">
                    <div class="activity-title">No Recent Feedback</div>
                    <div class="activity-description">No customer feedback has been received recently.</div>
                </div>
            </div>
            <%
                }
            %>
        </div>


        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/marketing-dashboard/view-feedback-metrics">
                <i class="fas fa-chart-bar"></i> View Feedback Metrics
            </a>
            <a href="${pageContext.request.contextPath}/marketing-dashboard/manage-reports">
                <i class="fas fa-cogs"></i> Manage Reports
            </a>
            <a href="${pageContext.request.contextPath}/marketing-dashboard/create-report">
                <i class="fas fa-plus"></i> Create Report
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Update notification count
        function updateNotificationCount() {
            fetch('${pageContext.request.contextPath}/notifications?action=count')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('notificationCount').textContent = data.count || 0;
                })
                .catch(error => {
                    console.log('Error fetching notification count:', error);
                });
        }

        // Update notification count on page load
        updateNotificationCount();

        // Sentiment Chart
        const ctx = document.getElementById('sentimentChart').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Positive', 'Negative', 'Neutral'],
                datasets: [{
                    data: [
                        <%= request.getAttribute("positiveFeedback") != null ? request.getAttribute("positiveFeedback") : "0" %>,
                        <%= request.getAttribute("negativeFeedback") != null ? request.getAttribute("negativeFeedback") : "0" %>,
                        <%= request.getAttribute("neutralFeedback") != null ? request.getAttribute("neutralFeedback") : "0" %>
                    ],
                    backgroundColor: [
                        '#27ae60',
                        '#e74c3c',
                        '#3498db'
                    ],
                    borderWidth: 0
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
                            font: {
                                size: 14
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>