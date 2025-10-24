<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.smartlanka.ccs.model.FinancialReport" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Reports - Smart Lanka CCS</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            display: flex;
            align-items: center;
            gap: 15px;
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
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.4);
        }

        .btn-success { background: linear-gradient(135deg, #2ecc71, #27ae60); }
        .btn-warning { background: linear-gradient(135deg, #f39c12, #e67e22); }
        .btn-danger { background: linear-gradient(135deg, #e74c3c, #c0392b); }
        .btn-info { background: linear-gradient(135deg, #1abc9c, #16a085); }

        .content {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .table th,
        .table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        .table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
            position: sticky;
            top: 0;
        }

        .table tr:hover {
            background: #f8f9fa;
        }

        .actions {
            display: flex;
            gap: 5px;
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

        .filters {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        .filters select,
        .filters input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            border-left: 4px solid #3498db;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: bold;
            color: #2c3e50;
        }

        .stat-label {
            color: #7f8c8d;
            font-size: 0.9rem;
            margin-top: 5px;
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 20px;
            }
            
            .filters {
                flex-direction: column;
                align-items: stretch;
            }
            
            .actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>
                <i class="fas fa-file-alt"></i>
                Financial Reports
            </h1>
            <div>
                <a href="${pageContext.request.contextPath}/finance?action=dashboard" class="btn btn-info">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/finance?action=create" class="btn btn-success">
                    <i class="fas fa-plus"></i> New Report
                </a>
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
                <% if ("not_found".equals(request.getParameter("error"))) { %>
                    Financial report not found.
                <% } else if ("server_error".equals(request.getParameter("error"))) { %>
                    An error occurred. Please try again.
                <% } %>
            </div>
        <% } %>

        <!-- Content -->
        <div class="content">
            <!-- Filters -->
            <div class="filters">
                <label><strong>Filters:</strong></label>
                <select onchange="filterByType(this.value)">
                    <option value="">All Types</option>
                    <option value="MONTHLY">Monthly</option>
                    <option value="QUARTERLY">Quarterly</option>
                    <option value="ANNUAL">Annual</option>
                    <option value="CUSTOM">Custom</option>
                </select>
                <input type="text" placeholder="Search by title..." onkeyup="searchReports(this.value)">
                <button onclick="exportReports()" class="btn btn-info">
                    <i class="fas fa-download"></i> Export CSV
                </button>
            </div>

            <!-- Statistics -->
            <% 
                List<FinancialReport> reports = (List<FinancialReport>) request.getAttribute("reports");
                int totalReports = reports != null ? reports.size() : 0;
            %>
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-value"><%= totalReports %></div>
                    <div class="stat-label">Total Reports</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <%= reports != null && !reports.isEmpty() ? 
                            reports.stream().filter(r -> "MONTHLY".equals(r.getReportType())).count() : 0 %>
                    </div>
                    <div class="stat-label">Monthly Reports</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <%= reports != null && !reports.isEmpty() ? 
                            reports.stream().filter(r -> "QUARTERLY".equals(r.getReportType())).count() : 0 %>
                    </div>
                    <div class="stat-label">Quarterly Reports</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <%= reports != null && !reports.isEmpty() ? 
                            reports.stream().filter(r -> "ANNUAL".equals(r.getReportType())).count() : 0 %>
                    </div>
                    <div class="stat-label">Annual Reports</div>
                </div>
            </div>

            <!-- Reports Table -->
            <table class="table" id="reportsTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Type</th>
                        <th>Period</th>
                        <th>Revenue</th>
                        <th>Costs</th>
                        <th>Profit</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        if (reports != null && !reports.isEmpty()) {
                            for (FinancialReport report : reports) {
                    %>
                    <tr data-type="<%= report.getReportType() %>" data-title="<%= report.getTitle().toLowerCase() %>">
                        <td><%= report.getReportId() %></td>
                        <td><%= report.getTitle() %></td>
                        <td>
                            <span class="badge badge-<%= report.getReportType().toLowerCase() %>">
                                <%= report.getReportTypeDisplayName() %>
                            </span>
                        </td>
                        <td><%= report.getPeriodDisplayName() %></td>
                        <td>$<%= report.getTotalRevenue() != null ? report.getTotalRevenue() : "0.00" %></td>
                        <td>$<%= report.getTotalCosts() != null ? report.getTotalCosts() : "0.00" %></td>
                        <td>$<%= report.getNetProfit() != null ? report.getNetProfit() : "0.00" %></td>
                        <td><%= report.getCreatedAt() != null ? report.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                        <td class="actions">
                            <a href="${pageContext.request.contextPath}/finance?action=view&id=<%= report.getReportId() %>" class="btn btn-info">
                                <i class="fas fa-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/finance?action=edit&id=<%= report.getReportId() %>" class="btn btn-warning">
                                <i class="fas fa-edit"></i>
                            </a>
                            <button onclick="deleteReport(<%= report.getReportId() %>)" class="btn btn-danger">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                    <% 
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="9" style="text-align: center; color: #7f8c8d; padding: 40px;">
                            <i class="fas fa-info-circle" style="font-size: 2rem; margin-bottom: 10px;"></i><br>
                            No financial reports found
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function filterByType(type) {
            const rows = document.querySelectorAll('#reportsTable tbody tr');
            rows.forEach(row => {
                if (type === '' || row.dataset.type === type) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function searchReports(searchTerm) {
            const rows = document.querySelectorAll('#reportsTable tbody tr');
            const term = searchTerm.toLowerCase();
            rows.forEach(row => {
                const title = row.dataset.title || '';
                if (title.includes(term)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function deleteReport(reportId) {
            if (confirm('Are you sure you want to delete this financial report?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/finance';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'reportId';
                idInput.value = reportId;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function exportReports() {
            window.location.href = '${pageContext.request.contextPath}/finance?action=export&format=csv';
        }
    </script>

    <style>
        .badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .badge-monthly { background: #e3f2fd; color: #1976d2; }
        .badge-quarterly { background: #f3e5f5; color: #7b1fa2; }
        .badge-annual { background: #e8f5e8; color: #388e3c; }
        .badge-custom { background: #fff3e0; color: #f57c00; }
    </style>
</body>
</html>

