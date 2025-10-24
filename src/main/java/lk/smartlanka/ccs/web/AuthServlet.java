package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.smartlanka.ccs.infra.Mailer;
import lk.smartlanka.ccs.infra.OtpService;
import lk.smartlanka.ccs.model.User;
import lk.smartlanka.ccs.service.AuthService;

import java.io.IOException;

public class AuthServlet extends HttpServlet {
  private AuthService service = new AuthService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String pathInfo = req.getPathInfo(); // Gets the part after /auth/

    if (pathInfo == null || pathInfo.equals("/")) {
      // Default to login page if no specific path
      req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
      return;
    }

    if (pathInfo.equals("/logout")) {
      req.getSession().invalidate();
      resp.sendRedirect(req.getContextPath() + "/auth/login");
      return;
    }

    // Remove leading slash and .jsp extension if present
    String view = pathInfo.substring(1);
    if (view.endsWith(".jsp")) {
      view = view.substring(0, view.length() - 4);
    }

    // Forward to the appropriate JSP in WEB-INF
    req.getRequestDispatcher("/WEB-INF/views/auth/" + view + ".jsp").forward(req, resp);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
    String action = req.getParameter("action");
    if ("login".equals(action)) {
      String email = req.getParameter("email");
      String password = req.getParameter("password");
      User user = service.login(email, password);
      if (user != null) {
        req.getSession().setAttribute("userId", user.getUserId());
        req.getSession().setAttribute("roleId", user.getRoleId());
        req.getSession().setAttribute("userName", user.getFullName());
        resp.sendRedirect(req.getContextPath() + getDashboardByRole(user.getRoleId()));
      } else {
        resp.sendRedirect(req.getContextPath() + "/auth/login?error=invalid");
      }
    } else if ("register".equals(action)) {
      String firstName = req.getParameter("firstName");
      String lastName = req.getParameter("lastName");
      String email = req.getParameter("email");
      String password = req.getParameter("password");
      String confirmPassword = req.getParameter("confirmPassword");
      String phone = req.getParameter("phone");
      String userType = req.getParameter("userType");
      
      // Validation
      if (firstName == null || firstName.trim().isEmpty() ||
          lastName == null || lastName.trim().isEmpty() ||
          email == null || email.trim().isEmpty() ||
          password == null || password.trim().isEmpty() ||
          phone == null || phone.trim().isEmpty() ||
          userType == null || userType.trim().isEmpty()) {
        resp.sendRedirect(req.getContextPath() + "/auth/register?error=validation&firstName=" + 
            (firstName != null ? firstName : "") + "&lastName=" + (lastName != null ? lastName : "") + 
            "&email=" + (email != null ? email : "") + "&phone=" + (phone != null ? phone : "") + 
            "&userType=" + (userType != null ? userType : ""));
        return;
      }
      
      if (!password.equals(confirmPassword)) {
        resp.sendRedirect(req.getContextPath() + "/auth/register?error=password_mismatch&firstName=" + 
            firstName + "&lastName=" + lastName + "&email=" + email + "&phone=" + phone + 
            "&userType=" + userType);
        return;
      }
      
      // Check if email already exists
      User existingUser = service.findByEmail(email);
      if (existingUser != null) {
        resp.sendRedirect(req.getContextPath() + "/auth/register?error=email_exists&firstName=" + 
            firstName + "&lastName=" + lastName + "&phone=" + phone + "&userType=" + userType);
        return;
      }
      
      // Map userType to roleId
      int roleId;
      switch (userType) {
          case "CUSTOMER": roleId = 7; break;        // Customer
          case "SUPPORT_STAFF": roleId = 3; break;   // Support Staff
          case "MANAGER": roleId = 5; break;         // Manager
          case "MARKETING_EXECUTIVE": roleId = 6; break; // Marketing Executive
          default: roleId = 7; break; // Default to customer
      }
      
      // Create username from email (before @ symbol)
      String username = email.substring(0, email.indexOf('@'));
      
      // Create new user
      User newUser = new User(username, email, password, firstName, lastName, phone, roleId, null, null);
      boolean success = service.register(newUser);
      
      if (success) {
        resp.sendRedirect(req.getContextPath() + "/auth/register?status=success");
      } else {
        resp.sendRedirect(req.getContextPath() + "/auth/register?error=server_error");
      }
    } else if ("reset".equals(action)) {
      String email = req.getParameter("email");
      boolean success = service.initiatePasswordReset(email);
      if (success) {
        resp.sendRedirect(req.getContextPath() + "/auth/reset?success=sent");
      } else {
        resp.sendRedirect(req.getContextPath() + "/auth/reset?error=nouser");
      }
    } else if ("verifyOtp".equals(action)) {
      String token = req.getParameter("token");
      String otp = req.getParameter("otp");
      String newPassword = req.getParameter("newPassword");
      
      if (token == null || otp == null || newPassword == null) {
        resp.sendRedirect(req.getContextPath() + "/auth/otp?error=invalidotp");
        return;
      }
      
      boolean success = service.verifyPasswordReset(token, otp, newPassword);
      if (success) {
        resp.sendRedirect(req.getContextPath() + "/auth/login?success=reset");
      } else {
        resp.sendRedirect(req.getContextPath() + "/auth/otp?error=invalidotp");
      }
    } else {
      // If no action is specified, just forward the request as a GET
      doGet(req, resp);
    }
  }

  private String getDashboardByRole(int roleId) {
    return switch (roleId) {
      case 1 -> "/dashboard"; // ADMIN
      case 2 -> "/dashboard"; // SYSADMIN
      case 3 -> "/dashboard"; // SUPPORT
      case 4 -> "/dashboard"; // FINANCE
      case 5 -> "/dashboard"; // MANAGER
      case 6 -> "/dashboard"; // MARKETING
      case 7 -> "/dashboard"; // CUSTOMER
      default -> "/index";
    };
  }
}