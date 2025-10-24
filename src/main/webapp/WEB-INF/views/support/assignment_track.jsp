<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Complaint" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Assigned Complaints - Support Dashboard</title>
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

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .stat-card i {
            font-size: 2.5em;
            margin-bottom: 10px;
            color: white;
        }

        .stat-card .number {
            font-size: 2em;
            font-weight: bold;
            color: white;
            margin-bottom: 5px;
        }

        .stat-card .label {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9em;
        }

        .tracking-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .tracking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .tracking-header h2 {
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

        .status-closed {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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

        .progress-timeline {
            margin-top: 20px;
            padding: 20px;
            background: white;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .timeline-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            position: relative;
        }

        .timeline-item:last-child {
            margin-bottom: 0;
        }

        .timeline-item:not(:last-child)::after {
            content: '';
            position: absolute;
            left: 15px;
            top: 30px;
            width: 2px;
            height: 20px;
            background: #e1e8ed;
        }

        .timeline-icon {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 0.8em;
            color: white;
            z-index: 1;
            position: relative;
        }

        .timeline-icon.submitted {
            background: #667eea;
        }

        .timeline-icon.assigned {
            background: #f39c12;
        }

        .timeline-icon.in-progress {
            background: #3498db;
        }

        .timeline-icon.resolved {
            background: #27ae60;
        }

        .timeline-icon.closed {
            background: #95a5a6;
        }

        .timeline-content {
            flex: 1;
        }

        .timeline-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .timeline-date {
            font-size: 0.9em;
            color: #7f8c8d;
        }

        .complaint-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .complaint-actions .btn {
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
            
            .tracking-container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .complaint-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .complaint-actions {
                width: 100%;
                justify-content: stretch;
            }
            
            .complaint-actions .btn {
                flex: 1;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-search"></i> Track Assigned Complaints</h1>
            <p>Monitor the progress of assigned complaints and their resolution status</p>
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
            List<Complaint> assignedComplaints = (List<Complaint>) request.getAttribute("assignedComplaints");
            int totalAssigned = assignedComplaints != null ? assignedComplaints.size() : 0;
            int openAssigned = 0;
            int inProgressAssigned = 0;
            int resolvedAssigned = 0;
            
            if (assignedComplaints != null) {
                for (Complaint complaint : assignedComplaints) {
                    if ("OPEN".equals(complaint.getStatusCode())) {
                        openAssigned++;
                    } else if ("IN_PROGRESS".equals(complaint.getStatusCode())) {
                        inProgressAssigned++;
                    } else if ("RESOLVED".equals(complaint.getStatusCode())) {
                        resolvedAssigned++;
                    }
                }
            }
        %>

        <div class="stats-container">
            <div class="stat-card">
                <i class="fas fa-tasks"></i>
                <div class="number"><%= totalAssigned %></div>
                <div class="label">Total Assigned</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-clock"></i>
                <div class="number"><%= openAssigned %></div>
                <div class="label">Open</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-cog"></i>
                <div class="number"><%= inProgressAssigned %></div>
                <div class="label">In Progress</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-check-circle"></i>
                <div class="number"><%= resolvedAssigned %></div>
                <div class="label">Resolved</div>
            </div>
        </div>

        <div class="tracking-container">
            <div class="tracking-header">
                <h2><i class="fas fa-clipboard-list"></i> Assignment Tracking</h2>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>

            <% if (assignedComplaints == null || assignedComplaints.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>No Assigned Complaints</h3>
                    <p>There are no complaints currently assigned to track.</p>
                </div>
            <% } else { %>
                <% for (Complaint complaint : assignedComplaints) { %>
                    <div class="complaint-card">
                        <div class="complaint-header">
                            <div>
                                <div class="complaint-title"><%= complaint.getTitle() %></div>
                                <div class="complaint-id">Complaint #<%= complaint.getComplaintId() %> - Assigned to Support Member #<%= complaint.getAssignedTo() %></div>
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
                            <% if (complaint.getLastUpdated() != null) { %>
                                <div class="meta-item">
                                    <i class="fas fa-clock"></i>
                                    <span>Updated: <%= complaint.getLastUpdated().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) %></span>
                                </div>
                            <% } %>
                        </div>

                        <div class="complaint-description">
                            <%= complaint.getDescription() != null && complaint.getDescription().length() > 200 ? 
                                complaint.getDescription().substring(0, 200) + "..." : 
                                complaint.getDescription() != null ? complaint.getDescription() : "No description provided" %>
                        </div>

                        <!-- Progress Timeline -->
                        <div class="progress-timeline">
                            <h4 style="margin-bottom: 15px; color: #2c3e50;"><i class="fas fa-timeline"></i> Assignment Progress</h4>
                            
                            <div class="timeline-item">
                                <div class="timeline-icon submitted">
                                    <i class="fas fa-paper-plane"></i>
                                </div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Complaint Submitted</div>
                                    <div class="timeline-date"><%= complaint.getSubmittedDate().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) %></div>
                                </div>
                            </div>
                            
                            <div class="timeline-item">
                                <div class="timeline-icon assigned">
                                    <i class="fas fa-user-check"></i>
                                </div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Assigned to Support Team</div>
                                    <div class="timeline-date"><%= complaint.getSubmittedDate().plusDays(1).format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) %></div>
                                </div>
                            </div>
                            
                            <% if ("IN_PROGRESS".equals(complaint.getStatusCode()) || "RESOLVED".equals(complaint.getStatusCode()) || "CLOSED".equals(complaint.getStatusCode())) { %>
                                <div class="timeline-item">
                                    <div class="timeline-icon in-progress">
                                        <i class="fas fa-cog"></i>
                                    </div>
                                    <div class="timeline-content">
                                        <div class="timeline-title">Work In Progress</div>
                                        <div class="timeline-date"><%= complaint.getLastUpdated() != null ? complaint.getLastUpdated().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : "In Progress" %></div>
                                    </div>
                                </div>
                            <% } %>
                            
                            <% if ("RESOLVED".equals(complaint.getStatusCode()) || "CLOSED".equals(complaint.getStatusCode())) { %>
                                <div class="timeline-item">
                                    <div class="timeline-icon resolved">
                                        <i class="fas fa-check"></i>
                                    </div>
                                    <div class="timeline-content">
                                        <div class="timeline-title">Issue Resolved</div>
                                        <div class="timeline-date"><%= complaint.getResolvedDate() != null ? complaint.getResolvedDate().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : "Resolved" %></div>
                                    </div>
                                </div>
                            <% } %>
                            
                            <% if ("CLOSED".equals(complaint.getStatusCode())) { %>
                                <div class="timeline-item">
                                    <div class="timeline-icon closed">
                                        <i class="fas fa-lock"></i>
                                    </div>
                                    <div class="timeline-content">
                                        <div class="timeline-title">Complaint Closed</div>
                                        <div class="timeline-date"><%= complaint.getLastUpdated() != null ? complaint.getLastUpdated().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : "Closed" %></div>
                                    </div>
                                </div>
                            <% } %>
                        </div>

                        <div class="complaint-actions">
                            <a href="${pageContext.request.contextPath}/complaint?action=view&id=<%= complaint.getComplaintId() %>" class="btn">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                            <a href="${pageContext.request.contextPath}/complaint?action=edit&id=<%= complaint.getComplaintId() %>" class="btn btn-warning">
                                <i class="fas fa-edit"></i> Update
                            </a>
                            <a href="${pageContext.request.contextPath}/assignment?action=reassign&id=<%= complaint.getComplaintId() %>" class="btn btn-secondary">
                                <i class="fas fa-exchange-alt"></i> Reassign
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
            <a href="${pageContext.request.contextPath}/assignment?action=assign">
                <i class="fas fa-user-plus"></i> Assign Complaints
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

