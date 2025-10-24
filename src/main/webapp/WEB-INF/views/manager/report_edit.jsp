<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Performance Report - Manager Dashboard</title>
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

        .edit-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .edit-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .edit-header h2 {
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

        .edit-form {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .edit-form h3 {
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

        .current-info {
            background: #e8f4fd;
            border: 1px solid #bee5eb;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .current-info h4 {
            color: #0c5460;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .current-info h4 i {
            margin-right: 10px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .info-item {
            background: white;
            border: 1px solid #bee5eb;
            border-radius: 6px;
            padding: 10px;
            text-align: center;
        }

        .info-label {
            color: #0c5460;
            font-size: 0.9em;
            margin-bottom: 5px;
        }

        .info-value {
            color: #0c5460;
            font-weight: bold;
            font-size: 1.1em;
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
            
            .edit-container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
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
            <h1><i class="fas fa-edit"></i> Edit Performance Report</h1>
            <p>Update report details and configuration</p>
        </div>

        <div class="edit-container">
            <div class="edit-header">
                <h2><i class="fas fa-file-alt"></i> Edit Report #<%= request.getAttribute("reportId") != null ? request.getAttribute("reportId") : "1" %></h2>
                <a href="${pageContext.request.contextPath}/manager?action=viewReport&id=<%= request.getAttribute("reportId") != null ? request.getAttribute("reportId") : "1" %>" class="btn btn-secondary">
                    <i class="fas fa-eye"></i> View Report
                </a>
            </div>

            <!-- Current Report Information -->
            <div class="current-info">
                <h4><i class="fas fa-info-circle"></i> Current Report Information</h4>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Report ID</div>
                        <div class="info-value">#<%= request.getAttribute("reportId") != null ? request.getAttribute("reportId") : "1" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Created Date</div>
                        <div class="info-value">Dec 15, 2024</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Last Modified</div>
                        <div class="info-value">Dec 20, 2024</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Download Count</div>
                        <div class="info-value">12 times</div>
                    </div>
                </div>
            </div>

            <!-- Edit Form -->
            <div class="edit-form">
                <h3><i class="fas fa-edit"></i> Update Report Details</h3>
                <form action="${pageContext.request.contextPath}/manager" method="post">
                    <input type="hidden" name="action" value="updateReport">
                    <input type="hidden" name="reportId" value="<%= request.getAttribute("reportId") != null ? request.getAttribute("reportId") : "1" %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="reportTitle">Report Title:</label>
                            <input type="text" id="reportTitle" name="reportTitle" required
                                   value="Q4 2024 Performance Report"
                                   placeholder="Enter report title">
                            <small>This will be displayed as the main title of the report</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="reportType">Report Type:</label>
                            <select id="reportType" name="reportType" required>
                                <option value="MONTHLY" selected>Monthly Report</option>
                                <option value="QUARTERLY">Quarterly Report</option>
                                <option value="ANNUAL">Annual Report</option>
                                <option value="CUSTOM">Custom Report</option>
                            </select>
                            <small>Select the type of performance report</small>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="reportPeriod">Report Period:</label>
                            <input type="text" id="reportPeriod" name="reportPeriod" required
                                   value="Q4 2024 (Oct-Dec)"
                                   placeholder="e.g., November 2024, Q4 2024, 2024">
                            <small>Specify the time period this report covers</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="reportFormat">Output Format:</label>
                            <select id="reportFormat" name="reportFormat" required>
                                <option value="PDF" selected>PDF Document</option>
                                <option value="CSV">CSV Spreadsheet</option>
                                <option value="EXCEL">Excel Workbook</option>
                                <option value="HTML">HTML Report</option>
                            </select>
                            <small>Choose the default output format for downloads</small>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="reportDescription">Report Description:</label>
                        <textarea id="reportDescription" name="reportDescription" 
                                  placeholder="Describe the purpose and scope of this performance report...">This quarterly performance report provides a comprehensive analysis of staff performance, customer satisfaction metrics, and operational efficiency for Q4 2024. The data shows significant improvements in resolution times and customer satisfaction compared to previous quarters.</textarea>
                        <small>Provide a detailed description of what this report contains</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="includeMetrics">Include Metrics:</label>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; margin-top: 10px;">
                            <label style="display: flex; align-items: center; font-weight: normal;">
                                <input type="checkbox" name="includeMetrics" value="RESOLUTION_TIME" checked style="margin-right: 8px;">
                                Resolution Time Analysis
                            </label>
                            <label style="display: flex; align-items: center; font-weight: normal;">
                                <input type="checkbox" name="includeMetrics" value="CUSTOMER_SATISFACTION" checked style="margin-right: 8px;">
                                Customer Satisfaction Metrics
                            </label>
                            <label style="display: flex; align-items: center; font-weight: normal;">
                                <input type="checkbox" name="includeMetrics" value="COMPLAINT_VOLUME" checked style="margin-right: 8px;">
                                Complaint Volume Analysis
                            </label>
                            <label style="display: flex; align-items: center; font-weight: normal;">
                                <input type="checkbox" name="includeMetrics" value="STAFF_PERFORMANCE" checked style="margin-right: 8px;">
                                Individual Staff Performance
                            </label>
                            <label style="display: flex; align-items: center; font-weight: normal;">
                                <input type="checkbox" name="includeMetrics" value="TREND_ANALYSIS" checked style="margin-right: 8px;">
                                Trend Analysis
                            </label>
                            <label style="display: flex; align-items: center; font-weight: normal;">
                                <input type="checkbox" name="includeMetrics" value="RECOMMENDATIONS" checked style="margin-right: 8px;">
                                Recommendations
                            </label>
                        </div>
                        <small>Select which metrics and analyses to include in the report</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="reportStatus">Report Status:</label>
                        <select id="reportStatus" name="reportStatus" required>
                            <option value="DRAFT">Draft</option>
                            <option value="PUBLISHED" selected>Published</option>
                            <option value="ARCHIVED">Archived</option>
                        </select>
                        <small>Set the current status of this report</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="accessLevel">Access Level:</label>
                        <select id="accessLevel" name="accessLevel" required>
                            <option value="PUBLIC">Public (All Users)</option>
                            <option value="MANAGERS" selected>Managers Only</option>
                            <option value="ADMIN">Admin Only</option>
                        </select>
                        <small>Control who can view and download this report</small>
                    </div>
                </form>
            </div>

            <!-- Form Actions -->
            <div class="form-actions">
                <button type="submit" form="editForm" class="btn btn-success">
                    <i class="fas fa-save"></i> Save Changes
                </button>
                <a href="${pageContext.request.contextPath}/manager?action=viewReport&id=<%= request.getAttribute("reportId") != null ? request.getAttribute("reportId") : "1" %>" class="btn btn-secondary">
                    <i class="fas fa-eye"></i> Preview Changes
                </a>
                <a href="${pageContext.request.contextPath}/manager?action=reports" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/manager?action=reports">
                <i class="fas fa-file-alt"></i> All Reports
            </a>
            <a href="${pageContext.request.contextPath}/manager?action=performance">
                <i class="fas fa-chart-line"></i> Performance Tracking
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Add form ID to the form element
        document.querySelector('form').id = 'editForm';
        
        // Form validation
        document.getElementById('editForm').addEventListener('submit', function(e) {
            const title = document.getElementById('reportTitle').value.trim();
            const period = document.getElementById('reportPeriod').value.trim();
            const description = document.getElementById('reportDescription').value.trim();
            
            if (!title || !period || !description) {
                e.preventDefault();
                alert('Please fill in all required fields.');
                return false;
            }
            
            // Show loading state
            const submitBtn = document.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
            submitBtn.disabled = true;
        });
        
        // Auto-save functionality (optional)
        let autoSaveTimeout;
        const form = document.getElementById('editForm');
        const inputs = form.querySelectorAll('input, select, textarea');
        
        inputs.forEach(input => {
            input.addEventListener('input', function() {
                clearTimeout(autoSaveTimeout);
                autoSaveTimeout = setTimeout(() => {
                    // Auto-save logic could be implemented here
                    console.log('Auto-saving...');
                }, 2000);
            });
        });
    </script>
</body>
</html>




