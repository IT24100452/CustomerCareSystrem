<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Feedback" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Feedback Metrics - Marketing Dashboard</title>
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

        .metrics-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .metrics-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .metrics-header h2 {
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

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .metric-card {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .metric-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .metric-icon {
            font-size: 2.5em;
            margin-bottom: 15px;
        }

        .metric-icon.rating {
            color: #f39c12;
        }

        .metric-icon.positive {
            color: #27ae60;
        }

        .metric-icon.negative {
            color: #e74c3c;
        }

        .metric-icon.total {
            color: #3498db;
        }

        .metric-value {
            font-size: 2.5em;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .metric-label {
            color: #7f8c8d;
            font-size: 1em;
            margin-bottom: 10px;
        }

        .metric-change {
            font-size: 0.9em;
            padding: 5px 10px;
            border-radius: 15px;
            font-weight: 600;
        }

        .metric-change.positive {
            background: #d4edda;
            color: #155724;
        }

        .metric-change.negative {
            background: #f8d7da;
            color: #721c24;
        }

        .charts-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .chart-container {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 25px;
        }

        .chart-container h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            text-align: center;
            font-size: 1.3em;
        }

        .chart-wrapper {
            position: relative;
            height: 300px;
        }

        .feedback-table {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .feedback-table h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 1.3em;
        }

        .table-container {
            overflow-x: auto;
        }

        .feedback-table table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .feedback-table th,
        .feedback-table td {
            border: 1px solid #e1e8ed;
            padding: 12px;
            text-align: left;
        }

        .feedback-table th {
            background: #667eea;
            color: white;
            font-weight: 600;
        }

        .feedback-table tr:nth-child(even) {
            background: white;
        }

        .feedback-table tr:hover {
            background: #e8f4fd;
        }

        .rating-stars {
            color: #f39c12;
            font-size: 1.1em;
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
            
            .header h1 {
                font-size: 2em;
            }
            
            .charts-section {
                grid-template-columns: 1fr;
            }
            
            .metrics-grid {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-chart-bar"></i> Customer Feedback Metrics</h1>
            <p>Comprehensive analysis of customer satisfaction and feedback trends</p>
        </div>

        <div class="metrics-container">
            <div class="metrics-header">
                <h2><i class="fas fa-analytics"></i> Feedback Analytics Dashboard</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/marketing/reports?action=create" class="btn btn-success">
                        <i class="fas fa-plus"></i> Create Report
                    </a>
                    <a href="${pageContext.request.contextPath}/marketing/dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </div>

            <!-- Key Metrics -->
            <div class="metrics-grid">
                <div class="metric-card">
                    <div class="metric-icon total">
                        <i class="fas fa-comments"></i>
                    </div>
                    <div class="metric-value"><%= request.getAttribute("totalFeedback") != null ? request.getAttribute("totalFeedback") : "0" %></div>
                    <div class="metric-label">Total Feedback</div>
                    <div class="metric-change positive">+12% this month</div>
                </div>

                <div class="metric-card">
                    <div class="metric-icon rating">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="metric-value"><%= request.getAttribute("avgRating") != null ? String.format("%.1f", request.getAttribute("avgRating")) : "0.0" %></div>
                    <div class="metric-label">Average Rating</div>
                    <div class="metric-change positive">+0.3 this month</div>
                </div>

                <div class="metric-card">
                    <div class="metric-icon positive">
                        <i class="fas fa-thumbs-up"></i>
                    </div>
                    <div class="metric-value"><%= request.getAttribute("positiveFeedback") != null ? request.getAttribute("positiveFeedback") : "0" %></div>
                    <div class="metric-label">Positive Feedback</div>
                    <div class="metric-change positive">+8% this month</div>
                </div>

                <div class="metric-card">
                    <div class="metric-icon negative">
                        <i class="fas fa-thumbs-down"></i>
                    </div>
                    <div class="metric-value"><%= request.getAttribute("negativeFeedback") != null ? request.getAttribute("negativeFeedback") : "0" %></div>
                    <div class="metric-label">Negative Feedback</div>
                    <div class="metric-change negative">-5% this month</div>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="charts-section">
                <div class="chart-container">
                    <h3><i class="fas fa-chart-pie"></i> Feedback Sentiment Distribution</h3>
                    <div class="chart-wrapper">
                        <canvas id="sentimentChart"></canvas>
                    </div>
                </div>

                <div class="chart-container">
                    <h3><i class="fas fa-chart-line"></i> Rating Trends</h3>
                    <div class="chart-wrapper">
                        <canvas id="ratingTrendChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Detailed Feedback Table -->
            <div class="feedback-table">
                <h3><i class="fas fa-table"></i> Recent Customer Feedback</h3>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Customer</th>
                                <th>Rating</th>
                                <th>Sentiment</th>
                                <th>Comment</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Feedback> allFeedback = (List<Feedback>) request.getAttribute("allFeedback");
                                if (allFeedback != null && !allFeedback.isEmpty()) {
                                    for (int i = 0; i < Math.min(allFeedback.size(), 10); i++) {
                                        Feedback feedback = allFeedback.get(i);
                            %>
                            <tr>
                                <td>
                                    <strong>Customer #<%= feedback.getCustomerId() %></strong>
                                    <% if (feedback.getComplaintId() != null) { %>
                                    <br><small>Linked to Complaint #<%= feedback.getComplaintId() %></small>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="rating-stars">
                                        <% for (int j = 0; j < feedback.getRating(); j++) { %>
                                            <i class="fas fa-star"></i>
                                        <% } %>
                                        <% for (int j = feedback.getRating(); j < 5; j++) { %>
                                            <i class="far fa-star"></i>
                                        <% } %>
                                    </span>
                                    <br><small><%= feedback.getRating() %>/5</small>
                                </td>
                                <td>
                                    <span class="sentiment-badge sentiment-<%= feedback.getSentiment() != null ? feedback.getSentiment().toLowerCase() : "neutral" %>">
                                        <%= feedback.getSentiment() != null ? feedback.getSentiment() : "NEUTRAL" %>
                                    </span>
                                </td>
                                <td>
                                    <%= feedback.getComment() != null && feedback.getComment().length() > 100 ? 
                                        feedback.getComment().substring(0, 100) + "..." : 
                                        (feedback.getComment() != null ? feedback.getComment() : "No comment") %>
                                </td>
                                <td>
                                    <%= feedback.getCreatedAt() != null ? feedback.getCreatedAt().toString().substring(0, 10) : "Recently" %>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/feedback?action=view&id=<%= feedback.getFeedbackId() %>" class="btn" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 20px; color: #7f8c8d;">
                                    <i class="fas fa-comment-slash"></i> No feedback data available
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Insights and Recommendations -->
            <div class="feedback-table">
                <h3><i class="fas fa-lightbulb"></i> Insights & Recommendations</h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-top: 20px;">
                    <div style="background: #e8f5e8; border: 1px solid #c3e6c3; border-radius: 8px; padding: 15px;">
                        <h4 style="color: #155724; margin-bottom: 10px;"><i class="fas fa-check-circle"></i> Strengths</h4>
                        <ul style="color: #155724; padding-left: 20px;">
                            <li>High customer satisfaction rating (4.2/5)</li>
                            <li>Positive sentiment trending upward</li>
                            <li>Quick response to feedback</li>
                            <li>Strong customer engagement</li>
                        </ul>
                    </div>
                    <div style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 15px;">
                        <h4 style="color: #856404; margin-bottom: 10px;"><i class="fas fa-exclamation-triangle"></i> Areas for Improvement</h4>
                        <ul style="color: #856404; padding-left: 20px;">
                            <li>Address negative feedback promptly</li>
                            <li>Improve product quality concerns</li>
                            <li>Enhance customer service response time</li>
                            <li>Focus on complaint resolution</li>
                        </ul>
                    </div>
                    <div style="background: #d1ecf1; border: 1px solid #bee5eb; border-radius: 8px; padding: 15px;">
                        <h4 style="color: #0c5460; margin-bottom: 10px;"><i class="fas fa-rocket"></i> Recommendations</h4>
                        <ul style="color: #0c5460; padding-left: 20px;">
                            <li>Implement customer feedback loop</li>
                            <li>Create targeted improvement campaigns</li>
                            <li>Develop customer satisfaction surveys</li>
                            <li>Establish feedback response protocols</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/marketing/dashboard">
                <i class="fas fa-chart-line"></i> Marketing Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/marketing/reports">
                <i class="fas fa-file-alt"></i> Reports
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Sentiment Distribution Chart
        const sentimentCtx = document.getElementById('sentimentChart').getContext('2d');
        new Chart(sentimentCtx, {
            type: 'doughnut',
            data: {
                labels: ['Positive', 'Negative', 'Neutral'],
                datasets: [{
                    data: [
                        <%= request.getAttribute("positiveFeedback") != null ? request.getAttribute("positiveFeedback") : "0" %>,
                        <%= request.getAttribute("negativeFeedback") != null ? request.getAttribute("negativeFeedback") : "0" %>,
                        <%= request.getAttribute("totalFeedback") != null ? 
                            Math.max(0, (Integer) request.getAttribute("totalFeedback") - 
                            (Integer) request.getAttribute("positiveFeedback") - 
                            (Integer) request.getAttribute("negativeFeedback")) : "0" %>
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

        // Rating Trends Chart
        const ratingCtx = document.getElementById('ratingTrendChart').getContext('2d');
        new Chart(ratingCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    label: 'Average Rating',
                    data: [3.8, 4.0, 4.1, 4.0, 4.2, 4.1, 4.3, 4.2, 4.1, 4.0, 4.2, 4.2],
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 5,
                        ticks: {
                            callback: function(value) {
                                return value + '/5';
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    </script>
</body>
</html>
