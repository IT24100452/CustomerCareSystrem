package lk.smartlanka.ccs.model;

import java.time.LocalDateTime;

public class PasswordResetToken {
    private int tokenId;
    private int userId;
    private String token;
    private String email;
    private LocalDateTime createdAt;
    private LocalDateTime expiresAt;
    private boolean used;
    
    // Constructors
    public PasswordResetToken() {}
    
    public PasswordResetToken(int userId, String token, String email) {
        this.userId = userId;
        this.token = token;
        this.email = email;
        this.createdAt = LocalDateTime.now();
        this.expiresAt = LocalDateTime.now().plusMinutes(15); // 15 minutes expiry
        this.used = false;
    }
    
    // Getters and Setters
    public int getTokenId() { return tokenId; }
    public void setTokenId(int tokenId) { this.tokenId = tokenId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getExpiresAt() { return expiresAt; }
    public void setExpiresAt(LocalDateTime expiresAt) { this.expiresAt = expiresAt; }
    
    public boolean isUsed() { return used; }
    public void setUsed(boolean used) { this.used = used; }
    
    // Helper methods
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiresAt);
    }
    
    public boolean isValid() {
        return !used && !isExpired();
    }
}



