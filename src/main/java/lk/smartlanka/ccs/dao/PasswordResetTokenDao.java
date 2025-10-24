package lk.smartlanka.ccs.dao;

import lk.smartlanka.ccs.infra.DataSourceProvider;
import lk.smartlanka.ccs.model.PasswordResetToken;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PasswordResetTokenDao {
    
    public void create(PasswordResetToken token) {
        String sql = "INSERT INTO password_reset_tokens (user_id, token, email, created_at, expires_at, used) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, token.getUserId());
            ps.setString(2, token.getToken());
            ps.setString(3, token.getEmail());
            ps.setTimestamp(4, Timestamp.valueOf(token.getCreatedAt()));
            ps.setTimestamp(5, Timestamp.valueOf(token.getExpiresAt()));
            ps.setBoolean(6, token.isUsed());
            
            ps.executeUpdate();
            
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    token.setTokenId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create password reset token", e);
        }
    }
    
    public PasswordResetToken findByToken(String token) {
        String sql = "SELECT * FROM password_reset_tokens WHERE token = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, token);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapToToken(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find password reset token", e);
        }
        return null;
    }
    
    public List<PasswordResetToken> findByUserId(int userId) {
        String sql = "SELECT * FROM password_reset_tokens WHERE user_id = ? ORDER BY created_at DESC";
        List<PasswordResetToken> tokens = new ArrayList<>();
        
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tokens.add(mapToToken(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find password reset tokens for user", e);
        }
        return tokens;
    }
    
    public void markAsUsed(String token) {
        String sql = "UPDATE password_reset_tokens SET used = true WHERE token = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to mark token as used", e);
        }
    }
    
    public void deleteExpiredTokens() {
        String sql = "DELETE FROM password_reset_tokens WHERE expires_at < NOW()";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete expired tokens", e);
        }
    }
    
    private PasswordResetToken mapToToken(ResultSet rs) throws SQLException {
        PasswordResetToken token = new PasswordResetToken();
        token.setTokenId(rs.getInt("token_id"));
        token.setUserId(rs.getInt("user_id"));
        token.setToken(rs.getString("token"));
        token.setEmail(rs.getString("email"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        token.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
        
        Timestamp expiresAt = rs.getTimestamp("expires_at");
        token.setExpiresAt(expiresAt != null ? expiresAt.toLocalDateTime() : null);
        
        token.setUsed(rs.getBoolean("used"));
        return token;
    }
}



