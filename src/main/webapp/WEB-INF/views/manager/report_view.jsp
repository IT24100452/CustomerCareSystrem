<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Performance Report - Manager Dashboard</title>
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

        .report-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .report-header h2 {
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

        .report-info {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .report-info h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.3em;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .info-item {
            display: flex;
            align-items: center;
            padding: 10px;
            background: white;
            border-radius: 8px;
            border: 1px solid #e1e8ed;
        }

        .info-item i {
            margin-right: 10px;
            color: #667eea;
            width: 20px;
        }

        .info-label {
            font-weight: 600;
            color: #2c3e50;
            margin-right: 10px;
        }

        .info-value {
            color: #5a6c7d;
        }

        .report-content {
            margin-bottom: 30px;
        }

        .content-section {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .content-section h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.2em;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .metric-card {
            background: white;
            border: 1px solid #e1e8ed;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
        }

        .metric-value {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }

        .metric-label {
            color: #7f8c8d;
            font-size: 0.9em;
        }

        .chart-container {
            background: white;
            border: 1px solid #e1e8ed;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .chart-container h4 {
            color: #2c3e50;
            margin-bottom: 15px;
            text-align: center;
        }

        .chart-wrapper {
            position: relative;
            height: 300px;
        }

        .staff-performance-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .staff-performance-table th,
        .staff-performance-table td {
            border: 1px solid #e1e8ed;
            padding: 12px;
            text-align: left;
        }

        .staff-performance-table th {
            background: #667eea;
            color: white;
            font-weight: 600;
        }

        .staff-performance-table tr:nth-child(even) {
            background: #f8f9fa;
        }

        .staff-performance-table tr:hover {
            background: #e8f4fd;
        }

        .performance-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 600;
        }

        .performance-excellent {
            background: #d4edda;
            color: #155724;
        }

        .performance-good {
            background: #d1ecf1;
            color: #0c5460;
        }

        .performance-average {
            background: #fff3cd;
            color: #856404;
        }

        .performance-poor {
            background: #f8d7da;
            color: #721c24;
        }

        .report-actions {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 30px;
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
            
            .report-container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .report-actions {
                flex-direction: column;
            }
            
            .report-actions .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-file-alt"></i> Performance Report</h1>
            <p>Detailed view of performance metrics and analytics</p>
        </div>

        <div class="report-container">
            <div class="report-header">
                <h2><i class="fas fa-chart-bar"></i> Q4 2024 Performance Report</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/manager?action=reports" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Reports
                    </a>
                </div>
            </div>

            <!-- Report Information -->
            <div class="report-info">
                <h3><i class="fas fa-info-circle"></i> Report Information</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <i class="fas fa-hashtag"></i>
                        <span class="info-label">Report ID:</span>
                        <span class="info-value">#<%= request.getAttribute("reportId") != null ? request.getAttribute("reportId") : "1" %></span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-calendar"></i>
                        <span class="info-label">Period:</span>
                        <span class="info-value">Q4 2024 (Oct-Dec)</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-clock"></i>
                        <span class="info-label">Created:</span>
                        <span class="info-value">December 15, 2024</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-file"></i>
                        <span class="info-label">Format:</span>
                        <span class="info-value">PDF Document</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-download"></i>
                        <span class="info-label">Downloads:</span>
                        <span class="info-value">12 times</span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-user"></i>
                        <span class="info-label">Generated By:</span>
                        <span class="info-value">Manager Dashboard</span>
                    </div>
                </div>
            </div>

            <!-- Report Content -->
            <div class="report-content">
                <!-- Executive Summary -->
                <div class="content-section">
                    <h3><i class="fas fa-chart-line"></i> Executive Summary</h3>
                    <p style="color: #5a6c7d; line-height: 1.6; margin-bottom: 20px;">
                        This quarterly performance report provides a comprehensive analysis of staff performance, 
                        customer satisfaction metrics, and operational efficiency for Q4 2024. The data shows 
                        significant improvements in resolution times and customer satisfaction compared to 
                        previous quarters.
                    </p>
                    
                    <div class="metrics-grid">
                        <div class="metric-card">
                            <div class="metric-value">87.5%</div>
                            <div class="metric-label">Average Performance</div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-value">2.3</div>
                            <div class="metric-label">Avg Resolution Time (Days)</div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-value">156</div>
                            <div class="metric-label">Total Complaints Resolved</div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-value">94%</div>
                            <div class="metric-label">Customer Satisfaction</div>
                        </div>
                    </div>
                </div>

                <!-- Performance Chart -->
                <div class="content-section">
                    <h3><i class="fas fa-chart-bar"></i> Staff Performance Overview</h3>
                    <div class="chart-container">
                        <h4>Performance Distribution</h4>
                        <div class="chart-wrapper">
                            <canvas id="performanceChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Detailed Staff Performance -->
                <div class="content-section">
                    <h3><i class="fas fa-users"></i> Individual Staff Performance</h3>
                    <table class="staff-performance-table">
                        <thead>
                            <tr>
                                <th>Staff Member</th>
                                <th>Performance %</th>
                                <th>Complaints Resolved</th>
                                <th>Avg Resolution Time</th>
                                <th>Customer Satisfaction</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Sarah Johnson</strong><br><small>Senior Support Specialist</small></td>
                                <td>95%</td>
                                <td>24</td>
                                <td>1.8 days</td>
                                <td>98%</td>
                                <td><span class="performance-badge performance-excellent">Excellent</span></td>
                            </tr>
                            <tr>
                                <td><strong>Mike Wilson</strong><br><small>Technical Support</small></td>
                                <td>92%</td>
                                <td>18</td>
                                <td>2.1 days</td>
                                <td>96%</td>
                                <td><span class="performance-badge performance-excellent">Excellent</span></td>
                            </tr>
                            <tr>
                                <td><strong>Lisa Brown</strong><br><small>Customer Support</small></td>
                                <td>89%</td>
                                <td>15</td>
                                <td>2.5 days</td>
                                <td>93%</td>
                                <td><span class="performance-badge performance-good">Good</span></td>
                            </tr>
                            <tr>
                                <td><strong>John Smith</strong><br><small>Billing Support</small></td>
                                <td>85%</td>
                                <td>12</td>
                                <td>2.8 days</td>
                                <td>91%</td>
                                <td><span class="performance-badge performance-good">Good</span></td>
                            </tr>
                            <tr>
                                <td><strong>Emma Davis</strong><br><small>Customer Support</small></td>
                                <td>88%</td>
                                <td>16</td>
                                <td>2.2 days</td>
                                <td>94%</td>
                                <td><span class="performance-badge performance-good">Good</span></td>
                            </tr>
                            <tr>
                                <td><strong>David Lee</strong><br><small>Technical Support</small></td>
                                <td>82%</td>
                                <td>10</td>
                                <td>3.1 days</td>
                                <td>89%</td>
                                <td><span class="performance-badge performance-average">Average</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Key Insights -->
                <div class="content-section">
                    <h3><i class="fas fa-lightbulb"></i> Key Insights & Recommendations</h3>
                    <div style="color: #5a6c7d; line-height: 1.6;">
                        <h4 style="color: #2c3e50; margin-bottom: 10px;">Strengths:</h4>
                        <ul style="margin-bottom: 20px; padding-left: 20px;">
                            <li>Overall team performance improved by 5% compared to Q3</li>
                            <li>Customer satisfaction reached an all-time high of 94%</li>
                            <li>Resolution time decreased by 0.3 days on average</li>
                            <li>Sarah Johnson and Mike Wilson consistently exceed performance targets</li>
                        </ul>
                        
                        <h4 style="color: #2c3e50; margin-bottom: 10px;">Areas for Improvement:</h4>
                        <ul style="margin-bottom: 20px; padding-left: 20px;">
                            <li>David Lee's performance needs attention (82% vs team average 87.5%)</li>
                            <li>Resolution time for complex technical issues could be optimized</li>
                            <li>Consider additional training for billing-related complaints</li>
                        </ul>
                        
                        <h4 style="color: #2c3e50; margin-bottom: 10px;">Recommendations:</h4>
                        <ul style="padding-left: 20px;">
                            <li>Implement peer mentoring program pairing top performers with struggling staff</li>
                            <li>Introduce specialized training modules for technical support</li>
                            <li>Set up weekly performance review sessions</li>
                            <li>Consider performance-based incentives for Q1 2025</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Report Actions -->
            <div class="report-actions">
                <a href="${pageContext.request.contextPath}/manager?action=editReport&id=<%= request.getAttribute("reportId") != null ? request.getAttribute("reportId") : "1" %>" class="btn btn-warning">
                    <i class="fas fa-edit"></i> Edit Report
                </a>
                <a href="${pageContext.request.contextPath}/manager?action=downloadReport&id=<%= request.getAttribute("reportId") != null ? request.getAttribute("reportId") : "1" %>" class="btn btn-success">
                    <i class="fas fa-download"></i> Download PDF
                </a>
                <a href="${pageContext.request.contextPath}/manager?action=downloadReport&id=<%= request.getAttribute("reportId") != null ? request.getAttribute("reportId") : "1" %>&format=csv" class="btn btn-success">
                    <i class="fas fa-file-csv"></i> Download CSV
                </a>
                <a href="${pageContext.request.contextPath}/manager?action=deleteReport&id=<%= request.getAttribute("reportId") != null ? request.getAttribute("reportId") : "1" %>" 
                   class="btn btn-danger" 
                   onclick="return confirm('Are you sure you want to delete this report?')">
                    <i class="fas fa-trash"></i> Delete Report
                </a>
            </div>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/manager?action=reports">
                <i class="fas fa-file-alt"></i> All Reports
            </a>
            <a href="${pageContext.request.contextPath}/manager?action=performance">
                <i class="fas fa-chart-line"></i> Performance Tracking
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Performance Chart
        const ctx = document.getElementById('performanceChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Sarah Johnson', 'Mike Wilson', 'Lisa Brown', 'John Smith', 'Emma Davis', 'David Lee'],
                datasets: [{
                    label: 'Performance %',
                    data: [95, 92, 89, 85, 88, 82],
                    backgroundColor: [
                        '#27ae60',
                        '#2ecc71',
                        '#3498db',
                        '#9b59b6',
                        '#f39c12',
                        '#e74c3c'
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
    </script>
</body>
</html>




