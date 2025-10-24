<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="lk.smartlanka.ccs.model.MarketingReport" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Reports - Marketing Dashboard</title>
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

        .manage-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .manage-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .manage-header h2 {
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

        .btn-info {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
        }

        .btn-info:hover {
            box-shadow: 0 10px 20px rgba(52, 152, 219, 0.3);
        }

        .btn i {
            margin-right: 8px;
        }

        .reports-table {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .reports-table h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 1.3em;
        }

        .table-container {
            overflow-x: auto;
        }

        .reports-table table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .reports-table th,
        .reports-table td {
            border: 1px solid #e1e8ed;
            padding: 12px;
            text-align: left;
        }

        .reports-table th {
            background: #667eea;
            color: white;
            font-weight: 600;
        }

        .reports-table tr:nth-child(even) {
            background: white;
        }

        .reports-table tr:hover {
            background: #e8f4fd;
        }

        .roi-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 600;
        }

        .roi-excellent {
            background: #d4edda;
            color: #155724;
        }

        .roi-good {
            background: #d1ecf1;
            color: #0c5460;
        }

        .roi-average {
            background: #fff3cd;
            color: #856404;
        }

        .roi-poor {
            background: #f8d7da;
            color: #721c24;
        }

        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 600;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-draft {
            background: #fff3cd;
            color: #856404;
        }

        .status-published {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-archived {
            background: #f8d7da;
            color: #721c24;
        }

        .report-statistics {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .report-statistics h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 1.3em;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .stat-card {
            background: white;
            border: 1px solid #e1e8ed;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
        }

        .stat-value {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 10px;
        }

        .stat-label {
            color: #7f8c8d;
            font-size: 0.9em;
        }

        .bulk-actions {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .bulk-actions h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 1.3em;
        }

        .bulk-actions-content {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: center;
        }

        .bulk-actions-content select {
            padding: 8px 12px;
            border: 1px solid #e1e8ed;
            border-radius: 6px;
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
            
            .header h1 {
                font-size: 2em;
            }
            
            .manage-header {
                flex-direction: column;
                text-align: center;
            }
            
            .bulk-actions-content {
                flex-direction: column;
                align-items: stretch;
            }
            
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-cogs"></i> Manage Reports</h1>
            <p>Manage and organize your marketing reports and analytics</p>
        </div>

        <!-- Success/Error Messages -->
        <% if ("created".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Marketing Report Created Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            Your marketing report has been created and is now available for management.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <% if ("updated".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Marketing Report Updated Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            Your marketing report has been updated successfully.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <% if ("deleted".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Marketing Report Deleted Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            The marketing report has been permanently deleted from the system.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <% if ("validation_error".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" style="border-left: 4px solid #ef4444; background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(239, 68, 68, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-exclamation-circle" style="color: #ef4444; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #ef4444;">Validation Error!</strong>
                        <p style="margin: 5px 0 0 0; color: #dc2626;">
                            Please fill in all required fields before submitting.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <% if ("server_error".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" style="border-left: 4px solid #ef4444; background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(239, 68, 68, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-exclamation-circle" style="color: #ef4444; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #ef4444;">Server Error!</strong>
                        <p style="margin: 5px 0 0 0; color: #dc2626;">
                            An error occurred while processing your request. Please try again.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <div class="manage-container">
            <div class="manage-header">
                <h2><i class="fas fa-file-alt"></i> Marketing Reports Management</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/marketing?action=create" class="btn btn-success">
                        <i class="fas fa-plus"></i> Create New Report
                    </a>
                    <a href="${pageContext.request.contextPath}/marketing?action=dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </div>

            <!-- Report Statistics -->
            <div class="report-statistics">
                <h3><i class="fas fa-chart-bar"></i> Report Statistics</h3>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value">4</div>
                        <div class="stat-label">Total Reports</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">$40,700</div>
                        <div class="stat-label">Total Budget</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">20%</div>
                        <div class="stat-label">Average ROI</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">2</div>
                        <div class="stat-label">Active Campaigns</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">156</div>
                        <div class="stat-label">Downloads</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">12</div>
                        <div class="stat-label">This Month</div>
                    </div>
                </div>
            </div>

            <!-- Bulk Actions -->
            <div class="bulk-actions">
                <h3><i class="fas fa-tasks"></i> Bulk Actions</h3>
                <div class="bulk-actions-content">
                    <select id="bulkAction">
                        <option value="">Select Action</option>
                        <option value="download">Download Selected</option>
                        <option value="archive">Archive Selected</option>
                        <option value="delete">Delete Selected</option>
                        <option value="export">Export to CSV</option>
                    </select>
                    <button onclick="executeBulkAction()" class="btn btn-warning">
                        <i class="fas fa-play"></i> Execute
                    </button>
                    <button onclick="selectAll()" class="btn btn-info">
                        <i class="fas fa-check-square"></i> Select All
                    </button>
                    <button onclick="clearSelection()" class="btn btn-secondary">
                        <i class="fas fa-square"></i> Clear Selection
                    </button>
                </div>
            </div>

            <!-- Reports Table -->
            <div class="reports-table">
                <h3><i class="fas fa-table"></i> Marketing Reports</h3>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th><input type="checkbox" id="selectAllCheckbox" onchange="toggleAllCheckboxes()"></th>
                                <th>Description</th>
                                <th>Type</th>
                                <th>Period</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<MarketingReport> reports = (List<MarketingReport>) request.getAttribute("reports");
                                if (reports != null && !reports.isEmpty()) {
                                    for (MarketingReport report : reports) {
                            %>
                            <tr>
                                <td><input type="checkbox" class="report-checkbox" value="<%= report.getReportId() %>"></td>
                                <td><strong><%= report.getDescription() %></strong></td>
                                <td><%= report.getTypeDisplayName() %></td>
                                <td><%= report.getPeriodDisplay() %></td>
                                <td><%= report.getCreatedAt() != null ? 
                                    report.getCreatedAt().toLocalDateTime().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) : 
                                    "Not available" %></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/marketing?action=view&id=<%= report.getReportId() %>" class="btn btn-info" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <a href="${pageContext.request.contextPath}/marketing?action=edit&id=<%= report.getReportId() %>" class="btn btn-warning" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <a href="${pageContext.request.contextPath}/marketing?action=download&id=<%= report.getReportId() %>" class="btn btn-success" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-download"></i> CSV
                                    </a>
                                    <a href="${pageContext.request.contextPath}/marketing?action=delete&id=<%= report.getReportId() %>" 
                                       class="btn btn-danger" 
                                       style="padding: 5px 10px; font-size: 0.8em;"
                                       onclick="return confirm('Are you sure you want to delete this report?')">
                                        <i class="fas fa-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 40px; color: #666;">
                                    <i class="fas fa-file-alt" style="font-size: 3em; margin-bottom: 15px; opacity: 0.3;"></i>
                                    <h3>No Marketing Reports Found</h3>
                                    <p>You haven't created any marketing reports yet. Use the "Create New Report" button above to create your first report.</p>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/marketing?action=dashboard">
                <i class="fas fa-chart-line"></i> Marketing Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/marketing?action=reports">
                <i class="fas fa-file-alt"></i> Manage Reports
            </a>
            <a href="${pageContext.request.contextPath}/marketing?action=create">
                <i class="fas fa-plus"></i> Create Report
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Checkbox management
        function toggleAllCheckboxes() {
            const selectAllCheckbox = document.getElementById('selectAllCheckbox');
            const reportCheckboxes = document.querySelectorAll('.report-checkbox');
            
            reportCheckboxes.forEach(checkbox => {
                checkbox.checked = selectAllCheckbox.checked;
            });
        }
        
        function selectAll() {
            const reportCheckboxes = document.querySelectorAll('.report-checkbox');
            const selectAllCheckbox = document.getElementById('selectAllCheckbox');
            
            reportCheckboxes.forEach(checkbox => {
                checkbox.checked = true;
            });
            selectAllCheckbox.checked = true;
        }
        
        function clearSelection() {
            const reportCheckboxes = document.querySelectorAll('.report-checkbox');
            const selectAllCheckbox = document.getElementById('selectAllCheckbox');
            
            reportCheckboxes.forEach(checkbox => {
                checkbox.checked = false;
            });
            selectAllCheckbox.checked = false;
        }
        
        // Bulk actions
        function executeBulkAction() {
            const bulkAction = document.getElementById('bulkAction').value;
            const selectedReports = document.querySelectorAll('.report-checkbox:checked');
            
            if (!bulkAction) {
                alert('Please select an action.');
                return;
            }
            
            if (selectedReports.length === 0) {
                alert('Please select at least one report.');
                return;
            }
            
            const reportIds = Array.from(selectedReports).map(checkbox => checkbox.value);
            
            switch(bulkAction) {
                case 'download':
                    alert('Downloading ' + reportIds.length + ' reports...');
                    break;
                case 'archive':
                    if (confirm('Are you sure you want to archive ' + reportIds.length + ' reports?')) {
                        alert('Archiving ' + reportIds.length + ' reports...');
                    }
                    break;
                case 'delete':
                    if (confirm('Are you sure you want to delete ' + reportIds.length + ' reports? This action cannot be undone.')) {
                        alert('Deleting ' + reportIds.length + ' reports...');
                    }
                    break;
                case 'export':
                    alert('Exporting ' + reportIds.length + ' reports to CSV...');
                    break;
            }
        }
        
        // Individual report actions
        function viewReport(id) {
            window.location.href = '${pageContext.request.contextPath}/marketing-dashboard/report-view?id=' + id;
        }
        
        function editReport(id) {
            window.location.href = '${pageContext.request.contextPath}/marketing-dashboard/report-edit?id=' + id;
        }
        
        function downloadReport(id) {
            window.location.href = '${pageContext.request.contextPath}/marketing-dashboard/download-report?id=' + id + '&format=csv';
        }
        
        function deleteReport(id) {
            if (confirm('Are you sure you want to delete this report? This action cannot be undone.')) {
                alert('Report #' + id + ' has been deleted.\n\nThis is a demo action. In a real application, this would actually delete the report from the database.');
                // In a real application, you would make an AJAX call to delete the report
                // fetch('${pageContext.request.contextPath}/marketing-dashboard/' + id, { method: 'DELETE' })
                //     .then(response => { if (response.ok) location.reload(); });
            }
        }
    </script>
</body>
</html>
