package lk.smartlanka.ccs.dao;

import lk.smartlanka.ccs.infra.DataSourceProvider;
import lk.smartlanka.ccs.model.Complaint;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDao {
    public long create(Complaint complaint) {
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_CreateComplaint(?, ?, ?, ?, ?, ?)}")) {
            cs.setInt(1, complaint.getCustomerId());
            cs.setString(2, complaint.getTitle());
            cs.setString(3, complaint.getDescription());
            cs.setString(4, complaint.getIssueTypeCode());
            cs.setString(5, complaint.getPriorityCode());
            cs.registerOutParameter(6, Types.BIGINT);
            cs.execute();
            return cs.getLong(6);
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create complaint", e);
        }
    }

    public void update(long id, String description, String priorityCode) {
        String sql = "UPDATE Complaint SET Description = ?, PriorityCode = ?, LastUpdated = CURRENT_TIMESTAMP WHERE ComplaintID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, description);
            ps.setString(2, priorityCode);
            ps.setLong(3, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update complaint", e);
        }
    }

    public void updateComplaint(long id, String title, String description, String category, String priority) {
        String sql = "UPDATE Complaint SET Title = ?, Description = ?, IssueTypeCode = ?, PriorityCode = ?, LastUpdated = CURRENT_TIMESTAMP WHERE ComplaintID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, category);
            ps.setString(4, priority);
            ps.setLong(5, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update complaint", e);
        }
    }

    public void updateStatus(long id, String statusCode, int actorUserId) {
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_UpdateComplaintStatus(?, ?, ?)}")) {
            cs.setLong(1, id);
            cs.setString(2, statusCode);
            cs.setInt(3, actorUserId);
            cs.execute();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update complaint status", e);
        }
    }

    public void delete(long id) {
        String sql = "DELETE FROM Complaint WHERE ComplaintID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete complaint", e);
        }
    }

    public Complaint getById(long id) {
        String sql = "SELECT * FROM Complaint WHERE ComplaintID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapToComplaint(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Database error in getById for ID " + id + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get complaint by ID", e);
        }
        return null;
    }

    public List<Complaint> getByCustomer(int customerId) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM Complaint WHERE CustomerID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapToComplaint(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get complaints by customer", e);
        }
        return complaints;
    }

    public List<Complaint> getAll() {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM Complaint";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                complaints.add(mapToComplaint(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get all complaints", e);
        }
        return complaints;
    }

    public void addAttachment(long complaintId, String filePath) {
        String sql = "INSERT INTO Attachment (ComplaintID, FileName, FileType, FilePath) VALUES (?, ?, ?, ?)";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, complaintId);
            ps.setString(2, new java.io.File(filePath).getName());
            ps.setString(3, "application/octet-stream"); // Default
            ps.setString(4, filePath);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to add attachment", e);
        }
    }

    private Complaint mapToComplaint(ResultSet rs) throws SQLException {
        Complaint complaint = new Complaint();
        complaint.setComplaintId(rs.getLong("ComplaintID"));
        complaint.setCustomerId(rs.getInt("CustomerID"));
        complaint.setTitle(rs.getString("Title"));
        complaint.setDescription(rs.getString("Description"));
        complaint.setIssueTypeCode(rs.getString("IssueTypeCode"));
        complaint.setPriorityCode(rs.getString("PriorityCode"));
        complaint.setStatusCode(rs.getString("StatusCode"));
        
        Timestamp submittedDate = rs.getTimestamp("SubmittedDate");
        if (submittedDate != null) {
            complaint.setSubmittedDate(submittedDate.toLocalDateTime());
        }
        
        Timestamp lastUpdated = rs.getTimestamp("LastUpdated");
        if (lastUpdated != null) {
            complaint.setLastUpdated(lastUpdated.toLocalDateTime());
        }
        
        Timestamp resolvedDate = rs.getTimestamp("ResolvedDate");
        if (resolvedDate != null) {
            complaint.setResolvedDate(resolvedDate.toLocalDateTime());
        }
        
        // Set default values for fields not in database
        complaint.setAssignedTo(0); // Default to 0 (not assigned)
        complaint.setResolution(null); // Default to null
        complaint.setAssigneeId(0); // Default to 0
        
        return complaint;
    }
}