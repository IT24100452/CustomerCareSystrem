package lk.smartlanka.ccs.web.filters;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class RbacFilter implements Filter {
  @Override
  public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
    HttpServletRequest request = (HttpServletRequest) req;
    HttpServletResponse response = (HttpServletResponse) res;
    HttpSession session = request.getSession();
    Integer roleId = (Integer) session.getAttribute("roleId");

    String path = request.getServletPath();
    // Allow access to /auth/* and public assets for unauthenticated users
    if (path.startsWith("/auth") || path.startsWith("/assets/") || "/".equals(path) || "/index.jsp".equals(path)) {
      chain.doFilter(req, res);
      return;
    }

    // Allow static resources or public paths without authentication if needed
    // Example: if (path.startsWith("/static/") || path.equals("/public")) { chain.doFilter(req, res); return; }

    if (roleId == null) {
      response.sendRedirect(request.getContextPath() + "/auth/login");
      return;
    }

    // Role IDs based on database seed:
    // 1: ADMIN (Administrator)
    // 2: SYSADMIN (System Administrator) - assuming similar access to ADMIN
    // 3: SUPPORT (Support Staff)
    // 4: FINANCE (Finance Assistant)
    // 5: MANAGER (Manager)
    // 6: MARKETING (Marketing Executive)
    // 7: CUSTOMER (Customer)

    // Check role against URL
    // Assuming paths like /admin/, /support/, /finance/, /manager/, /marketing/, /customer/
    // Adjust these paths based on your actual servlet mappings or dashboards
    // For /user (from UserServlet), assuming it's admin/manager accessible - customize as needed

    if (path.startsWith("/admin/")) {
      if (roleId != 1 && roleId != 2) { // Allow ADMIN and SYSADMIN
        response.sendError(403, "Access Denied: Admin privileges required");
        return;
      }
    } else if (path.startsWith("/support/")) {
      if (roleId != 3) { // SUPPORT
        response.sendError(403, "Access Denied: Support Staff privileges required");
        return;
      }
    } else if (path.startsWith("/finance")) {
      if (roleId != 4 && roleId != 1) { // FINANCE and ADMIN
        response.sendError(403, "Access Denied: Finance Assistant privileges required");
        return;
      }
    } else if (path.startsWith("/manager/")) {
      if (roleId != 5) { // MANAGER
        response.sendError(403, "Access Denied: Manager privileges required");
        return;
      }
    } else if (path.startsWith("/marketing/")) {
      if (roleId != 6) { // MARKETING
        response.sendError(403, "Access Denied: Marketing Executive privileges required");
        return;
      }
    } else if (path.startsWith("/customer/")) {
      if (roleId != 7) { // CUSTOMER
        response.sendError(403, "Access Denied: Customer access only");
        return;
      }
    } else if ("/user".equals(path)) {
      // Assuming /user is for admins, managers, etc. - customize
      if (roleId != 1 && roleId != 2 && roleId != 5) {
        response.sendError(403, "Access Denied: Insufficient privileges");
        return;
      }
    } else if ("/dashboard".equals(path)) {
      // All authenticated users can access /dashboard; specific JSPs are chosen server-side.
    } else if ("/complaint".equals(path)) {
      // Customers and support staff can access complaints
      if (roleId != 7 && roleId != 3 && roleId != 5 && roleId != 1 && roleId != 2) {
        response.sendError(403, "Access Denied: Complaint access restricted");
        return;
      }
    } else if ("/assignment".equals(path)) {
      // Support staff and managers/admins
      if (roleId != 3 && roleId != 5 && roleId != 1 && roleId != 2) {
        response.sendError(403, "Access Denied: Assignment access restricted");
        return;
      }
    } else if ("/feedback".equals(path)) {
      // Customers, managers, marketing and admins
      if (roleId != 7 && roleId != 5 && roleId != 6 && roleId != 1 && roleId != 2) {
        response.sendError(403, "Access Denied: Feedback access restricted");
        return;
      }
    } else if ("/report".equals(path) || "/export".equals(path)) {
      // Managers, finance, marketing, admins
      if (roleId != 5 && roleId != 4 && roleId != 6 && roleId != 1 && roleId != 2) {
        response.sendError(403, "Access Denied: Reports restricted");
        return;
      }
    } else if ("/notifications".equals(path)) {
      // Any authenticated user
    }
    // Add more path checks as needed for other servlets/dashboards

    // If no restrictions matched, proceed
    chain.doFilter(req, res);
  }
}