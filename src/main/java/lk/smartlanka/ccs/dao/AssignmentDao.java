package lk.smartlanka.ccs.dao;

import lk.smartlanka.ccs.infra.DataSourceProvider;
import lk.smartlanka.ccs.model.Assignment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class AssignmentDao {
    public void create(Assignment assignment) {
        System.out.println("DEBUG: AssignmentDao.create called with complaint ID: " + assignment.getComplaintId());
        
        // First, verify the complaint exists
        if (!complaintExists(assignment.getComplaintId())) {
            System.out.println("DEBUG: Complaint ID " + assignment.getComplaintId() + " does not exist in database");
            throw new IllegalArgumentException("Cannot assign complaint - Complaint ID " + assignment.getComplaintId() + " does not exist");
        }
        
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_AssignComplaint(?, ?, ?, ?, ?)}")) {
            
            System.out.println("DEBUG: Executing stored procedure with parameters:");
            System.out.println("  ComplaintID: " + assignment.getComplaintId());
            System.out.println("  AssignedTo: " + assignment.getAssignedTo());
            System.out.println("  AssignedBy: " + assignment.getAssignedBy());
            System.out.println("  Deadline: " + assignment.getDeadline());
            System.out.println("  Notes: " + assignment.getNotes());
            
            cs.setLong(1, assignment.getComplaintId());
            cs.setInt(2, assignment.getAssignedTo());
            cs.setInt(3, assignment.getAssignedBy());
            cs.setTimestamp(4, assignment.getDeadline());
            cs.setString(5, assignment.getNotes());
            cs.execute();
            
            System.out.println("DEBUG: Assignment created successfully in database");
        } catch (SQLException e) {
            System.err.println("DEBUG: SQL Error creating assignment: " + e.getMessage());
            if (e.getMessage().contains("foreign key constraint")) {
                throw new IllegalArgumentException("Cannot assign complaint - the complaint ID " + assignment.getComplaintId() + " does not exist in the database", e);
            }
            throw new RuntimeException("Failed to create assignment: " + e.getMessage(), e);
        }
    }
    
    private boolean complaintExists(long complaintId) {
        String sql = "SELECT COUNT(*) FROM Complaint WHERE ComplaintID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, complaintId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("DEBUG: Complaint ID " + complaintId + " exists check: " + (count > 0) + " (count: " + count + ")");
                    return count > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("DEBUG: Error checking if complaint exists: " + e.getMessage());
        }
        return false;
    }

    public void update(Assignment assignment) {
        String sql = "UPDATE Assignment SET AssignedTo = ?, Deadline = ?, Notes = ?, UpdatedAt = NOW() WHERE AssignmentID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assignment.getAssignedTo());
            ps.setTimestamp(2, assignment.getDeadline());
            ps.setString(3, assignment.getNotes());
            ps.setLong(4, assignment.getAssignmentId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update assignment", e);
        }
    }

    public void delete(long id) {
        String sql = "DELETE FROM Assignment WHERE AssignmentID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete assignment", e);
        }
    }

    public List<Assignment> getByComplaint(long complaintId) {
        List<Assignment> assignments = new ArrayList<>();
        String sql = "SELECT * FROM Assignment WHERE ComplaintID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, complaintId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Assignment assignment = new Assignment();
                    assignment.setAssignmentId(rs.getLong("AssignmentID"));
                    assignment.setComplaintId(rs.getLong("ComplaintID"));
                    assignment.setAssignedTo(rs.getInt("AssignedTo"));
                    assignment.setAssignedBy(rs.getInt("AssignedBy"));
                    assignment.setDeadline(rs.getTimestamp("Deadline"));
                    assignment.setNotes(rs.getString("Notes"));
                    assignment.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    assignments.add(assignment);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get assignments by complaint", e);
        }
        return assignments;
    }

}