package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.smartlanka.ccs.model.FinancialReport;
import lk.smartlanka.ccs.service.FinancialReportService;
import lk.smartlanka.ccs.service.NotificationService;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

public class FinanceServlet extends HttpServlet {
    private FinancialReportService service = new FinancialReportService();
    private NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        Integer roleId = (Integer) req.getSession().getAttribute("roleId");
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        
        // Check if user has finance access (role 4 = Finance or role 1 = Admin)
        if (roleId != null && roleId != 4 && roleId != 1) {
            resp.sendRedirect(req.getContextPath() + "/dashboard?error=access_denied");
            return;
        }
        
        try {
            if ("dashboard".equals(action) || action == null) {
                // Load dashboard data
                List<FinancialReport> recentReports = service.getRecentFinancialReports(5);
                List<FinancialReport> allReports = service.getAllFinancialReports();
                
                req.setAttribute("recentReports", recentReports);
                req.setAttribute("totalReports", service.getTotalFinancialReports());
                req.setAttribute("totalRevenue", service.calculateTotalRevenue(allReports));
                req.setAttribute("totalCosts", service.calculateTotalCosts(allReports));
                req.setAttribute("totalNetProfit", service.calculateTotalNetProfit(allReports));
                req.setAttribute("averageProfitMargin", service.calculateAverageProfitMargin(allReports));
                
                req.getRequestDispatcher("/WEB-INF/views/finance/dashboard.jsp").forward(req, resp);
                
            } else if ("list".equals(action)) {
                // List all financial reports
                List<FinancialReport> reports = service.getAllFinancialReports();
                req.setAttribute("reports", reports);
                req.getRequestDispatcher("/WEB-INF/views/finance/reports_list.jsp").forward(req, resp);
                
            } else if ("create".equals(action)) {
                // Show create form
                req.getRequestDispatcher("/WEB-INF/views/finance/report_create.jsp").forward(req, resp);
                
            } else if ("view".equals(action)) {
                // View specific report
                long reportId = Long.parseLong(req.getParameter("id"));
                FinancialReport report = service.getFinancialReportById(reportId);
                
                if (report != null) {
                    req.setAttribute("report", report);
                    req.getRequestDispatcher("/WEB-INF/views/finance/report_view.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/finance?action=list&error=not_found");
                }
                
            } else if ("edit".equals(action)) {
                // Show edit form
                long reportId = Long.parseLong(req.getParameter("id"));
                FinancialReport report = service.getFinancialReportById(reportId);
                
                if (report != null) {
                    req.setAttribute("report", report);
                    req.getRequestDispatcher("/WEB-INF/views/finance/report_edit.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/finance?action=list&error=not_found");
                }
                
            } else if ("analytics".equals(action)) {
                // Show analytics dashboard
                List<FinancialReport> reports = service.getAllFinancialReports();
                req.setAttribute("reports", reports);
                req.setAttribute("totalRevenue", service.calculateTotalRevenue(reports));
                req.setAttribute("totalCosts", service.calculateTotalCosts(reports));
                req.setAttribute("totalNetProfit", service.calculateTotalNetProfit(reports));
                req.setAttribute("averageProfitMargin", service.calculateAverageProfitMargin(reports));
                req.setAttribute("totalComplaintCosts", service.calculateTotalComplaintCosts(reports));
                req.setAttribute("totalResolutionCosts", service.calculateTotalResolutionCosts(reports));
                
                req.getRequestDispatcher("/WEB-INF/views/finance/analytics.jsp").forward(req, resp);
                
            } else if ("export".equals(action)) {
                // Export reports
                String format = req.getParameter("format");
                if ("pdf".equals(format)) {
                    exportToPDF(req, resp);
                } else if ("csv".equals(format)) {
                    exportToCSV(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/finance?action=dashboard&error=invalid_format");
                }
                
            } else {
                resp.sendRedirect(req.getContextPath() + "/finance?action=dashboard");
            }
            
        } catch (Exception e) {
            System.err.println("Error in FinanceServlet doGet: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/finance?action=dashboard&error=server_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        Integer roleId = (Integer) req.getSession().getAttribute("roleId");
        
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        
        // Check if user has finance access (role 4 = Finance or role 1 = Admin)
        if (roleId != null && roleId != 4 && roleId != 1) {
            resp.sendRedirect(req.getContextPath() + "/dashboard?error=access_denied");
            return;
        }
        
        try {
            if ("create".equals(action)) {
                // Create new financial report
                FinancialReport report = new FinancialReport();
                report.setTitle(req.getParameter("title"));
                report.setReportType(req.getParameter("reportType"));
                report.setPeriodStart(Date.valueOf(req.getParameter("periodStart")));
                report.setPeriodEnd(Date.valueOf(req.getParameter("periodEnd")));
                report.setCreatedBy(userId);
                
                // Set financial data - use totalRevenue as the main amount
                String totalRevenueStr = req.getParameter("totalRevenue");
                if (totalRevenueStr != null && !totalRevenueStr.trim().isEmpty()) {
                    report.setTotalRevenue(new BigDecimal(totalRevenueStr));
                } else {
                    report.setTotalRevenue(BigDecimal.ZERO);
                }
                
                // Set other financial data for display purposes
                String totalCostsStr = req.getParameter("totalCosts");
                if (totalCostsStr != null && !totalCostsStr.trim().isEmpty()) {
                    report.setTotalCosts(new BigDecimal(totalCostsStr));
                } else {
                    report.setTotalCosts(BigDecimal.ZERO);
                }
                
                String complaintCostsStr = req.getParameter("complaintCosts");
                if (complaintCostsStr != null && !complaintCostsStr.trim().isEmpty()) {
                    report.setComplaintCosts(new BigDecimal(complaintCostsStr));
                } else {
                    report.setComplaintCosts(BigDecimal.ZERO);
                }
                
                String resolutionCostsStr = req.getParameter("resolutionCosts");
                if (resolutionCostsStr != null && !resolutionCostsStr.trim().isEmpty()) {
                    report.setResolutionCosts(new BigDecimal(resolutionCostsStr));
                } else {
                    report.setResolutionCosts(BigDecimal.ZERO);
                }
                
                report.setSummary(req.getParameter("summary"));
                
                service.createFinancialReport(report);
                
                // Create notification
                notificationService.createFinancialReportNotification(userId, "created", report.getReportId(), report.getTitle());
                
                resp.sendRedirect(req.getContextPath() + "/finance?action=list&status=created");
                
            } else if ("update".equals(action)) {
                // Update existing financial report
                long reportId = Long.parseLong(req.getParameter("reportId"));
                FinancialReport report = service.getFinancialReportById(reportId);
                
                if (report != null) {
                    report.setTitle(req.getParameter("title"));
                    report.setReportType(req.getParameter("reportType"));
                    report.setPeriodStart(Date.valueOf(req.getParameter("periodStart")));
                    report.setPeriodEnd(Date.valueOf(req.getParameter("periodEnd")));
                    
                    // Set financial data
                    String totalRevenueStr = req.getParameter("totalRevenue");
                    if (totalRevenueStr != null && !totalRevenueStr.trim().isEmpty()) {
                        report.setTotalRevenue(new BigDecimal(totalRevenueStr));
                    }
                    
                    String totalCostsStr = req.getParameter("totalCosts");
                    if (totalCostsStr != null && !totalCostsStr.trim().isEmpty()) {
                        report.setTotalCosts(new BigDecimal(totalCostsStr));
                    }
                    
                    String complaintCostsStr = req.getParameter("complaintCosts");
                    if (complaintCostsStr != null && !complaintCostsStr.trim().isEmpty()) {
                        report.setComplaintCosts(new BigDecimal(complaintCostsStr));
                    }
                    
                    String resolutionCostsStr = req.getParameter("resolutionCosts");
                    if (resolutionCostsStr != null && !resolutionCostsStr.trim().isEmpty()) {
                        report.setResolutionCosts(new BigDecimal(resolutionCostsStr));
                    }
                    
                    report.setSummary(req.getParameter("summary"));
                    
                    service.updateFinancialReport(report);
                    
                    // Create notification
                    notificationService.createFinancialReportNotification(userId, "updated", report.getReportId(), report.getTitle());
                    
                    resp.sendRedirect(req.getContextPath() + "/finance?action=list&status=updated");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/finance?action=list&error=not_found");
                }
                
            } else if ("delete".equals(action)) {
                // Delete financial report
                long reportId = Long.parseLong(req.getParameter("reportId"));
                FinancialReport report = service.getFinancialReportById(reportId);
                
                if (report != null) {
                    service.deleteFinancialReport(reportId);
                    
                    // Create notification
                    notificationService.createFinancialReportNotification(userId, "deleted", reportId, report.getTitle());
                    
                    resp.sendRedirect(req.getContextPath() + "/finance?action=list&status=deleted");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/finance?action=list&error=not_found");
                }
                
            } else if ("generate".equals(action)) {
                // Generate predefined report
                String reportType = req.getParameter("reportType");
                FinancialReport report;
                
                if ("monthly".equals(reportType)) {
                    int year = Integer.parseInt(req.getParameter("year"));
                    int month = Integer.parseInt(req.getParameter("month"));
                    report = service.generateMonthlyReport(year, month, userId);
                } else if ("quarterly".equals(reportType)) {
                    int year = Integer.parseInt(req.getParameter("year"));
                    int quarter = Integer.parseInt(req.getParameter("quarter"));
                    report = service.generateQuarterlyReport(year, quarter, userId);
                } else if ("annual".equals(reportType)) {
                    int year = Integer.parseInt(req.getParameter("year"));
                    report = service.generateAnnualReport(year, userId);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/finance?action=create&error=invalid_type");
                    return;
                }
                
                service.createFinancialReport(report);
                
                // Create notification
                notificationService.createFinancialReportNotification(userId, "generated", report.getReportId(), report.getTitle());
                
                resp.sendRedirect(req.getContextPath() + "/finance?action=edit&id=" + report.getReportId() + "&status=generated");
                
            } else {
                resp.sendRedirect(req.getContextPath() + "/finance?action=dashboard&error=invalid_action");
            }
            
        } catch (Exception e) {
            System.err.println("Error in FinanceServlet doPost: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/finance?action=dashboard&error=server_error");
        }
    }
    
    private void exportToPDF(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // TODO: Implement PDF export functionality
        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=financial_reports.pdf");
        
        // For now, redirect to a placeholder
        resp.getWriter().println("PDF export functionality will be implemented here");
    }
    
    private void exportToCSV(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment; filename=financial_reports.csv");
        
        List<FinancialReport> reports = service.getAllFinancialReports();
        
        resp.getWriter().println("Report ID,Title,Report Type,Period Start,Period End,Total Revenue,Total Costs,Net Profit,Complaint Costs,Resolution Costs,Summary,Created By,Created At");
        
        for (FinancialReport report : reports) {
            resp.getWriter().printf("%d,\"%s\",\"%s\",%s,%s,%s,%s,%s,%s,%s,\"%s\",%d,%s%n",
                report.getReportId(),
                report.getTitle(),
                report.getReportType(),
                report.getPeriodStart(),
                report.getPeriodEnd(),
                report.getTotalRevenue(),
                report.getTotalCosts(),
                report.getNetProfit(),
                report.getComplaintCosts(),
                report.getResolutionCosts(),
                report.getSummary(),
                report.getCreatedBy(),
                report.getCreatedAt()
            );
        }
    }
}
