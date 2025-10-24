package lk.smartlanka.ccs.dao;

import lk.smartlanka.ccs.infra.DataSourceProvider;
import lk.smartlanka.ccs.model.FinancialReport;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FinancialReportDao {
    private final DataSource dataSource = DataSourceProvider.getDataSource();

    public void create(FinancialReport report) {
        String sql = "INSERT INTO FinancialReport (GeneratedBy, Amount, Type, PeriodStart, PeriodEnd, Description) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, report.getCreatedBy());
            stmt.setBigDecimal(2, report.getTotalRevenue() != null ? report.getTotalRevenue() : BigDecimal.ZERO);
            stmt.setString(3, report.getReportType());
            stmt.setDate(4, report.getPeriodStart());
            stmt.setDate(5, report.getPeriodEnd());
            stmt.setString(6, report.getSummary());
            
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    report.setReportId(rs.getLong(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating financial report", e);
        }
    }

    public void update(FinancialReport report) {
        String sql = "UPDATE FinancialReport SET GeneratedBy = ?, Amount = ?, Type = ?, PeriodStart = ?, PeriodEnd = ?, " +
                    "Description = ? WHERE ReportID = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, report.getCreatedBy());
            stmt.setBigDecimal(2, report.getTotalRevenue() != null ? report.getTotalRevenue() : BigDecimal.ZERO);
            stmt.setString(3, report.getReportType());
            stmt.setDate(4, report.getPeriodStart());
            stmt.setDate(5, report.getPeriodEnd());
            stmt.setString(6, report.getSummary());
            stmt.setLong(7, report.getReportId());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating financial report", e);
        }
    }

    public void delete(long reportId) {
        String sql = "DELETE FROM FinancialReport WHERE ReportID = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, reportId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting financial report", e);
        }
    }

    public FinancialReport getById(long reportId) {
        String sql = "SELECT * FROM FinancialReport WHERE ReportID = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, reportId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFinancialReport(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting financial report by ID", e);
        }
        
        return null;
    }

    public List<FinancialReport> getAll() {
        String sql = "SELECT * FROM FinancialReport ORDER BY CreatedAt DESC";
        List<FinancialReport> reports = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                reports.add(mapResultSetToFinancialReport(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting all financial reports", e);
        }
        
        return reports;
    }

    public List<FinancialReport> getByCreatedBy(int createdBy) {
        String sql = "SELECT * FROM FinancialReport WHERE CreatedBy = ? ORDER BY CreatedAt DESC";
        List<FinancialReport> reports = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, createdBy);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToFinancialReport(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting financial reports by creator", e);
        }
        
        return reports;
    }

    public List<FinancialReport> getByReportType(String reportType) {
        String sql = "SELECT * FROM FinancialReport WHERE ReportType = ? ORDER BY CreatedAt DESC";
        List<FinancialReport> reports = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, reportType);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToFinancialReport(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting financial reports by type", e);
        }
        
        return reports;
    }

    public List<FinancialReport> getByDateRange(Date startDate, Date endDate) {
        String sql = "SELECT * FROM FinancialReport WHERE PeriodStart >= ? AND PeriodEnd <= ? ORDER BY CreatedAt DESC";
        List<FinancialReport> reports = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, startDate);
            stmt.setDate(2, endDate);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToFinancialReport(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting financial reports by date range", e);
        }
        
        return reports;
    }

    public List<FinancialReport> getRecentReports(int limit) {
        String sql = "SELECT * FROM FinancialReport ORDER BY CreatedAt DESC LIMIT ?";
        List<FinancialReport> reports = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToFinancialReport(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting recent financial reports", e);
        }
        
        return reports;
    }

    public int getTotalReports() {
        String sql = "SELECT COUNT(*) FROM FinancialReport";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting total financial reports count", e);
        }
        
        return 0;
    }

    private FinancialReport mapResultSetToFinancialReport(ResultSet rs) throws SQLException {
        FinancialReport report = new FinancialReport();
        report.setReportId(rs.getLong("ReportID"));
        report.setCreatedBy(rs.getInt("GeneratedBy"));
        report.setTotalRevenue(rs.getBigDecimal("Amount"));
        report.setReportType(rs.getString("Type"));
        report.setPeriodStart(rs.getDate("PeriodStart"));
        report.setPeriodEnd(rs.getDate("PeriodEnd"));
        report.setSummary(rs.getString("Description"));
        report.setCreatedAt(rs.getTimestamp("CreatedAt"));
        
        // Set default values for fields not in the database
        report.setTitle("Financial Report #" + report.getReportId());
        report.setTotalCosts(BigDecimal.ZERO);
        report.setNetProfit(report.getTotalRevenue());
        report.setComplaintCosts(BigDecimal.ZERO);
        report.setResolutionCosts(BigDecimal.ZERO);
        report.setUpdatedAt(report.getCreatedAt());
        
        return report;
    }
}