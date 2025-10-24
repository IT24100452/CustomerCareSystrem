<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Financial Report - Smart Lanka CCS</title>
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
            max-width: 800px;
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
            text-align: center;
        }

        .header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .form-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
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
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ecf0f1;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3498db;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .btn {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 25px;
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
        .btn-secondary { background: linear-gradient(135deg, #95a5a6, #7f8c8d); }

        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ecf0f1;
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-color: #dc3545;
        }

        .required {
            color: #e74c3c;
        }

        .help-text {
            font-size: 0.9rem;
            color: #7f8c8d;
            margin-top: 5px;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>
                <i class="fas fa-plus-circle"></i>
                Create Financial Report
            </h1>
            <p>Add a new financial report to the system</p>
        </div>

        <!-- Error Messages -->
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <% if ("validation_error".equals(request.getParameter("error"))) { %>
                    Please fill in all required fields.
                <% } else if ("server_error".equals(request.getParameter("error"))) { %>
                    An error occurred while creating the report. Please try again.
                <% } %>
            </div>
        <% } %>

        <!-- Form -->
        <div class="form-container">
            <form action="${pageContext.request.contextPath}/finance" method="post">
                <input type="hidden" name="action" value="create">
                
                <!-- Basic Information -->
                <div class="form-group">
                    <label for="title">Report Title <span class="required">*</span></label>
                    <input type="text" id="title" name="title" required 
                           placeholder="Enter report title (e.g., Q1 2024 Financial Report)">
                    <div class="help-text">A descriptive title for your financial report</div>
                </div>

                <div class="form-group">
                    <label for="reportType">Report Type <span class="required">*</span></label>
                    <select id="reportType" name="reportType" required>
                        <option value="">Select report type</option>
                        <option value="MONTHLY">Monthly Report</option>
                        <option value="QUARTERLY">Quarterly Report</option>
                        <option value="ANNUAL">Annual Report</option>
                        <option value="CUSTOM">Custom Period Report</option>
                    </select>
                    <div class="help-text">Choose the type of financial report</div>
                </div>

                <!-- Period Information -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="periodStart">Period Start <span class="required">*</span></label>
                        <input type="date" id="periodStart" name="periodStart" required>
                        <div class="help-text">Start date of the reporting period</div>
                    </div>

                    <div class="form-group">
                        <label for="periodEnd">Period End <span class="required">*</span></label>
                        <input type="date" id="periodEnd" name="periodEnd" required>
                        <div class="help-text">End date of the reporting period</div>
                    </div>
                </div>

                <!-- Financial Data -->
                <h3 style="margin: 30px 0 20px 0; color: #2c3e50;">
                    <i class="fas fa-dollar-sign"></i> Financial Data
                </h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="totalRevenue">Total Revenue</label>
                        <input type="number" id="totalRevenue" name="totalRevenue" 
                               step="0.01" min="0" placeholder="0.00">
                        <div class="help-text">Total revenue for the period</div>
                    </div>

                    <div class="form-group">
                        <label for="totalCosts">Total Costs</label>
                        <input type="number" id="totalCosts" name="totalCosts" 
                               step="0.01" min="0" placeholder="0.00">
                        <div class="help-text">Total costs for the period</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="complaintCosts">Complaint Costs</label>
                        <input type="number" id="complaintCosts" name="complaintCosts" 
                               step="0.01" min="0" placeholder="0.00">
                        <div class="help-text">Costs related to complaint handling</div>
                    </div>

                    <div class="form-group">
                        <label for="resolutionCosts">Resolution Costs</label>
                        <input type="number" id="resolutionCosts" name="resolutionCosts" 
                               step="0.01" min="0" placeholder="0.00">
                        <div class="help-text">Costs related to issue resolution</div>
                    </div>
                </div>

                <!-- Summary -->
                <div class="form-group">
                    <label for="summary">Summary</label>
                    <textarea id="summary" name="summary" 
                              placeholder="Enter a summary of the financial report..."></textarea>
                    <div class="help-text">Optional summary or notes about the report</div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/finance?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save"></i> Create Report
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Auto-calculate net profit
        function calculateNetProfit() {
            const revenue = parseFloat(document.getElementById('totalRevenue').value) || 0;
            const costs = parseFloat(document.getElementById('totalCosts').value) || 0;
            const netProfit = revenue - costs;
            
            // You could display this in a read-only field or update a display element
            console.log('Net Profit:', netProfit);
        }

        // Add event listeners for auto-calculation
        document.getElementById('totalRevenue').addEventListener('input', calculateNetProfit);
        document.getElementById('totalCosts').addEventListener('input', calculateNetProfit);

        // Set default dates
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date();
            const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
            const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
            
            document.getElementById('periodStart').value = firstDay.toISOString().split('T')[0];
            document.getElementById('periodEnd').value = lastDay.toISOString().split('T')[0];
        });

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const startDate = new Date(document.getElementById('periodStart').value);
            const endDate = new Date(document.getElementById('periodEnd').value);
            
            if (startDate >= endDate) {
                e.preventDefault();
                alert('Period start date must be before period end date.');
                return false;
            }
        });
    </script>
</body>
</html>

