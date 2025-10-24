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
    <title>Update Complaint - Smart Lanka CCS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css" type="text/css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .edit-complaint-container {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin: 20px auto;
            width: 90%;
            max-width: 800px;
        }

        .edit-header {
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }

        .edit-title {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .complaint-id {
            font-size: 16px;
            color: #6c757d;
            font-weight: 500;
        }

        .status-info {
            background-color: #e3f2fd;
            border: 1px solid #bbdefb;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 30px;
        }

        .status-info h4 {
            color: #1976d2;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-open { background-color: #fff3cd; color: #856404; }
        .status-in-progress { background-color: #cce5ff; color: #004085; }

        .form-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .form-section h3 {
            color: #495057;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
        }

        .form-group textarea {
            height: 120px;
            resize: vertical;
            font-family: inherit;
        }

        .form-group small {
            color: #6c757d;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }

        .file-upload-section {
            background-color: #fff;
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
            transition: border-color 0.3s ease;
        }

        .file-upload-section:hover {
            border-color: #007bff;
        }

        .file-upload-section.dragover {
            border-color: #007bff;
            background-color: #f8f9ff;
        }

        .file-upload-icon {
            font-size: 48px;
            color: #6c757d;
            margin-bottom: 15px;
        }

        .file-upload-text {
            color: #495057;
            font-weight: 500;
            margin-bottom: 10px;
        }

        .file-upload-hint {
            color: #6c757d;
            font-size: 14px;
        }

        .current-attachment {
            background-color: #e8f5e8;
            border: 1px solid #c3e6c3;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .current-attachment-icon {
            color: #28a745;
            font-size: 20px;
        }

        .current-attachment-info {
            flex: 1;
        }

        .current-attachment-name {
            font-weight: 500;
            color: #155724;
            margin-bottom: 5px;
        }

        .current-attachment-size {
            font-size: 12px;
            color: #6c757d;
        }

        .current-attachment-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 14px;
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

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
            transform: translateY(-2px);
        }

        .btn-outline-secondary {
            background-color: transparent;
            color: #6c757d;
            border: 1px solid #6c757d;
        }

        .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
        }

        .required {
            color: #dc3545;
        }

        .form-help {
            background-color: #d1ecf1;
            border: 1px solid #bee5eb;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .form-help h4 {
            color: #0c5460;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-help p {
            color: #0c5460;
            margin: 0;
            font-size: 14px;
            line-height: 1.5;
        }

        .character-count {
            text-align: right;
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }

        .character-count.warning {
            color: #ffc107;
        }

        .character-count.danger {
            color: #dc3545;
        }

        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
            }
            
            .current-attachment {
                flex-direction: column;
                text-align: center;
            }
            
            .current-attachment-actions {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="edit-complaint-container">
        <div class="edit-header">
            <h1 class="edit-title">
                <i class="fas fa-edit"></i>
                Update Complaint
            </h1>
            <div class="complaint-id">Complaint ID: #${complaint.complaintId}</div>
        </div>

        <div class="status-info">
            <h4><i class="fas fa-info-circle"></i> Current Status</h4>
            <p>This complaint is currently <span class="status-badge status-${complaint.statusCode.toLowerCase().replace('_', '-')}">${complaint.statusCode.replace('_', ' ')}</span>. 
            You can update the details below, but status changes are handled by our support team.</p>
        </div>

        <form action="${pageContext.request.contextPath}/complaint" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${complaint.complaintId}">

            <div class="form-section">
                <h3><i class="fas fa-edit"></i> Complaint Details</h3>
                
                <div class="form-group">
                    <label for="title">Title <span class="required">*</span></label>
                    <input type="text" id="title" name="title" value="${complaint.title}" required maxlength="200">
                    <small>Brief, descriptive title for your complaint (max 200 characters)</small>
                    <div class="character-count" id="title-count">0/200</div>
                </div>

                <div class="form-group">
                    <label for="category">Category</label>
                    <select id="category" name="category">
                        <option value="TECHNICAL" <%= "TECHNICAL".equals(complaint.getIssueTypeCode()) ? "selected" : "" %>>Technical Issue</option>
                        <option value="BILLING" <%= "BILLING".equals(complaint.getIssueTypeCode()) ? "selected" : "" %>>Billing Problem</option>
                        <option value="SERVICE" <%= "SERVICE".equals(complaint.getIssueTypeCode()) ? "selected" : "" %>>Service Quality</option>
                        <option value="NETWORK" <%= "INTERNET".equals(complaint.getIssueTypeCode()) ? "selected" : "" %>>Network Issue</option>
                        <option value="EQUIPMENT" <%= "TECHNICAL".equals(complaint.getIssueTypeCode()) ? "selected" : "" %>>Equipment Problem</option>
                        <option value="OTHER" <%= "OTHER".equals(complaint.getIssueTypeCode()) ? "selected" : "" %>>Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="priority">Priority</label>
                    <select id="priority" name="priority">
                        <option value="LOW" <%= "LOW".equals(complaint.getPriorityCode()) ? "selected" : "" %>>Low</option>
                        <option value="NORMAL" <%= "MEDIUM".equals(complaint.getPriorityCode()) ? "selected" : "" %>>Normal</option>
                        <option value="HIGH" <%= "HIGH".equals(complaint.getPriorityCode()) ? "selected" : "" %>>High</option>
                        <option value="URGENT" <%= "CRITICAL".equals(complaint.getPriorityCode()) ? "selected" : "" %>>Urgent</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="description">Description <span class="required">*</span></label>
                    <textarea id="description" name="description" required maxlength="2000" placeholder="Please provide detailed information about your complaint...">${complaint.description}</textarea>
                    <small>Detailed description of the issue (max 2000 characters)</small>
                    <div class="character-count" id="description-count">0/2000</div>
                </div>
            </div>

            <div class="form-section">
                <h3><i class="fas fa-paperclip"></i> Attachments</h3>
                
                <div class="form-group">
                    <label for="attachment">Upload Attachment (Optional)</label>
                    <input type="file" id="attachment" name="attachment" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png,.txt">
                    <small>Supported formats: PDF, DOC, DOCX, JPG, PNG, TXT (Max 10MB)</small>
                </div>
                
                <div class="form-help">
                    <h4><i class="fas fa-info-circle"></i> File Upload Guidelines</h4>
                    <p>• Supported formats: PDF, DOC, DOCX, JPG, JPEG, PNG, GIF, TXT<br>
                    • Maximum file size: 10MB<br>
                    • Uploading a new file will replace the current attachment</p>
                </div>
            </div>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/complaint?action=view&id=${complaint.complaintId}" class="btn btn-secondary">
                    <i class="fas fa-eye"></i> View Details
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Update Complaint
                </button>
                <a href="${pageContext.request.contextPath}/complaint?action=list" class="btn btn-outline-secondary">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
        </form>
    </div>

    <script>
        // Character count functionality
        function updateCharacterCount(inputId, countId, maxLength) {
            const input = document.getElementById(inputId);
            const count = document.getElementById(countId);
            
            function updateCount() {
                const length = input.value.length;
                count.textContent = length + '/' + maxLength;
                
                if (length > maxLength * 0.9) {
                    count.className = 'character-count danger';
                } else if (length > maxLength * 0.8) {
                    count.className = 'character-count warning';
                } else {
                    count.className = 'character-count';
                }
            }
            
            input.addEventListener('input', updateCount);
            updateCount(); // Initial count
        }

        // Initialize character counters
        updateCharacterCount('title', 'title-count', 200);
        updateCharacterCount('description', 'description-count', 2000);

        // File upload functionality
        const fileUpload = document.getElementById('file-upload');
        const fileInput = document.getElementById('attachment');

        fileUpload.addEventListener('click', () => {
            fileInput.click();
        });

        fileUpload.addEventListener('dragover', (e) => {
            e.preventDefault();
            fileUpload.classList.add('dragover');
        });

        fileUpload.addEventListener('dragleave', () => {
            fileUpload.classList.remove('dragover');
        });

        fileUpload.addEventListener('drop', (e) => {
            e.preventDefault();
            fileUpload.classList.remove('dragover');
            
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                fileInput.files = files;
                updateFileDisplay(files[0]);
            }
        });

        fileInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                updateFileDisplay(e.target.files[0]);
            }
        });

        function updateFileDisplay(file) {
            const fileText = fileUpload.querySelector('.file-upload-text');
            const fileHint = fileUpload.querySelector('.file-upload-hint');
            
            fileText.textContent = 'Selected: ' + file.name;
            fileHint.textContent = 'Size: ' + (file.size / 1024 / 1024).toFixed(2) + ' MB';
        }

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const description = document.getElementById('description').value.trim();
            
            if (!title || !description) {
                e.preventDefault();
                alert('Please fill in all required fields.');
                return false;
            }
            
            if (title.length > 200) {
                e.preventDefault();
                alert('Title must be 200 characters or less.');
                return false;
            }
            
            if (description.length > 2000) {
                e.preventDefault();
                alert('Description must be 2000 characters or less.');
                return false;
            }
        });
    </script>
</body>
</html>
