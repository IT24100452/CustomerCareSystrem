<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="lk.smartlanka.ccs.model.Feedback" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Feedback - Smart Lanka CCS</title>
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

        .rating-container {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }

        .rating-stars {
            display: flex;
            gap: 5px;
        }

        .rating-star {
            font-size: 2em;
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s ease;
        }

        .rating-star:hover,
        .rating-star.active {
            color: #f39c12;
        }

        .rating-text {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1em;
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

        .char-counter {
            text-align: right;
            font-size: 0.9em;
            color: #7f8c8d;
            margin-top: 5px;
        }

        .char-counter.warning {
            color: #e74c3c;
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
            <h1><i class="fas fa-edit"></i> Edit Feedback</h1>
            <p>Update your feedback rating and comments</p>
        </div>

        <%
            Feedback feedback = (Feedback) request.getAttribute("feedback");
            if (feedback == null) {
        %>
            <div class="form-card">
                <div class="empty-state">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Feedback Not Found</h3>
                    <p>The feedback you're trying to edit could not be found or may have been deleted.</p>
                    <a href="${pageContext.request.contextPath}/feedback?action=list" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Back to Feedback List
                    </a>
                </div>
            </div>
        <% } else { %>
            <!-- Success Message -->
            <% if ("updated".equals(request.getParameter("status"))) { %>
                <div class="alert alert-success">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-check-circle" style="font-size: 1.2em;"></i>
                        <div>
                            <strong>Feedback Updated Successfully!</strong>
                            <p style="margin: 5px 0 0 0;">Your feedback has been updated and the changes have been saved.</p>
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
                            <p style="margin: 5px 0 0 0;">An error occurred while updating your feedback. Please try again.</p>
                        </div>
                    </div>
                </div>
            <% } %>

            <div class="form-card">
                <form action="${pageContext.request.contextPath}/feedback" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= feedback.getFeedbackId() %>">

                    <div class="form-group">
                        <label for="rating"><i class="fas fa-star"></i> Overall Rating *</label>
                        <div class="rating-container">
                            <div class="rating-stars">
                                <span class="rating-star" data-rating="1">★</span>
                                <span class="rating-star" data-rating="2">★</span>
                                <span class="rating-star" data-rating="3">★</span>
                                <span class="rating-star" data-rating="4">★</span>
                                <span class="rating-star" data-rating="5">★</span>
                            </div>
                            <span id="rating-text" class="rating-text">Select a rating</span>
                        </div>
                        <input type="hidden" id="rating" name="rating" value="<%= feedback.getRating() %>" required>
                    </div>

                    <div class="form-group">
                        <label for="comment"><i class="fas fa-comment"></i> Your Feedback *</label>
                        <textarea id="comment" name="comment" class="form-control" required 
                                  placeholder="Please share your detailed feedback about our service. What went well? What could be improved? Any suggestions?"
                                  maxlength="1000"><%= feedback.getComment() != null ? feedback.getComment() : "" %></textarea>
                        <div class="char-counter">
                            <span id="charCounter">0</span>/1000 characters
                        </div>
                    </div>

                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/feedback?action=list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Cancel
                        </a>
                        
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Update Feedback
                        </button>
                        
                        <a href="${pageContext.request.contextPath}/feedback?action=view&id=<%= feedback.getFeedbackId() %>" class="btn btn-success">
                            <i class="fas fa-eye"></i> View Details
                        </a>
                    </div>
                </form>
            </div>
        <% } %>
    </div>

    <script>
        // Rating functionality
        const ratingStars = document.querySelectorAll('.rating-star');
        const ratingInput = document.getElementById('rating');
        const ratingText = document.getElementById('rating-text');
        const currentRating = <%= feedback != null ? feedback.getRating() : 0 %>;

        // Set initial rating
        if (currentRating > 0) {
            setRating(currentRating);
        }

        ratingStars.forEach(star => {
            star.addEventListener('click', () => {
                const rating = parseInt(star.dataset.rating);
                setRating(rating);
            });

            star.addEventListener('mouseenter', () => {
                const rating = parseInt(star.dataset.rating);
                highlightStars(rating);
            });
        });

        document.querySelector('.rating-stars').addEventListener('mouseleave', () => {
            highlightStars(currentRating);
        });

        function setRating(rating) {
            ratingInput.value = rating;
            highlightStars(rating);
            updateRatingText(rating);
        }

        function highlightStars(rating) {
            ratingStars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('active');
                } else {
                    star.classList.remove('active');
                }
            });
        }

        function updateRatingText(rating) {
            const texts = {
                1: 'Poor',
                2: 'Fair', 
                3: 'Good',
                4: 'Very Good',
                5: 'Excellent'
            };
            ratingText.textContent = rating + ' - ' + texts[rating];
        }

        // Character counter
        const commentTextarea = document.getElementById('comment');
        const charCounter = document.getElementById('charCounter');

        function updateCharCounter() {
            const currentLength = commentTextarea.value.length;
            charCounter.textContent = currentLength;
            
            if (currentLength > 900) {
                charCounter.classList.add('warning');
            } else {
                charCounter.classList.remove('warning');
            }
        }

        commentTextarea.addEventListener('input', updateCharCounter);
        
        // Initialize character counter
        updateCharCounter();

        // Auto-hide success message
        const successAlert = document.querySelector('.alert-success');
        if (successAlert) {
            setTimeout(() => {
                successAlert.style.opacity = '0';
                setTimeout(() => {
                    successAlert.remove();
                }, 300);
            }, 5000);
        }
    </script>
</body>
</html>
