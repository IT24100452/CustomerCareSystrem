<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Assignment" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assignment List - Smart Lanka CCS</title>
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
            max-width: 1200px;
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

        .assignment-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .assignment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .assignment-title {
            font-size: 1.5em;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .assignment-id {
            color: #7f8c8d;
            font-size: 1em;
        }

        .assignment-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #3498db;
        }

        .detail-item i {
            color: #3498db;
            font-size: 1.2em;
            width: 20px;
        }

        .detail-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .detail-value {
            color: #7f8c8d;
        }

        .assignment-notes {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #e74c3c;
            margin-bottom: 20px;
        }

        .notes-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .notes-text {
            color: #555;
            line-height: 1.6;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
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

        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
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

        .navigation {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .assignment-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-tasks"></i> Assignment List</h1>
            <p>View all assignments for this complaint</p>
        </div>

        <!-- Success Messages -->
        <% if ("assigned".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Assignment Created Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            The complaint has been assigned to a support staff member.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <% if ("reassigned".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Assignment Reassigned Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            The assignment has been updated and reassigned to a different staff member.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <% if ("unassigned".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Assignment Removed Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            The assignment has been removed and the complaint is now unassigned.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- Error Messages -->
        <% if ("error".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error" style="border-left: 4px solid #ef4444; background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(239, 68, 68, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-exclamation-circle" style="color: #ef4444; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #ef4444;">Operation Failed!</strong>
                        <p style="margin: 5px 0 0 0; color: #dc2626;">
                            An error occurred while processing your request. Please try again.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <%
            List<Assignment> assignments = (List<Assignment>) request.getAttribute("assignments");
            if (assignments == null || assignments.isEmpty()) {
        %>
            <div class="assignment-card">
                <div class="empty-state">
                    <i class="fas fa-clipboard-list"></i>
                    <h3>No Assignments Found</h3>
                    <p>There are no assignments for this complaint yet.</p>
                    <a href="${pageContext.request.contextPath}/assignment?action=assign" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Create Assignment
                    </a>
                </div>
            </div>
        <% } else { %>
            <% for (Assignment assignment : assignments) { %>
                <div class="assignment-card">
                    <div class="assignment-header">
                        <div>
                            <div class="assignment-title">Assignment #<%= assignment.getAssignmentId() %></div>
                            <div class="assignment-id">Complaint ID: #<%= assignment.getComplaintId() %></div>
                        </div>
                    </div>

                    <div class="assignment-details">
                        <div class="detail-item">
                            <i class="fas fa-user"></i>
                            <div>
                                <div class="detail-label">Assigned To</div>
                                <div class="detail-value">User ID: <%= assignment.getAssignedTo() %></div>
                            </div>
                        </div>

                        <div class="detail-item">
                            <i class="fas fa-user-tie"></i>
                            <div>
                                <div class="detail-label">Assigned By</div>
                                <div class="detail-value">User ID: <%= assignment.getAssignedBy() %></div>
                            </div>
                        </div>

                        <div class="detail-item">
                            <i class="fas fa-calendar"></i>
                            <div>
                                <div class="detail-label">Deadline</div>
                                <div class="detail-value">
                                    <%= assignment.getDeadline() != null ? 
                                        assignment.getDeadline().toLocalDateTime().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : 
                                        "No deadline set" %>
                                </div>
                            </div>
                        </div>

                        <div class="detail-item">
                            <i class="fas fa-clock"></i>
                            <div>
                                <div class="detail-label">Created At</div>
                                <div class="detail-value">
                                    <%= assignment.getCreatedAt() != null ? 
                                        assignment.getCreatedAt().toLocalDateTime().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : 
                                        "Not available" %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% if (assignment.getNotes() != null && !assignment.getNotes().trim().isEmpty()) { %>
                        <div class="assignment-notes">
                            <div class="notes-label">
                                <i class="fas fa-sticky-note"></i>
                                Assignment Notes
                            </div>
                            <div class="notes-text">
                                <%= assignment.getNotes() %>
                            </div>
                        </div>
                    <% } %>

                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/assignment?action=reassign&id=<%= assignment.getAssignmentId() %>" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Reassign
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/assignment?action=unassign&id=<%= assignment.getAssignmentId() %>" 
                           class="btn btn-danger" 
                           onclick="return confirm('Are you sure you want to unassign this assignment? This action cannot be undone.')">
                            <i class="fas fa-times"></i> Unassign
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/complaint?action=view&id=<%= assignment.getComplaintId() %>" class="btn btn-secondary">
                            <i class="fas fa-eye"></i> View Complaint
                        </a>
                    </div>
                </div>
            <% } %>
        <% } %>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/assignment?action=assign" class="btn btn-primary">
                <i class="fas fa-plus"></i> Create Assignment
            </a>
            <a href="${pageContext.request.contextPath}/assignment?action=track" class="btn btn-secondary">
                <i class="fas fa-list"></i> Track Assignments
            </a>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-success">
                <i class="fas fa-home"></i> Dashboard
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
    </script>
</body>
</html>
