<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Submit Complaint - Smart Lanka CCS" scope="request" />
<%@ include file="../common/header.jspf" %>

<div class="card">
    <div class="card-header">
        <h2 class="card-title"><i class="fas fa-exclamation-triangle"></i> Submit New Complaint</h2>
        <p>Please provide detailed information about your issue so we can assist you better</p>
    </div>
    
    <div class="card-body">
        <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger">
            <% if ("validation_error".equals(request.getParameter("error"))) { %>
            Please fill in all required fields correctly.
            <% } else if ("file_upload_error".equals(request.getParameter("error"))) { %>
            There was an error uploading your file. Please try again.
            <% } else { %>
            Failed to submit complaint. Please try again.
            <% } %>
        </div>
        <% } %>
        
        <% if ("success".equals(request.getParameter("status"))) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> Your complaint has been submitted successfully! 
            You will receive a confirmation email shortly.
        </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/complaint" method="post" enctype="multipart/form-data" id="complaintForm">
            <input type="hidden" name="action" value="create">
            
            <div class="form-group">
                <label for="title">Complaint Title *</label>
                <input type="text" id="title" name="title" class="form-control" required 
                       placeholder="Brief description of your issue" maxlength="120">
                <small class="text-muted">Keep it concise but descriptive</small>
            </div>
            
            <div class="form-group">
                <label for="issueTypeCode">Issue Type *</label>
                <select id="issueTypeCode" name="issueTypeCode" class="form-control" required>
                    <option value="">Select issue type</option>
                    <option value="INTERNET">Internet</option>
                    <option value="MOBILE">Mobile</option>
                    <option value="BILLING">Billing</option>
                    <option value="ACCOUNT">Account</option>
                    <option value="OTHER">Other</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="priorityCode">Priority Level *</label>
                <select id="priorityCode" name="priorityCode" class="form-control" required>
                    <option value="">Select priority</option>
                    <option value="LOW">Low - Can wait</option>
                    <option value="MEDIUM">Medium - Standard</option>
                    <option value="HIGH">High - Urgent</option>
                    <option value="CRITICAL">Critical - Immediate attention required</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="description">Detailed Description *</label>
                <textarea id="description" name="description" class="form-control" required 
                          rows="6" placeholder="Please provide a detailed description of your issue, including steps to reproduce if applicable"></textarea>
                <small class="text-muted">The more details you provide, the better we can assist you</small>
            </div>
            
            <div class="form-group">
                <label for="attachment">Attach File (Optional)</label>
                <div class="file-upload">
                    <input type="file" id="attachment" name="attachment" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png,.gif,.txt">
                    <label for="attachment" class="file-upload-label">
                        <i class="fas fa-cloud-upload-alt"></i> Click to upload file
                    </label>
                    <p class="text-muted">Supported formats: PDF, DOC, DOCX, JPG, PNG, GIF, TXT (Max 10MB)</p>
                </div>
            </div>
            
            <div class="form-group">
                <button type="submit" class="btn btn-success btn-lg">
                    <i class="fas fa-paper-plane"></i> Submit Complaint
                </button>
                <a href="${pageContext.request.contextPath}/complaint?action=list" class="btn btn-secondary btn-lg">
                    <i class="fas fa-list"></i> View My Complaints
                </a>
            </div>
        </form>
    </div>
</div>

<script>
document.getElementById('attachment').addEventListener('change', function(e) {
    const file = e.target.files[0];
    if (file) {
        // Check file size (10MB limit)
        if (file.size > 10 * 1024 * 1024) {
            alert('File size must be less than 10MB');
            this.value = '';
            return;
        }
        
        // Check file type
        const allowedTypes = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 
                             'image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'text/plain'];
        if (!allowedTypes.includes(file.type)) {
            alert('File type not supported. Please upload PDF, DOC, DOCX, JPG, PNG, GIF, or TXT files only.');
            this.value = '';
            return;
        }
        
        alert('File selected: ' + file.name);
    }
});

// Character counter for description
document.getElementById('description').addEventListener('input', function() {
    const maxLength = 2000;
    const currentLength = this.value.length;
    const remaining = maxLength - currentLength;
    
    let counter = document.getElementById('charCounter');
    if (!counter) {
        counter = document.createElement('small');
        counter.id = 'charCounter';
        counter.className = 'text-muted';
        this.parentNode.appendChild(counter);
    }
    
    counter.textContent = currentLength + '/' + maxLength + ' characters';
    
    if (remaining < 100) {
        counter.className = 'text-warning';
    } else {
        counter.className = 'text-muted';
    }
});
</script>

<%@ include file="../common/footer.jspf" %>

