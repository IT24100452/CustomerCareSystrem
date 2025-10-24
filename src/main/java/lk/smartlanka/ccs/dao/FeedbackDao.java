package lk.smartlanka.ccs.dao;

import lk.smartlanka.ccs.infra.DataSourceProvider;
import lk.smartlanka.ccs.model.Feedback;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDao {
    public void create(Feedback feedback) {
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_CreateFeedback(?, ?, ?, ?, ?)}")) {
            // Handle NULL ComplaintID for general feedback
            if (feedback.getComplaintId() == 0) {
                cs.setNull(1, Types.BIGINT);
            } else {
                cs.setLong(1, feedback.getComplaintId());
            }
            cs.setInt(2, feedback.getCustomerId());
            cs.setInt(3, feedback.getRating());
            cs.setString(4, feedback.getComment());
            cs.setString(5, feedback.getSentiment());
            cs.execute();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create feedback", e);
        }
    }

    public void update(Feedback feedback) {
        String sql = "UPDATE Feedback SET Rating = ?, Comment = ? WHERE FeedbackID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedback.getRating());
            ps.setString(2, feedback.getComment());
            ps.setLong(3, feedback.getFeedbackId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update feedback", e);
        }
    }

    public void delete(long id) {
        String sql = "DELETE FROM Feedback WHERE FeedbackID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete feedback", e);
        }
    }

    public Feedback getById(long id) {
        String sql = "SELECT * FROM Feedback WHERE FeedbackID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFeedback(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get feedback by ID", e);
        }
        return null;
    }

    public List<Feedback> getByComplaint(long complaintId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM Feedback WHERE ComplaintID = ? ORDER BY CreatedAt DESC";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, complaintId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    feedbacks.add(mapResultSetToFeedback(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get feedback by complaint", e);
        }
        return feedbacks;
    }

    public List<Feedback> getByCustomer(Integer customerId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM Feedback WHERE CustomerID = ? ORDER BY CreatedAt DESC";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    feedbacks.add(mapResultSetToFeedback(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get feedback by customer", e);
        }
        return feedbacks;
    }

    public List<Feedback> getAll() {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM Feedback";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                feedbacks.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get all feedback", e);
        }
        return feedbacks;
    }

    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(rs.getLong("FeedbackID"));
        // Handle NULL ComplaintID
        long complaintId = rs.getLong("ComplaintID");
        feedback.setComplaintId(rs.wasNull() ? 0 : complaintId);
        feedback.setCustomerId(rs.getInt("CustomerID"));
        feedback.setRating(rs.getInt("Rating"));
        feedback.setComment(rs.getString("Comment"));
        feedback.setSentiment(rs.getString("Sentiment"));
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        feedback.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
        feedback.setSubmittedDate(feedback.getCreatedAt());
        return feedback;
    }
}