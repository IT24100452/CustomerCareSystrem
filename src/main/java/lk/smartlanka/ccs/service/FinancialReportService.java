package lk.smartlanka.ccs.service;

import lk.smartlanka.ccs.dao.FinancialReportDao;
import lk.smartlanka.ccs.model.FinancialReport;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class FinancialReportService {
    private FinancialReportDao dao = new FinancialReportDao();

    public void createFinancialReport(FinancialReport report) {
        // Calculate net profit if not provided
        if (report.getNetProfit() == null) {
            report.setNetProfit(report.calculateNetProfit());
        }
        
        // Set timestamps
        report.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        report.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        
        dao.create(report);
    }

    public void updateFinancialReport(FinancialReport report) {
        // Calculate net profit if not provided
        if (report.getNetProfit() == null) {
            report.setNetProfit(report.calculateNetProfit());
        }
        
        // Update timestamp
        report.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        
        dao.update(report);
    }

    public void deleteFinancialReport(long reportId) {
        dao.delete(reportId);
    }

    public FinancialReport getFinancialReportById(long reportId) {
        return dao.getById(reportId);
    }

    public List<FinancialReport> getAllFinancialReports() {
        return dao.getAll();
    }

    public List<FinancialReport> getFinancialReportsByCreator(int createdBy) {
        return dao.getByCreatedBy(createdBy);
    }

    public List<FinancialReport> getFinancialReportsByType(String reportType) {
        return dao.getByReportType(reportType);
    }

    public List<FinancialReport> getFinancialReportsByDateRange(Date startDate, Date endDate) {
        return dao.getByDateRange(startDate, endDate);
    }

    public List<FinancialReport> getRecentFinancialReports(int limit) {
        return dao.getRecentReports(limit);
    }

    public int getTotalFinancialReports() {
        return dao.getTotalReports();
    }

    // Business logic methods
    public BigDecimal calculateTotalRevenue(List<FinancialReport> reports) {
        return reports.stream()
                .map(FinancialReport::getTotalRevenue)
                .filter(revenue -> revenue != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal calculateTotalCosts(List<FinancialReport> reports) {
        return reports.stream()
                .map(FinancialReport::getTotalCosts)
                .filter(costs -> costs != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal calculateTotalNetProfit(List<FinancialReport> reports) {
        return reports.stream()
                .map(FinancialReport::getNetProfit)
                .filter(profit -> profit != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal calculateAverageProfitMargin(List<FinancialReport> reports) {
        if (reports.isEmpty()) return BigDecimal.ZERO;
        
        BigDecimal totalMargin = reports.stream()
                .map(FinancialReport::calculateProfitMargin)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        return totalMargin.divide(new BigDecimal(reports.size()), 2, java.math.RoundingMode.HALF_UP);
    }

    public BigDecimal calculateTotalComplaintCosts(List<FinancialReport> reports) {
        return reports.stream()
                .map(FinancialReport::getComplaintCosts)
                .filter(costs -> costs != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal calculateTotalResolutionCosts(List<FinancialReport> reports) {
        return reports.stream()
                .map(FinancialReport::getResolutionCosts)
                .filter(costs -> costs != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // Report generation methods
    public FinancialReport generateMonthlyReport(int year, int month, int createdBy) {
        FinancialReport report = new FinancialReport();
        report.setTitle("Monthly Financial Report - " + year + "/" + String.format("%02d", month));
        report.setReportType("MONTHLY");
        report.setCreatedBy(createdBy);
        
        // Set period dates
        Date startDate = Date.valueOf(year + "-" + String.format("%02d", month) + "-01");
        Date endDate = Date.valueOf(year + "-" + String.format("%02d", month) + "-" + getLastDayOfMonth(year, month));
        report.setPeriodStart(startDate);
        report.setPeriodEnd(endDate);
        
        return report;
    }

    public FinancialReport generateQuarterlyReport(int year, int quarter, int createdBy) {
        FinancialReport report = new FinancialReport();
        report.setTitle("Quarterly Financial Report - Q" + quarter + " " + year);
        report.setReportType("QUARTERLY");
        report.setCreatedBy(createdBy);
        
        // Set period dates based on quarter
        Date startDate, endDate;
        switch (quarter) {
            case 1:
                startDate = Date.valueOf(year + "-01-01");
                endDate = Date.valueOf(year + "-03-31");
                break;
            case 2:
                startDate = Date.valueOf(year + "-04-01");
                endDate = Date.valueOf(year + "-06-30");
                break;
            case 3:
                startDate = Date.valueOf(year + "-07-01");
                endDate = Date.valueOf(year + "-09-30");
                break;
            case 4:
                startDate = Date.valueOf(year + "-10-01");
                endDate = Date.valueOf(year + "-12-31");
                break;
            default:
                throw new IllegalArgumentException("Invalid quarter: " + quarter);
        }
        
        report.setPeriodStart(startDate);
        report.setPeriodEnd(endDate);
        
        return report;
    }

    public FinancialReport generateAnnualReport(int year, int createdBy) {
        FinancialReport report = new FinancialReport();
        report.setTitle("Annual Financial Report - " + year);
        report.setReportType("ANNUAL");
        report.setCreatedBy(createdBy);
        
        Date startDate = Date.valueOf(year + "-01-01");
        Date endDate = Date.valueOf(year + "-12-31");
        report.setPeriodStart(startDate);
        report.setPeriodEnd(endDate);
        
        return report;
    }

    private int getLastDayOfMonth(int year, int month) {
        switch (month) {
            case 1: case 3: case 5: case 7: case 8: case 10: case 12:
                return 31;
            case 4: case 6: case 9: case 11:
                return 30;
            case 2:
                return isLeapYear(year) ? 29 : 28;
            default:
                return 30;
        }
    }

    private boolean isLeapYear(int year) {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    }
}
