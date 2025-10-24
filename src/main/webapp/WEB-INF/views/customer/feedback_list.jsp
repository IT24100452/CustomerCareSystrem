<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.smartlanka.ccs.model.Feedback" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Feedback - Smart Lanka CCS</title>
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

        .feedback-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .feedback-header h2 {
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

        .feedback-card {
            border: 1px solid #e1e8ed;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .feedback-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
        }

        .feedback-header-card {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .feedback-title {
            font-size: 1.3em;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .feedback-id {
            color: #7f8c8d;
            font-size: 0.9em;
        }

        .rating-display {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stars {
            display: flex;
            gap: 2px;
        }

        .star {
            font-size: 1.2em;
            color: #ffd700;
        }

        .star.empty {
            color: #ddd;
        }

        .rating-text {
            font-weight: 600;
            color: #2c3e50;
        }

        .sentiment-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 600;
            text-transform: uppercase;
        }

        .sentiment-positive {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .sentiment-neutral {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .sentiment-negative {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .feedback-meta {
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

        .feedback-comment {
            color: #5a6c7d;
            line-height: 1.6;
            margin-bottom: 15px;
            background: white;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .feedback-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .feedback-actions .btn {
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
            
            .feedback-container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .feedback-header-card {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .feedback-actions {
                width: 100%;
                justify-content: stretch;
            }
            
            .feedback-actions .btn {
                flex: 1;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-comments"></i> My Feedback</h1>
            <p>View and manage all your submitted feedback</p>
        </div>

        <!-- Success Messages -->
        <% if ("success".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Feedback Submitted Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            Your feedback has been submitted and is now visible in your feedback history.
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
                        <strong style="color: #10b981;">Feedback Updated Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            Your feedback has been updated and the changes have been saved.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <% if ("deleted".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success" style="border-left: 4px solid #10b981; background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(16, 185, 129, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #10b981; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #10b981;">Feedback Deleted Successfully!</strong>
                        <p style="margin: 5px 0 0 0; color: #059669;">
                            Your feedback has been permanently deleted from the system.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- Error Messages -->
        <% if ("delete_error".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error" style="border-left: 4px solid #ef4444; background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(239, 68, 68, 0.05)); margin-bottom: 20px; padding: 15px; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-exclamation-circle" style="color: #ef4444; font-size: 1.2em;"></i>
                    <div>
                        <strong style="color: #ef4444;">Delete Error!</strong>
                        <p style="margin: 5px 0 0 0; color: #dc2626;">
                            An error occurred while deleting your feedback. Please try again.
                        </p>
                    </div>
                </div>
            </div>
        <% } %>

        <%
            List<Feedback> feedback = (List<Feedback>) request.getAttribute("feedback");
            int totalFeedback = feedback != null ? feedback.size() : 0;
            int positiveFeedback = 0;
            int neutralFeedback = 0;
            int negativeFeedback = 0;
            double averageRating = 0;
            
            if (feedback != null && !feedback.isEmpty()) {
                for (Feedback f : feedback) {
                    if ("POSITIVE".equals(f.getSentiment())) {
                        positiveFeedback++;
                    } else if ("NEUTRAL".equals(f.getSentiment())) {
                        neutralFeedback++;
                    } else if ("NEGATIVE".equals(f.getSentiment())) {
                        negativeFeedback++;
                    }
                    averageRating += f.getRating();
                }
                averageRating = averageRating / feedback.size();
            }
        %>

        <div class="stats-container">
            <div class="stat-card">
                <i class="fas fa-comment"></i>
                <div class="number"><%= totalFeedback %></div>
                <div class="label">Total Feedback</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-star"></i>
                <div class="number"><%= String.format("%.1f", averageRating) %></div>
                <div class="label">Average Rating</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-thumbs-up"></i>
                <div class="number"><%= positiveFeedback %></div>
                <div class="label">Positive</div>
            </div>
            <div class="stat-card">
                <i class="fas fa-minus"></i>
                <div class="number"><%= neutralFeedback %></div>
                <div class="label">Neutral</div>
            </div>
        </div>

        <div class="feedback-container">
            <div class="feedback-header">
                <h2><i class="fas fa-clipboard-list"></i> Feedback History</h2>
                <a href="${pageContext.request.contextPath}/feedback?action=create" class="btn">
                    <i class="fas fa-plus"></i> Submit New Feedback
                </a>
            </div>

            <% if (feedback == null || feedback.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-comment-slash"></i>
                    <h3>No Feedback Yet</h3>
                    <p>You haven't submitted any feedback yet. Click the button above to submit your first feedback.</p>
                    <a href="${pageContext.request.contextPath}/feedback?action=create" class="btn">
                        <i class="fas fa-plus"></i> Submit Your First Feedback
                    </a>
                </div>
            <% } else { %>
                <% for (Feedback f : feedback) { %>
                    <div class="feedback-card">
                        <div class="feedback-header-card">
                            <div>
                                <div class="feedback-title">Feedback #<%= f.getFeedbackId() %></div>
                                <div class="feedback-id">
                                    <% if (f.getComplaintId() > 0) { %>
                                        Related to Complaint #<%= f.getComplaintId() %>
                                    <% } else { %>
                                        General Feedback
                                    <% } %>
                                </div>
                            </div>
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <div class="rating-display">
                                    <div class="stars">
                                        <% for (int i = 1; i <= 5; i++) { %>
                                            <span class="star <%= i <= f.getRating() ? "" : "empty" %>">★</span>
                                        <% } %>
                                    </div>
                                    <span class="rating-text"><%= f.getRating() %>/5</span>
                                </div>
                                <% if (f.getSentiment() != null && !f.getSentiment().isEmpty()) { %>
                                    <span class="sentiment-badge sentiment-<%= f.getSentiment().toLowerCase() %>">
                                        <%= f.getSentiment() %>
                                    </span>
                                <% } %>
                            </div>
                        </div>

                        <div class="feedback-meta">
                            <div class="meta-item">
                                <i class="fas fa-calendar"></i>
                                <span>Submitted: <%= f.getSubmittedDate().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) %></span>
                            </div>
                            <% if (f.getComplaintId() > 0) { %>
                                <div class="meta-item">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <span>Related Complaint: #<%= f.getComplaintId() %></span>
                                </div>
                            <% } %>
                        </div>

                        <div class="feedback-comment">
                            <%= f.getComment() != null ? f.getComment() : "No comment provided" %>
                        </div>

                        <div class="feedback-actions">
                            <a href="${pageContext.request.contextPath}/feedback?action=view&id=<%= f.getFeedbackId() %>" class="btn">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                            <a href="${pageContext.request.contextPath}/feedback?action=edit&id=<%= f.getFeedbackId() %>" class="btn btn-secondary">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="${pageContext.request.contextPath}/feedback?action=delete&id=<%= f.getFeedbackId() %>" 
                               class="btn btn-danger" 
                               onclick="return confirm('Are you sure you want to delete this feedback? This action cannot be undone.')">
                                <i class="fas fa-trash"></i> Delete
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
            <a href="${pageContext.request.contextPath}/feedback?action=create">
                <i class="fas fa-plus"></i> Submit Feedback
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