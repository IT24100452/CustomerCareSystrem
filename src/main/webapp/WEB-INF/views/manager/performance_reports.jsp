<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="lk.smartlanka.ccs.model.PerformanceReport" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Performance Reports Management - Manager Dashboard</title>
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

        .reports-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .reports-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .reports-header h2 {
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

        .create-report-form {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .create-report-form h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 1.3em;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
            font-size: 1em;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e8ed;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s ease;
            background: white;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }

        .reports-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .report-card {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s ease;
        }

        .report-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
        }

        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .report-title {
            font-size: 1.2em;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .report-type {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.7em;
            font-weight: 600;
            text-transform: uppercase;
        }

        .type-monthly {
            background: #d1ecf1;
            color: #0c5460;
        }

        .type-quarterly {
            background: #d4edda;
            color: #155724;
        }

        .type-annual {
            background: #fff3cd;
            color: #856404;
        }

        .type-custom {
            background: #f8d7da;
            color: #721c24;
        }

        .report-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            color: #5a6c7d;
        }

        .meta-item i {
            margin-right: 8px;
            color: #7f8c8d;
            width: 16px;
        }

        .report-description {
            color: #5a6c7d;
            line-height: 1.6;
            margin-bottom: 15px;
            max-height: 60px;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .report-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .report-actions .btn {
            padding: 8px 16px;
            font-size: 0.9em;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }

        .empty-state i {
            font-size: 4em;
            margin-bottom: 20px;
            color: #bdc3c7;
        }

        .empty-state h3 {
            font-size: 1.5em;
            margin-bottom: 10px;
            color: #5a6c7d;
        }

        .empty-state p {
            font-size: 1.1em;
            margin-bottom: 30px;
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
            
            .reports-container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .report-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .report-actions {
                width: 100%;
                justify-content: stretch;
            }
            
            .report-actions .btn {
                flex: 1;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-file-alt"></i> Performance Reports Management</h1>
            <p>Create, update, and manage performance reports for your team</p>
        </div>

        <div class="reports-container">
            <div class="reports-header">
                <h2><i class="fas fa-chart-bar"></i> Report Management</h2>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>

            <!-- Success Messages -->
            <% if ("created".equals(request.getParameter("status"))) { %>
                <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                        <div>
                            <strong style="color: #10b981;">Performance Report Created Successfully!</strong>
                            <p style="margin: 5px 0 0 0; color: #059669;">
                                Your performance report has been created and is now available for download.
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
                            <strong style="color: #10b981;">Performance Report Updated Successfully!</strong>
                            <p style="margin: 5px 0 0 0; color: #059669;">
                                Your performance report has been updated and the changes have been saved.
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
                            <strong style="color: #10b981;">Performance Report Deleted Successfully!</strong>
                            <p style="margin: 5px 0 0 0; color: #059669;">
                                The performance report has been permanently deleted from the system.
                            </p>
                        </div>
                    </div>
                </div>
            <% } %>

            <!-- Error Messages -->
            <% if ("validation_error".equals(request.getParameter("error"))) { %>
                <div class="alert alert-error" style="border-left: 4px solid #ef4444; background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(239, 68, 68, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-exclamation-circle" style="color: #ef4444; font-size: 1.2em;"></i>
                        <div>
                            <strong style="color: #ef4444;">Validation Error!</strong>
                            <p style="margin: 5px 0 0 0; color: #dc2626;">
                                Please fill in all required fields before submitting the form.
                            </p>
                        </div>
                    </div>
                </div>
            <% } %>
            
            <% if ("server_error".equals(request.getParameter("error"))) { %>
                <div class="alert alert-error" style="border-left: 4px solid #ef4444; background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(239, 68, 68, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
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

            <!-- Create Report Form -->
            <div class="create-report-form">
                <h3><i class="fas fa-plus"></i> Create New Performance Report</h3>
                <form action="${pageContext.request.contextPath}/manager" method="post">
                    <input type="hidden" name="action" value="createReport">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="reportTitle">Report Title:</label>
                            <input type="text" id="reportTitle" name="reportTitle" required
                                   placeholder="Enter report title (e.g., Q4 2024 Performance Report)">
                        </div>
                        
                        <div class="form-group">
                            <label for="reportType">Report Type:</label>
                            <select id="reportType" name="reportType" required>
                                <option value="">Select report type</option>
                                <option value="MONTHLY">Monthly Report</option>
                                <option value="QUARTERLY">Quarterly Report</option>
                                <option value="ANNUAL">Annual Report</option>
                                <option value="CUSTOM">Custom Report</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="reportPeriod">Report Period:</label>
                            <input type="text" id="reportPeriod" name="reportPeriod" required
                                   placeholder="e.g., November 2024, Q4 2024, 2024">
                        </div>
                        
                        <div class="form-group">
                            <label for="reportFormat">Output Format:</label>
                            <select id="reportFormat" name="reportFormat" required>
                                <option value="PDF">PDF Document</option>
                                <option value="CSV">CSV Spreadsheet</option>
                                <option value="EXCEL">Excel Workbook</option>
                                <option value="HTML">HTML Report</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="reportDescription">Report Description:</label>
                        <textarea id="reportDescription" name="reportDescription" 
                                  placeholder="Describe the purpose and scope of this performance report..."></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="includeMetrics">Include Metrics:</label>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; margin-top: 10px;">
                            <label style="display: flex; align-items: center; font-weight: normal;">
                                <input type="checkbox" name="includeMetrics" value="RESOLUTION_TIME" checked style="margin-right: 8px;">
                                Resolution Time
                            </label>
                            <label style="display: flex; align-items: center; font-weight: normal;">
                                <input type="checkbox" name="includeMetrics" value="CUSTOMER_SATISFACTION" checked style="margin-right: 8px;">
                                Customer Satisfaction
                            </label>
                            <label style="display: flex; align-items: center; font-weight: normal;">
                                <input type="checkbox" name="includeMetrics" value="COMPLAINT_VOLUME" checked style="margin-right: 8px;">
                                Complaint Volume
                            </label>
                            <label style="display: flex; align-items: center; font-weight: normal;">
                                <input type="checkbox" name="includeMetrics" value="STAFF_PERFORMANCE" checked style="margin-right: 8px;">
                                Staff Performance
                            </label>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-plus"></i> Create Report
                    </button>
                </form>
            </div>

            <!-- Existing Reports -->
            <h3 style="color: #2c3e50; margin-bottom: 20px;">
                <i class="fas fa-list"></i> Existing Performance Reports
            </h3>

            <div class="reports-grid">
                <%
                    List<PerformanceReport> reports = (List<PerformanceReport>) request.getAttribute("reports");
                    if (reports != null && !reports.isEmpty()) {
                        for (PerformanceReport report : reports) {
                %>
                <div class="report-card">
                    <div class="report-header">
                        <div>
                            <div class="report-title"><%= report.getReportTitle() %></div>
                        </div>
                        <span class="report-type type-<%= report.getReportType().toLowerCase() %>"><%= report.getReportTypeDisplayName() %></span>
                    </div>

                    <div class="report-meta">
                        <div class="meta-item">
                            <i class="fas fa-calendar"></i>
                            <span>Period: <%= report.getReportPeriod() %></span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-clock"></i>
                            <span>Created: <%= report.getCreatedAt() != null ? 
                                report.getCreatedAt().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) : 
                                "Not available" %></span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-file"></i>
                            <span>Format: <%= report.getReportFormatDisplayName() %></span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-download"></i>
                            <span>Downloads: <%= report.getDownloadCount() %></span>
                        </div>
                    </div>

                    <div class="report-description">
                        <%= report.getReportDescription() != null ? report.getReportDescription() : "No description available" %>
                    </div>

                    <div class="report-actions">
                        <a href="${pageContext.request.contextPath}/manager?action=viewReport&id=<%= report.getReportId() %>" class="btn">
                            <i class="fas fa-eye"></i> View
                        </a>
                        <a href="${pageContext.request.contextPath}/manager?action=editReport&id=<%= report.getReportId() %>" class="btn btn-warning">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <a href="${pageContext.request.contextPath}/manager?action=downloadReport&id=<%= report.getReportId() %>" class="btn btn-success">
                            <i class="fas fa-download"></i> Download
                        </a>
                        <a href="${pageContext.request.contextPath}/manager?action=deleteReport&id=<%= report.getReportId() %>" 
                           class="btn btn-danger" 
                           onclick="return confirm('Are you sure you want to delete this report?')">
                            <i class="fas fa-trash"></i> Delete
                        </a>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="empty-state">
                    <i class="fas fa-file-alt"></i>
                    <h3>No Performance Reports Found</h3>
                    <p>You haven't created any performance reports yet. Use the form above to create your first report.</p>
                </div>
                <%
                    }
                %>
            </div>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/manager?action=performance">
                <i class="fas fa-chart-line"></i> Performance Tracking
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
        // Auto-hide success messages
        const successAlerts = document.querySelectorAll('.alert-success');
        successAlerts.forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                setTimeout(() => {
                    alert.remove();
                }, 300);
            }, 5000);
        });
        
        // Auto-hide error messages
        const errorAlerts = document.querySelectorAll('.alert-error');
        errorAlerts.forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                setTimeout(() => {
                    alert.remove();
                }, 300);
            }, 8000);
        });
    </script>
</body>
</html>

