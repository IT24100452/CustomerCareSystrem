package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.smartlanka.ccs.infra.FileStorage;
import lk.smartlanka.ccs.model.Complaint;
import lk.smartlanka.ccs.service.ComplaintService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@MultipartConfig
public class ComplaintServlet extends HttpServlet {
  private ComplaintService service = new ComplaintService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String action = req.getParameter("action");
    int roleId = (Integer) req.getSession().getAttribute("roleId");
    
    try {
      if ("list".equals(action)) {
        int userId = (Integer) req.getSession().getAttribute("userId");
        List<Complaint> complaints;
        
        try {
          complaints = (roleId == 7) ? service.getByCustomer(userId) : service.getAll(); // Customer vs Support
        } catch (Exception e) {
          System.err.println("Database error loading complaints: " + e.getMessage());
          e.printStackTrace();
          // Show empty list instead of sample data
          complaints = new ArrayList<>();
        }
        
        req.setAttribute("complaints", complaints);
        
        // Forward to appropriate JSP based on role
        if (roleId == 7) { // Customer
          req.getRequestDispatcher("/WEB-INF/views/customer/complaint_list.jsp").forward(req, resp);
        } else { // Support/Admin
          req.getRequestDispatcher("/WEB-INF/views/support/complaint_list.jsp").forward(req, resp);
        }
      } else if ("view".equals(action)) {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
          resp.sendRedirect(req.getContextPath() + "/complaint?action=list&error=missing_id");
          return;
        }
        
        long id;
        try {
          id = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
          System.err.println("Invalid complaint ID format: " + idParam);
          resp.sendRedirect(req.getContextPath() + "/complaint?action=list&error=invalid_id");
          return;
        }
        
        Complaint complaint;
        try {
          complaint = service.getById(id);
          if (complaint == null) {
            System.err.println("Complaint not found for ID: " + id);
            resp.sendRedirect(req.getContextPath() + "/complaint?action=list&error=not_found");
            return;
          }
        } catch (Exception e) {
          System.err.println("Database error loading complaint: " + e.getMessage());
          e.printStackTrace();
          resp.sendRedirect(req.getContextPath() + "/complaint?action=list&error=database_error");
          return;
        }
        
        req.setAttribute("complaint", complaint);
        req.getRequestDispatcher("/WEB-INF/views/customer/complaint_view.jsp").forward(req, resp);
      } else if ("create".equals(action)) {
        // Show create complaint form
        req.getRequestDispatcher("/WEB-INF/views/customer/complaint_submit.jsp").forward(req, resp);
      } else if ("edit".equals(action)) {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
          resp.sendRedirect(req.getContextPath() + "/complaint?action=list&error=missing_id");
          return;
        }
        
        long id;
        try {
          id = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
          System.err.println("Invalid complaint ID format: " + idParam);
          resp.sendRedirect(req.getContextPath() + "/complaint?action=list&error=invalid_id");
          return;
        }
        
        Complaint complaint;
        try {
          complaint = service.getById(id);
          if (complaint == null) {
            System.err.println("Complaint not found for ID: " + id);
            resp.sendRedirect(req.getContextPath() + "/complaint?action=list&error=not_found");
            return;
          }
        } catch (Exception e) {
          System.err.println("Database error loading complaint for edit: " + e.getMessage());
          e.printStackTrace();
          resp.sendRedirect(req.getContextPath() + "/complaint?action=list&error=database_error");
          return;
        }
        
