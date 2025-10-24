<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="lk.smartlanka.ccs.model.FinancialReport" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>

<%
    List<FinancialReport> reports = (List<FinancialReport>) request.getAttribute("reports");
    BigDecimal totalRevenue = (BigDecimal) request.getAttribute("totalRevenue");
    BigDecimal totalCosts = (BigDecimal) request.getAttribute("totalCosts");
    BigDecimal totalNetProfit = (BigDecimal) request.getAttribute("totalNetProfit");
    BigDecimal averageProfitMargin = (BigDecimal) request.getAttribute("averageProfitMargin");
    BigDecimal totalComplaintCosts = (BigDecimal) request.getAttribute("totalComplaintCosts");
    BigDecimal totalResolutionCosts = (BigDecimal) request.getAttribute("totalResolutionCosts");
    
    if (reports == null) reports = new java.util.ArrayList<>();
    if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;
    if (totalCosts == null) totalCosts = BigDecimal.ZERO;
    if (totalNetProfit == null) totalNetProfit = BigDecimal.ZERO;
    if (averageProfitMargin == null) averageProfitMargin = BigDecimal.ZERO;
    if (totalComplaintCosts == null) totalComplaintCosts = BigDecimal.ZERO;
    if (totalResolutionCosts == null) totalResolutionCosts = BigDecimal.ZERO;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Analytics - Smart Lanka CCS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }

        .container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            padding: 30px;
            margin: 0 auto;
            max-width: 1400px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e9ecef;
        }

        .header h1 {
            color: #2c3e50;
            margin: 0;
            font-size: 2.5rem;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card h3 {
            margin: 0 0 10px 0;
            font-size: 1rem;
            opacity: 0.9;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .stat-card .value {
            font-size: 2.5rem;
            font-weight: bold;
            margin: 0;
        }

        .charts-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }

        .chart-container {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .chart-container h3 {
            color: #2c3e50;
            margin: 0 0 20px 0;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .chart-wrapper {
            position: relative;
            height: 400px;
        }

        .analytics-table {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .analytics-table h3 {
            color: #2c3e50;
            margin: 0 0 20px 0;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        th {
            background: #3498db;
            color: white;
            font-weight: 600;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .trend-indicator {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .trend-up {
            background: #d4edda;
            color: #155724;
        }

        .trend-down {
            background: #f8d7da;
            color: #721c24;
        }

        .trend-neutral {
            background: #d1ecf1;
            color: #0c5460;
        }

        .insights-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .insights-section h3 {
            margin: 0 0 20px 0;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .insights-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .insight-item {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 20px;
            backdrop-filter: blur(10px);
        }

        .insight-item h4 {
            margin: 0 0 10px 0;
            font-size: 1rem;
            opacity: 0.9;
        }

        .insight-item p {
            margin: 0;
            line-height: 1.5;
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px;
                margin: 10px;
            }
            
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .charts-grid {
                grid-template-columns: 1fr;
            }
            
            .chart-wrapper {
                height: 300px;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>
                <i class="fas fa-chart-pie"></i>
                Financial Analytics
            </h1>
            <div>
                <a href="${pageContext.request.contextPath}/finance?action=dashboard" class="btn btn-secondary">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/finance?action=list" class="btn btn-primary">
                    <i class="fas fa-list"></i> All Reports
                </a>
            </div>
        </div>

        <!-- Key Metrics -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3><i class="fas fa-dollar-sign"></i> Total Revenue</h3>
                <p class="value">$<%= String.format("%.2f", totalRevenue) %></p>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-receipt"></i> Total Costs</h3>
                <p class="value">$<%= String.format("%.2f", totalCosts) %></p>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-chart-line"></i> Net Profit</h3>
                <p class="value">$<%= String.format("%.2f", totalNetProfit) %></p>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-percentage"></i> Avg Profit Margin</h3>
                <p class="value"><%= String.format("%.2f", averageProfitMargin) %>%</p>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="charts-grid">
            <!-- Revenue vs Costs Chart -->
            <div class="chart-container">
                <h3><i class="fas fa-chart-bar"></i> Revenue vs Costs Trend</h3>
                <div class="chart-wrapper">
                    <canvas id="revenueCostsChart"></canvas>
                </div>
            </div>

            <!-- Profit Margin Chart -->
            <div class="chart-container">
                <h3><i class="fas fa-chart-pie"></i> Cost Breakdown</h3>
                <div class="chart-wrapper">
                    <canvas id="costBreakdownChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Monthly Performance Chart -->
        <div class="chart-container">
            <h3><i class="fas fa-chart-line"></i> Monthly Performance Overview</h3>
            <div class="chart-wrapper">
                <canvas id="monthlyChart"></canvas>
            </div>
        </div>

        <!-- Recent Reports Table -->
        <div class="analytics-table">
            <h3><i class="fas fa-table"></i> Recent Financial Reports</h3>
            <table>
                <thead>
                    <tr>
                        <th>Report ID</th>
                        <th>Title</th>
                        <th>Type</th>
                        <th>Period</th>
                        <th>Revenue</th>
                        <th>Profit</th>
                        <th>Margin</th>
                        <th>Trend</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (int i = 0; i < Math.min(reports.size(), 10); i++) {
                            FinancialReport report = reports.get(i);
                            BigDecimal margin = report.calculateProfitMargin();
                            String trendClass = "trend-neutral";
                            String trendIcon = "fas fa-minus";
                            String trendText = "Stable";
                            
                            if (margin != null) {
                                if (margin.compareTo(BigDecimal.valueOf(15)) > 0) {
                                    trendClass = "trend-up";
                                    trendIcon = "fas fa-arrow-up";
                                    trendText = "High";
                                } else if (margin.compareTo(BigDecimal.valueOf(5)) < 0) {
                                    trendClass = "trend-down";
                                    trendIcon = "fas fa-arrow-down";
                                    trendText = "Low";
                                }
                            }
                    %>
                    <tr>
                        <td>#<%= report.getReportId() %></td>
                        <td><%= report.getTitle() %></td>
                        <td><%= report.getReportTypeDisplayName() %></td>
                        <td><%= report.getPeriodDisplayName() %></td>
                        <td>$<%= report.getTotalRevenue() != null ? String.format("%.2f", report.getTotalRevenue()) : "0.00" %></td>
                        <td>$<%= report.getNetProfit() != null ? String.format("%.2f", report.getNetProfit()) : "0.00" %></td>
                        <td><%= margin != null ? String.format("%.2f", margin) + "%" : "0.00%" %></td>
                        <td>
                            <span class="trend-indicator <%= trendClass %>">
                                <i class="<%= trendIcon %>"></i>
                                <%= trendText %>
                            </span>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Insights Section -->
        <div class="insights-section">
            <h3><i class="fas fa-lightbulb"></i> Key Insights</h3>
            <div class="insights-grid">
                <div class="insight-item">
                    <h4>Revenue Performance</h4>
                    <p>Total revenue of $<%= String.format("%.2f", totalRevenue) %> across <%= reports.size() %> reports shows 
                    <% if (totalRevenue.compareTo(BigDecimal.valueOf(100000)) > 0) { %>
                        strong financial performance with significant revenue generation.
                    <% } else { %>
                        moderate revenue levels with room for growth.
                    <% } %></p>
                </div>
                <div class="insight-item">
                    <h4>Cost Management</h4>
                    <p>Total operational costs of $<%= String.format("%.2f", totalCosts) %> represent 
                    <% if (totalCosts.compareTo(totalRevenue.multiply(BigDecimal.valueOf(0.7))) < 0) { %>
                        efficient cost management with good cost-to-revenue ratio.
                    <% } else { %>
                        higher cost structure that may need optimization.
                    <% } %></p>
                </div>
                <div class="insight-item">
                    <h4>Profitability Analysis</h4>
                    <p>Average profit margin of <%= String.format("%.2f", averageProfitMargin) %>% indicates 
                    <% if (averageProfitMargin.compareTo(BigDecimal.valueOf(15)) > 0) { %>
                        excellent profitability with strong margins.
                    <% } else if (averageProfitMargin.compareTo(BigDecimal.valueOf(10)) > 0) { %>
                        good profitability with healthy margins.
                    <% } else { %>
                        moderate profitability that could be improved.
                    <% } %></p>
                </div>
                <div class="insight-item">
                    <h4>Cost Breakdown</h4>
                    <p>Complaint costs ($<%= String.format("%.2f", totalComplaintCosts) %>) and resolution costs 
                    ($<%= String.format("%.2f", totalResolutionCosts) %>) represent 
                    <% if (totalComplaintCosts.add(totalResolutionCosts).compareTo(totalCosts.multiply(BigDecimal.valueOf(0.3))) < 0) { %>
                        efficient customer service operations.
                    <% } else { %>
                        significant investment in customer service quality.
                    <% } %></p>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Revenue vs Costs Chart
        const revenueCostsCtx = document.getElementById('revenueCostsChart').getContext('2d');
        new Chart(revenueCostsCtx, {
            type: 'line',
            data: {
                labels: [
                    <% for (int i = 0; i < Math.min(reports.size(), 6); i++) { %>
                        '<%= reports.get(i).getPeriodDisplayName() %>'<%= i < Math.min(reports.size(), 6) - 1 ? "," : "" %>
                    <% } %>
                ],
                datasets: [{
                    label: 'Revenue',
                    data: [
                        <% for (int i = 0; i < Math.min(reports.size(), 6); i++) { %>
                            <%= reports.get(i).getTotalRevenue() != null ? reports.get(i).getTotalRevenue() : 0 %><%= i < Math.min(reports.size(), 6) - 1 ? "," : "" %>
                        <% } %>
                    ],
                    borderColor: '#27ae60',
                    backgroundColor: 'rgba(39, 174, 96, 0.1)',
                    tension: 0.4
                }, {
                    label: 'Costs',
                    data: [
                        <% for (int i = 0; i < Math.min(reports.size(), 6); i++) { %>
                            <%= reports.get(i).getTotalCosts() != null ? reports.get(i).getTotalCosts() : 0 %><%= i < Math.min(reports.size(), 6) - 1 ? "," : "" %>
                        <% } %>
                    ],
                    borderColor: '#e74c3c',
                    backgroundColor: 'rgba(231, 76, 60, 0.1)',
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });

        // Cost Breakdown Chart
        const costBreakdownCtx = document.getElementById('costBreakdownChart').getContext('2d');
        new Chart(costBreakdownCtx, {
            type: 'doughnut',
            data: {
                labels: ['Complaint Costs', 'Resolution Costs', 'Other Costs'],
                datasets: [{
                    data: [
                        <%= totalComplaintCosts %>,
                        <%= totalResolutionCosts %>,
                        <%= totalCosts.subtract(totalComplaintCosts).subtract(totalResolutionCosts) %>
                    ],
                    backgroundColor: [
                        '#e74c3c',
                        '#f39c12',
                        '#95a5a6'
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
                    }
                }
            }
        });

        // Monthly Performance Chart
        const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');
        new Chart(monthlyCtx, {
            type: 'bar',
            data: {
                labels: [
                    <% for (int i = 0; i < Math.min(reports.size(), 8); i++) { %>
                        '<%= reports.get(i).getPeriodDisplayName() %>'<%= i < Math.min(reports.size(), 8) - 1 ? "," : "" %>
                    <% } %>
                ],
                datasets: [{
                    label: 'Net Profit',
                    data: [
                        <% for (int i = 0; i < Math.min(reports.size(), 8); i++) { %>
                            <%= reports.get(i).getNetProfit() != null ? reports.get(i).getNetProfit() : 0 %><%= i < Math.min(reports.size(), 8) - 1 ? "," : "" %>
                        <% } %>
                    ],
                    backgroundColor: 'rgba(52, 152, 219, 0.8)',
                    borderColor: '#3498db',
                    borderWidth: 1
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
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    </script>

    <%@ include file="../common/footer.jspf" %>
</body>
</html>

