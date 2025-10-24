package lk.smartlanka.ccs.model;

import java.time.LocalDateTime;

public class User {
  private int userId;
  private String username;
  private String email;
  private String password;
  private String firstName;
  private String lastName;
  private String phoneNumber;
  private int roleId;
  private boolean isActive;
  private LocalDateTime createdAt;
  private LocalDateTime lastLogin;
  private String department;
  private String employeeId;
  
  // Constructors
  public User() {}
  
  public User(String username, String email, String password, String firstName, String lastName, 
             String phoneNumber, int roleId, String department, String employeeId) {
    this.username = username;
    this.email = email;
    this.password = password;
    this.firstName = firstName;
    this.lastName = lastName;
    this.phoneNumber = phoneNumber;
    this.roleId = roleId;
    this.department = department;
    this.employeeId = employeeId;
    this.isActive = true;
    this.createdAt = LocalDateTime.now();
  }
  
  // Getters/Setters
  public int getUserId() { return userId; }
  public void setUserId(int userId) { this.userId = userId; }
  public String getUsername() { return username; }
  public void setUsername(String username) { this.username = username; }
  public String getEmail() { return email; }
  public void setEmail(String email) { this.email = email; }
  public String getPassword() { return password; }
  public void setPassword(String password) { this.password = password; }
  public String getFirstName() { return firstName; }
  public void setFirstName(String firstName) { this.firstName = firstName; }
  public String getLastName() { return lastName; }
  public void setLastName(String lastName) { this.lastName = lastName; }
  public String getPhoneNumber() { return phoneNumber; }
  public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
  public int getRoleId() { return roleId; }
  public void setRoleId(int roleId) { this.roleId = roleId; }
  public boolean isActive() { return isActive; }
  public void setActive(boolean active) { isActive = active; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

  public String getDepartment() { return department; }
  public void setDepartment(String department) { this.department = department; }
  public String getEmployeeId() { return employeeId; }
  public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }
  
  // Helper methods
  public String getFullName() {
    return firstName + " " + lastName;
  }

  public String getCreatedDate() {
    return createdAt != null ? createdAt.toString() : "Unknown";
  }
}