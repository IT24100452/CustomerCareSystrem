<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="lk.smartlanka.ccs.model.Complaint" %>

<%
    Complaint complaint = (Complaint) request.getAttribute("complaint");
    if (complaint == null) {
        response.sendRedirect(request.getContextPath() + "/complaint?action=list&error=complaint_not_found");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint Details - Smart Lanka CCS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css" type="text/css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
        .complaint-details-container {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin: 20px auto;
            width: 90%;
            max-width: 1000px;
        }

        .complaint-header {
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }

        .complaint-title {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .complaint-id {
            font-size: 16px;
            color: #6c757d;
            font-weight: 500;
        }

        .status-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-open { background-color: #fff3cd; color: #856404; }
        .status-in-progress { background-color: #cce5ff; color: #004085; }
        .status-resolved { background-color: #d4edda; color: #155724; }
        .status-closed { background-color: #f8d7da; color: #721c24; }

        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .detail-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
        }

        .detail-section h3 {
            color: #495057;
            font-size: 18px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .detail-item {
            margin-bottom: 15px;
        }

        .detail-label {
            font-weight: 600;
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .detail-value {
            color: #2c3e50;
            font-size: 16px;
            line-height: 1.5;
        }

        .description-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .description-text {
            background-color: white;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 15px;
            font-size: 16px;
            line-height: 1.6;
            color: #495057;
            white-space: pre-wrap;
        }

        .attachments-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .attachment-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
      background-color: white;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            margin-bottom: 10px;
        }

        .attachment-icon {
            color: #6c757d;
            font-size: 18px;
        }

        .attachment-name {
            flex: 1;
            font-weight: 500;
            color: #495057;
        }

        .attachment-download {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }

        .attachment-download:hover {
            text-decoration: underline;
        }

        .timeline-section {
            background-color: #f8f9fa;
      border-radius: 8px;
      padding: 20px;
            margin-bottom: 30px;
        }

        .timeline {
            position: relative;
            padding-left: 30px;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background-color: #dee2e6;
        }

        .timeline-item {
            position: relative;
            margin-bottom: 20px;
        }

        .timeline-icon {
            position: absolute;
            left: -22px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #007bff;
            border: 3px solid white;
            box-shadow: 0 0 0 2px #dee2e6;
        }

        .timeline-content {
            background-color: white;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 15px;
        }

        .timeline-title {
            font-weight: 600;
            color: #495057;
            margin-bottom: 5px;
        }

        .timeline-date {
            font-size: 14px;
            color: #6c757d;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
    }

    .btn {
            padding: 12px 24px;
            border-radius: 6px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
      border: none;
      cursor: pointer;
        }

        .btn-primary {
            background-color: #007bff;
            color: white;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #545b62;
            transform: translateY(-2px);
        }

        .btn-success {
            background-color: #28a745;
      color: white;
    }

        .btn-success:hover {
            background-color: #1e7e34;
            transform: translateY(-2px);
        }

        .feedback-section {
            background-color: #e8f5e8;
            border: 1px solid #c3e6c3;
            border-radius: 8px;
            padding: 20px;
            margin-top: 30px;
        }

        .feedback-form {
            margin-top: 15px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #495057;
            margin-bottom: 5px;
        }

        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-group textarea {
            height: 100px;
            resize: vertical;
        }

        .no-attachments {
            color: #6c757d;
            font-style: italic;
            text-align: center;
            padding: 20px;
        }

        @media (max-width: 768px) {
            .details-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
    }
  </style>
</head>
<body>
    <div class="complaint-details-container">
        <div class="complaint-header">
            <h1 class="complaint-title">${complaint.title}</h1>
            <div class="complaint-id">Complaint ID: #${complaint.complaintId}</div>
            <div style="margin-top: 15px;">
                <span class="status-badge status-${complaint.statusCode.toLowerCase().replace('_', '-')}">
                    ${complaint.statusCode.replace('_', ' ')}
                </span>
            </div>
        </div>

        <div class="details-grid">
            <div class="detail-section">
                <h3><i class="fas fa-calendar"></i> Complaint Information</h3>
                <div class="detail-item">
                    <div class="detail-label">Submitted Date</div>
                    <div class="detail-value">
                        <%= complaint.getSubmittedDate() != null ? 
                            complaint.getSubmittedDate().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : 
                            "Not available" %>
                    </div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Last Updated</div>
                    <div class="detail-value">
                        <%= complaint.getLastUpdated() != null ? 
                            complaint.getLastUpdated().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : 
                            "Not available" %>
                    </div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Priority</div>
                    <div class="detail-value">
                        <%= complaint.getPriorityCode() != null ? complaint.getPriorityCode() : "MEDIUM" %>
                    </div>
                </div>
            </div>

            <div class="detail-section">
                <h3><i class="fas fa-user"></i> Assignment Details</h3>
                <div class="detail-item">
                    <div class="detail-label">Assigned To</div>
                    <div class="detail-value">
                        <%= complaint.getAssignedTo() != 0 ? complaint.getAssignedTo() : "Not assigned" %>
                    </div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Category</div>
                    <div class="detail-value">
                        <%= complaint.getIssueTypeCode() != null ? complaint.getIssueTypeCode() : "OTHER" %>
                    </div>
                </div>
            </div>
        </div>

        <div class="description-section">
            <h3><i class="fas fa-file-alt"></i> Description</h3>
            <div class="description-text">${complaint.description}</div>
        </div>

        <div class="attachments-section">
            <h3><i class="fas fa-paperclip"></i> Attachments</h3>
            <div class="no-attachments">No attachments available</div>
        </div>

        <div class="timeline-section">
            <h3><i class="fas fa-history"></i> Status Timeline</h3>
            <div class="timeline">
                <div class="timeline-item">
                    <div class="timeline-icon"></div>
                    <div class="timeline-content">
                        <div class="timeline-title">Complaint Submitted</div>
                        <div class="timeline-date">
                            <%= complaint.getSubmittedDate() != null ? 
                                complaint.getSubmittedDate().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : 
                                "Date not available" %>
                        </div>
                    </div>
                </div>
                
                <% if ("IN_PROGRESS".equals(complaint.getStatusCode()) || "RESOLVED".equals(complaint.getStatusCode()) || "CLOSED".equals(complaint.getStatusCode())) { %>
                    <div class="timeline-item">
                        <div class="timeline-icon"></div>
                        <div class="timeline-content">
                            <div class="timeline-title">Complaint In Progress</div>
                            <div class="timeline-date">
                                <%= complaint.getLastUpdated() != null ? 
                                    complaint.getLastUpdated().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : 
                                    "Date not available" %>
                            </div>
                        </div>
                    </div>
                <% } %>
                
                <% if ("RESOLVED".equals(complaint.getStatusCode()) || "CLOSED".equals(complaint.getStatusCode())) { %>
                    <div class="timeline-item">
                        <div class="timeline-icon"></div>
                        <div class="timeline-content">
                            <div class="timeline-title">Complaint Resolved</div>
                            <div class="timeline-date">
                                <%= complaint.getLastUpdated() != null ? 
                                    complaint.getLastUpdated().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : 
                                    "Date not available" %>
                            </div>
                        </div>
                    </div>
                <% } %>
                
                <% if ("CLOSED".equals(complaint.getStatusCode())) { %>
                    <div class="timeline-item">
                        <div class="timeline-icon"></div>
                        <div class="timeline-content">
                            <div class="timeline-title">Complaint Closed</div>
                            <div class="timeline-date">
                                <%= complaint.getLastUpdated() != null ? 
                                    complaint.getLastUpdated().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : 
                                    "Date not available" %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/complaint?action=list" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to List
            </a>
            
            <% if ("OPEN".equals(complaint.getStatusCode()) || "IN_PROGRESS".equals(complaint.getStatusCode())) { %>
                <a href="${pageContext.request.contextPath}/complaint?action=edit&id=${complaint.complaintId}" class="btn btn-primary">
                    <i class="fas fa-edit"></i> Update Complaint
                </a>
            <% } %>
            
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-success">
                <i class="fas fa-home"></i> Dashboard
            </a>
        </div>

        <% if ("RESOLVED".equals(complaint.getStatusCode()) || "CLOSED".equals(complaint.getStatusCode())) { %>
            <div class="feedback-section">
                <h3><i class="fas fa-star"></i> Provide Feedback</h3>
                <p>We value your feedback! Please rate your experience and let us know how we can improve.</p>
                <form action="${pageContext.request.contextPath}/feedback" method="post" class="feedback-form">
        <input type="hidden" name="action" value="create">
        <input type="hidden" name="complaintId" value="${complaint.complaintId}">
                    
                    <div class="form-group">
                        <label for="rating">Rating:</label>
                        <select id="rating" name="rating" required>
                            <option value="">Select a rating</option>
                            <option value="1">1 - Poor</option>
                            <option value="2">2 - Fair</option>
                            <option value="3">3 - Good</option>
                            <option value="4">4 - Very Good</option>
                            <option value="5">5 - Excellent</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="comment">Comments:</label>
                        <textarea id="comment" name="comment" placeholder="Please share your thoughts about the service..."></textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-paper-plane"></i> Submit Feedback
                    </button>
    </form>
            </div>
        <% } %>
    </div>
</body>
</html>