<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="lk.smartlanka.ccs.model.MarketingReport" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Report - Smart Lanka CCS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        .edit-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }

        .edit-header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .edit-title {
            font-size: 2.2em;
            color: #2c3e50;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .edit-subtitle {
            color: #7f8c8d;
            font-size: 1.1em;
            margin-bottom: 20px;
        }

        .edit-form {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .form-group {
            margin-bottom: 25px;
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
            padding: 12px 15px;
            border: 2px solid #e0e6ed;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
            background: white;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e0e6ed;
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
            font-size: 1em;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
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

        .btn-warning {
            background: linear-gradient(135deg, #f39c12, #e67e22);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .current-info {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            border-left: 4px solid #3498db;
        }

        .current-info h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.2em;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            padding: 5px 0;
        }

        .info-label {
            font-weight: 600;
            color: #7f8c8d;
        }

        .info-value {
            color: #2c3e50;
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

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <%
        // Get the MarketingReport object from request attribute
        MarketingReport report = (MarketingReport) request.getAttribute("report");
        if (report == null) {
            // If no report object is passed, create a default one
            report = new MarketingReport();
            report.setReportId(1);
            report.setType("CAMPAIGN");
            report.setPeriodStart(java.sql.Date.valueOf("2024-01-01"));
            report.setPeriodEnd(java.sql.Date.valueOf("2024-01-31"));
            report.setDescription("Sample Report");
        }
    %>
    <div class="edit-container">
        <!-- Edit Header -->
        <div class="edit-header">
            <h1 class="edit-title">
                <i class="fas fa-edit"></i>
                Edit Report
            </h1>
            <p class="edit-subtitle">Update report details and settings</p>
        </div>

        <!-- Current Information -->
        <div class="current-info">
            <h3><i class="fas fa-info-circle"></i> Current Report Information</h3>
            <div class="info-item">
                <span class="info-label">Report ID:</span>
                <span class="info-value">#<%= report.getReportId() %></span>
            </div>
            <div class="info-item">
                <span class="info-label">Created Date:</span>
                <span class="info-value"><%= report.getCreatedAt() != null ? 
                    report.getCreatedAt().toLocalDateTime().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) : 
                    "Not available" %></span>
            </div>
            <div class="info-item">
                <span class="info-label">Current Type:</span>
                <span class="info-value"><%= report.getTypeDisplayName() %></span>
            </div>
        </div>

        <!-- Edit Form -->
        <form class="edit-form" action="${pageContext.request.contextPath}/marketing" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="reportId" value="<%= report.getReportId() %>">
            
            <div class="form-row">
                <div class="form-group">
                    <label for="type">
                        <i class="fas fa-tag"></i> Report Type
                    </label>
                    <select id="type" name="type" required>
                        <option value="CAMPAIGN" <%= "CAMPAIGN".equals(report.getType()) ? "selected" : "" %>>Campaign Report</option>
                        <option value="ANALYTICS" <%= "ANALYTICS".equals(report.getType()) ? "selected" : "" %>>Analytics Report</option>
                        <option value="SOCIAL_MEDIA" <%= "SOCIAL_MEDIA".equals(report.getType()) ? "selected" : "" %>>Social Media Report</option>
                        <option value="EMAIL_MARKETING" <%= "EMAIL_MARKETING".equals(report.getType()) ? "selected" : "" %>>Email Marketing Report</option>
                        <option value="CUSTOMER_ANALYSIS" <%= "CUSTOMER_ANALYSIS".equals(report.getType()) ? "selected" : "" %>>Customer Analysis Report</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="periodStart">
                        <i class="fas fa-calendar"></i> Start Date
                    </label>
                    <input type="date" id="periodStart" name="periodStart" value="<%= report.getPeriodStart() %>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="periodEnd">
                        <i class="fas fa-calendar"></i> End Date
                    </label>
                    <input type="date" id="periodEnd" name="periodEnd" value="<%= report.getPeriodEnd() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="description">
                        <i class="fas fa-align-left"></i> Description
                    </label>
                    <textarea id="description" name="description" placeholder="Enter detailed report description..." required><%= report.getDescription() %></textarea>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save"></i> Update Report
                </button>
                <a href="${pageContext.request.contextPath}/marketing?action=view&id=<%= report.getReportId() %>" class="btn btn-primary">
                    <i class="fas fa-eye"></i> View Report
                </a>
                <a href="${pageContext.request.contextPath}/marketing?action=reports" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Reports
                </a>
                <button type="button" onclick="resetForm()" class="btn btn-warning">
                    <i class="fas fa-undo"></i> Reset Form
                </button>
            </div>
        </form>

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
        function resetForm() {
            if (confirm('Are you sure you want to reset the form? All changes will be lost.')) {
                document.querySelector('.edit-form').reset();
            }
        }

        // Form validation
        document.querySelector('.edit-form').addEventListener('submit', function(e) {
            const budget = document.getElementById('budget').value;
            const roi = document.getElementById('roi').value;
            
            if (parseFloat(budget) < 0) {
                alert('Budget cannot be negative');
                e.preventDefault();
                return;
            }
            
            if (parseFloat(roi) < 0 || parseFloat(roi) > 100) {
                alert('ROI must be between 0% and 100%');
                e.preventDefault();
                return;
            }
        });

        // Auto-save draft functionality
        let autoSaveTimeout;
        document.querySelectorAll('input, select, textarea').forEach(element => {
            element.addEventListener('input', function() {
                clearTimeout(autoSaveTimeout);
                autoSaveTimeout = setTimeout(() => {
                    // In a real application, you would save the draft here
                    console.log('Auto-saving draft...');
                }, 2000);
            });
        });
    </script>
</body>
</html>

