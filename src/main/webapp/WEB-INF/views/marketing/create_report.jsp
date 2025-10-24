<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Report - Marketing Dashboard</title>
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
            max-width: 1000px;
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

        .create-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .create-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .create-header h2 {
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

        .btn i {
            margin-right: 8px;
        }

        .create-form {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .create-form h3 {
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

        .form-group small {
            color: #7f8c8d;
            font-size: 0.9em;
            margin-top: 5px;
            display: block;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 30px;
        }

        .form-actions .btn {
            min-width: 150px;
        }

        .report-templates {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .report-templates h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 1.3em;
        }

        .template-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .template-card {
            background: white;
            border: 1px solid #e1e8ed;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .template-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
        }

        .template-icon {
            font-size: 2.5em;
            color: #667eea;
            margin-bottom: 15px;
        }

        .template-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .template-description {
            color: #7f8c8d;
            font-size: 0.9em;
            margin-bottom: 15px;
        }

        .template-btn {
            background: #667eea;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            font-size: 0.9em;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .template-btn:hover {
            background: #5a6fd8;
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
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .form-actions .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-plus"></i> Create Report</h1>
            <p>Generate comprehensive marketing reports and analytics</p>
        </div>

        <div class="create-container">
            <div class="create-header">
                <h2><i class="fas fa-file-alt"></i> Create New Marketing Report</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/marketing-dashboard/manage-reports" class="btn btn-secondary">
                        <i class="fas fa-list"></i> View All Reports
                    </a>
                    <a href="${pageContext.request.contextPath}/marketing-dashboard/dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </div>

            <!-- Report Templates -->
            <div class="report-templates">
                <h3><i class="fas fa-layer-group"></i> Report Templates</h3>
                <div class="template-grid">
                    <div class="template-card" onclick="loadTemplate('feedback')">
                        <div class="template-icon">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                        <div class="template-title">Feedback Analysis</div>
                        <div class="template-description">Comprehensive customer feedback metrics and sentiment analysis</div>
                        <button class="template-btn">Use Template</button>
                    </div>
                    
                    <div class="template-card" onclick="loadTemplate('campaign')">
                        <div class="template-icon">
                            <i class="fas fa-bullhorn"></i>
                        </div>
                        <div class="template-title">Campaign Report</div>
                        <div class="template-description">Marketing campaign performance and ROI analysis</div>
                        <button class="template-btn">Use Template</button>
                    </div>
                    
                    <div class="template-card" onclick="loadTemplate('monthly')">
                        <div class="template-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div class="template-title">Monthly Summary</div>
                        <div class="template-description">Monthly marketing performance and key metrics</div>
                        <button class="template-btn">Use Template</button>
                    </div>
                    
                    <div class="template-card" onclick="loadTemplate('custom')">
                        <div class="template-icon">
                            <i class="fas fa-cogs"></i>
                        </div>
                        <div class="template-title">Custom Report</div>
                        <div class="template-description">Create a custom report from scratch</div>
                        <button class="template-btn">Use Template</button>
                    </div>
                </div>
            </div>

            <!-- Create Report Form -->
            <div class="create-form">
                <h3><i class="fas fa-edit"></i> Report Details</h3>
                <form id="createReportForm" action="${pageContext.request.contextPath}/marketing" method="POST">
                    <input type="hidden" name="action" value="create">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="title">Report Title:</label>
                            <input type="text" id="title" name="title" required placeholder="Enter report title">
                            <small>This will be displayed as the main title of the report</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="type">Report Type:</label>
                            <select id="type" name="type" required>
                                <option value="">Select Report Type</option>
                                <option value="CAMPAIGN">Campaign Report</option>
                                <option value="ANALYTICS">Analytics Report</option>
                                <option value="SOCIAL_MEDIA">Social Media Report</option>
                                <option value="EMAIL_MARKETING">Email Marketing Report</option>
                                <option value="CUSTOMER_ANALYSIS">Customer Analysis Report</option>
                            </select>
                            <small>Select the type of marketing report</small>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Report Description:</label>
                        <textarea id="description" name="description" 
                                  placeholder="Describe the purpose and scope of this marketing report..."></textarea>
                        <small>Provide a detailed description of what this report contains</small>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="periodStart">Start Date:</label>
                            <input type="date" id="periodStart" name="periodStart" required>
                            <small>Start date for the report period</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="periodEnd">End Date:</label>
                            <input type="date" id="periodEnd" name="periodEnd" required>
                            <small>End date for the report period</small>
                        </div>
                    </div>
                    
                    <input type="hidden" name="createdBy" value="<%= session.getAttribute("userId") != null ? session.getAttribute("userId") : "1" %>">
                </form>
            </div>

            <!-- Form Actions -->
            <div class="form-actions">
                <button type="submit" form="createReportForm" class="btn btn-success">
                    <i class="fas fa-save"></i> Create Report
                </button>
                <button type="button" onclick="previewReport()" class="btn btn-warning">
                    <i class="fas fa-eye"></i> Preview Report
                </button>
                <button type="button" onclick="resetForm()" class="btn btn-secondary">
                    <i class="fas fa-undo"></i> Reset Form
                </button>
            </div>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/marketing-dashboard/dashboard">
                <i class="fas fa-chart-line"></i> Marketing Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/marketing-dashboard/view-feedback-metrics">
                <i class="fas fa-chart-bar"></i> View Feedback Metrics
            </a>
            <a href="${pageContext.request.contextPath}/marketing-dashboard/manage-reports">
                <i class="fas fa-cogs"></i> Manage Reports
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Template loading functions
        function loadTemplate(templateType) {
            const form = document.getElementById('createReportForm');
            
            switch(templateType) {
                case 'feedback':
                    document.getElementById('title').value = 'Customer Feedback Analysis Report';
                    document.getElementById('reportType').value = 'FEEDBACK_ANALYSIS';
                    document.getElementById('description').value = 'Comprehensive analysis of customer feedback metrics, sentiment analysis, and satisfaction trends.';
                    document.getElementById('metrics').value = 'Customer satisfaction rating, sentiment distribution, feedback volume trends, response time analysis, complaint resolution rates.';
                    break;
                    
                case 'campaign':
                    document.getElementById('title').value = 'Marketing Campaign Performance Report';
                    document.getElementById('reportType').value = 'CAMPAIGN_REPORT';
                    document.getElementById('description').value = 'Detailed analysis of marketing campaign performance, ROI, and effectiveness metrics.';
                    document.getElementById('metrics').value = 'Campaign reach, engagement rates, conversion rates, cost per acquisition, return on investment, lead generation metrics.';
                    break;
                    
                case 'monthly':
                    document.getElementById('title').value = 'Monthly Marketing Summary Report';
                    document.getElementById('reportType').value = 'MONTHLY_SUMMARY';
                    document.getElementById('description').value = 'Monthly overview of marketing activities, performance metrics, and key achievements.';
                    document.getElementById('metrics').value = 'Monthly campaign performance, customer acquisition, feedback trends, budget utilization, goal achievement.';
                    break;
                    
                case 'custom':
                    document.getElementById('title').value = 'Custom Marketing Report';
                    document.getElementById('reportType').value = 'CUSTOM';
                    document.getElementById('description').value = 'Custom marketing report tailored to specific business needs and objectives.';
                    document.getElementById('metrics').value = 'Custom metrics and KPIs as per business requirements.';
                    break;
            }
            
            // Scroll to form
            form.scrollIntoView({ behavior: 'smooth' });
        }
        
        // Form functions
        function previewReport() {
            const title = document.getElementById('title').value;
            const type = document.getElementById('reportType').value;
            const description = document.getElementById('description').value;
            
            if (!title || !type) {
                alert('Please fill in the required fields (Title and Report Type) before previewing.');
                return;
            }
            
            alert('Report Preview:\n\nTitle: ' + title + '\nType: ' + type + '\nDescription: ' + description + '\n\nThis is a preview. The actual report will be generated after creation.');
        }
        
        function resetForm() {
            if (confirm('Are you sure you want to reset the form? All entered data will be lost.')) {
                document.getElementById('createReportForm').reset();
            }
        }
        
        // Form validation
        document.getElementById('createReportForm').addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const type = document.getElementById('reportType').value;
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            const budget = document.getElementById('budget').value;
            const roi = document.getElementById('roi').value;
            
            if (!title || !type) {
                e.preventDefault();
                alert('Please fill in all required fields (Title and Report Type).');
                return false;
            }
            
            if (startDate && endDate && new Date(startDate) >= new Date(endDate)) {
                e.preventDefault();
                alert('End date must be after start date.');
                return false;
            }
            
            if (budget && parseFloat(budget) < 0) {
                e.preventDefault();
                alert('Budget cannot be negative.');
                return false;
            }
            
            if (roi && parseFloat(roi) < 0) {
                e.preventDefault();
                alert('ROI cannot be negative.');
                return false;
            }
            
            // Show loading state
            const submitBtn = document.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating...';
            submitBtn.disabled = true;
        });
    </script>
</body>
</html>
