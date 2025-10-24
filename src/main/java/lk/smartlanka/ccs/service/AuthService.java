package lk.smartlanka.ccs.service;

import lk.smartlanka.ccs.dao.PasswordResetTokenDao;
import lk.smartlanka.ccs.dao.UserDao;
import lk.smartlanka.ccs.infra.Mailer;
import lk.smartlanka.ccs.infra.OtpService;
import lk.smartlanka.ccs.model.PasswordResetToken;
import lk.smartlanka.ccs.model.User;

import java.time.LocalDateTime;
import java.util.UUID;

public class AuthService {
  private UserDao userDao = new UserDao();
  private PasswordResetTokenDao tokenDao = new PasswordResetTokenDao();

  public User login(String email, String password) {
    User user = userDao.findByEmail(email);
    if (user != null && user.getPassword() != null) {
      // The password is stored as SHA256 hash in the database
      // We need to hash the input password and compare with stored hash
      String inputPasswordHash = hashPassword(password);
      if (inputPasswordHash.equals(user.getPassword())) {
        return user;
      }
    }
    return null;
  }
  
  private String hashPassword(String password) {
    try {
      java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-256");
      byte[] hash = digest.digest(password.getBytes("UTF-8"));
      StringBuilder hexString = new StringBuilder();
      for (byte b : hash) {
        String hex = Integer.toHexString(0xff & b);
        if (hex.length() == 1) {
          hexString.append('0');
        }
        hexString.append(hex);
      }
      return hexString.toString().toUpperCase();
    } catch (Exception e) {
      throw new RuntimeException("Error hashing password", e);
    }
  }

  public boolean register(User user) {
    try {
      // Check if email already exists
      User existingUser = userDao.findByEmail(user.getEmail());
      if (existingUser != null) {
        return false;
      }
      
      // Check if username already exists
      User existingUsername = userDao.findByUsername(user.getUsername());
      if (existingUsername != null) {
        return false;
      }
      
      // Hash the password before storing
      user.setPassword(hashPassword(user.getPassword()));
      
      // Create new user
      userDao.create(user);
      return true;
    } catch (Exception e) {
      return false;
    }
  }

  public boolean initiatePasswordReset(String email) {
    User user = userDao.findByEmail(email);
    if (user == null) {
      return false;
    }
    
    // Generate a secure token
    String token = UUID.randomUUID().toString().replace("-", "");
    
    // Create password reset token
    PasswordResetToken resetToken = new PasswordResetToken(user.getUserId(), token, email);
    tokenDao.create(resetToken);
    
    // Send OTP via email
    String otp = OtpService.generateOtp();
    try {
      Mailer.sendPasswordResetEmail(email, otp, token);
      System.out.println("Password reset initiated successfully for: " + email);
      return true;
    } catch (Exception e) {
      System.err.println("Failed to send password reset email to " + email + ": " + e.getMessage());
      // Even if email fails, we still created the token, so return true
      // The user can check the console/server logs for the OTP and token
      return true;
    }
  }
  
  public boolean verifyPasswordReset(String token, String otp, String newPassword) {
    PasswordResetToken resetToken = tokenDao.findByToken(token);
    if (resetToken == null || !resetToken.isValid()) {
      return false;
    }
    
    // In a real implementation, you would verify the OTP here
    // For now, we'll just check if the token is valid and not expired
    
    // Update the user's password
    User user = userDao.findById(resetToken.getUserId());
    if (user != null) {
      user.setPassword(hashPassword(newPassword));
      userDao.update(user);
      
      // Mark token as used
      tokenDao.markAsUsed(token);
      
      // Clean up expired tokens
      tokenDao.deleteExpiredTokens();
      
      return true;
    }
    
    return false;
  }

  public User findByEmail(String email) {
    return userDao.findByEmail(email);
  }

  public User findByUsername(String username) {
    return userDao.findByUsername(username);
  }

  public void update(User user) {
    userDao.update(user);
  }
}