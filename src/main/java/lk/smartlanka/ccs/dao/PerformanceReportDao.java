package lk.smartlanka.ccs.dao;

import lk.smartlanka.ccs.infra.DataSourceProvider;
import lk.smartlanka.ccs.model.PerformanceReport;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PerformanceReportDao {
    
    public void create(PerformanceReport report) {
        String sql = "INSERT INTO performancereport (GeneratedBy, ReportTitle, ReportType, ReportPeriod, ReportFormat, ReportDescription, IncludeMetrics) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, report.getGeneratedBy());
            ps.setString(2, report.getReportTitle());
            ps.setString(3, report.getReportType());
            ps.setString(4, report.getReportPeriod());
            ps.setString(5, report.getReportFormat());
            ps.setString(6, report.getReportDescription());
            ps.setString(7, report.getIncludeMetrics());
            
            ps.executeUpdate();
            
            // Get the generated ID
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    report.setReportId(rs.getLong(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create performance report", e);
        }
    }

    public PerformanceReport getById(long reportId) {
        String sql = "SELECT * FROM performancereport WHERE ReportID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, reportId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReport(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get performance report by ID", e);
        }
        return null;
    }

    public List<PerformanceReport> getAll() {
        List<PerformanceReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM performancereport ORDER BY CreatedAt DESC";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                reports.add(mapResultSetToReport(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get all performance reports", e);
        }
        return reports;
    }

    public List<PerformanceReport> getByManager(int managerId) {
        List<PerformanceReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM performancereport WHERE GeneratedBy = ? ORDER BY CreatedAt DESC";
        System.out.println("[PerformanceReportDao] Executing query: " + sql + " with managerId: " + managerId);
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToReport(rs));
                }
            }
            System.out.println("[PerformanceReportDao] Found " + reports.size() + " reports for manager " + managerId);
        } catch (SQLException e) {
            System.err.println("[PerformanceReportDao] SQL Error: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get performance reports by manager", e);
        }
        return reports;
    }

    public void update(PerformanceReport report) {
        String sql = "UPDATE performancereport SET ReportTitle = ?, ReportType = ?, ReportPeriod = ?, ReportFormat = ?, ReportDescription = ?, IncludeMetrics = ?, UpdatedAt = NOW() WHERE ReportID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, report.getReportTitle());
            ps.setString(2, report.getReportType());
            ps.setString(3, report.getReportPeriod());
            ps.setString(4, report.getReportFormat());
            ps.setString(5, report.getReportDescription());
            ps.setString(6, report.getIncludeMetrics());
            ps.setLong(7, report.getReportId());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update performance report", e);
        }
    }

    public void delete(long reportId) {
        String sql = "DELETE FROM performancereport WHERE ReportID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, reportId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete performance report", e);
        }
    }

    public void incrementDownloadCount(long reportId) {
        String sql = "UPDATE performancereport SET DownloadCount = DownloadCount + 1 WHERE ReportID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, reportId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to increment download count", e);
        }
    }

    public void updateFilePath(long reportId, String filePath) {
        String sql = "UPDATE performancereport SET FilePath = ? WHERE ReportID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, filePath);
            ps.setLong(2, reportId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update file path", e);
        }
    }

    private PerformanceReport mapResultSetToReport(ResultSet rs) throws SQLException {
        PerformanceReport report = new PerformanceReport();
        report.setReportId(rs.getLong("ReportID"));
        report.setGeneratedBy(rs.getInt("GeneratedBy"));
        report.setReportTitle(rs.getString("ReportTitle"));
        report.setReportType(rs.getString("ReportType"));
        report.setReportPeriod(rs.getString("ReportPeriod"));
        report.setReportFormat(rs.getString("ReportFormat"));
        report.setReportDescription(rs.getString("ReportDescription"));
        report.setIncludeMetrics(rs.getString("IncludeMetrics"));
        report.setFilePath(rs.getString("FilePath"));
        report.setDownloadCount(rs.getInt("DownloadCount"));
        
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            report.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            report.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return report;
    }
}