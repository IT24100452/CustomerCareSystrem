package lk.smartlanka.ccs.dao;

import lk.smartlanka.ccs.infra.DataSourceProvider;
import lk.smartlanka.ccs.model.MarketingReport;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MarketingReportDao {
    
    public void create(MarketingReport report) {
        String sql = "INSERT INTO marketingreport (GeneratedBy, Type, PeriodStart, PeriodEnd, Description) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, report.getGeneratedBy());
            ps.setString(2, report.getType());
            ps.setDate(3, report.getPeriodStart());
            ps.setDate(4, report.getPeriodEnd());
            ps.setString(5, report.getDescription());
            
            ps.executeUpdate();
            
            // Get the generated ID
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    report.setReportId(rs.getLong(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create marketing report", e);
        }
    }

    public MarketingReport getById(long reportId) {
        String sql = "SELECT * FROM marketingreport WHERE ReportID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, reportId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReport(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get marketing report by ID", e);
        }
        return null;
    }

    public List<MarketingReport> getAll() {
        List<MarketingReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM marketingreport ORDER BY CreatedAt DESC";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                reports.add(mapResultSetToReport(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get all marketing reports", e);
        }
        return reports;
    }

    public List<MarketingReport> getByMarketingExecutive(int marketingExecutiveId) {
        List<MarketingReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM marketingreport WHERE GeneratedBy = ? ORDER BY CreatedAt DESC";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, marketingExecutiveId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToReport(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get marketing reports by executive", e);
        }
        return reports;
    }

    public void update(MarketingReport report) {
        String sql = "UPDATE marketingreport SET Type = ?, PeriodStart = ?, PeriodEnd = ?, Description = ? WHERE ReportID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, report.getType());
            ps.setDate(2, report.getPeriodStart());
            ps.setDate(3, report.getPeriodEnd());
            ps.setString(4, report.getDescription());
            ps.setLong(5, report.getReportId());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update marketing report", e);
        }
    }

    public void delete(long reportId) {
        String sql = "DELETE FROM marketingreport WHERE ReportID = ?";
        try (Connection conn = DataSourceProvider.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, reportId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete marketing report", e);
        }
    }

    private MarketingReport mapResultSetToReport(ResultSet rs) throws SQLException {
        MarketingReport report = new MarketingReport();
        report.setReportId(rs.getLong("ReportID"));
        report.setGeneratedBy(rs.getInt("GeneratedBy"));
        report.setType(rs.getString("Type"));
        report.setPeriodStart(rs.getDate("PeriodStart"));
        report.setPeriodEnd(rs.getDate("PeriodEnd"));
        report.setDescription(rs.getString("Description"));
        report.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return report;
    }
}