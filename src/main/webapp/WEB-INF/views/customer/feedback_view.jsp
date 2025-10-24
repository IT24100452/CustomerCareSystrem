<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.smartlanka.ccs.model.Feedback" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Details - Smart Lanka CCS</title>
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
            max-width: 1000px;
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

        .feedback-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .feedback-title {
            font-size: 1.8em;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .feedback-id {
            color: #7f8c8d;
            font-size: 1em;
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
            color: #f39c12;
            font-size: 1.5em;
        }

        .star.empty {
            color: #ddd;
        }

        .rating-text {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1em;
        }

        .sentiment-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9em;
            text-transform: uppercase;
        }

        .sentiment-positive {
            background: #d4edda;
            color: #155724;
        }

        .sentiment-negative {
            background: #f8d7da;
            color: #721c24;
        }

        .sentiment-neutral {
            background: #d1ecf1;
            color: #0c5460;
        }

        .feedback-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
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

        .feedback-comment {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #e74c3c;
            margin-bottom: 25px;
        }

        .comment-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .comment-text {
            color: #555;
            line-height: 1.6;
            font-size: 1.05em;
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

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .feedback-header {
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
            <h1><i class="fas fa-star"></i> Feedback Details</h1>
            <p>View detailed information about your feedback</p>
        </div>

        <%
            Feedback feedback = (Feedback) request.getAttribute("feedback");
            if (feedback == null) {
        %>
            <div class="feedback-card">
                <div class="empty-state">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Feedback Not Found</h3>
                    <p>The feedback you're looking for could not be found or may have been deleted.</p>
                    <a href="${pageContext.request.contextPath}/feedback?action=list" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Back to Feedback List
                    </a>
                </div>
            </div>
        <% } else { %>
            <div class="feedback-card">
                <div class="feedback-header">
                    <div>
                        <div class="feedback-title">Feedback #<%= feedback.getFeedbackId() %></div>
                        <div class="feedback-id">
                            <% if (feedback.getComplaintId() > 0) { %>
                                Related to Complaint #<%= feedback.getComplaintId() %>
                            <% } else { %>
                                General Feedback
                            <% } %>
                        </div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <div class="rating-display">
                            <div class="stars">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <span class="star <%= i <= feedback.getRating() ? "" : "empty" %>">★</span>
                                <% } %>
                            </div>
                            <span class="rating-text"><%= feedback.getRating() %>/5</span>
                        </div>
                        <% if (feedback.getSentiment() != null && !feedback.getSentiment().isEmpty()) { %>
                            <span class="sentiment-badge sentiment-<%= feedback.getSentiment().toLowerCase() %>">
                                <%= feedback.getSentiment() %>
                            </span>
                        <% } %>
                    </div>
                </div>

                <div class="feedback-details">
                    <div class="detail-item">
                        <i class="fas fa-calendar"></i>
                        <div>
                            <div class="detail-label">Submitted Date</div>
                            <div class="detail-value">
                                <%= feedback.getSubmittedDate() != null ? 
                                    feedback.getSubmittedDate().format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm")) : 
                                    "Not available" %>
                            </div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <i class="fas fa-star"></i>
                        <div>
                            <div class="detail-label">Rating</div>
                            <div class="detail-value"><%= feedback.getRating() %> out of 5 stars</div>
                        </div>
                    </div>

                    <% if (feedback.getComplaintId() > 0) { %>
                        <div class="detail-item">
                            <i class="fas fa-exclamation-triangle"></i>
                            <div>
                                <div class="detail-label">Related Complaint</div>
                                <div class="detail-value">Complaint #<%= feedback.getComplaintId() %></div>
                            </div>
                        </div>
                    <% } %>

                    <% if (feedback.getSentiment() != null && !feedback.getSentiment().isEmpty()) { %>
                        <div class="detail-item">
                            <i class="fas fa-heart"></i>
                            <div>
                                <div class="detail-label">Sentiment Analysis</div>
                                <div class="detail-value"><%= feedback.getSentiment() %></div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <div class="feedback-comment">
                    <div class="comment-label">
                        <i class="fas fa-comment"></i>
                        Your Feedback
                    </div>
                    <div class="comment-text">
                        <%= feedback.getComment() != null ? feedback.getComment() : "No comment provided" %>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/feedback?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/feedback?action=edit&id=<%= feedback.getFeedbackId() %>" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Edit Feedback
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/feedback?action=delete&id=<%= feedback.getFeedbackId() %>" 
                       class="btn btn-danger" 
                       onclick="return confirm('Are you sure you want to delete this feedback? This action cannot be undone.')">
                        <i class="fas fa-trash"></i> Delete Feedback
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-success">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                </div>
            </div>
        <% } %>
    </div>
</body>
</html>
