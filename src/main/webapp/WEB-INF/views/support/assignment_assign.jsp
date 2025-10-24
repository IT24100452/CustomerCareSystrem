<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Complaint" %>
<%@ page import="lk.smartlanka.ccs.model.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Complaints - Support Dashboard</title>
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

        .assignment-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .assignment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .assignment-header h2 {
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

        .assignment-form {
            background: #f8f9fa;
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .assignment-form h3 {
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

        .form-group select,
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e8ed;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s ease;
            background: white;
        }

        .form-group select:focus,
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }

        .complaint-card {
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .complaint-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
        }

        .complaint-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .complaint-title {
            font-size: 1.3em;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .complaint-id {
            color: #7f8c8d;
            font-size: 0.9em;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-open {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .status-in-progress {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .status-resolved {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .priority-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.7em;
            font-weight: 600;
            text-transform: uppercase;
            margin-left: 10px;
        }

        .priority-critical {
            background: #f8d7da;
            color: #721c24;
        }

        .priority-high {
            background: #fff3cd;
            color: #856404;
        }

        .priority-medium {
            background: #d1ecf1;
            color: #0c5460;
        }

        .priority-low {
            background: #d4edda;
            color: #155724;
        }

        .complaint-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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

        .complaint-description {
            color: #5a6c7d;
            line-height: 1.6;
            margin-bottom: 15px;
            max-height: 60px;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .assignment-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .assignment-actions .btn {
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
            
            .assignment-container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .complaint-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .assignment-actions {
                width: 100%;
                justify-content: stretch;
            }
            
            .assignment-actions .btn {
                flex: 1;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-user-plus"></i> Assign Complaints</h1>
            <p>Assign complaints to support team members for resolution</p>
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

        <!-- Error Messages -->
        <% if ("validation".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error" style="border-left: 4px solid #ef4444; background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(239, 68, 68, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-exclamation-triangle" style="color: #ef4444; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #ef4444;">Validation Error!</strong>
                        <p style="margin: 5px 0 0 0; color: #dc2626;">
                            <%= request.getParameter("message") != null ? 
                                java.net.URLDecoder.decode(request.getParameter("message"), "UTF-8") : 
                                "Please check your input and try again." %>
                        </p>
                    </div>
                </div>
            </div>
        <% } else if ("assignment_error".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error" style="border-left: 4px solid #ef4444; background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(239, 68, 68, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-exclamation-circle" style="color: #ef4444; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #ef4444;">Assignment Failed!</strong>
                        <p style="margin: 5px 0 0 0; color: #dc2626;">
                            An error occurred while creating the assignment. Please try again.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <div class="assignment-container">
            <div class="assignment-header">
                <h2><i class="fas fa-tasks"></i> Assignment Management</h2>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>

            <!-- Assignment Form -->
            <div class="assignment-form">
                <h3><i class="fas fa-plus"></i> Assign New Complaint</h3>
                <form action="${pageContext.request.contextPath}/assignment" method="post">
                    <input type="hidden" name="action" value="assign">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="complaintId">Select Complaint:</label>
                            <select id="complaintId" name="complaintId" required>
                                <option value="">Choose a complaint to assign</option>
                                <% 
                                    List<Complaint> availableComplaints = (List<Complaint>) request.getAttribute("availableComplaints");
                                    if (availableComplaints != null && !availableComplaints.isEmpty()) {
                                        for (Complaint complaint : availableComplaints) {
                                %>
                                    <option value="<%= complaint.getComplaintId() %>">
                                        <%= complaint.getTitle() %> - #<%= complaint.getComplaintId() %> 
                                        (<%= complaint.getPriorityDisplayName() %> Priority)
                                    </option>
                                <% 
                                        }
                                    } else {
                                %>
                                    <option value="" disabled>No complaints available for assignment</option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="assigneeId">Assign to Support Member:</label>
                            <select id="assigneeId" name="assigneeId" required>
                                <option value="">Select support member</option>
                                <option value="2">Nimal Perera - Technical Support (L1)</option>
                                <option value="20">Kamal Fernando - Technical Support (L1)</option>
                                <option value="21">Samantha Jayawardena - Technical Support (L2)</option>
                                <option value="22">Rajesh Kumar - Technical Support (L1)</option>
                                <option value="23">Priya Silva - Billing (L1)</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="assignmentNotes">Assignment Notes:</label>
                        <textarea id="assignmentNotes" name="assignmentNotes" 
                                  placeholder="Add any specific instructions or notes for the assigned support member..."></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="priority">Priority Level:</label>
                        <select id="priority" name="priority" required>
                            <option value="LOW">Low Priority</option>
                            <option value="MEDIUM" selected>Medium Priority</option>
                            <option value="HIGH">High Priority</option>
                            <option value="CRITICAL">Critical Priority</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-user-plus"></i> Assign Complaint
                    </button>
                </form>
            </div>

            <!-- Assigned Complaints List -->
            <h3 style="color: #2c3e50; margin-bottom: 20px;">
                <i class="fas fa-list"></i> Currently Assigned Complaints
            </h3>

            <% 
                List<Complaint> assignedComplaints = (List<Complaint>) request.getAttribute("assignedComplaints");
                if (assignedComplaints == null || assignedComplaints.isEmpty()) {
            %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>No Assigned Complaints</h3>
                    <p>There are no complaints currently assigned to support members.</p>
                </div>
            <% } else { %>
                <% for (Complaint complaint : assignedComplaints) { %>
                    <div class="complaint-card">
                        <div class="complaint-header">
                            <div>
                                <div class="complaint-title"><%= complaint.getTitle() %></div>
                                <div class="complaint-id">Complaint #<%= complaint.getComplaintId() %> - Assigned to Support Member</div>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <span class="status-badge status-<%= complaint.getStatusCode().toLowerCase().replace("_", "-") %>">
                                    <%= complaint.getStatusDisplayName() %>
                                </span>
                                <span class="priority-badge priority-<%= complaint.getPriorityCode().toLowerCase() %>">
                                    <%= complaint.getPriorityDisplayName() %>
                                </span>
                            </div>
                        </div>

                        <div class="complaint-meta">
                            <div class="meta-item">
                                <i class="fas fa-tag"></i>
                                <span><%= complaint.getIssueTypeDisplayName() %></span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-calendar"></i>
                                <span>Submitted: <%= complaint.getSubmittedDate().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) %></span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-user"></i>
                                <span>Assigned to: Support Member #<%= complaint.getAssignedTo() %></span>
                            </div>
                        </div>

                        <div class="complaint-description">
                            <%= complaint.getDescription() != null && complaint.getDescription().length() > 200 ? 
                                complaint.getDescription().substring(0, 200) + "..." : 
                                complaint.getDescription() != null ? complaint.getDescription() : "No description provided" %>
                        </div>

                        <div class="assignment-actions">
                            <a href="${pageContext.request.contextPath}/complaint?action=view&id=<%= complaint.getComplaintId() %>" class="btn">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                            <a href="${pageContext.request.contextPath}/assignment?action=reassign&id=<%= complaint.getComplaintId() %>" class="btn btn-warning">
                                <i class="fas fa-exchange-alt"></i> Reassign
                            </a>
                            <a href="${pageContext.request.contextPath}/assignment?action=track&id=<%= complaint.getComplaintId() %>" class="btn btn-secondary">
                                <i class="fas fa-search"></i> Track Status
                            </a>
                            <a href="${pageContext.request.contextPath}/assignment?action=unassign&id=<%= complaint.getComplaintId() %>" 
                               class="btn btn-danger" 
                               onclick="return confirm('Are you sure you want to unassign this complaint?')">
                                <i class="fas fa-user-minus"></i> Unassign
                            </a>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/complaint?action=list">
                <i class="fas fa-clipboard-list"></i> Manage Complaints
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
    </script>
</body>
</html>

