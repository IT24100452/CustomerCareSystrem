package lk.smartlanka.ccs.listeners;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import lk.smartlanka.ccs.infra.AppConfig;

import javax.sql.DataSource;
import java.sql.Connection;

@WebListener
public class StartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            DataSource ds = AppConfig.getDataSource();

            // 🔍 Try getting a real connection to verify DB is reachable
            try (Connection conn = ds.getConnection()) {
                // Get metadata to verify connection is working
                conn.getMetaData();
                System.out.println("[SmartLankaCCS] ✅ Database connection established successfully.");
            }

        } catch (Exception e) {
            System.err.println("[SmartLankaCCS] ❌ Failed to initialize database connection.");
            e.printStackTrace(); // full stacktrace in Tomcat logs

            // Re-throw so Tomcat knows startup failed
            throw new RuntimeException("StartupListener failed: Cannot connect to DB", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[SmartLankaCCS] 🔴 Application shutting down, releasing resources...");
    }
}
