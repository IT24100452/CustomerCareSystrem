package lk.smartlanka.ccs.dao;

import lk.smartlanka.ccs.infra.DataSourceProvider;
import lk.smartlanka.ccs.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {
  public void create(User user) {
    String sql = "INSERT INTO UserTable (Username, Email, PasswordHash, FirstName, LastName, PhoneNumber, RoleID, IsActive) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    try (Connection conn = DataSourceProvider.getDataSource().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
      ps.setString(1, user.getUsername());
      ps.setString(2, user.getEmail());
      
      // Convert hex string password hash back to binary for storage
      if (user.getPassword() != null) {
        byte[] passwordHash = hexStringToByteArray(user.getPassword());
        ps.setBytes(3, passwordHash);
      } else {
        ps.setBytes(3, null);
      }
      
      ps.setString(4, user.getFirstName());
      ps.setString(5, user.getLastName());
      ps.setString(6, user.getPhoneNumber());
      ps.setInt(7, user.getRoleId());
      ps.setBoolean(8, user.isActive());
      ps.executeUpdate();
      try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
        if (generatedKeys.next()) {
          user.setUserId(generatedKeys.getInt(1));
        }
      }
    } catch (SQLException e) {
      throw new RuntimeException("Failed to create user", e);
    }
  }

  public void update(User user) {
    StringBuilder sql = new StringBuilder("UPDATE UserTable SET Username = ?, Email = ?, FirstName = ?, LastName = ?, PhoneNumber = ?, RoleID = ?, IsActive = ?");
    if (user.getPassword() != null) {
      sql.append(", PasswordHash = ?");
    }
    sql.append(" WHERE UserID = ?");
    try (Connection conn = DataSourceProvider.getDataSource().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
      ps.setString(1, user.getUsername());
      ps.setString(2, user.getEmail());
      ps.setString(3, user.getFirstName());
      ps.setString(4, user.getLastName());
      ps.setString(5, user.getPhoneNumber());
      ps.setInt(6, user.getRoleId());
      ps.setBoolean(7, user.isActive());
      int index = 8;
      if (user.getPassword() != null) {
        // Convert hex string password hash back to binary for storage
        byte[] passwordHash = hexStringToByteArray(user.getPassword());
        ps.setBytes(index++, passwordHash);
      }
      ps.setInt(index, user.getUserId());
      ps.executeUpdate();
    } catch (SQLException e) {
      throw new RuntimeException("Failed to update user", e);
    }
  }

  public void delete(int id) {
    String sql = "DELETE FROM UserTable WHERE UserID = ?";
    try (Connection conn = DataSourceProvider.getDataSource().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, id);
      ps.executeUpdate();
    } catch (SQLException e) {
      throw new RuntimeException("Failed to delete user", e);
    }
  }

  public User findById(int id) {
    String sql = "SELECT * FROM UserTable WHERE UserID = ?";
    try (Connection conn = DataSourceProvider.getDataSource().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, id);
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          return mapToUser(rs);
        }
      }
    } catch (SQLException e) {
      throw new RuntimeException("Failed to find user by ID", e);
    }
    return null;
  }

  public User findByEmail(String email) {
    String sql = "SELECT * FROM UserTable WHERE Email = ?";
    try (Connection conn = DataSourceProvider.getDataSource().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, email);
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          return mapToUser(rs);
        }
      }
    } catch (SQLException e) {
      throw new RuntimeException("Failed to find user by email", e);
    }
    return null;
  }

  public User findByUsername(String username) {
    String sql = "SELECT * FROM UserTable WHERE Username = ?";
    try (Connection conn = DataSourceProvider.getDataSource().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, username);
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          return mapToUser(rs);
        }
      }
    } catch (SQLException e) {
      throw new RuntimeException("Failed to find user by username", e);
    }
    return null;
  }

  public List<User> getAll() {
    List<User> users = new ArrayList<>();
    String sql = "SELECT * FROM UserTable";
    try (Connection conn = DataSourceProvider.getDataSource().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        users.add(mapToUser(rs));
      }
    } catch (SQLException e) {
      throw new RuntimeException("Failed to get all users", e);
    }
    return users;
  }

  private User mapToUser(ResultSet rs) throws SQLException {
    User user = new User();
    user.setUserId(rs.getInt("UserID"));
    user.setUsername(rs.getString("Username"));
    user.setEmail(rs.getString("Email"));
    
    // Read password hash as binary data and convert to hex string
    byte[] passwordHash = rs.getBytes("PasswordHash");
    if (passwordHash != null) {
      StringBuilder hexString = new StringBuilder();
      for (byte b : passwordHash) {
        String hex = Integer.toHexString(0xff & b);
        if (hex.length() == 1) {
          hexString.append('0');
        }
        hexString.append(hex);
      }
      user.setPassword(hexString.toString().toUpperCase());
    }
    
    user.setFirstName(rs.getString("FirstName"));
    user.setLastName(rs.getString("LastName"));
    user.setPhoneNumber(rs.getString("PhoneNumber"));
    user.setRoleId(rs.getInt("RoleID"));
    user.setActive(rs.getBoolean("IsActive"));
    return user;
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
  
  private byte[] hexStringToByteArray(String hexString) {
    int len = hexString.length();
    byte[] data = new byte[len / 2];
    for (int i = 0; i < len; i += 2) {
      data[i / 2] = (byte) ((Character.digit(hexString.charAt(i), 16) << 4)
                           + Character.digit(hexString.charAt(i+1), 16));
    }
    return data;
  }
}