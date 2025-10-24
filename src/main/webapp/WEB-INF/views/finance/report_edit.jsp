<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="lk.smartlanka.ccs.model.FinancialReport" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    FinancialReport report = (FinancialReport) request.getAttribute("report");
    if (report == null) {
        response.sendRedirect(request.getContextPath() + "/finance?action=list&error=not_found");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Financial Report - Smart Lanka CCS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
    
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
            max-width: 1000px;
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
            font-size: 2rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
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

        .btn-success {
            background: #27ae60;
            color: white;
        }

        .btn-success:hover {
            background: #229954;
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

        .form-container {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .required {
            color: #e74c3c;
        }

        .help-text {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 5px;
        }

        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e9ecef;
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
            
            .form-row {
                grid-template-columns: 1fr;
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
                <i class="fas fa-edit"></i>
                Edit Financial Report
            </h1>
            <div>
                <a href="${pageContext.request.contextPath}/finance?action=view&id=<%= report.getReportId() %>" class="btn btn-secondary">
                    <i class="fas fa-eye"></i> View Report
                </a>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <% if (request.getParameter("status") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <% if ("updated".equals(request.getParameter("status"))) { %>
                    Financial report updated successfully!
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

        <!-- Form -->
        <div class="form-container">
            <form action="${pageContext.request.contextPath}/finance" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="reportId" value="<%= report.getReportId() %>">
                
                <!-- Basic Information -->
                <div class="form-group">
                    <label for="title">Report Title <span class="required">*</span></label>
                    <input type="text" id="title" name="title" required 
                           value="<%= report.getTitle() != null ? report.getTitle() : "" %>"
                           placeholder="Enter report title (e.g., Q1 2024 Financial Report)">
                    <div class="help-text">A descriptive title for your financial report</div>
                </div>

                <div class="form-group">
                    <label for="reportType">Report Type <span class="required">*</span></label>
                    <select id="reportType" name="reportType" required>
                        <option value="">Select report type</option>
                        <option value="MONTHLY" <%= "MONTHLY".equals(report.getReportType()) ? "selected" : "" %>>Monthly Report</option>
                        <option value="QUARTERLY" <%= "QUARTERLY".equals(report.getReportType()) ? "selected" : "" %>>Quarterly Report</option>
                        <option value="ANNUAL" <%= "ANNUAL".equals(report.getReportType()) ? "selected" : "" %>>Annual Report</option>
                        <option value="CUSTOM" <%= "CUSTOM".equals(report.getReportType()) ? "selected" : "" %>>Custom Period Report</option>
                    </select>
                    <div class="help-text">Choose the type of financial report</div>
                </div>

                <!-- Period Information -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="periodStart">Period Start <span class="required">*</span></label>
                        <input type="date" id="periodStart" name="periodStart" required
                               value="<%= report.getPeriodStart() != null ? report.getPeriodStart().toString() : "" %>">
                        <div class="help-text">Start date of the reporting period</div>
                    </div>

                    <div class="form-group">
                        <label for="periodEnd">Period End <span class="required">*</span></label>
                        <input type="date" id="periodEnd" name="periodEnd" required
                               value="<%= report.getPeriodEnd() != null ? report.getPeriodEnd().toString() : "" %>">
                        <div class="help-text">End date of the reporting period</div>
                    </div>
                </div>

                <!-- Financial Data -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="totalRevenue">Total Revenue <span class="required">*</span></label>
                        <input type="number" id="totalRevenue" name="totalRevenue" step="0.01" min="0" required
                               value="<%= report.getTotalRevenue() != null ? report.getTotalRevenue() : "" %>"
                               placeholder="0.00">
                        <div class="help-text">Total revenue for the period</div>
                    </div>

                    <div class="form-group">
                        <label for="totalCosts">Total Costs</label>
                        <input type="number" id="totalCosts" name="totalCosts" step="0.01" min="0"
                               value="<%= report.getTotalCosts() != null ? report.getTotalCosts() : "" %>"
                               placeholder="0.00">
                        <div class="help-text">Total operational costs</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="complaintCosts">Complaint Costs</label>
                        <input type="number" id="complaintCosts" name="complaintCosts" step="0.01" min="0"
                               value="<%= report.getComplaintCosts() != null ? report.getComplaintCosts() : "" %>"
                               placeholder="0.00">
                        <div class="help-text">Costs related to complaint handling</div>
                    </div>

                    <div class="form-group">
                        <label for="resolutionCosts">Resolution Costs</label>
                        <input type="number" id="resolutionCosts" name="resolutionCosts" step="0.01" min="0"
                               value="<%= report.getResolutionCosts() != null ? report.getResolutionCosts() : "" %>"
                               placeholder="0.00">
                        <div class="help-text">Costs related to issue resolution</div>
                    </div>
                </div>

                <!-- Summary -->
                <div class="form-group">
                    <label for="summary">Report Summary</label>
                    <textarea id="summary" name="summary" 
                              placeholder="Enter a detailed summary of the financial report..."><%= report.getSummary() != null ? report.getSummary() : "" %></textarea>
                    <div class="help-text">Detailed description and analysis of the financial data</div>
                </div>

                <!-- Actions -->
                <div class="actions">
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save"></i> Update Report
                    </button>
                    <a href="${pageContext.request.contextPath}/finance?action=view&id=<%= report.getReportId() %>" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../common/footer.jspf" %>
</body>
</html>

