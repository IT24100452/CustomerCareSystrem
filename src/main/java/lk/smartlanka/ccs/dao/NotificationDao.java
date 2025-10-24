package lk.smartlanka.ccs.dao;

import lk.smartlanka.ccs.infra.DataSourceProvider;
import lk.smartlanka.ccs.model.Notification;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDao {
    private final DataSource dataSource = DataSourceProvider.getDataSource();
    
    public void create(Notification notification) {
        String sql = "INSERT INTO notifications (user_id, title, message, type, is_read, created_at, " +
                    "related_entity_type, related_entity_id, action_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, notification.getUserId());
            stmt.setString(2, notification.getTitle());
            stmt.setString(3, notification.getMessage());
            stmt.setString(4, notification.getType());
            stmt.setBoolean(5, notification.isRead());
            stmt.setTimestamp(6, Timestamp.valueOf(notification.getCreatedAt()));
            stmt.setString(7, notification.getRelatedEntityType());
            if (notification.getRelatedEntityId() == 0) {
                stmt.setNull(8, Types.BIGINT);
            } else {
                stmt.setLong(8, notification.getRelatedEntityId());
            }
            stmt.setString(9, notification.getActionUrl());
            
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    notification.setNotificationId(rs.getLong(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating notification", e);
        }
    }
    
    public List<Notification> getByUserId(int userId) {
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
        List<Notification> notifications = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error fetching notifications for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error fetching notifications for user", e);
        }
        
        return notifications;
    }
    
    public List<Notification> getUnreadByUserId(int userId) {
        String sql = "SELECT * FROM notifications WHERE user_id = ? AND is_read = false ORDER BY created_at DESC";
        List<Notification> notifications = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching unread notifications", e);
        }
        
        return notifications;
    }
    
    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = false";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting unread count", e);
        }
        
        return 0;
    }
    
    public void markAsRead(long notificationId) {
        String sql = "UPDATE notifications SET is_read = true WHERE notification_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, notificationId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error marking notification as read", e);
        }
    }
    
    public void markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = true WHERE user_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error marking all notifications as read", e);
        }
    }
    
    public void delete(long notificationId) {
        String sql = "DELETE FROM notifications WHERE notification_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, notificationId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting notification", e);
        }
    }
    
    public void deleteOldNotifications(int daysOld) {
        String sql = "DELETE FROM notifications WHERE created_at < DATE_SUB(NOW(), INTERVAL ? DAY)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, daysOld);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting old notifications", e);
        }
    }
    
    // Enhanced methods for bulk operations
    public List<Integer> getAllUserIds() {
        String sql = "SELECT DISTINCT UserID FROM UserTable WHERE UserID IS NOT NULL";
        List<Integer> userIds = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                userIds.add(rs.getInt("UserID"));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting all user IDs", e);
        }
        
        return userIds;
    }
    
    public List<Integer> getUserIdsByRole(int roleId) {
        String sql = "SELECT UserID FROM UserTable WHERE RoleID = ?";
        List<Integer> userIds = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roleId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    userIds.add(rs.getInt("UserID"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting user IDs by role", e);
        }
        
        return userIds;
    }
    
    public List<Notification> getNotificationsByType(String type) {
        String sql = "SELECT * FROM notifications WHERE type = ? ORDER BY created_at DESC";
        List<Notification> notifications = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, type);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching notifications by type", e);
        }
        
        return notifications;
    }
    
    public List<Notification> getRecentNotifications(int userId, int limit) {
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
        List<Notification> notifications = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching recent notifications", e);
        }
        
        return notifications;
    }
    
    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setNotificationId(rs.getLong("notification_id"));
        notification.setUserId(rs.getInt("user_id"));
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        notification.setType(rs.getString("type"));
        notification.setRead(rs.getBoolean("is_read"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            notification.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        notification.setRelatedEntityType(rs.getString("related_entity_type"));
        long relatedEntityId = rs.getLong("related_entity_id");
        notification.setRelatedEntityId(rs.wasNull() ? 0 : relatedEntityId);
        notification.setActionUrl(rs.getString("action_url"));
        
        return notification;
    }
    
    /**
     * Get all notifications for admin users
     */
    public List<Notification> getAllNotifications() {
        String sql = "SELECT * FROM notifications ORDER BY created_at DESC";
        List<Notification> notifications = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error fetching all notifications: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error fetching all notifications", e);
        }
        
        return notifications;
    }
    
    /**
     * Get all unread notifications for admin users
     */
    public List<Notification> getAllUnreadNotifications() {
        String sql = "SELECT * FROM notifications WHERE is_read = false ORDER BY created_at DESC";
        List<Notification> notifications = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error fetching all unread notifications: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error fetching all unread notifications", e);
        }
        
        return notifications;
    }
}





