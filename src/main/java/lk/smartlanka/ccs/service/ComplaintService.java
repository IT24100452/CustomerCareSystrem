package lk.smartlanka.ccs.service;

import lk.smartlanka.ccs.dao.ComplaintDao;
import lk.smartlanka.ccs.model.Complaint;

import java.util.List;

public class ComplaintService {
    private ComplaintDao dao = new ComplaintDao();

    public long createComplaint(Complaint complaint) {
        // Basic validation
        if (complaint.getTitle() == null || complaint.getTitle().isEmpty()) {
            throw new IllegalArgumentException("Title is required");
        }
        return dao.create(complaint);
    }

    public void update(long id, String description, String priorityCode) {
        // Validation
        dao.update(id, description, priorityCode);
    }

    public void updateComplaint(long id, String title, String description, String category, String priority) {
        // Validation
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Title is required");
        }
        if (description == null || description.trim().isEmpty()) {
            throw new IllegalArgumentException("Description is required");
        }
        dao.updateComplaint(id, title.trim(), description.trim(), category, priority);
    }

    public void updateStatus(long id, String status, int actorId) {
        dao.updateStatus(id, status, actorId);
    }

    public void delete(long id) {
        dao.delete(id);
    }

    public Complaint getById(long id) {
        return dao.getById(id);
    }

    public List<Complaint> getByCustomer(int customerId) {
        return dao.getByCustomer(customerId);
    }

    public List<Complaint> getAll() {
        return dao.getAll();
    }

    public List<Complaint> getAllComplaints() {
        return getAll();
    }

    public void addAttachment(long complaintId, String filePath) {
        dao.addAttachment(complaintId, filePath);
    }

    public List<Complaint> getComplaintsByCustomer(Integer customerId) {
        return customerId != null ? getByCustomer(customerId) : getAll();
    }
    
    public int getTotalComplaints() {
        return getAll().size();
    }
    
    public List<Complaint> getComplaintsByStatus(String status) {
        return getAll().stream()
                .filter(c -> status.equals(c.getStatusCode()))
                .toList();
    }
    
    public List<Complaint> getComplaintsByType(String type) {
        return getAll().stream()
                .filter(c -> type.equals(c.getIssueTypeCode()))
                .toList();
    }
    
    public List<Complaint> getComplaintsByAssignee(Integer assigneeId) {
        return getAll().stream()
                .filter(c -> assigneeId.equals(c.getAssigneeId()))
                .toList();
    }
    
    public List<Complaint> getRecentComplaints(int limit) {
        return getAll().stream()
                .sorted((c1, c2) -> c2.getSubmittedDate().compareTo(c1.getSubmittedDate()))
                .limit(limit)
                .toList();
    }
    
    public List<Complaint> getComplaintsByAssigneeAndStatus(Integer assigneeId, String status) {
        return getAll().stream()
                .filter(c -> assigneeId.equals(c.getAssigneeId()) && status.equals(c.getStatusCode()))
                .toList();
    }
    
    public List<Complaint> getComplaintsByTypeAndStatus(String type, String status) {
        return getAll().stream()
                .filter(c -> type.equals(c.getIssueTypeCode()) && status.equals(c.getStatusCode()))
                .toList();
    }
    
    public List<Complaint> getComplaintsByCustomerAndStatus(Integer customerId, String status) {
        return getByCustomer(customerId).stream()
                .filter(c -> status.equals(c.getStatusCode()))
                .toList();
    }
    
    public double getAverageResolutionTime() {
        return getAll().stream()
                .filter(c -> c.getResolvedDate() != null)
                .mapToDouble(c -> c.getResolvedDate().toLocalTime().toSecondOfDay() - 
                                c.getSubmittedDate().toLocalTime().toSecondOfDay())
                .average()
                .orElse(0.0);
    }
}