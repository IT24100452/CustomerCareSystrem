<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Complaint" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Complaints - Support Dashboard</title>
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

        .delete-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .delete-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .delete-header h2 {
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

        .btn-warning {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
        }

        .btn-warning:hover {
            box-shadow: 0 10px 20px rgba(243, 156, 18, 0.3);
        }

        .warning-banner {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            text-align: center;
        }

        .warning-banner i {
            font-size: 2em;
            margin-bottom: 10px;
        }

        .warning-banner h3 {
            font-size: 1.3em;
            margin-bottom: 10px;
        }

        .warning-banner p {
            font-size: 1em;
            opacity: 0.9;
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

        .complaint-card.deletable {
            border-left: 4px solid #e74c3c;
        }

        .complaint-card.not-deletable {
            border-left: 4px solid #95a5a6;
            opacity: 0.7;
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

        .delete-form {
            background: #fff5f5;
            border: 1px solid #fed7d7;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
        }

        .delete-form h4 {
            color: #c53030;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .delete-form h4 i {
            margin-right: 8px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #2c3e50;
        }

        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 2px solid #e1e8ed;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s ease;
        }

        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #e74c3c;
        }

        .form-group textarea {
            min-height: 80px;
            resize: vertical;
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

        .deletion-rules {
            background: #e8f4fd;
            border: 1px solid #bee5eb;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .deletion-rules h3 {
            color: #0c5460;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .deletion-rules h3 i {
            margin-right: 10px;
        }

        .deletion-rules ul {
            list-style: none;
            padding: 0;
        }

        .deletion-rules li {
            padding: 8px 0;
            color: #0c5460;
            display: flex;
            align-items: center;
        }

        .deletion-rules li i {
            margin-right: 10px;
            color: #17a2b8;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .delete-container {
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
            <h1><i class="fas fa-trash-alt"></i> Delete Complaints</h1>
            <p>Remove resolved or invalid complaints from the system</p>
        </div>

        <!-- Success Messages -->
        <% if ("deleted".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Complaint Deleted Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            The complaint has been permanently deleted from the system.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <% if ("status_updated".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Status Updated Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            The complaint status has been updated successfully.
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

        <div class="delete-container">
            <div class="delete-header">
                <h2><i class="fas fa-exclamation-triangle"></i> Complaint Deletion Management</h2>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>

            <div class="warning-banner">
                <i class="fas fa-exclamation-triangle"></i>
                <h3>⚠️ Important Notice</h3>
                <p>Deleting complaints is a permanent action that cannot be undone. Please ensure you have proper authorization and valid reasons before proceeding.</p>
            </div>

            <div class="deletion-rules">
                <h3><i class="fas fa-info-circle"></i> Deletion Rules & Guidelines</h3>
                <ul>
                    <li><i class="fas fa-check"></i> Only RESOLVED or CLOSED complaints can be deleted</li>
                    <li><i class="fas fa-check"></i> Complaints with OPEN or IN_PROGRESS status cannot be deleted</li>
                    <li><i class="fas fa-check"></i> Duplicate complaints can be deleted after verification</li>
                    <li><i class="fas fa-check"></i> Invalid or spam complaints can be deleted immediately</li>
                    <li><i class="fas fa-check"></i> Always provide a reason for deletion</li>
                </ul>
            </div>

            <% 
                List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
                if (complaints == null || complaints.isEmpty()) {
            %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>No Complaints Available</h3>
                    <p>There are no complaints available for deletion at the moment.</p>
                </div>
            <% } else { %>
                <% for (Complaint complaint : complaints) { 
                    boolean isDeletable = "RESOLVED".equals(complaint.getStatusCode()) || "CLOSED".equals(complaint.getStatusCode());
                %>
                    <div class="complaint-card <%= isDeletable ? "deletable" : "not-deletable" %>">
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
                            <% if (complaint.getResolvedDate() != null) { %>
                                <div class="meta-item">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Resolved: <%= complaint.getResolvedDate().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) %></span>
                                </div>
                            <% } %>
                        </div>

                        <div class="complaint-description">
                            <%= complaint.getDescription() != null && complaint.getDescription().length() > 200 ? 
                                complaint.getDescription().substring(0, 200) + "..." : 
                                complaint.getDescription() != null ? complaint.getDescription() : "No description provided" %>
                        </div>

                        <% if (isDeletable) { %>
                            <!-- Delete Form -->
                            <div class="delete-form">
                                <h4><i class="fas fa-trash"></i> Delete This Complaint</h4>
                                <form action="${pageContext.request.contextPath}/complaint" method="post">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= complaint.getComplaintId() %>">
                                    
                                    <div class="form-group">
                                        <label for="deleteReason-<%= complaint.getComplaintId() %>">Reason for Deletion:</label>
                                        <select id="deleteReason-<%= complaint.getComplaintId() %>" name="deleteReason" required>
                                            <option value="">Select a reason</option>
                                            <option value="RESOLVED">Complaint has been resolved and closed</option>
                                            <option value="DUPLICATE">Duplicate complaint - already handled</option>
                                            <option value="INVALID">Invalid complaint - incorrect information</option>
                                            <option value="SPAM">Spam or inappropriate content</option>
                                            <option value="CUSTOMER_REQUEST">Customer requested deletion</option>
                                            <option value="SYSTEM_CLEANUP">System cleanup - old resolved complaints</option>
                                        </select>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="deleteNotes-<%= complaint.getComplaintId() %>">Additional Notes:</label>
                                        <textarea id="deleteNotes-<%= complaint.getComplaintId() %>" name="deleteNotes" 
                                                  placeholder="Provide additional details about why this complaint is being deleted..."></textarea>
                                    </div>
                                    
                                    <button type="submit" class="btn btn-danger" 
                                            onclick="return confirm('Are you absolutely sure you want to delete Complaint #<%= complaint.getComplaintId() %>? This action cannot be undone!')">
                                        <i class="fas fa-trash"></i> Delete Complaint
                                    </button>
                                </form>
                            </div>
                        <% } else { %>
                            <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-top: 15px;">
                                <i class="fas fa-lock"></i> <strong>Cannot Delete:</strong> This complaint is still <%= complaint.getStatusDisplayName().toLowerCase() %> and cannot be deleted. Only resolved or closed complaints can be deleted.
                            </div>
                        <% } %>

                        <div class="complaint-actions">
                            <a href="${pageContext.request.contextPath}/complaint?action=view&id=<%= complaint.getComplaintId() %>" class="btn">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                            <a href="${pageContext.request.contextPath}/complaint?action=edit&id=<%= complaint.getComplaintId() %>" class="btn btn-warning">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <% if (isDeletable) { %>
                                <span style="color: #27ae60; font-weight: 600; padding: 8px 16px; background: #d4edda; border-radius: 8px;">
                                    <i class="fas fa-check"></i> Ready for Deletion
                                </span>
                            <% } else { %>
                                <span style="color: #856404; font-weight: 600; padding: 8px 16px; background: #fff3cd; border-radius: 8px;">
                                    <i class="fas fa-lock"></i> Cannot Delete
                                </span>
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
            <a href="${pageContext.request.contextPath}/assignment?action=assign">
                <i class="fas fa-user-plus"></i> Assign Complaints
            </a>
            <a href="${pageContext.request.contextPath}/assignment?action=track">
                <i class="fas fa-search"></i> Track Complaints
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

