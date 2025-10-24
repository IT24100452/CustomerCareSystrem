<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Details - Smart Lanka CCS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        .report-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .report-header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .report-title {
            font-size: 2.5em;
            color: #2c3e50;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .report-meta {
            display: flex;
            gap: 30px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #7f8c8d;
            font-size: 0.9em;
        }

        .meta-item i {
            color: #3498db;
        }

        .report-actions {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            font-size: 0.9em;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .btn-warning {
            background: linear-gradient(135deg, #f39c12, #e67e22);
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .report-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .report-section {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .section-title {
            font-size: 1.4em;
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .metric-card {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            border-left: 4px solid #3498db;
        }

        .metric-value {
            font-size: 2em;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .metric-label {
            color: #7f8c8d;
            font-size: 0.9em;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .chart-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .chart-title {
            font-size: 1.4em;
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .chart-wrapper {
            position: relative;
            height: 300px;
        }

        .navigation {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 20px;
            margin-top: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .navigation a {
            padding: 12px 20px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .navigation a:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .status-active {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
        }

        .status-draft {
            background: linear-gradient(135deg, #f39c12, #e67e22);
            color: white;
        }

        .status-published {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .status-archived {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
        }

        .roi-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .roi-excellent {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
        }

        .roi-good {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
        }

        .roi-average {
            background: linear-gradient(135deg, #f39c12, #e67e22);
            color: white;
        }

        .roi-poor {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }

        @media (max-width: 768px) {
            .report-content {
                grid-template-columns: 1fr;
            }
            
            .report-meta {
                flex-direction: column;
                gap: 10px;
            }
            
            .metrics-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }
        }
    </style>
</head>
<body>
    <div class="report-container">
        <%
            // Get report ID from request parameter
            String reportIdParam = request.getParameter("id");
            int reportId = 1; // Default
            if (reportIdParam != null) {
                try {
                    reportId = Integer.parseInt(reportIdParam);
                } catch (NumberFormatException e) {
                    reportId = 1;
                }
            }
            
            // Sample report data based on ID
            String reportTitle = "";
            String reportType = "";
            String campaignName = "";
            String period = "";
            String budget = "";
            String roi = "";
            String status = "";
            String createdDate = "";
            String description = "";
            
            switch (reportId) {
                case 1:
                    reportTitle = "Q4 2024 Campaign Analysis";
                    reportType = "Campaign Report";
                    campaignName = "Holiday Marketing Campaign";
                    period = "Oct 1 - Dec 31, 2024";
                    budget = "$15,000";
                    roi = "28%";
                    status = "Active";
                    createdDate = "Dec 15, 2024";
                    description = "Comprehensive analysis of the holiday marketing campaign performance, including customer engagement metrics, conversion rates, and ROI analysis.";
                    break;
                case 2:
                    reportTitle = "Social Media Performance Report";
                    reportType = "Campaign Report";
                    campaignName = "Social Media Campaign";
                    period = "Nov 1 - Nov 30, 2024";
                    budget = "$8,500";
                    roi = "22%";
                    status = "Draft";
                    createdDate = "Dec 10, 2024";
                    description = "Detailed analysis of social media campaign performance across multiple platforms, including engagement rates, reach, and conversion metrics.";
                    break;
                case 3:
                    reportTitle = "Email Marketing Analysis";
                    reportType = "Feedback Analysis";
                    campaignName = "Email Campaign";
                    period = "Dec 1 - Dec 15, 2024";
                    budget = "$5,200";
                    roi = "18%";
                    status = "Published";
                    createdDate = "Dec 20, 2024";
                    description = "Analysis of email marketing campaign effectiveness, including open rates, click-through rates, and customer feedback integration.";
                    break;
                case 4:
                    reportTitle = "Customer Acquisition Report";
                    reportType = "Monthly Summary";
                    campaignName = "Acquisition Campaign";
                    period = "Sep 1 - Sep 30, 2024";
                    budget = "$12,000";
                    roi = "12%";
                    status = "Archived";
                    createdDate = "Oct 5, 2024";
                    description = "Monthly summary of customer acquisition efforts, including lead generation, conversion rates, and cost per acquisition analysis.";
                    break;
                default:
                    reportTitle = "Sample Report";
                    reportType = "General Report";
                    campaignName = "Sample Campaign";
                    period = "Jan 1 - Dec 31, 2024";
                    budget = "$10,000";
                    roi = "20%";
                    status = "Active";
                    createdDate = "Dec 30, 2024";
                    description = "This is a sample report for demonstration purposes.";
                    break;
            }
        %>

        <!-- Report Header -->
        <div class="report-header">
            <h1 class="report-title"><%= reportTitle %></h1>
            <div class="report-meta">
                <div class="meta-item">
                    <i class="fas fa-tag"></i>
                    <span><%= reportType %></span>
                </div>
                <div class="meta-item">
                    <i class="fas fa-calendar"></i>
                    <span><%= period %></span>
                </div>
                <div class="meta-item">
                    <i class="fas fa-dollar-sign"></i>
                    <span><%= budget %></span>
                </div>
                <div class="meta-item">
                    <i class="fas fa-chart-line"></i>
                    <span>ROI: <%= roi %></span>
                </div>
                <div class="meta-item">
                    <i class="fas fa-info-circle"></i>
                    <span>Status: <span class="status-badge status-<%= status.toLowerCase() %>"><%= status %></span></span>
                </div>
                <div class="meta-item">
                    <i class="fas fa-clock"></i>
                    <span>Created: <%= createdDate %></span>
                </div>
            </div>
            
            <p style="color: #7f8c8d; font-size: 1.1em; line-height: 1.6; margin: 20px 0;">
                <%= description %>
            </p>
            
            <div class="report-actions">
                <a href="${pageContext.request.contextPath}/marketing-dashboard/report-edit?id=<%= reportId %>" class="btn btn-warning">
                    <i class="fas fa-edit"></i> Edit Report
                </a>
                <a href="${pageContext.request.contextPath}/marketing-dashboard/download-report?id=<%= reportId %>&format=csv" class="btn btn-success">
                    <i class="fas fa-download"></i> Download CSV
                </a>
                <a href="${pageContext.request.contextPath}/marketing-dashboard/download-report?id=<%= reportId %>&format=pdf" class="btn btn-primary">
                    <i class="fas fa-file-pdf"></i> Download PDF
                </a>
            </div>
        </div>

        <!-- Report Content -->
        <div class="report-content">
            <!-- Key Metrics -->
            <div class="report-section">
                <h2 class="section-title">
                    <i class="fas fa-chart-bar"></i>
                    Key Metrics
                </h2>
                <div class="metrics-grid">
                    <div class="metric-card">
                        <div class="metric-value"><%= budget %></div>
                        <div class="metric-label">Total Budget</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-value"><%= roi %></div>
                        <div class="metric-label">ROI</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-value">1,250</div>
                        <div class="metric-label">Impressions</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-value">85%</div>
                        <div class="metric-label">Engagement Rate</div>
                    </div>
                </div>
            </div>

            <!-- Campaign Details -->
            <div class="report-section">
                <h2 class="section-title">
                    <i class="fas fa-info-circle"></i>
                    Campaign Details
                </h2>
                <div style="line-height: 1.8;">
                    <p><strong>Campaign Name:</strong> <%= campaignName %></p>
                    <p><strong>Report Type:</strong> <%= reportType %></p>
                    <p><strong>Period:</strong> <%= period %></p>
                    <p><strong>Budget:</strong> <%= budget %></p>
                    <p><strong>ROI:</strong> <span class="roi-badge roi-<%= roi.equals("28%") ? "excellent" : roi.equals("22%") ? "good" : roi.equals("18%") ? "average" : "poor" %>"><%= roi %></span></p>
                    <p><strong>Status:</strong> <span class="status-badge status-<%= status.toLowerCase() %>"><%= status %></span></p>
                    <p><strong>Created Date:</strong> <%= createdDate %></p>
                </div>
            </div>
        </div>

        <!-- Performance Chart -->
        <div class="chart-container">
            <h2 class="chart-title">
                <i class="fas fa-chart-line"></i>
                Performance Overview
            </h2>
            <div class="chart-wrapper">
                <canvas id="performanceChart"></canvas>
            </div>
        </div>

        <!-- Navigation -->
        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/marketing-dashboard/dashboard">
                <i class="fas fa-chart-line"></i> Marketing Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/marketing-dashboard/manage-reports">
                <i class="fas fa-list"></i> All Reports
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
        // Performance Chart
        const ctx = document.getElementById('performanceChart').getContext('2d');
        const performanceChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5', 'Week 6', 'Week 7', 'Week 8'],
                datasets: [{
                    label: 'Impressions',
                    data: [1200, 1350, 1100, 1400, 1600, 1500, 1700, 1650],
                    borderColor: '#3498db',
                    backgroundColor: 'rgba(52, 152, 219, 0.1)',
                    tension: 0.4,
                    fill: true
                }, {
                    label: 'Clicks',
                    data: [85, 95, 78, 105, 120, 115, 130, 125],
                    borderColor: '#27ae60',
                    backgroundColor: 'rgba(39, 174, 96, 0.1)',
                    tension: 0.4,
                    fill: true
                }, {
                    label: 'Conversions',
                    data: [12, 15, 10, 18, 22, 20, 25, 23],
                    borderColor: '#e74c3c',
                    backgroundColor: 'rgba(231, 76, 60, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: 'Campaign Performance Over Time'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>




