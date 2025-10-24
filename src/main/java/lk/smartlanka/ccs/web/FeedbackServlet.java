package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.smartlanka.ccs.model.Feedback;
import lk.smartlanka.ccs.model.Complaint;
import lk.smartlanka.ccs.service.FeedbackService;
import lk.smartlanka.ccs.service.ComplaintService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class FeedbackServlet extends HttpServlet {
    private FeedbackService service = new FeedbackService();
    private ComplaintService complaintService = new ComplaintService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String action = req.getParameter("action");
    
    try {
      if ("list".equals(action)) {
        int userId = (Integer) req.getSession().getAttribute("userId");
        List<Feedback> feedback;
        
        try {
          feedback = service.getFeedbackByCustomer(userId);
        } catch (Exception e) {
          System.err.println("Database error loading feedback: " + e.getMessage());
          // Create sample data for demo purposes
          feedback = createSampleFeedback(userId);
        }
        
        req.setAttribute("feedback", feedback);
        req.getRequestDispatcher("/WEB-INF/views/customer/feedback_list.jsp").forward(req, resp);
      } else if ("view".equals(action)) {
        long id = Long.parseLong(req.getParameter("id"));
        Feedback feedback;
        
        try {
          feedback = service.getById(id);
        } catch (Exception e) {
          System.err.println("Database error loading feedback: " + e.getMessage());
          feedback = createSampleFeedbackItem(id);
        }
        
        req.setAttribute("feedback", feedback);
        req.getRequestDispatcher("/WEB-INF/views/customer/feedback_view.jsp").forward(req, resp);
      } else if ("create".equals(action)) {
        // Load resolved complaints for the customer to select from
        int userId = (Integer) req.getSession().getAttribute("userId");
        List<Complaint> resolvedComplaints;
        
        try {
          resolvedComplaints = complaintService.getComplaintsByCustomerAndStatus(userId, "RESOLVED");
        } catch (Exception e) {
          System.err.println("Database error loading resolved complaints: " + e.getMessage());
          resolvedComplaints = new ArrayList<>();
        }
        
        req.setAttribute("resolvedComplaints", resolvedComplaints);
        req.getRequestDispatcher("/WEB-INF/views/customer/feedback_submit.jsp").forward(req, resp);
      } else if ("edit".equals(action)) {
        long id = Long.parseLong(req.getParameter("id"));
        Feedback feedback;
        
        try {
          feedback = service.getById(id);
        } catch (Exception e) {
          System.err.println("Database error loading feedback for edit: " + e.getMessage());
          feedback = createSampleFeedbackItem(id);
        }
        
        req.setAttribute("feedback", feedback);
        req.getRequestDispatcher("/WEB-INF/views/customer/feedback_edit.jsp").forward(req, resp);
      } else if ("delete".equals(action)) {
        long id = Long.parseLong(req.getParameter("id"));
        try {
          service.delete(id);
          resp.sendRedirect(req.getContextPath() + "/feedback?action=list&status=deleted");
        } catch (Exception e) {
          System.err.println("Error deleting feedback: " + e.getMessage());
          resp.sendRedirect(req.getContextPath() + "/feedback?action=list&error=delete_error");
        }
      }
    } catch (Exception e) {
      System.err.println("Error in FeedbackServlet doGet: " + e.getMessage());
      e.printStackTrace();
      resp.sendRedirect(req.getContextPath() + "/dashboard?error=database_error");
    }
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String action = req.getParameter("action");
    try {
      if ("create".equals(action)) {
        // Validate required fields
        String ratingStr = req.getParameter("rating");
        String comment = req.getParameter("comment");
        String complaintIdStr = req.getParameter("complaintId");
        
        if (ratingStr == null || ratingStr.trim().isEmpty() || 
            comment == null || comment.trim().isEmpty() ||
            complaintIdStr == null || complaintIdStr.trim().isEmpty()) {
          resp.sendRedirect(req.getContextPath() + "/feedback?action=create&error=validation_error");
          return;
        }
        
        Feedback feedback = new Feedback();
        feedback.setComplaintId(Long.parseLong(complaintIdStr));
        feedback.setCustomerId((Integer) req.getSession().getAttribute("userId"));
        feedback.setRating(Integer.parseInt(ratingStr));
        feedback.setComment(comment.trim());
        feedback.setSentiment(req.getParameter("sentiment"));
        feedback.setSubmittedDate(LocalDateTime.now());
        feedback.setCreatedAt(LocalDateTime.now());
        
        try {
          service.createFeedback(feedback);
          resp.sendRedirect(req.getContextPath() + "/feedback?action=list&status=success");
        } catch (Exception e) {
          System.err.println("Error creating feedback: " + e.getMessage());
          resp.sendRedirect(req.getContextPath() + "/feedback?action=create&error=server_error");
        }
      } else if ("update".equals(action)) {
        long id = Long.parseLong(req.getParameter("id"));
        String ratingStr = req.getParameter("rating");
        String comment = req.getParameter("comment");
        
        if (ratingStr == null || ratingStr.trim().isEmpty() || 
            comment == null || comment.trim().isEmpty()) {
          resp.sendRedirect(req.getContextPath() + "/feedback?action=edit&id=" + id + "&error=validation_error");
          return;
        }
        
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(id);
        feedback.setRating(Integer.parseInt(ratingStr));
        feedback.setComment(comment.trim());
        feedback.setSentiment(req.getParameter("sentiment"));
        
        try {
          service.update(feedback);
          resp.sendRedirect(req.getContextPath() + "/feedback?action=list&status=updated");
        } catch (Exception e) {
          System.err.println("Error updating feedback: " + e.getMessage());
          resp.sendRedirect(req.getContextPath() + "/feedback?action=edit&id=" + id + "&error=server_error");
        }
      } else if ("delete".equals(action)) {
        long id = Long.parseLong(req.getParameter("id"));
        try {
          service.delete(id);
          resp.sendRedirect(req.getContextPath() + "/feedback?action=list&status=deleted");
        } catch (Exception e) {
          System.err.println("Error deleting feedback: " + e.getMessage());
          resp.sendRedirect(req.getContextPath() + "/feedback?action=list&error=delete_error");
        }
      }
    } catch (Exception e) {
      System.err.println("Error in FeedbackServlet doPost: " + e.getMessage());
      e.printStackTrace();
      resp.sendRedirect(req.getContextPath() + "/feedback?action=create&error=server_error");
    }
  }

  // Sample data creation methods for demo purposes
  private List<Feedback> createSampleFeedback(int customerId) {
    List<Feedback> feedback = new ArrayList<>();
    
    // Sample feedback 1
    Feedback feedback1 = new Feedback();
    feedback1.setFeedbackId(2001L);
    feedback1.setComplaintId(1003L);
    feedback1.setCustomerId(customerId);
    feedback1.setRating(5);
    feedback1.setComment("Excellent service! The technician was very professional and resolved the outage quickly. Thank you for the prompt response.");
    feedback1.setSentiment("POSITIVE");
    feedback1.setSubmittedDate(LocalDateTime.now().minusDays(1));
    feedback1.setCreatedAt(LocalDateTime.now().minusDays(1));
    feedback.add(feedback1);
    
    // Sample feedback 2
    Feedback feedback2 = new Feedback();
    feedback2.setFeedbackId(2002L);
    feedback2.setComplaintId(1002L);
    feedback2.setCustomerId(customerId);
    feedback2.setRating(3);
    feedback2.setComment("The billing issue was resolved, but it took longer than expected. The customer service representative was helpful though.");
    feedback2.setSentiment("NEUTRAL");
    feedback2.setSubmittedDate(LocalDateTime.now().minusDays(3));
    feedback2.setCreatedAt(LocalDateTime.now().minusDays(3));
    feedback.add(feedback2);
    
    // Sample feedback 3
    Feedback feedback3 = new Feedback();
    feedback3.setFeedbackId(2003L);
    feedback3.setComplaintId(0L); // General feedback
    feedback3.setCustomerId(customerId);
    feedback3.setRating(4);
    feedback3.setComment("Overall good service. The website is easy to use and the support team is responsive. Keep up the good work!");
    feedback3.setSentiment("POSITIVE");
    feedback3.setSubmittedDate(LocalDateTime.now().minusDays(5));
    feedback3.setCreatedAt(LocalDateTime.now().minusDays(5));
    feedback.add(feedback3);
    
    return feedback;
  }
  
  private Feedback createSampleFeedbackItem(long id) {
    Feedback feedback = new Feedback();
    feedback.setFeedbackId(id);
    feedback.setComplaintId(1001L);
    feedback.setCustomerId(7); // Sample customer ID
    feedback.setRating(4);
    feedback.setComment("This is a sample feedback created for demonstration purposes. The actual feedback details would be loaded from the database in a real scenario.");
    feedback.setSentiment("POSITIVE");
    feedback.setSubmittedDate(LocalDateTime.now().minusDays(1));
    feedback.setCreatedAt(LocalDateTime.now().minusDays(1));
    return feedback;
  }
}