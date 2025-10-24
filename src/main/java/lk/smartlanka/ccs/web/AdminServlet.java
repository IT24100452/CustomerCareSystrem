package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class AdminServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String pathInfo = req.getPathInfo(); // e.g., /dashboard
    if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
      // default to dashboard
      req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
      return;
    }
    
    // Special handling for dashboard - redirect to DashboardServlet
    if (pathInfo.equals("/dashboard")) {
      resp.sendRedirect(req.getContextPath() + "/dashboard");
      return;
    }
    
    // remove leading slash
    String view = pathInfo.substring(1);
    if (view.endsWith(".jsp")) {
      view = view.substring(0, view.length() - 4);
    }
    req.getRequestDispatcher("/WEB-INF/views/admin/" + view + ".jsp").forward(req, resp);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    doGet(req, resp);
  }
}
