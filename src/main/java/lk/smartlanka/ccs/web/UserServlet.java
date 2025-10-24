package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.smartlanka.ccs.model.User;
import lk.smartlanka.ccs.service.UserService; // Assume UserService with DAO calls

import java.io.IOException;
import java.util.List;

public class UserServlet extends HttpServlet {
    private UserService service = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("list".equals(action)) {
            List<User> users = service.getAllUsers();
            req.setAttribute("users", users);
            req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
        } else if ("view".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            User user = service.getById(id);
            req.setAttribute("user", user);
            req.getRequestDispatcher("/WEB-INF/views/admin/user_view.jsp").forward(req, resp);
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            User user = service.getById(id);
            req.setAttribute("user", user);
            req.getRequestDispatcher("/WEB-INF/views/admin/user_edit.jsp").forward(req, resp);
        } else if ("create".equals(action)) {
            req.getRequestDispatcher("/WEB-INF/views/admin/user_create.jsp").forward(req, resp);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            service.delete(id);
            resp.sendRedirect(req.getContextPath() + "/user?action=list&status=deleted");
        } else {
            // Default to user list
            resp.sendRedirect(req.getContextPath() + "/user?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        User user = new User();
        user.setUsername(req.getParameter("username"));
        user.setEmail(req.getParameter("email"));
        user.setFirstName(req.getParameter("firstName"));
        user.setLastName(req.getParameter("lastName"));
        user.setPhoneNumber(req.getParameter("phoneNumber"));
        user.setRoleId(Integer.parseInt(req.getParameter("roleId")));
        if ("create".equals(action)) {
            String password = req.getParameter("password");
            user.setPassword(password);
            user.setEmployeeId(req.getParameter("employeeId"));
            user.setActive(Boolean.parseBoolean(req.getParameter("isActive")));
            try {
                service.create(user);
                
                // If creating a customer, also add to Customer table
                if (user.getRoleId() == 7) {
                    addToCustomerTable(user.getUserId());
                }
                
                resp.sendRedirect(req.getContextPath() + "/user?action=create&status=success");
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/user?action=create&error=validation_error");
                return;
            }
        } else if ("update".equals(action)) {
            user.setUserId(Integer.parseInt(req.getParameter("id")));
            String newPassword = req.getParameter("newPassword");
            if (newPassword != null && !newPassword.isEmpty()) {
                user.setPassword(newPassword);
            }
            user.setEmployeeId(req.getParameter("employeeId"));
            user.setActive(Boolean.parseBoolean(req.getParameter("isActive")));
            service.update(user);
            resp.sendRedirect(req.getContextPath() + "/user?action=view&id=" + user.getUserId() + "&status=success");
            return;
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            service.delete(id);
            resp.sendRedirect(req.getContextPath() + "/user?action=list&status=deleted");
            return;
        }
        // Default redirect if no action matches
        resp.sendRedirect(req.getContextPath() + "/user?action=list");
    }
    
    private void addToCustomerTable(int userId) {
        try {
            java.sql.Connection conn = lk.smartlanka.ccs.infra.DataSourceProvider.getDataSource().getConnection();
            String sql = "INSERT INTO Customer(UserID, CustomerNo, NIC, ServiceRegion) VALUES (?, ?, ?, ?)";
            try (java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, "CUST-" + String.format("%05d", userId));
                ps.setString(3, "200000000000");
                ps.setString(4, "Colombo");
                ps.executeUpdate();
            }
            conn.close();
        } catch (Exception e) {
            System.err.println("Error adding user to Customer table: " + e.getMessage());
        }
    }
}