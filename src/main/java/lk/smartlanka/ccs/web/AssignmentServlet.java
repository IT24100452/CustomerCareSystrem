package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.smartlanka.ccs.model.Assignment;
import lk.smartlanka.ccs.model.Complaint;
import lk.smartlanka.ccs.service.AssignmentService;
import lk.smartlanka.ccs.service.ComplaintService;
import lk.smartlanka.ccs.util.DatabaseInitializer;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AssignmentServlet extends HttpServlet {
    private AssignmentService service = new AssignmentService();
    private ComplaintService complaintService = new ComplaintService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("list".equals(action)) {
                long complaintId = Long.parseLong(req.getParameter("complaintId"));
                List<Assignment> assignments = service.getByComplaint(complaintId);
                req.setAttribute("assignments", assignments);
                req.getRequestDispatcher("/WEB-INF/views/support/assignment_list.jsp").forward(req, resp);
            } else if ("assign".equals(action)) {
                // Ensure sample complaints exist in database
                DatabaseInitializer.ensureSampleComplaints();
                
                // Show assign complaints page with sample data
                List<Complaint> assignedComplaints;
                List<Complaint> availableComplaints;
                try {
                    assignedComplaints = complaintService.getAll();
                    System.out.println("DEBUG: Found " + assignedComplaints.size() + " total complaints");
                    
                    // Get complaints that are not yet assigned or are open/in-progress
                    availableComplaints = complaintService.getAll().stream()
                        .filter(c -> c.getStatusCode() == null || 
                                    "OPEN".equals(c.getStatusCode()) || 
                                    "IN_PROGRESS".equals(c.getStatusCode()))
                        .collect(java.util.stream.Collectors.toList());
                    
                    System.out.println("DEBUG: Found " + availableComplaints.size() + " available complaints for assignment");
                    for (Complaint c : availableComplaints) {
                        System.out.println("  - ID: " + c.getComplaintId() + ", Title: " + c.getTitle() + ", Status: " + c.getStatusCode());
                    }
                    
                    // If no complaints from database, use sample data
                    if (availableComplaints.isEmpty()) {
                        System.out.println("DEBUG: No complaints from database, using sample data");
                        availableComplaints = createSampleAvailableComplaints();
                    }
                } catch (Exception e) {
                    System.err.println("Database error loading complaints for assignment: " + e.getMessage());
                    e.printStackTrace();
                    assignedComplaints = createSampleAssignedComplaints();
                    availableComplaints = createSampleAvailableComplaints();
                }
                req.setAttribute("assignedComplaints", assignedComplaints);
                req.setAttribute("availableComplaints", availableComplaints);
                req.getRequestDispatcher("/WEB-INF/views/support/assignment_assign.jsp").forward(req, resp);
            } else if ("track".equals(action)) {
                // Show track assigned complaints page with sample data
                List<Complaint> assignedComplaints;
                try {
                    assignedComplaints = complaintService.getAll();
                } catch (Exception e) {
                    System.err.println("Database error loading complaints for tracking: " + e.getMessage());
                    assignedComplaints = createSampleAssignedComplaints();
                }
                req.setAttribute("assignedComplaints", assignedComplaints);
                req.getRequestDispatcher("/WEB-INF/views/support/assignment_track.jsp").forward(req, resp);
            } else if ("reassign".equals(action)) {
                // Show reassign form for specific complaint
                long complaintId = Long.parseLong(req.getParameter("id"));
                req.setAttribute("complaintId", complaintId);
                req.getRequestDispatcher("/WEB-INF/views/support/assignment_reassign.jsp").forward(req, resp);
            } else if ("unassign".equals(action)) {
                // Handle unassign action
                long assignmentId = Long.parseLong(req.getParameter("id"));
                service.delete(assignmentId);
                resp.sendRedirect(req.getContextPath() + "/assignment?action=track&status=unassigned");
            } else {
                // Default to assign page
                req.getRequestDispatcher("/WEB-INF/views/support/assignment_assign.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            System.err.println("Error in AssignmentServlet doGet: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dashboard?error=assignment_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        try {
            if ("assign".equals(action)) {
                // Handle assignment creation
                String complaintIdStr = req.getParameter("complaintId");
                String assigneeIdStr = req.getParameter("assigneeId");
                
                System.out.println("DEBUG: Assignment request - complaintId: " + complaintIdStr + ", assigneeId: " + assigneeIdStr);
                
                Assignment assignment = new Assignment();
                assignment.setComplaintId(Long.parseLong(complaintIdStr));
                assignment.setAssignedTo(Integer.parseInt(assigneeIdStr));
                assignment.setAssignedBy((Integer) req.getSession().getAttribute("userId"));
                assignment.setNotes(req.getParameter("assignmentNotes"));
                
                System.out.println("DEBUG: About to assign complaint ID: " + assignment.getComplaintId());
                service.assign(assignment);
                System.out.println("DEBUG: Assignment successful");
                resp.sendRedirect(req.getContextPath() + "/assignment?action=assign&status=assigned");
            } else if ("create".equals(action)) {
                Assignment assignment = new Assignment();
                assignment.setComplaintId(Long.parseLong(req.getParameter("complaintId")));
                assignment.setAssignedTo(Integer.parseInt(req.getParameter("assignedTo")));
                assignment.setAssignedBy((Integer) req.getSession().getAttribute("userId"));
                assignment.setNotes(req.getParameter("notes"));
                try {
                    if (req.getParameter("deadline") != null && !req.getParameter("deadline").trim().isEmpty()) {
                        assignment.setDeadline(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(req.getParameter("deadline")).getTime()));
                    }
                } catch (Exception e) {
                    // Handle parse error
                }
                service.assign(assignment);
                resp.sendRedirect(req.getContextPath() + "/complaint?action=view&id=" + assignment.getComplaintId());
            } else if ("update".equals(action)) {
                // Handle reassignment - find existing assignment by complaintId
                long complaintId = Long.parseLong(req.getParameter("complaintId"));
                List<Assignment> existingAssignments = service.getByComplaint(complaintId);
                
                if (existingAssignments.isEmpty()) {
                    // No existing assignment, create new one
                    Assignment assignment = new Assignment();
                    assignment.setComplaintId(complaintId);
                    assignment.setAssignedTo(Integer.parseInt(req.getParameter("assignedTo")));
                    assignment.setAssignedBy((Integer) req.getSession().getAttribute("userId"));
                    assignment.setNotes(req.getParameter("notes"));
                    try {
                        if (req.getParameter("deadline") != null && !req.getParameter("deadline").trim().isEmpty()) {
                            assignment.setDeadline(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(req.getParameter("deadline")).getTime()));
                        }
                    } catch (Exception e) {
                        // Handle parse error
                    }
                    service.assign(assignment);
                } else {
                    // Update existing assignment
                    Assignment assignment = existingAssignments.get(0); // Get first assignment
                    assignment.setAssignedTo(Integer.parseInt(req.getParameter("assignedTo")));
                    assignment.setAssignedBy((Integer) req.getSession().getAttribute("userId"));
                    assignment.setNotes(req.getParameter("notes"));
                    try {
                        if (req.getParameter("deadline") != null && !req.getParameter("deadline").trim().isEmpty()) {
                            assignment.setDeadline(new Timestamp(new SimpleDateFormat("yyyy-MM-dd").parse(req.getParameter("deadline")).getTime()));
                        }
                    } catch (Exception e) {
                        // Handle parse error
                    }
                    service.update(assignment);
                }
                resp.sendRedirect(req.getContextPath() + "/assignment?action=list&complaintId=" + complaintId + "&status=reassigned");
            } else if ("delete".equals(action)) {
                long id = Long.parseLong(req.getParameter("id"));
                service.delete(id);
                resp.sendRedirect(req.getContextPath() + "/assignment?action=list&complaintId=" + req.getParameter("complaintId") + "&status=unassigned");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard?error=invalid_action");
            }
        } catch (IllegalArgumentException e) {
            System.err.println("Validation error in AssignmentServlet doPost: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/assignment?action=assign&error=validation&message=" + 
                            java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (Exception e) {
            System.err.println("Error in AssignmentServlet doPost: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/assignment?action=assign&error=assignment_error");
        }
    }
    
    // Sample data creation method for demo purposes
    private List<Complaint> createSampleAssignedComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        
        // Sample assigned complaint 1
        Complaint complaint1 = new Complaint();
        complaint1.setComplaintId(1001L);
        complaint1.setCustomerId(7);
        complaint1.setTitle("Internet Connection Issues");
        complaint1.setDescription("Customer experiencing intermittent internet connectivity problems affecting work from home setup.");
        complaint1.setIssueTypeCode("TECHNICAL");
        complaint1.setPriorityCode("HIGH");
        complaint1.setStatusCode("IN_PROGRESS");
        complaint1.setSubmittedDate(LocalDateTime.now().minusDays(2));
        complaint1.setLastUpdated(LocalDateTime.now().minusHours(6));
        complaint1.setAssignedTo(3); // Assigned to support member
        complaints.add(complaint1);
        
        // Sample assigned complaint 2
        Complaint complaint2 = new Complaint();
        complaint2.setComplaintId(1002L);
        complaint2.setCustomerId(8);
        complaint2.setTitle("Billing Discrepancy");
        complaint2.setDescription("Customer found unauthorized charges on monthly bill for premium support services.");
        complaint2.setIssueTypeCode("BILLING");
        complaint2.setPriorityCode("MEDIUM");
        complaint2.setStatusCode("OPEN");
        complaint2.setSubmittedDate(LocalDateTime.now().minusDays(5));
        complaint2.setLastUpdated(LocalDateTime.now().minusDays(1));
        complaint2.setAssignedTo(4); // Assigned to support member
        complaints.add(complaint2);
        
        // Sample assigned complaint 3
        Complaint complaint3 = new Complaint();
        complaint3.setComplaintId(1005L);
        complaint3.setCustomerId(9);
        complaint3.setTitle("Slow Internet Speed");
        complaint3.setDescription("Customer reporting significantly slower internet speeds than advertised plan.");
        complaint3.setIssueTypeCode("TECHNICAL");
        complaint3.setPriorityCode("MEDIUM");
        complaint3.setStatusCode("RESOLVED");
        complaint3.setSubmittedDate(LocalDateTime.now().minusDays(7));
        complaint3.setLastUpdated(LocalDateTime.now().minusDays(1));
        complaint3.setResolvedDate(LocalDateTime.now().minusDays(1));
        complaint3.setAssignedTo(5); // Assigned to support member
        complaints.add(complaint3);
        
        return complaints;
    }
    
    // Sample data for available complaints that can be assigned
    private List<Complaint> createSampleAvailableComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        
        // Sample available complaint 1
        Complaint complaint1 = new Complaint();
        complaint1.setComplaintId(1L);
        complaint1.setCustomerId(1);
        complaint1.setTitle("Network Connectivity Issue");
        complaint1.setDescription("Customer experiencing network connectivity problems.");
        complaint1.setIssueTypeCode("TECHNICAL");
        complaint1.setPriorityCode("HIGH");
        complaint1.setStatusCode("OPEN");
        complaint1.setSubmittedDate(LocalDateTime.now().minusDays(1));
        complaint1.setLastUpdated(LocalDateTime.now().minusHours(2));
        complaints.add(complaint1);
        
        // Sample available complaint 2
        Complaint complaint2 = new Complaint();
        complaint2.setComplaintId(2L);
        complaint2.setCustomerId(2);
        complaint2.setTitle("Service Interruption");
        complaint2.setDescription("Customer reporting service interruption during peak hours.");
        complaint2.setIssueTypeCode("SERVICE");
        complaint2.setPriorityCode("MEDIUM");
        complaint2.setStatusCode("OPEN");
        complaint2.setSubmittedDate(LocalDateTime.now().minusDays(2));
        complaint2.setLastUpdated(LocalDateTime.now().minusHours(4));
        complaints.add(complaint2);
        
        return complaints;
    }
}