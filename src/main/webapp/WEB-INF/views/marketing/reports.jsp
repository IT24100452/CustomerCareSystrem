<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.MarketingReport" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Marketing Reports - Marketing Dashboard</title>
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

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 0;
            border-radius: 15px;
            width: 90%;
            max-width: 800px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease;
        }

        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 15px 15px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h3 {
            margin: 0;
            font-size: 1.5em;
        }

        .close {
            color: white;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .close:hover {
            color: #f39c12;
        }

        .modal-body {
            padding: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e8ed;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .modal-footer {
            padding: 20px 30px;
            background: #f8f9fa;
            border-radius: 0 0 15px 15px;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
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
            
            .reports-header {
                flex-direction: column;
                text-align: center;
            }
            
            .modal-content {
                width: 95%;
                margin: 10% auto;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-file-alt"></i> Marketing Reports</h1>
            <p>Manage and analyze your marketing campaign reports</p>
        </div>

        <div class="reports-container">
            <div class="reports-header">
                <h2><i class="fas fa-chart-line"></i> Campaign Reports</h2>
                <div>
                    <button onclick="openCreateModal()" class="btn btn-success">
                        <i class="fas fa-plus"></i> Create New Report
                    </button>
                    <a href="${pageContext.request.contextPath}/marketing/dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
    </div>

            <!-- Reports Table -->
            <div class="reports-table">
                <h3><i class="fas fa-table"></i> Marketing Reports</h3>
                <div class="table-container">
                    <table>
        <thead>
            <tr>
                <th>Title</th>
                <th>Campaign</th>
                <th>Period</th>
                <th>Budget</th>
                <th>ROI</th>
                                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
                            <tr>
                                <td><strong>Q4 2024 Campaign Analysis</strong></td>
                                <td>Holiday Marketing Campaign</td>
                                <td>Oct 1 - Dec 31, 2024</td>
                                <td>$15,000</td>
                                <td><span class="roi-badge roi-excellent">28%</span></td>
                                <td><span style="color: #27ae60; font-weight: 600;">Active</span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/marketing/report-view?id=1" class="btn btn-info" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <button onclick="editReport(1)" class="btn btn-warning" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                    <button onclick="downloadReport(1)" class="btn btn-success" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-download"></i> CSV
                                    </button>
                                    <button onclick="deleteReport(1)" class="btn btn-danger" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>Social Media Performance Report</strong></td>
                                <td>Social Media Campaign</td>
                                <td>Nov 1 - Nov 30, 2024</td>
                                <td>$8,500</td>
                                <td><span class="roi-badge roi-good">22%</span></td>
                                <td><span style="color: #f39c12; font-weight: 600;">Draft</span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/marketing/report-view?id=2" class="btn btn-info" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <button onclick="editReport(2)" class="btn btn-warning" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                    <button onclick="downloadReport(2)" class="btn btn-success" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-download"></i> CSV
                                    </button>
                                    <button onclick="deleteReport(2)" class="btn btn-danger" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>Email Marketing Analysis</strong></td>
                                <td>Email Campaign</td>
                                <td>Dec 1 - Dec 15, 2024</td>
                                <td>$5,200</td>
                                <td><span class="roi-badge roi-average">18%</span></td>
                                <td><span style="color: #27ae60; font-weight: 600;">Published</span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/marketing/report-view?id=3" class="btn btn-info" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <button onclick="editReport(3)" class="btn btn-warning" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                    <button onclick="downloadReport(3)" class="btn btn-success" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-download"></i> CSV
                                    </button>
                                    <button onclick="deleteReport(3)" class="btn btn-danger" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                    </td>
                            </tr>
                            <tr>
                                <td><strong>Customer Acquisition Report</strong></td>
                                <td>Acquisition Campaign</td>
                                <td>Sep 1 - Sep 30, 2024</td>
                                <td>$12,000</td>
                                <td><span class="roi-badge roi-poor">12%</span></td>
                                <td><span style="color: #95a5a6; font-weight: 600;">Archived</span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/marketing/report-view?id=4" class="btn btn-info" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <button onclick="editReport(4)" class="btn btn-warning" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                    <button onclick="downloadReport(4)" class="btn btn-success" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-download"></i> CSV
                                    </button>
                                    <button onclick="deleteReport(4)" class="btn btn-danger" style="padding: 5px 10px; font-size: 0.8em;">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                    </td>
                </tr>
        </tbody>
    </table>
</div>
            </div>

            <!-- Report Statistics -->
            <div class="reports-table">
                <h3><i class="fas fa-chart-bar"></i> Report Statistics</h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 20px;">
                    <div style="text-align: center; padding: 20px; background: white; border-radius: 10px; border: 1px solid #e1e8ed;">
                        <div style="font-size: 2.5em; color: #667eea; margin-bottom: 10px;">4</div>
                        <div style="color: #7f8c8d;">Total Reports</div>
                    </div>
                    <div style="text-align: center; padding: 20px; background: white; border-radius: 10px; border: 1px solid #e1e8ed;">
                        <div style="font-size: 2.5em; color: #27ae60; margin-bottom: 10px;">$40,700</div>
                        <div style="color: #7f8c8d;">Total Budget</div>
                    </div>
                    <div style="text-align: center; padding: 20px; background: white; border-radius: 10px; border: 1px solid #e1e8ed;">
                        <div style="font-size: 2.5em; color: #f39c12; margin-bottom: 10px;">20%</div>
                        <div style="color: #7f8c8d;">Average ROI</div>
                    </div>
                    <div style="text-align: center; padding: 20px; background: white; border-radius: 10px; border: 1px solid #e1e8ed;">
                        <div style="font-size: 2.5em; color: #3498db; margin-bottom: 10px;">2</div>
                        <div style="color: #7f8c8d;">Active Campaigns</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Create Report Modal -->
        <div id="createReportModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-plus"></i> Create Marketing Report</h3>
                    <span class="close" onclick="closeCreateModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="createReportForm" action="${pageContext.request.contextPath}/marketing" method="POST">
                        <div class="form-group">
                            <label for="title">Report Title:</label>
                            <input type="text" id="title" name="title" required placeholder="Enter report title">
                        </div>
                        
                        <div class="form-group">
                            <label for="description">Description:</label>
                            <textarea id="description" name="description" placeholder="Describe the report purpose and scope"></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label for="campaignName">Campaign Name:</label>
                            <input type="text" id="campaignName" name="campaignName" required placeholder="Enter campaign name">
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="startDate">Start Date:</label>
                                <input type="date" id="startDate" name="startDate" required>
                            </div>
                            <div class="form-group">
                                <label for="endDate">End Date:</label>
                                <input type="date" id="endDate" name="endDate" required>
                    </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="budget">Budget ($):</label>
                                <input type="number" step="0.01" id="budget" name="budget" required placeholder="0.00">
                            </div>
                            <div class="form-group">
                                <label for="roi">ROI (%):</label>
                                <input type="number" step="0.01" id="roi" name="roi" required placeholder="0.00">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="metrics">Key Metrics:</label>
                            <textarea id="metrics" name="metrics" placeholder="Describe key performance metrics and KPIs"></textarea>
                    </div>
                        
                        <input type="hidden" name="createdBy" value="<%= session.getAttribute("userId") != null ? session.getAttribute("userId") : "1" %>">
                </form>
            </div>
            <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeCreateModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="submit" form="createReportForm" class="btn btn-success">
                        <i class="fas fa-save"></i> Create Report
                    </button>
                </div>
            </div>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/marketing/dashboard">
                <i class="fas fa-chart-line"></i> Marketing Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/marketing/feedback-metrics">
                <i class="fas fa-chart-bar"></i> Feedback Metrics
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
    </div>
</div>

<script>
        // Modal functions
        function openCreateModal() {
            document.getElementById('createReportModal').style.display = 'block';
        }

        function closeCreateModal() {
            document.getElementById('createReportModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('createReportModal');
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        }

        // Report management functions
        function editReport(id) {
            window.location.href = '${pageContext.request.contextPath}/marketing/report-edit?id=' + id;
        }

        function downloadReport(id) {
            window.location.href = '${pageContext.request.contextPath}/marketing/download?id=' + id + '&format=csv';
        }

function deleteReport(id) {
            if (confirm('Are you sure you want to delete this report? This action cannot be undone.')) {
        fetch('${pageContext.request.contextPath}/marketing/' + id, {
            method: 'DELETE'
        }).then(response => {
            if (response.ok) {
                location.reload();
            } else {
                alert('Error deleting report');
            }
                }).catch(error => {
                    console.error('Error:', error);
                    alert('Error deleting report');
        });
    }
}

        // Form validation
        document.getElementById('createReportForm').addEventListener('submit', function(e) {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            const budget = document.getElementById('budget').value;
            const roi = document.getElementById('roi').value;
            
            if (new Date(startDate) >= new Date(endDate)) {
                e.preventDefault();
                alert('End date must be after start date.');
                return false;
            }
            
            if (parseFloat(budget) <= 0) {
                e.preventDefault();
                alert('Budget must be greater than 0.');
                return false;
            }
            
            if (parseFloat(roi) < 0) {
                e.preventDefault();
                alert('ROI cannot be negative.');
                return false;
            }
        });
</script>
</body>
</html>