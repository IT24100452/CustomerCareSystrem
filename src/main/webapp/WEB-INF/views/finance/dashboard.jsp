
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.smartlanka.ccs.model.FinancialReport" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Dashboard - Smart Lanka CCS</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js" rel="stylesheet">
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
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header p {
            color: #7f8c8d;
            font-size: 1.1rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #3498db, #2ecc71);
        }

        .stat-card.revenue::before { background: linear-gradient(90deg, #2ecc71, #27ae60); }
        .stat-card.costs::before { background: linear-gradient(90deg, #e74c3c, #c0392b); }
        .stat-card.profit::before { background: linear-gradient(90deg, #f39c12, #e67e22); }
        .stat-card.margin::before { background: linear-gradient(90deg, #9b59b6, #8e44ad); }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            opacity: 0.8;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #7f8c8d;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }

        .main-content {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .widget {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .widget h3 {
      color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
    }

    .btn {
            background: linear-gradient(135deg, #3498db, #2980b9);
      color: white;
      border: none;
            border-radius: 8px;
            padding: 12px 20px;
      font-size: 14px;
            font-weight: 600;
      cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin: 5px;
    }

    .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.4);
        }

        .btn-success { background: linear-gradient(135deg, #2ecc71, #27ae60); }
        .btn-warning { background: linear-gradient(135deg, #f39c12, #e67e22); }
        .btn-danger { background: linear-gradient(135deg, #e74c3c, #c0392b); }
        .btn-info { background: linear-gradient(135deg, #1abc9c, #16a085); }

        .table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }

        .table th,
        .table td {
      padding: 12px;
      text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        .table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
        }

        .table tr:hover {
            background: #f8f9fa;
        }

        .chart-container {
            position: relative;
            height: 300px;
            margin-top: 20px;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-color: #28a745;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-color: #dc3545;
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

        @media (max-width: 768px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }
            
            .quick-actions {
                grid-template-columns: 1fr;
            }
    }
  </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1>
                        <i class="fas fa-chart-line"></i>
                        Financial Dashboard
                    </h1>
                    <p>Comprehensive financial overview and reporting system</p>
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
                            <span class="user-name">${sessionScope.userName != null ? sessionScope.userName : 'Finance'}</span>
                            <span class="user-email">${sessionScope.userEmail != null ? sessionScope.userEmail : 'finance@smartlanka.com'}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger logout-btn">Logout</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <% if (request.getParameter("status") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <% if ("created".equals(request.getParameter("status"))) { %>
                    Financial report created successfully!
                <% } else if ("updated".equals(request.getParameter("status"))) { %>
                    Financial report updated successfully!
                <% } else if ("deleted".equals(request.getParameter("status"))) { %>
                    Financial report deleted successfully!
                <% } %>
            </div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <% if ("server_error".equals(request.getParameter("error"))) { %>
                    An error occurred. Please try again.
                <% } else if ("access_denied".equals(request.getParameter("error"))) { %>
                    Access denied. You don't have permission to view this page.
                <% } %>
            </div>
        <% } %>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card revenue">
                <div class="stat-icon">
                    <i class="fas fa-dollar-sign"></i>
                </div>
                <div class="stat-value">
                    $<%= request.getAttribute("totalRevenue") != null ? request.getAttribute("totalRevenue") : "0.00" %>
                </div>
                <div class="stat-label">Total Revenue</div>
            </div>

            <div class="stat-card costs">
                <div class="stat-icon">
                    <i class="fas fa-receipt"></i>
                </div>
                <div class="stat-value">
                    $<%= request.getAttribute("totalCosts") != null ? request.getAttribute("totalCosts") : "0.00" %>
                </div>
                <div class="stat-label">Total Costs</div>
            </div>

            <div class="stat-card profit">
                <div class="stat-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-value">
                    $<%= request.getAttribute("totalNetProfit") != null ? request.getAttribute("totalNetProfit") : "0.00" %>
                </div>
                <div class="stat-label">Net Profit</div>
            </div>

            <div class="stat-card margin">
                <div class="stat-icon">
                    <i class="fas fa-percentage"></i>
                </div>
                <div class="stat-value">
                    <%= request.getAttribute("averageProfitMargin") != null ? request.getAttribute("averageProfitMargin") : "0.00" %>%
                </div>
                <div class="stat-label">Avg Profit Margin</div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="content-grid">
            <div class="main-content">
                <h2><i class="fas fa-chart-bar"></i> Financial Overview</h2>
                
                <!-- Chart Container -->
                <div class="chart-container">
                    <canvas id="financialChart"></canvas>
                </div>

                <!-- Recent Reports Table -->
                <h3 style="margin-top: 30px;"><i class="fas fa-file-alt"></i> Recent Financial Reports</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Type</th>
                            <th>Period</th>
                            <th>Revenue</th>
                            <th>Profit</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<FinancialReport> recentReports = (List<FinancialReport>) request.getAttribute("recentReports");
                            if (recentReports != null && !recentReports.isEmpty()) {
                                for (FinancialReport report : recentReports) {
                        %>
                        <tr>
                            <td><%= report.getTitle() %></td>
                            <td><%= report.getReportTypeDisplayName() %></td>
                            <td><%= report.getPeriodDisplayName() %></td>
                            <td>$<%= report.getTotalRevenue() != null ? report.getTotalRevenue() : "0.00" %></td>
                            <td>$<%= report.getNetProfit() != null ? report.getNetProfit() : "0.00" %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/finance?action=view&id=<%= report.getReportId() %>" class="btn btn-info">
                                    <i class="fas fa-eye"></i> View
                                </a>
                                <a href="${pageContext.request.contextPath}/finance?action=edit&id=<%= report.getReportId() %>" class="btn btn-warning">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: #7f8c8d;">
                                <i class="fas fa-info-circle"></i> No financial reports found
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Sidebar -->
            <div class="sidebar">
                <!-- Quick Actions -->
                <div class="widget">
                    <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
                    <div class="quick-actions">
                        <a href="${pageContext.request.contextPath}/finance?action=create" class="btn btn-success">
                            <i class="fas fa-plus"></i> New Report
                        </a>
                        <a href="${pageContext.request.contextPath}/finance?action=list" class="btn btn-info">
                            <i class="fas fa-list"></i> All Reports
                        </a>
                        <a href="${pageContext.request.contextPath}/finance?action=analytics" class="btn btn-warning">
                            <i class="fas fa-chart-pie"></i> Analytics
                        </a>
                        <a href="${pageContext.request.contextPath}/finance?action=export&format=csv" class="btn btn-danger">
                            <i class="fas fa-download"></i> Export CSV
                        </a>
                    </div>
                </div>


                <!-- Summary Stats -->
                <div class="widget">
                    <h3><i class="fas fa-info-circle"></i> Summary</h3>
                    <p><strong>Total Reports:</strong> <%= request.getAttribute("totalReports") != null ? request.getAttribute("totalReports") : "0" %></p>
                    <p><strong>Last Updated:</strong> <%= new java.util.Date() %></p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Financial Chart
        const ctx = document.getElementById('financialChart').getContext('2d');
        const financialChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Revenue',
                    data: [12000, 19000, 15000, 25000, 22000, 30000],
                    borderColor: '#2ecc71',
                    backgroundColor: 'rgba(46, 204, 113, 0.1)',
                    tension: 0.4
                }, {
                    label: 'Costs',
                    data: [8000, 12000, 10000, 15000, 14000, 18000],
                    borderColor: '#e74c3c',
                    backgroundColor: 'rgba(231, 76, 60, 0.1)',
                    tension: 0.4
                }, {
                    label: 'Profit',
                    data: [4000, 7000, 5000, 10000, 8000, 12000],
                    borderColor: '#f39c12',
                    backgroundColor: 'rgba(243, 156, 18, 0.1)',
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