<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.smartlanka.ccs.model.Complaint" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Feedback - Smart Lanka CCS</title>
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

        .form-container {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1em;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .char-counter {
            text-align: right;
            font-size: 0.9em;
            color: #7f8c8d;
            margin-top: 5px;
        }

        .rating-container {
            display: flex;
            gap: 10px;
            align-items: center;
            margin-top: 10px;
        }

        .rating-star {
            font-size: 2em;
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s ease;
        }

        .rating-star:hover,
        .rating-star.active {
            color: #ffd700;
        }

        .rating-star:hover ~ .rating-star {
            color: #ddd;
        }

        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-right: 15px;
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

        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid;
        }

        .alert-error {
            background: #fdf2f2;
            border-color: #e74c3c;
            color: #c0392b;
        }

        .alert-success {
            background: #f0f9f0;
            border-color: #27ae60;
            color: #1e8449;
        }

        .complaint-selector {
            background: #f8f9fa;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .complaint-item {
            padding: 10px;
            border: 1px solid #e1e8ed;
            border-radius: 8px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .complaint-item:hover {
            border-color: #667eea;
            background: rgba(102, 126, 234, 0.05);
        }

        .complaint-item.selected {
            border-color: #667eea;
            background: rgba(102, 126, 234, 0.1);
        }

        .complaint-item input[type="radio"] {
            margin-right: 10px;
        }

        .complaint-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .complaint-meta {
            font-size: 0.9em;
            color: #7f8c8d;
        }

        .sentiment-info {
            background: #e8f4fd;
            border: 1px solid #bee5eb;
            border-radius: 10px;
            padding: 15px;
            margin-top: 10px;
        }

        .sentiment-info h4 {
            color: #0c5460;
            margin-bottom: 10px;
        }

        .sentiment-info ul {
            margin-left: 20px;
            color: #0c5460;
        }

        .sentiment-info li {
            margin-bottom: 5px;
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
            
            .form-container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .rating-container {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-comment-plus"></i> Submit Feedback</h1>
            <p>Share your experience and help us improve our services</p>
        </div>

        <div class="form-container">
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <% if ("validation_error".equals(request.getParameter("error"))) { %>
                        Please fill in all required fields correctly.
                    <% } else { %>
                        An error occurred while submitting your feedback. Please try again.
                    <% } %>
                </div>
            <% } %>

            <% if ("success".equals(request.getParameter("status"))) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    Your feedback has been submitted successfully! Thank you for helping us improve.
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/feedback" method="post">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
                    <%--@declare id="complaintid"--%><label for="complaintId"><i class="fas fa-exclamation-triangle"></i> Related Complaint (Optional)</label>
                    <div class="complaint-selector">
                        <% 
                            List<Complaint> resolvedComplaints = (List<Complaint>) request.getAttribute("resolvedComplaints");
                            boolean first = true;
                        %>
                        <div class="complaint-item">
                            <input type="radio" id="complaint-none" name="complaintId" value="0" checked>
                            <label for="complaint-none">
                                <div class="complaint-title">General Feedback</div>
                                <div class="complaint-meta">No specific complaint - General service feedback</div>
                            </label>
                        </div>
                        <% 
                            if (resolvedComplaints != null && !resolvedComplaints.isEmpty()) {
                                for (Complaint complaint : resolvedComplaints) {
                        %>
                        <div class="complaint-item">
                            <input type="radio" id="complaint-<%= complaint.getComplaintId() %>" name="complaintId" value="<%= complaint.getComplaintId() %>">
                            <label for="complaint-<%= complaint.getComplaintId() %>">
                                <div class="complaint-title"><%= complaint.getTitle() %></div>
                                <div class="complaint-meta">Complaint #<%= complaint.getComplaintId() %> - <%= complaint.getIssueTypeDisplayName() %> (<%= complaint.getPriorityDisplayName() %> Priority)</div>
                            </label>
                        </div>
                        <% 
                                }
                            }
                        %>
                    </div>
                </div>

                <div class="form-group">
                    <label for="rating"><i class="fas fa-star"></i> Overall Rating *</label>
                    <div class="rating-container">
                        <span class="rating-star" data-rating="1">★</span>
                        <span class="rating-star" data-rating="2">★</span>
                        <span class="rating-star" data-rating="3">★</span>
                        <span class="rating-star" data-rating="4">★</span>
                        <span class="rating-star" data-rating="5">★</span>
                        <span id="rating-text" style="margin-left: 15px; font-weight: 600; color: #2c3e50;">Select a rating</span>
                    </div>
                    <input type="hidden" id="rating" name="rating" required>
                </div>

                <div class="form-group">
                    <label for="comment"><i class="fas fa-comment"></i> Your Feedback *</label>
                    <textarea id="comment" name="comment" required 
                              placeholder="Please share your detailed feedback about our service. What went well? What could be improved? Any suggestions?"
                              maxlength="1000"></textarea>
                    <div class="char-counter">
                        <span id="charCounter">0</span>/1000 characters
                    </div>
                </div>

                <div class="form-group">
                    <label for="sentiment"><i class="fas fa-heart"></i> Sentiment</label>
                    <select id="sentiment" name="sentiment">
                        <option value="">Auto-detect from rating</option>
                        <option value="POSITIVE">Positive</option>
                        <option value="NEUTRAL">Neutral</option>
                        <option value="NEGATIVE">Negative</option>
                    </select>
                    
                    <div class="sentiment-info">
                        <h4><i class="fas fa-info-circle"></i> Sentiment Guidelines:</h4>
                        <ul>
                            <li><strong>Positive:</strong> Excellent service, exceeded expectations, highly satisfied</li>
                            <li><strong>Neutral:</strong> Good service, met expectations, satisfactory experience</li>
                            <li><strong>Negative:</strong> Poor service, below expectations, needs improvement</li>
                        </ul>
                    </div>
                </div>

                <div style="text-align: center; margin-top: 30px;">
                    <button type="submit" class="btn">
                        <i class="fas fa-paper-plane"></i> Submit Feedback
                    </button>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </form>
        </div>

        <div class="navigation">
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/feedback?action=list">
                <i class="fas fa-comments"></i> My Feedback
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Star rating functionality
        const stars = document.querySelectorAll('.rating-star');
        const ratingInput = document.getElementById('rating');
        const ratingText = document.getElementById('rating-text');
        
        const ratingTexts = {
            1: 'Poor - Very Dissatisfied',
            2: 'Fair - Dissatisfied',
            3: 'Good - Neutral',
            4: 'Very Good - Satisfied',
            5: 'Excellent - Very Satisfied'
        };
        
        stars.forEach((star, index) => {
            star.addEventListener('click', () => {
                const rating = index + 1;
                ratingInput.value = rating;
                
                // Update star display
                stars.forEach((s, i) => {
                    s.classList.toggle('active', i < rating);
                });
                
                // Update text
                ratingText.textContent = ratingTexts[rating];
            });
            
            star.addEventListener('mouseenter', () => {
                const rating = index + 1;
                stars.forEach((s, i) => {
                    s.style.color = i < rating ? '#ffd700' : '#ddd';
                });
            });
        });
        
        // Reset stars on mouse leave
        document.querySelector('.rating-container').addEventListener('mouseleave', () => {
            const currentRating = parseInt(ratingInput.value) || 0;
            stars.forEach((s, i) => {
                s.style.color = i < currentRating ? '#ffd700' : '#ddd';
            });
        });

        // Character counter for comment
        document.getElementById('comment').addEventListener('input', function() {
            const counter = document.getElementById('charCounter');
            const length = this.value.length;
            counter.textContent = length;
            
            if (length > 900) {
                counter.style.color = '#e74c3c';
            } else if (length > 700) {
                counter.style.color = '#f39c12';
            } else {
                counter.style.color = '#7f8c8d';
            }
        });

        // Complaint selection styling
        document.querySelectorAll('.complaint-item input[type="radio"]').forEach(radio => {
            radio.addEventListener('change', function() {
                document.querySelectorAll('.complaint-item').forEach(item => {
                    item.classList.remove('selected');
                });
                if (this.checked) {
                    this.closest('.complaint-item').classList.add('selected');
                }
            });
        });

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const rating = document.getElementById('rating').value;
            const comment = document.getElementById('comment').value.trim();
            
            if (!rating || !comment) {
                e.preventDefault();
                alert('Please provide both a rating and feedback comment.');
                return false;
            }
            
            if (comment.length < 10) {
                e.preventDefault();
                alert('Please provide more detailed feedback (at least 10 characters).');
                return false;
            }
        });
    </script>
</body>
</html>

