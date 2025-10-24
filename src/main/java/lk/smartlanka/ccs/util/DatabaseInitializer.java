package lk.smartlanka.ccs.util;

import lk.smartlanka.ccs.dao.ComplaintDao;
import lk.smartlanka.ccs.model.Complaint;
import lk.smartlanka.ccs.service.ComplaintService;

import java.time.LocalDateTime;
import java.util.List;

public class DatabaseInitializer {
    
    public static void ensureSampleComplaints() {
        try {
            ComplaintService complaintService = new ComplaintService();
            List<Complaint> existingComplaints = complaintService.getAll();
            
            System.out.println("DEBUG: Found " + existingComplaints.size() + " existing complaints in database");
            
            if (existingComplaints.isEmpty()) {
                System.out.println("DEBUG: No complaints found, creating sample complaints...");
                createSampleComplaints(complaintService);
            } else {
                System.out.println("DEBUG: Complaints already exist:");
                for (Complaint c : existingComplaints) {
                    System.out.println("  - ID: " + c.getComplaintId() + ", Title: " + c.getTitle() + ", Status: " + c.getStatusCode());
                }
            }
        } catch (Exception e) {
            System.err.println("Error checking/creating sample complaints: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void createSampleComplaints(ComplaintService complaintService) {
        try {
            System.out.println("DEBUG: Creating sample complaints using direct SQL insert...");
            
            // Use direct SQL insert to bypass stored procedure issues
            createComplaintDirectly(1, "Internet Connection Issues", 
                "Customer experiencing intermittent internet connectivity problems affecting work from home setup.", 
                "TECHNICAL", "HIGH");
            
            createComplaintDirectly(2, "Billing Discrepancy", 
                "Customer found unauthorized charges on monthly bill for premium support services.", 
                "BILLING", "MEDIUM");
            
            createComplaintDirectly(3, "Slow Internet Speed", 
                "Customer reporting significantly slower internet speeds than advertised plan.", 
                "TECHNICAL", "MEDIUM");
            
            System.out.println("Successfully created 3 sample complaints using direct SQL");
            
        } catch (Exception e) {
            System.err.println("Error creating sample complaints: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void createComplaintDirectly(int customerId, String title, String description, String issueType, String priority) {
        String sql = "INSERT INTO Complaint (CustomerID, Title, Description, IssueTypeCode, PriorityCode, StatusCode, SubmittedDate, LastUpdated) " +
                    "VALUES (?, ?, ?, ?, ?, 'OPEN', NOW(), NOW())";
        
        try (java.sql.Connection conn = lk.smartlanka.ccs.infra.DataSourceProvider.getDataSource().getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, customerId);
            ps.setString(2, title);
            ps.setString(3, description);
            ps.setString(4, issueType);
            ps.setString(5, priority);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (java.sql.ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        long complaintId = generatedKeys.getLong(1);
                        System.out.println("Created complaint with ID: " + complaintId + " - " + title);
                    }
                }
            }
            
        } catch (java.sql.SQLException e) {
            System.err.println("Error creating complaint directly: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
