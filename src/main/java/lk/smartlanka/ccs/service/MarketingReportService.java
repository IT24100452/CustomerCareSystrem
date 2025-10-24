package lk.smartlanka.ccs.service;

import lk.smartlanka.ccs.dao.MarketingReportDao;
import lk.smartlanka.ccs.model.MarketingReport;

import java.util.List;

public class MarketingReportService {
    private MarketingReportDao dao = new MarketingReportDao();

    public long createReport(MarketingReport report) {
        dao.create(report);
        return report.getReportId();
    }

    public MarketingReport getReportById(long reportId) {
        return dao.getById(reportId);
    }

    public List<MarketingReport> getAllReports() {
        return dao.getAll();
    }

    public List<MarketingReport> getReportsByMarketingExecutive(int marketingExecutiveId) {
        return dao.getByMarketingExecutive(marketingExecutiveId);
    }

    public void updateReport(MarketingReport report) {
        dao.update(report);
    }

    public void deleteReport(long reportId) {
        dao.delete(reportId);
    }

    public String generateReportData(MarketingReport report) {
        // Generate CSV data based on the report type
        StringBuilder csvContent = new StringBuilder();
        
        // Add header based on report type
        csvContent.append("Marketing Report Data\n");
        csvContent.append("Report ID,Type,Period,Description\n");
        csvContent.append(report.getReportId()).append(",")
                  .append(report.getType()).append(",")
                  .append(report.getPeriodDisplay()).append(",")
                  .append(report.getDescription()).append("\n\n");
        
        // Add specific metrics based on report type
        if (report.getType() != null) {
            switch (report.getType()) {
                case "CAMPAIGN":
                    csvContent.append("Campaign Performance Metrics\n");
                    csvContent.append("Metric,Value,Target,Status\n");
                    csvContent.append("Impressions,125000,100000,Exceeded\n");
                    csvContent.append("Clicks,2500,2000,Exceeded\n");
                    csvContent.append("Conversions,125,100,Exceeded\n");
                    csvContent.append("CTR,2.0%,2.0%,Met\n");
                    csvContent.append("Conversion Rate,5.0%,5.0%,Met\n\n");
                    break;
                    
                case "ANALYTICS":
                    csvContent.append("Analytics Performance Metrics\n");
                    csvContent.append("Metric,Value,Previous Period,Change\n");
                    csvContent.append("Website Visits,45000,42000,+7.1%\n");
                    csvContent.append("Page Views,180000,165000,+9.1%\n");
                    csvContent.append("Bounce Rate,35%,38%,-3%\n");
                    csvContent.append("Avg Session Duration,3:45,3:20,+12.5%\n");
                    csvContent.append("New Visitors,28000,26000,+7.7%\n\n");
                    break;
                    
                case "SOCIAL_MEDIA":
                    csvContent.append("Social Media Performance Metrics\n");
                    csvContent.append("Platform,Followers,Engagement Rate,Posts,Reach\n");
                    csvContent.append("Facebook,15000,4.2%,25,45000\n");
                    csvContent.append("Instagram,12000,6.8%,30,38000\n");
                    csvContent.append("Twitter,8500,3.1%,20,25000\n");
                    csvContent.append("LinkedIn,5500,2.8%,15,18000\n\n");
                    break;
                    
                case "EMAIL_MARKETING":
                    csvContent.append("Email Marketing Performance Metrics\n");
                    csvContent.append("Campaign,Recipients,Opens,Open Rate,Clicks,Click Rate\n");
                    csvContent.append("Newsletter #1,10000,3200,32%,850,8.5%\n");
                    csvContent.append("Promotional #1,8000,2400,30%,720,9.0%\n");
                    csvContent.append("Newsletter #2,10500,3360,32%,945,9.0%\n");
                    csvContent.append("Promotional #2,9000,2700,30%,810,9.0%\n\n");
                    break;
                    
                case "CUSTOMER_ANALYSIS":
                    csvContent.append("Customer Analysis Metrics\n");
                    csvContent.append("Segment,Customers,Revenue,Avg Order Value,Lifetime Value\n");
                    csvContent.append("New Customers,500,25000,50,75\n");
                    csvContent.append("Returning Customers,1200,96000,80,120\n");
                    csvContent.append("VIP Customers,200,40000,200,300\n");
                    csvContent.append("Inactive Customers,800,0,0,0\n\n");
                    break;
                    
                default:
                    csvContent.append("General Marketing Metrics\n");
                    csvContent.append("Metric,Value,Target,Status\n");
                    csvContent.append("Lead Generation,150,120,Exceeded\n");
                    csvContent.append("Customer Acquisition,45,40,Exceeded\n");
                    csvContent.append("Brand Awareness,78%,75%,Exceeded\n");
                    csvContent.append("Market Share,12%,10%,Exceeded\n\n");
                    break;
            }
        }
        
        return csvContent.toString();
    }
}