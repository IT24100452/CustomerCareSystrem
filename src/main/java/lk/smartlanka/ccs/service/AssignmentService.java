package lk.smartlanka.ccs.service;

import lk.smartlanka.ccs.dao.AssignmentDao;
import lk.smartlanka.ccs.model.Assignment;
import lk.smartlanka.ccs.model.Complaint;

import java.util.List;

public class AssignmentService {
    private AssignmentDao dao = new AssignmentDao();

    public void assign(Assignment assignment) {
        System.out.println("DEBUG: AssignmentService.assign called with complaint ID: " + assignment.getComplaintId());
        
        // Validation - check if complaint exists
        if (assignment.getComplaintId() <= 0) {
            System.out.println("DEBUG: Invalid complaint ID: " + assignment.getComplaintId());
            throw new IllegalArgumentException("Invalid complaint ID");
        }
        
        // Check if complaint exists before creating assignment
        ComplaintService complaintService = new ComplaintService();
        System.out.println("DEBUG: Checking if complaint exists in database...");
        Complaint complaint = complaintService.getById(assignment.getComplaintId());
        
        if (complaint == null) {
            System.out.println("DEBUG: Complaint with ID " + assignment.getComplaintId() + " does not exist in database");
            throw new IllegalArgumentException("Complaint with ID " + assignment.getComplaintId() + " does not exist");
        }
        
        System.out.println("DEBUG: Complaint found: " + complaint.getTitle());
        System.out.println("DEBUG: Proceeding to create assignment...");
        dao.create(assignment);
        System.out.println("DEBUG: Assignment created successfully");
    }

    public void update(Assignment assignment) {
        dao.update(assignment);
    }

    public void delete(long id) {
        dao.delete(id);
    }

    public List<Assignment> getByComplaint(long complaintId) {
        return dao.getByComplaint(complaintId);
    }
}