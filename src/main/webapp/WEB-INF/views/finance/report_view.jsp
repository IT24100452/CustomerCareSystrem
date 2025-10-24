<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="lk.smartlanka.ccs.model.FinancialReport" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

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
    <title>View Financial Report - Smart Lanka CCS</title>
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

        .btn-warning {
            background: #f39c12;
            color: white;
        }

        .btn-warning:hover {
            background: #e67e22;
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

        .report-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .info-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            border-left: 4px solid #3498db;
        }

        .info-card h3 {
            color: #2c3e50;
            margin: 0 0 15px 0;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }

        .info-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .info-label {
            font-weight: 600;
            color: #555;
        }

        .info-value {
            color: #2c3e50;
            font-weight: 500;
        }

        .financial-summary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .financial-summary h2 {
            margin: 0 0 20px 0;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .financial-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .financial-item {
            text-align: center;
            padding: 15px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            backdrop-filter: blur(10px);
        }

        .financial-item h4 {
            margin: 0 0 8px 0;
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .financial-item .amount {
            font-size: 1.5rem;
            font-weight: bold;
            margin: 0;
        }

        .description-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .description-section h3 {
            color: #2c3e50;
            margin: 0 0 15px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .description-text {
            color: #555;
            line-height: 1.6;
            font-size: 1rem;
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
            
            .actions {
                flex-direction: column;
            }
            
            .financial-grid {
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
                <i class="fas fa-file-alt"></i>
                Financial Report Details
            </h1>
            <div>
                <a href="${pageContext.request.contextPath}/finance?action=list" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Reports
                </a>
            </div>
        </div>

        <!-- Report Information -->
        <div class="report-info">
            <div class="info-card">
                <h3><i class="fas fa-info-circle"></i> Report Information</h3>
                <div class="info-item">
                    <span class="info-label">Report ID:</span>
                    <span class="info-value">#<%= report.getReportId() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Title:</span>
                    <span class="info-value"><%= report.getTitle() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Type:</span>
                    <span class="info-value"><%= report.getReportTypeDisplayName() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Period:</span>
                    <span class="info-value"><%= report.getPeriodDisplayName() %></span>
                </div>
            </div>

            <div class="info-card">
                <h3><i class="fas fa-calendar"></i> Timeline</h3>
                <div class="info-item">
                    <span class="info-label">Start Date:</span>
                    <span class="info-value"><%= report.getPeriodStart() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">End Date:</span>
                    <span class="info-value"><%= report.getPeriodEnd() %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Created:</span>
                    <span class="info-value">
                        <%= report.getCreatedAt() != null ? 
                            new SimpleDateFormat("MMM dd, yyyy 'at' HH:mm").format(report.getCreatedAt()) : 
                            "N/A" %>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">Last Updated:</span>
                    <span class="info-value">
                        <%= report.getUpdatedAt() != null ? 
                            new SimpleDateFormat("MMM dd, yyyy 'at' HH:mm").format(report.getUpdatedAt()) : 
                            "Never" %>
                    </span>
                </div>
            </div>
        </div>

        <!-- Financial Summary -->
        <div class="financial-summary">
            <h2><i class="fas fa-chart-line"></i> Financial Summary</h2>
            <div class="financial-grid">
                <div class="financial-item">
                    <h4>Total Revenue</h4>
                    <p class="amount">$<%= report.getTotalRevenue() != null ? String.format("%.2f", report.getTotalRevenue()) : "0.00" %></p>
                </div>
                <div class="financial-item">
                    <h4>Total Costs</h4>
                    <p class="amount">$<%= report.getTotalCosts() != null ? String.format("%.2f", report.getTotalCosts()) : "0.00" %></p>
                </div>
                <div class="financial-item">
                    <h4>Net Profit</h4>
                    <p class="amount">$<%= report.getNetProfit() != null ? String.format("%.2f", report.getNetProfit()) : "0.00" %></p>
                </div>
                <div class="financial-item">
                    <h4>Profit Margin</h4>
                    <p class="amount"><%= report.calculateProfitMargin() != null ? String.format("%.2f", report.calculateProfitMargin()) + "%" : "0.00%" %></p>
                </div>
            </div>
        </div>

        <!-- Cost Breakdown -->
        <div class="report-info">
            <div class="info-card">
                <h3><i class="fas fa-receipt"></i> Cost Breakdown</h3>
                <div class="info-item">
                    <span class="info-label">Complaint Costs:</span>
                    <span class="info-value">$<%= report.getComplaintCosts() != null ? String.format("%.2f", report.getComplaintCosts()) : "0.00" %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Resolution Costs:</span>
                    <span class="info-value">$<%= report.getResolutionCosts() != null ? String.format("%.2f", report.getResolutionCosts()) : "0.00" %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Other Costs:</span>
                    <span class="info-value">$<%= report.getTotalCosts() != null && report.getComplaintCosts() != null && report.getResolutionCosts() != null ? 
                        String.format("%.2f", report.getTotalCosts().subtract(report.getComplaintCosts()).subtract(report.getResolutionCosts())) : "0.00" %></span>
                </div>
            </div>
        </div>

        <!-- Description -->
        <% if (report.getSummary() != null && !report.getSummary().trim().isEmpty()) { %>
        <div class="description-section">
            <h3><i class="fas fa-align-left"></i> Report Summary</h3>
            <div class="description-text">
                <%= report.getSummary().replace("\n", "<br>") %>
            </div>
        </div>
        <% } %>

        <!-- Actions -->
        <div class="actions">
            <a href="${pageContext.request.contextPath}/finance?action=edit&id=<%= report.getReportId() %>" class="btn btn-warning">
                <i class="fas fa-edit"></i> Edit Report
            </a>
            <a href="${pageContext.request.contextPath}/finance?action=export&id=<%= report.getReportId() %>" class="btn btn-primary">
                <i class="fas fa-download"></i> Export CSV
            </a>
        </div>
    </div>

    <%@ include file="../common/footer.jspf" %>
</body>
</html>