package lk.smartlanka.ccs.infra;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class AppConfig {
    private static HikariDataSource dataSource;

    public static DataSource getDataSource() {
        if (dataSource == null) {
            try (InputStream input = AppConfig.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (input == null) {
                    throw new RuntimeException("db.properties not found in classpath");
                }

                Properties props = new Properties();
                props.load(input);

                HikariConfig config = new HikariConfig();
                String jdbcUrl = props.getProperty("jdbcUrl");
                String username = props.getProperty("username");
                String password = props.getProperty("password");
                String driver = props.getProperty("driverClassName", "com.mysql.cj.jdbc.Driver");

                // Diagnostic: print classloader info and attempt to load the driver explicitly
                ClassLoader appCl = AppConfig.class.getClassLoader();
                ClassLoader ctxCl = Thread.currentThread().getContextClassLoader();
                System.out.println("[AppConfig] App classloader: " + (appCl != null ? appCl.toString() : "null"));
                System.out.println("[AppConfig] Thread context classloader: " + (ctxCl != null ? ctxCl.toString() : "null"));

                // Try to load the JDBC driver class into the webapp classloader so DriverManager can find it
                try {
                    // Prefer context classloader (works in many servlet containers)
                    Class.forName(driver, true, Thread.currentThread().getContextClassLoader());
                    System.out.println("[AppConfig] Successfully loaded JDBC driver class via context classloader: " + driver);
                } catch (ClassNotFoundException e1) {
                    try {
                        // Fallback: try plain Class.forName which may register driver
                        Class.forName(driver);
                        System.out.println("[AppConfig] Successfully loaded JDBC driver class via system loader: " + driver);
                    } catch (ClassNotFoundException e2) {
                        // As a last resort, try to instantiate and register the driver directly with DriverManager
                        System.err.println("[AppConfig] JDBC driver class not found on classpath: " + driver + ". Attempting DriverManager.registerDriver...");
                        try {
                            java.sql.Driver drv = (java.sql.Driver) Class.forName(driver).getDeclaredConstructor().newInstance();
                            java.sql.DriverManager.registerDriver(new java.sql.Driver() {
                                private final java.sql.Driver delegate = drv;
                                public java.sql.Connection connect(String url, java.util.Properties info) throws java.sql.SQLException { return delegate.connect(url, info); }
                                public boolean acceptsURL(String url) throws java.sql.SQLException { return delegate.acceptsURL(url); }
                                public java.sql.DriverPropertyInfo[] getPropertyInfo(String url, java.util.Properties info) throws java.sql.SQLException { return delegate.getPropertyInfo(url, info); }
                                public int getMajorVersion() { return delegate.getMajorVersion(); }
                                public int getMinorVersion() { return delegate.getMinorVersion(); }
                                public boolean jdbcCompliant() { return delegate.jdbcCompliant(); }
                                public java.util.logging.Logger getParentLogger() { try { return delegate.getParentLogger(); } catch (java.sql.SQLFeatureNotSupportedException ex) { return java.util.logging.Logger.getGlobal(); } }
                            });
                            System.out.println("[AppConfig] Registered JDBC driver via DriverManager: " + driver);
                        } catch (Throwable t) {
                            System.err.println("[AppConfig] Failed to load or register JDBC driver: " + t.getMessage());
                            t.printStackTrace(System.err);
                        }
                    }
                }

                // List registered drivers for additional insight (printed to stdout)
                try {
                    java.util.Enumeration<java.sql.Driver> drivers = java.sql.DriverManager.getDrivers();
                    System.out.println("[AppConfig] Drivers registered with DriverManager:");
                    while (drivers.hasMoreElements()) {
                        java.sql.Driver d = drivers.nextElement();
                        System.out.println("  - " + d.getClass().getName() + " (classloader=" + (d.getClass().getClassLoader()) + ")");
                    }
                } catch (Throwable t) {
                    System.err.println("[AppConfig] Failed to enumerate DriverManager drivers: " + t.getMessage());
                }

                config.setJdbcUrl(jdbcUrl);
                config.setUsername(username);
                config.setPassword(password);
                config.setDriverClassName(driver);

                // Optional pool tuning
                config.setMaximumPoolSize(10);
                config.setMinimumIdle(2);
                config.setIdleTimeout(30000);
                config.setConnectionTimeout(30000);

                dataSource = new HikariDataSource(config);
            } catch (IOException e) {
                throw new RuntimeException("Failed to load DB config file", e);
            } catch (Exception e) {
                throw new RuntimeException("Failed to load DB config", e);
            }
        }
        return dataSource;
    }
}