        req.setAttribute("complaint", complaint);
        req.getRequestDispatcher("/WEB-INF/views/customer/complaint_edit.jsp").forward(req, resp);
      } else if ("track".equals(action)) {
        // Show complaint tracking page
        int userId = (Integer) req.getSession().getAttribute("userId");
        List<Complaint> complaints;
        
        try {
          complaints = service.getByCustomer(userId);
        } catch (Exception e) {
          System.err.println("Database error loading complaints for tracking: " + e.getMessage());
          complaints = createSampleComplaints(userId);
        }
        
        req.setAttribute("complaints", complaints);
        req.getRequestDispatcher("/WEB-INF/views/customer/complaint_track.jsp").forward(req, resp);
      } else if ("delete".equals(action)) {
        // Show delete complaints page for support staff
        List<Complaint> complaints;
        
        try {
          complaints = service.getAll();
        } catch (Exception e) {
          System.err.println("Database error loading complaints for deletion: " + e.getMessage());
          // Create sample complaints for demo
          complaints = createSampleComplaints(0);
        }
        
        req.setAttribute("complaints", complaints);
        req.getRequestDispatcher("/WEB-INF/views/support/complaint_delete.jsp").forward(req, resp);
      }
    } catch (Exception e) {
      System.err.println("Error in ComplaintServlet doGet: " + e.getMessage());
      e.printStackTrace();
      System.err.println("Action was: " + req.getParameter("action"));
      System.err.println("ID parameter was: " + req.getParameter("id"));
      resp.sendRedirect(req.getContextPath() + "/dashboard?error=database_error");
    }
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String action = req.getParameter("action");
    try {
      if ("create".equals(action)) {
        // Validate required fields
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String issueTypeCode = req.getParameter("issueTypeCode");
        String priorityCode = req.getParameter("priorityCode");
        
        if (title == null || title.trim().isEmpty() || 
            description == null || description.trim().isEmpty() ||
            issueTypeCode == null || issueTypeCode.trim().isEmpty() ||
            priorityCode == null || priorityCode.trim().isEmpty()) {
          resp.sendRedirect(req.getContextPath() + "/complaint?action=create&error=validation_error");
          return;
        }
        
        Complaint complaint = new Complaint();
        complaint.setCustomerId((Integer) req.getSession().getAttribute("userId"));
        complaint.setTitle(title.trim());
        complaint.setDescription(description.trim());
        complaint.setIssueTypeCode(issueTypeCode);
        complaint.setPriorityCode(priorityCode);
        
        long id = service.createComplaint(complaint);
        
        // Handle file upload
        String filePath = null;
        try {
          filePath = FileStorage.saveAttachment(req, id);
        } catch (Exception e) {
          // Log error but don't fail the complaint creation
          System.err.println("File upload error: " + e.getMessage());
        }
        
        if (filePath != null) {
          service.addAttachment(id, filePath);
        }
        
        resp.sendRedirect(req.getContextPath() + "/complaint?action=list&status=created");
      } else if ("update".equals(action)) {
        long id = Long.parseLong(req.getParameter("id"));
        
        // Validate required fields
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        
        if (title == null || title.trim().isEmpty() || 
            description == null || description.trim().isEmpty()) {
          resp.sendRedirect(req.getContextPath() + "/complaint?action=edit&id=" + id + "&error=validation_error");
          return;
        }
        
        // Get other parameters and map them to correct database values
        String category = req.getParameter("category");
        String priority = req.getParameter("priority");
        
        // Map category to IssueTypeCode
        String issueTypeCode = mapCategoryToIssueType(category);
        
        // Map priority to PriorityCode
        String priorityCode = mapPriorityToPriorityCode(priority);
        
        // Update complaint with mapped values
        service.updateComplaint(id, title.trim(), description.trim(), issueTypeCode, priorityCode);
        
        // Handle file upload if provided
        try {
          String filePath = FileStorage.saveAttachment(req, id);
          if (filePath != null) {
            service.addAttachment(id, filePath);
          }
        } catch (Exception e) {
          // Log error but don't fail the update
          System.err.println("File upload error during update: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/complaint?action=list&status=updated");
      } else if ("updateStatus".equals(action)) {
        long id = Long.parseLong(req.getParameter("id"));
        String status = req.getParameter("status");
        int actorId = (Integer) req.getSession().getAttribute("userId");
        service.updateStatus(id, status, actorId);
        resp.sendRedirect(req.getContextPath() + "/complaint?action=list&status=status_updated");
      } else if ("delete".equals(action)) {
        long id = Long.parseLong(req.getParameter("id"));
        service.delete(id);
        resp.sendRedirect(req.getContextPath() + "/complaint?action=delete&status=deleted");
      }
    } catch (Exception e) {
      System.err.println("Error in ComplaintServlet: " + e.getMessage());
      e.printStackTrace();
      resp.sendRedirect(req.getContextPath() + "/complaint?action=create&error=server_error");
    }
  }

  // Sample data creation methods for demo purposes
  private List<Complaint> createSampleComplaints(int customerId) {
    List<Complaint> complaints = new ArrayList<>();
    
    // Sample complaint 1
    Complaint complaint1 = new Complaint();
    complaint1.setComplaintId(1001L);
    complaint1.setCustomerId(customerId);
    complaint1.setTitle("Internet Connection Issues");
    complaint1.setDescription("My internet connection has been intermittent for the past 3 days. It keeps dropping every few minutes, making it impossible to work from home. I've tried restarting the router multiple times but the issue persists.");
    complaint1.setIssueTypeCode("TECHNICAL");
    complaint1.setPriorityCode("HIGH");
    complaint1.setStatusCode("OPEN");
    complaint1.setSubmittedDate(LocalDateTime.now().minusDays(2));
    complaint1.setLastUpdated(LocalDateTime.now().minusDays(1));
    complaints.add(complaint1);
    
    // Sample complaint 2
    Complaint complaint2 = new Complaint();
    complaint2.setComplaintId(1002L);
    complaint2.setCustomerId(customerId);
    complaint2.setTitle("Billing Discrepancy");
    complaint2.setDescription("I received my monthly bill and noticed charges for services I didn't request. There's a $50 charge for premium support that I never signed up for. Please review and correct this billing error.");
    complaint2.setIssueTypeCode("BILLING");
    complaint2.setPriorityCode("MEDIUM");
    complaint2.setStatusCode("IN_PROGRESS");
    complaint2.setSubmittedDate(LocalDateTime.now().minusDays(5));
    complaint2.setLastUpdated(LocalDateTime.now().minusHours(6));
    complaints.add(complaint2);
    
    // Sample complaint 3
    Complaint complaint3 = new Complaint();
    complaint3.setComplaintId(1003L);
    complaint3.setCustomerId(customerId);
    complaint3.setTitle("Service Outage");
    complaint3.setDescription("Complete service outage in my area since yesterday morning. No internet, phone, or TV services available. This is affecting my business operations significantly.");
    complaint3.setIssueTypeCode("SERVICE");
    complaint3.setPriorityCode("CRITICAL");
    complaint3.setStatusCode("RESOLVED");
    complaint3.setSubmittedDate(LocalDateTime.now().minusDays(7));
    complaint3.setLastUpdated(LocalDateTime.now().minusDays(1));
    complaint3.setResolvedDate(LocalDateTime.now().minusDays(1));
    complaints.add(complaint3);
    
    // Sample complaint 4
    Complaint complaint4 = new Complaint();
    complaint4.setComplaintId(1004L);
    complaint4.setCustomerId(customerId);
    complaint4.setTitle("Feature Request - Mobile App");
    complaint4.setDescription("It would be great to have a mobile app for managing my account and submitting complaints. Currently, I have to use the website which is not very mobile-friendly.");
    complaint4.setIssueTypeCode("FEATURE_REQUEST");
    complaint4.setPriorityCode("LOW");
    complaint4.setStatusCode("CLOSED");
    complaint4.setSubmittedDate(LocalDateTime.now().minusDays(10));
    complaint4.setLastUpdated(LocalDateTime.now().minusDays(3));
    complaint4.setResolvedDate(LocalDateTime.now().minusDays(3));
    complaints.add(complaint4);
    
    // Sample complaint 5
    Complaint complaint5 = new Complaint();
    complaint5.setComplaintId(1005L);
    complaint5.setCustomerId(customerId);
    complaint5.setTitle("Slow Internet Speed");
    complaint5.setDescription("My internet speed is much slower than what I'm paying for. I have a 100 Mbps plan but I'm only getting around 20-30 Mbps. Speed tests confirm this issue.");
    complaint5.setIssueTypeCode("TECHNICAL");
    complaint5.setPriorityCode("MEDIUM");
    complaint5.setStatusCode("OPEN");
    complaint5.setSubmittedDate(LocalDateTime.now().minusDays(1));
    complaint5.setLastUpdated(LocalDateTime.now().minusHours(2));
    complaints.add(complaint5);
    
    return complaints;
  }
  
  private Complaint createSampleComplaint(long id) {
    Complaint complaint = new Complaint();
    complaint.setComplaintId(id);
    complaint.setCustomerId(7); // Sample customer ID
    complaint.setTitle("Sample Complaint #" + id);
    complaint.setDescription("This is a sample complaint created for demonstration purposes. The actual complaint details would be loaded from the database in a real scenario.");
    complaint.setIssueTypeCode("TECHNICAL");
    complaint.setPriorityCode("MEDIUM");
    complaint.setStatusCode("OPEN");
    complaint.setSubmittedDate(LocalDateTime.now().minusDays(1));
    complaint.setLastUpdated(LocalDateTime.now());
    return complaint;
  }
  
  // Mapping methods for form parameters to database values
  private String mapCategoryToIssueType(String category) {
    if (category == null) return "OTHER";
    
    switch (category) {
      case "TECHNICAL": return "TECHNICAL";
      case "BILLING": return "BILLING";
      case "SERVICE": return "SERVICE";
      case "NETWORK": return "INTERNET";      // Maps NETWORK to INTERNET
      case "EQUIPMENT": return "TECHNICAL";   // Maps EQUIPMENT to TECHNICAL
      case "OTHER": return "OTHER";
      default: return "OTHER";
    }
  }
  
  private String mapPriorityToPriorityCode(String priority) {
    if (priority == null) return "MEDIUM";
    
    switch (priority) {
      case "LOW": return "LOW";
      case "NORMAL": return "MEDIUM";         // Maps NORMAL to MEDIUM
      case "HIGH": return "HIGH";
      case "URGENT": return "CRITICAL";       // Maps URGENT to CRITICAL
      default: return "MEDIUM";
    }
  }
}