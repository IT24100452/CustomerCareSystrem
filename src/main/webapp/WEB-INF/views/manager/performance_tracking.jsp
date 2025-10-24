<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Complaint" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Performance Tracking - Manager Dashboard</title>
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

        .performance-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .performance-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .performance-header h2 {
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

        .charts-grid {
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

        .staff-performance-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .staff-card {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s ease;
        }

        .staff-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
        }

        .staff-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .staff-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2em;
            font-weight: bold;
            margin-right: 15px;
        }

        .staff-info h4 {
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .staff-role {
            color: #7f8c8d;
            font-size: 0.9em;
        }

        .performance-metrics {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-bottom: 15px;
        }

        .metric {
            text-align: center;
            padding: 10px;
            background: white;
            border-radius: 8px;
            border: 1px solid #e1e8ed;
        }

        .metric-value {
            font-size: 1.5em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }

        .metric-label {
            color: #7f8c8d;
            font-size: 0.8em;
        }

        .performance-bar {
            width: 100%;
            height: 8px;
            background: #e1e8ed;
            border-radius: 4px;
            overflow: hidden;
            margin-bottom: 10px;
        }

        .performance-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-radius: 4px;
            transition: width 0.3s ease;
        }

        .performance-rating {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
        }

        .rating-stars {
            color: #f39c12;
        }

        .rating-score {
            font-weight: bold;
            color: #2c3e50;
        }

        .performance-summary {
            background: #e8f4fd;
            border: 1px solid #bee5eb;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .summary-title {
            color: #0c5460;
            margin-bottom: 15px;
            font-size: 1.2em;
            display: flex;
            align-items: center;
        }

        .summary-title i {
            margin-right: 10px;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .summary-item {
            text-align: center;
            padding: 15px;
            background: white;
            border-radius: 8px;
            border: 1px solid #bee5eb;
        }

        .summary-value {
            font-size: 2em;
            font-weight: bold;
            color: #0c5460;
            margin-bottom: 5px;
        }

        .summary-label {
            color: #0c5460;
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
            
            .performance-container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .charts-grid {
                grid-template-columns: 1fr;
            }
            
            .staff-performance-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-chart-line"></i> Staff Performance Tracking</h1>
            <p>Monitor and analyze staff performance with detailed metrics and visualizations</p>
        </div>

        <div class="performance-container">
            <div class="performance-header">
                <h2><i class="fas fa-users"></i> Performance Analytics</h2>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>

            <!-- Performance Summary -->
            <div class="performance-summary">
                <div class="summary-title">
                    <i class="fas fa-chart-bar"></i> Overall Performance Summary
                </div>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="summary-value">87.5%</div>
                        <div class="summary-label">Average Performance</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-value">2.3</div>
                        <div class="summary-label">Avg Resolution Time (Days)</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-value">156</div>
                        <div class="summary-label">Total Complaints Resolved</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-value">94%</div>
                        <div class="summary-label">Customer Satisfaction</div>
                    </div>
                </div>
            </div>

            <!-- Performance Charts -->
            <div class="charts-grid">
                <div class="chart-card">
                    <h3><i class="fas fa-chart-line"></i> Performance Trends (Last 6 Months)</h3>
                    <div class="chart-container">
                        <canvas id="trendsChart"></canvas>
                    </div>
                </div>

                <div class="chart-card">
                    <h3><i class="fas fa-chart-pie"></i> Resolution Time Distribution</h3>
                    <div class="chart-container">
                        <canvas id="resolutionChart"></canvas>
                    </div>
                </div>

                <div class="chart-card">
                    <h3><i class="fas fa-chart-bar"></i> Monthly Performance Comparison</h3>
                    <div class="chart-container">
                        <canvas id="monthlyChart"></canvas>
                    </div>
                </div>

                <div class="chart-card">
                    <h3><i class="fas fa-chart-area"></i> Customer Satisfaction Trends</h3>
                    <div class="chart-container">
                        <canvas id="satisfactionChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Individual Staff Performance -->
            <h3 style="color: #2c3e50; margin-bottom: 20px;">
                <i class="fas fa-user-friends"></i> Individual Staff Performance
            </h3>

            <div class="staff-performance-grid">
                <!-- Staff Member 1 -->
                <div class="staff-card">
                    <div class="staff-header">
                        <div class="staff-avatar">SJ</div>
                        <div class="staff-info">
                            <h4>Sarah Johnson</h4>
                            <div class="staff-role">Senior Support Specialist</div>
                        </div>
                    </div>
                    <div class="performance-metrics">
                        <div class="metric">
                            <div class="metric-value">95%</div>
                            <div class="metric-label">Performance</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">24</div>
                            <div class="metric-label">Resolved</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">1.8</div>
                            <div class="metric-label">Avg Days</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">98%</div>
                            <div class="metric-label">Satisfaction</div>
                        </div>
                    </div>
                    <div class="performance-bar">
                        <div class="performance-fill" style="width: 95%"></div>
                    </div>
                    <div class="performance-rating">
                        <div class="rating-stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="rating-score">4.9/5</div>
                    </div>
                </div>

                <!-- Staff Member 2 -->
                <div class="staff-card">
                    <div class="staff-header">
                        <div class="staff-avatar">MW</div>
                        <div class="staff-info">
                            <h4>Mike Wilson</h4>
                            <div class="staff-role">Technical Support</div>
                        </div>
                    </div>
                    <div class="performance-metrics">
                        <div class="metric">
                            <div class="metric-value">92%</div>
                            <div class="metric-label">Performance</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">18</div>
                            <div class="metric-label">Resolved</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">2.1</div>
                            <div class="metric-label">Avg Days</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">96%</div>
                            <div class="metric-label">Satisfaction</div>
                        </div>
                    </div>
                    <div class="performance-bar">
                        <div class="performance-fill" style="width: 92%"></div>
                    </div>
                    <div class="performance-rating">
                        <div class="rating-stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="rating-score">4.8/5</div>
                    </div>
                </div>

                <!-- Staff Member 3 -->
                <div class="staff-card">
                    <div class="staff-header">
                        <div class="staff-avatar">LB</div>
                        <div class="staff-info">
                            <h4>Lisa Brown</h4>
                            <div class="staff-role">Customer Support</div>
                        </div>
                    </div>
                    <div class="performance-metrics">
                        <div class="metric">
                            <div class="metric-value">89%</div>
                            <div class="metric-label">Performance</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">15</div>
                            <div class="metric-label">Resolved</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">2.5</div>
                            <div class="metric-label">Avg Days</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">93%</div>
                            <div class="metric-label">Satisfaction</div>
                        </div>
                    </div>
                    <div class="performance-bar">
                        <div class="performance-fill" style="width: 89%"></div>
                    </div>
                    <div class="performance-rating">
                        <div class="rating-stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="far fa-star"></i>
                        </div>
                        <div class="rating-score">4.5/5</div>
                    </div>
                </div>

                <!-- Staff Member 4 -->
                <div class="staff-card">
                    <div class="staff-header">
                        <div class="staff-avatar">JS</div>
                        <div class="staff-info">
                            <h4>John Smith</h4>
                            <div class="staff-role">Billing Support</div>
                        </div>
                    </div>
                    <div class="performance-metrics">
                        <div class="metric">
                            <div class="metric-value">85%</div>
                            <div class="metric-label">Performance</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">12</div>
                            <div class="metric-label">Resolved</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">2.8</div>
                            <div class="metric-label">Avg Days</div>
                        </div>
                        <div class="metric">
                            <div class="metric-value">91%</div>
                            <div class="metric-label">Satisfaction</div>
                        </div>
                    </div>
                    <div class="performance-bar">
                        <div class="performance-fill" style="width: 85%"></div>
                    </div>
                    <div class="performance-rating">
                        <div class="rating-stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="far fa-star"></i>
                        </div>
                        <div class="rating-score">4.3/5</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/manager?action=reports">
                <i class="fas fa-file-alt"></i> Performance Reports
            </a>
            <a href="${pageContext.request.contextPath}/manager?action=download">
                <i class="fas fa-download"></i> Download Reports
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Performance Trends Chart
        const trendsCtx = document.getElementById('trendsChart').getContext('2d');
        new Chart(trendsCtx, {
            type: 'line',
            data: {
                labels: ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    label: 'Average Performance %',
                    data: [82, 85, 88, 87, 89, 87.5],
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

        // Resolution Time Chart
        const resolutionCtx = document.getElementById('resolutionChart').getContext('2d');
        new Chart(resolutionCtx, {
            type: 'doughnut',
            data: {
                labels: ['< 1 Day', '1-2 Days', '2-3 Days', '3-5 Days', '> 5 Days'],
                datasets: [{
                    data: [15, 35, 25, 15, 10],
                    backgroundColor: [
                        '#27ae60',
                        '#2ecc71',
                        '#f39c12',
                        '#e67e22',
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
                            padding: 15,
                            usePointStyle: true
                        }
                    }
                }
            }
        });

        // Monthly Performance Chart
        const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');
        new Chart(monthlyCtx, {
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

        // Customer Satisfaction Chart
        const satisfactionCtx = document.getElementById('satisfactionChart').getContext('2d');
        new Chart(satisfactionCtx, {
            type: 'line',
            data: {
                labels: ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    label: 'Customer Satisfaction %',
                    data: [89, 91, 93, 92, 94, 94],
                    borderColor: '#27ae60',
                    backgroundColor: 'rgba(39, 174, 96, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
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




