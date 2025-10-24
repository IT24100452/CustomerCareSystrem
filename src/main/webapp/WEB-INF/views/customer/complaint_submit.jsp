<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Complaint - Smart Lanka CCS</title>
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

        .file-upload {
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .file-upload input[type="file"] {
            position: absolute;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }

        .file-upload-label {
            display: block;
            padding: 15px;
            border: 2px dashed #bdc3c7;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .file-upload-label:hover {
            border-color: #667eea;
            background: rgba(102, 126, 234, 0.05);
        }

        .file-upload-label i {
            font-size: 2em;
            color: #7f8c8d;
            margin-bottom: 10px;
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

        .priority-info {
            background: #e8f4fd;
            border: 1px solid #bee5eb;
            border-radius: 10px;
            padding: 15px;
            margin-top: 10px;
        }

        .priority-info h4 {
            color: #0c5460;
            margin-bottom: 10px;
        }

        .priority-info ul {
            margin-left: 20px;
            color: #0c5460;
        }

        .priority-info li {
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
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-exclamation-triangle"></i> Submit New Complaint</h1>
            <p>Please provide detailed information about your issue so we can assist you better</p>
        </div>

        <div class="form-container">
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <% if ("validation_error".equals(request.getParameter("error"))) { %>
                        Please fill in all required fields correctly.
                    <% } else if ("file_upload_error".equals(request.getParameter("error"))) { %>
                        There was an error uploading your file. Please try again.
                    <% } else { %>
                        An error occurred while submitting your complaint. Please try again.
                    <% } %>
                </div>
            <% } %>

            <% if ("success".equals(request.getParameter("status"))) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    Your complaint has been submitted successfully! We'll review it and get back to you soon.
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/complaint" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
                    <label for="title"><i class="fas fa-heading"></i> Complaint Title *</label>
                    <input type="text" id="title" name="title" required 
                           placeholder="Brief description of your issue" 
                           maxlength="200">
                </div>

                <div class="form-group">
                    <label for="description"><i class="fas fa-align-left"></i> Detailed Description *</label>
                    <textarea id="description" name="description" required 
                              placeholder="Please provide detailed information about your issue, including steps to reproduce if applicable..."
                              maxlength="2000"></textarea>
                    <div class="char-counter">
                        <span id="charCounter">0</span>/2000 characters
                    </div>
                </div>

                <div class="form-group">
                    <label for="issueTypeCode"><i class="fas fa-tags"></i> Issue Type *</label>
                    <select id="issueTypeCode" name="issueTypeCode" required>
                        <option value="">Select issue type</option>
                        <option value="TECHNICAL">Technical Issue</option>
                        <option value="BILLING">Billing Issue</option>
                        <option value="SERVICE">Service Issue</option>
                        <option value="COMPLAINT">General Complaint</option>
                        <option value="FEATURE_REQUEST">Feature Request</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="priorityCode"><i class="fas fa-exclamation"></i> Priority Level *</label>
                    <select id="priorityCode" name="priorityCode" required>
                        <option value="">Select priority</option>
                        <option value="LOW">Low - Minor inconvenience</option>
                        <option value="MEDIUM">Medium - Moderate impact</option>
                        <option value="HIGH">High - Significant impact</option>
                        <option value="CRITICAL">Critical - Service disruption</option>
                    </select>
                    
                    <div class="priority-info">
                        <h4><i class="fas fa-info-circle"></i> Priority Guidelines:</h4>
                        <ul>
                            <li><strong>Low:</strong> Minor issues, cosmetic problems, general questions</li>
                            <li><strong>Medium:</strong> Non-critical functionality issues, workarounds available</li>
                            <li><strong>High:</strong> Major functionality affected, impacts daily operations</li>
                            <li><strong>Critical:</strong> Service completely down, security issues, data loss</li>
                        </ul>
                    </div>
                </div>

                <div class="form-group">
                    <label for="attachment"><i class="fas fa-paperclip"></i> Attachments (Optional)</label>
                    <div class="file-upload">
                        <input type="file" id="attachment" name="attachment" 
                               accept=".pdf,.doc,.docx,.jpg,.jpeg,.png,.gif,.txt">
                        <label for="attachment" class="file-upload-label">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <div>Click to upload files or drag and drop</div>
                            <div style="font-size: 0.9em; color: #7f8c8d; margin-top: 5px;">
                                Supported formats: PDF, DOC, DOCX, JPG, PNG, GIF, TXT (Max 10MB)
                            </div>
                        </label>
                    </div>
                </div>

                <div style="text-align: center; margin-top: 30px;">
                    <button type="submit" class="btn">
                        <i class="fas fa-paper-plane"></i> Submit Complaint
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
            <a href="${pageContext.request.contextPath}/complaint?action=list">
                <i class="fas fa-list"></i> My Complaints
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <script>
        // Character counter for description
        document.getElementById('description').addEventListener('input', function() {
            const counter = document.getElementById('charCounter');
            const length = this.value.length;
            counter.textContent = length;
            
            if (length > 1800) {
                counter.style.color = '#e74c3c';
            } else if (length > 1500) {
                counter.style.color = '#f39c12';
            } else {
                counter.style.color = '#7f8c8d';
            }
        });

        // File upload feedback
        document.getElementById('attachment').addEventListener('change', function(e) {
            const label = document.querySelector('.file-upload-label');
            const files = e.target.files;
            
            if (files.length > 0) {
                const fileName = files[0].name;
                const fileSize = (files[0].size / 1024 / 1024).toFixed(2);
                label.innerHTML = `
                    <i class="fas fa-check-circle" style="color: #27ae60;"></i>
                    <div><strong>${fileName}</strong></div>
                    <div style="font-size: 0.9em; color: #7f8c8d;">${fileSize} MB</div>
                `;
                label.style.borderColor = '#27ae60';
                label.style.backgroundColor = 'rgba(39, 174, 96, 0.1)';
            } else {
                label.innerHTML = `
                    <i class="fas fa-cloud-upload-alt"></i>
                    <div>Click to upload files or drag and drop</div>
                    <div style="font-size: 0.9em; color: #7f8c8d; margin-top: 5px;">
                        Supported formats: PDF, DOC, DOCX, JPG, PNG, GIF, TXT (Max 10MB)
                    </div>
                `;
                label.style.borderColor = '#bdc3c7';
                label.style.backgroundColor = '#f8f9fa';
            }
        });

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const description = document.getElementById('description').value.trim();
            const issueType = document.getElementById('issueTypeCode').value;
            const priority = document.getElementById('priorityCode').value;
            
            if (!title || !description || !issueType || !priority) {
                e.preventDefault();
                alert('Please fill in all required fields.');
                return false;
            }
            
            if (description.length < 20) {
                e.preventDefault();
                alert('Please provide a more detailed description (at least 20 characters).');
                return false;
            }
        });
    </script>
</body>
</html>




