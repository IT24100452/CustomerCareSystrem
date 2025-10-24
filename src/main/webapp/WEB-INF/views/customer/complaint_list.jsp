<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Complaint" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Complaints - Smart Lanka CCS</title>
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

        .complaints-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .complaints-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .complaints-header h2 {
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

        .status-cancelled {
            background: #e2e3e5;
            color: #383d41;
            border: 1px solid #d6d8db;
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

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .complaints-container {
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
            <h1><i class="fas fa-list"></i> My Complaints</h1>
            <p>Track and manage all your submitted complaints</p>
        </div>

        <!-- Success Messages -->
        <% if ("deleted".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Complaint Deleted Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            Your complaint has been permanently deleted from the system.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <% if ("updated".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Complaint Updated Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            Your complaint has been updated and the changes have been saved.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <% if ("created".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Complaint Submitted Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            Your complaint has been submitted and is now being processed.
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
            List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
            int totalComplaints = complaints != null ? complaints.size() : 0;
            int openComplaints = 0;
            int resolvedComplaints = 0;
            int inProgressComplaints = 0;
            
            if (complaints != null) {
                for (Complaint complaint : complaints) {
                    if ("OPEN".equals(complaint.getStatusCode())) {
                        openComplaints++;
                    } else if ("RESOLVED".equals(complaint.getStatusCode())) {
                        resolvedComplaints++;
                    } else if ("IN_PROGRESS".equals(complaint.getStatusCode())) {
                        inProgressComplaints++;
                    }
                }
            }
        %>

        <div class="stats-container">
            <div class="stat-card">
                <i class="fas fa-exclamation-triangle"></i>
                <div class="number"><%= totalComplaints %></div>
                <div class="label">Total Complaints</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-clock"></i>
                <div class="number"><%= openComplaints %></div>
                <div class="label">Open</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-cog"></i>
                <div class="number"><%= inProgressComplaints %></div>
                <div class="label">In Progress</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-check-circle"></i>
                <div class="number"><%= resolvedComplaints %></div>
                <div class="label">Resolved</div>
            </div>
        </div>

        <div class="complaints-container">
            <div class="complaints-header">
                <h2><i class="fas fa-clipboard-list"></i> Complaint History</h2>
                <a href="${pageContext.request.contextPath}/complaint?action=create" class="btn">
                    <i class="fas fa-plus"></i> Submit New Complaint
                </a>
            </div>

            <% if (complaints == null || complaints.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>No Complaints Yet</h3>
                    <p>You haven't submitted any complaints yet. Click the button above to submit your first complaint.</p>
                    <a href="${pageContext.request.contextPath}/complaint?action=create" class="btn">
                        <i class="fas fa-plus"></i> Submit Your First Complaint
                    </a>
                </div>
            <% } else { %>
                <% for (Complaint complaint : complaints) { %>
                    <div class="complaint-card">
                        <div class="complaint-header">
                            <div>
                                <div class="complaint-title"><%= complaint.getTitle() %></div>
                                <div class="complaint-id">Complaint #<%= complaint.getComplaintId() %></div>
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

                        <div class="complaint-actions">
                            <a href="${pageContext.request.contextPath}/complaint?action=view&id=<%= complaint.getComplaintId() %>" class="btn">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                            <% if ("OPEN".equals(complaint.getStatusCode()) || "IN_PROGRESS".equals(complaint.getStatusCode())) { %>
                                <a href="${pageContext.request.contextPath}/complaint?action=edit&id=<%= complaint.getComplaintId() %>" class="btn btn-secondary">
                                    <i class="fas fa-edit"></i> Update
                                </a>
                            <% } %>
                            <% if ("OPEN".equals(complaint.getStatusCode())) { %>
                                <a href="${pageContext.request.contextPath}/complaint?action=delete&id=<%= complaint.getComplaintId() %>" 
                                   class="btn btn-danger" 
                                   onclick="return confirm('Are you sure you want to delete this complaint? This action cannot be undone.')">
                                    <i class="fas fa-trash"></i> Delete
                                </a>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/complaint?action=create">
                <i class="fas fa-plus"></i> Submit Complaint
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    alert.style.transition = 'opacity 0.5s ease';
                    alert.style.opacity = '0';
                    setTimeout(function() {
                        alert.remove();
                    }, 500);
                }, 5000);
            });
        });

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

        // Auto-hide error messages
        const errorAlerts = document.querySelectorAll('.alert-error');
        errorAlerts.forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                setTimeout(() => {
                    alert.remove();
                }, 300);
            }, 8000);
        });
    </script>
</body>
</html>

