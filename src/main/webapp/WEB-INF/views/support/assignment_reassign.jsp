<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reassign Assignment - Smart Lanka CCS</title>
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

        .form-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 1.1em;
        }

        .form-group label i {
            margin-right: 8px;
            color: #3498db;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s ease;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1em;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-right: 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1f618d);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #7f8c8d, #6c7b7d);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(149, 165, 166, 0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #229954, #1e8449);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(39, 174, 96, 0.3);
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 30px;
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid;
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05));
            border-left-color: #10b981;
            color: #059669;
        }

        .alert-error {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(239, 68, 68, 0.05));
            border-left-color: #ef4444;
            color: #dc2626;
        }

        .alert-warning {
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(245, 158, 11, 0.05));
            border-left-color: #f59e0b;
            color: #d97706;
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
            color: #2c3e50;
        }

        .empty-state p {
            font-size: 1.1em;
            margin-bottom: 20px;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 300px;
                justify-content: center;
                margin-right: 0;
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-exchange-alt"></i> Reassign Assignment</h1>
            <p>Update assignment details and reassign to different staff member</p>
        </div>

        <%
            Long complaintId = (Long) request.getAttribute("complaintId");
            if (complaintId == null) {
        %>
            <div class="form-card">
                <div class="empty-state">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Invalid Request</h3>
                    <p>No complaint ID provided for reassignment.</p>
                    <a href="${pageContext.request.contextPath}/assignment?action=track" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Back to Assignments
                    </a>
                </div>
            </div>
        <% } else { %>
            <!-- Success Message -->
            <% if ("reassigned".equals(request.getParameter("status"))) { %>
                <div class="alert alert-success">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-check-circle" style="font-size: 1.2em;"></i>
                        <div>
                            <strong>Assignment Reassigned Successfully!</strong>
                            <p style="margin: 5px 0 0 0;">The assignment has been updated and reassigned.</p>
                        </div>
                    </div>
                </div>
            <% } %>

            <!-- Error Messages -->
            <% if ("validation_error".equals(request.getParameter("error"))) { %>
                <div class="alert alert-error">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-exclamation-circle" style="font-size: 1.2em;"></i>
                        <div>
                            <strong>Validation Error!</strong>
                            <p style="margin: 5px 0 0 0;">Please fill in all required fields correctly.</p>
                        </div>
                    </div>
                </div>
            <% } %>

            <% if ("server_error".equals(request.getParameter("error"))) { %>
                <div class="alert alert-error">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-exclamation-circle" style="font-size: 1.2em;"></i>
                        <div>
                            <strong>Server Error!</strong>
                            <p style="margin: 5px 0 0 0;">An error occurred while reassigning the assignment. Please try again.</p>
                        </div>
                    </div>
                </div>
            <% } %>

            <div class="form-card">
                <form action="${pageContext.request.contextPath}/assignment" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="complaintId" value="<%= complaintId %>">

                    <div class="form-group">
                        <label for="assignedTo"><i class="fas fa-user"></i> Assign To *</label>
                        <select id="assignedTo" name="assignedTo" class="form-control" required>
                            <option value="">Select Support Staff Member</option>
                            <option value="2">Nimal Perera - Technical Support (L1)</option>
                            <option value="20">Kamal Fernando - Technical Support (L1)</option>
                            <option value="21">Samantha Jayawardena - Technical Support (L2)</option>
                            <option value="22">Rajesh Kumar - Technical Support (L1)</option>
                            <option value="23">Priya Silva - Billing (L1)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="deadline"><i class="fas fa-calendar"></i> Deadline</label>
                        <input type="date" id="deadline" name="deadline" class="form-control">
                    </div>

                    <div class="form-group">
                        <label for="notes"><i class="fas fa-sticky-note"></i> Assignment Notes</label>
                        <textarea id="notes" name="notes" class="form-control" 
                                  placeholder="Enter any additional notes or instructions for this assignment..."></textarea>
                    </div>

                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/assignment?action=track" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Cancel
                        </a>
                        
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Reassign Assignment
                        </button>
                        
                        <a href="${pageContext.request.contextPath}/complaint?action=view&id=<%= complaintId %>" class="btn btn-success">
                            <i class="fas fa-eye"></i> View Complaint
                        </a>
                    </div>
                </form>
            </div>
        <% } %>
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

        // Set minimum date to today
        const deadlineInput = document.getElementById('deadline');
        if (deadlineInput) {
            const today = new Date().toISOString().split('T')[0];
            deadlineInput.setAttribute('min', today);
        }
    </script>
</body>
</html>
