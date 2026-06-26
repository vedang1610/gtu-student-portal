package com.gtu.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * DBConnection - Handles H2 database connection for GTU Student Portal
 */
public class DBConnection {

    public static final String PROJECT_DIR = detectProjectDir();
    private static final String DB_USER = getEnvOrDefault("DB_USER", "avnadmin");
    private static final String DB_PASS = getEnvOrDefault("DB_PASS", "AVNS_tqrZqAsowc44WoezMmw");
    private static final String DB_URL = getEnvOrDefault("DB_URL", "jdbc:mysql://setup-patelvedang20001016-581b.l.aivencloud.com:12250/defaultdb?useSSL=true&allowPublicKeyRetrieval=true");
    private static final String JDBC_DRIVER = getEnvOrDefault("JDBC_DRIVER", "com.mysql.cj.jdbc.Driver");

    static {
        // Initialize database schema if it doesn't exist
        try {
            Class.forName(JDBC_DRIVER);
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                DatabaseMetaData meta = conn.getMetaData();
                boolean tableExists = false;
                try (ResultSet rs = meta.getTables(null, null, "students", null)) {
                    if (rs.next()) {
                        tableExists = true;
                    }
                }
                if (!tableExists) {
                    try (ResultSet rs = meta.getTables(null, null, "STUDENTS", null)) {
                        if (rs.next()) {
                            tableExists = true;
                        }
                    }
                }

                if (!tableExists) {
                    System.out.println("Database tables not found. Initializing schema...");
                    if (JDBC_DRIVER.contains("h2")) {
                        try (Statement stmt = conn.createStatement()) {
                            stmt.execute("RUNSCRIPT FROM '" + PROJECT_DIR + "/db/setup.sql'");
                            System.out.println("H2 database schema initialized successfully.");
                        }
                    } else {
                        executeSqlScript(conn, PROJECT_DIR + "/db/setup.sql");
                        System.out.println("MySQL database schema initialized successfully.");
                    }
                }

                // Update existing database data to match new college names
                try (Statement stmt = conn.createStatement()) {
                    stmt.executeUpdate(
                            "UPDATE students SET college_name = 'Atul Politech Collage' WHERE college_name = 'Sardar Patel College of Engineering, Bakrol'");
                    stmt.executeUpdate(
                            "UPDATE students SET college_name = 'Shree Swaminarayan Institute of Technology' WHERE college_name = 'L.D. College of Engineering, Ahmedabad'");
                }
            }
        } catch (Exception e) {
            System.err.println("Failed to initialize database: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(JDBC_DRIVER);
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC Driver not found: " + JDBC_DRIVER, e);
        }
    }

    private static void executeSqlScript(Connection conn, String filepath) throws Exception {
        java.io.File file = new java.io.File(filepath);
        if (!file.exists()) {
            System.err.println("SQL Script file not found: " + filepath);
            return;
        }
        try (Statement stmt = conn.createStatement();
                java.io.BufferedReader br = new java.io.BufferedReader(new java.io.FileReader(file))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                String trimmed = line.trim();
                if (trimmed.isEmpty() || trimmed.startsWith("--") || trimmed.startsWith("//")
                        || trimmed.startsWith("#")) {
                    continue;
                }
                sb.append(line).append("\n");
                if (trimmed.endsWith(";")) {
                    String sql = sb.toString().trim();
                    sql = sql.substring(0, sql.length() - 1).trim();
                    if (!sql.isEmpty()) {
                        try {
                            stmt.execute(sql);
                        } catch (SQLException e) {
                            System.err.println("Statement execution failed: " + sql);
                            System.err.println("Error: " + e.getMessage());
                        }
                    }
                    sb = new StringBuilder();
                }
            }
        }
    }

    private static String detectProjectDir() {
        // 1. Check environment variable
        String envPath = System.getenv("PROJECT_DIR");
        if (envPath != null && !envPath.isEmpty()) {
            return envPath.replace("\\", "/");
        }

        // 2. Check system property
        String propPath = System.getProperty("PROJECT_DIR");
        if (propPath != null && !propPath.isEmpty()) {
            return propPath.replace("\\", "/");
        }

        // 3. Try to locate based on class location
        try {
            java.net.URL url = DBConnection.class.getProtectionDomain().getCodeSource().getLocation();
            if (url != null) {
                java.io.File current = new java.io.File(url.toURI());
                while (current != null) {
                    // Check if current directory has db/setup.sql
                    java.io.File checkDirect = new java.io.File(current, "db/setup.sql");
                    if (checkDirect.exists()) {
                        return current.getAbsolutePath().replace("\\", "/");
                    }

                    // Check if current directory has a subdirectory (like gtudemo-main) containing
                    // db/setup.sql
                    java.io.File[] subDirs = current.listFiles(java.io.File::isDirectory);
                    if (subDirs != null) {
                        for (java.io.File sub : subDirs) {
                            java.io.File checkSub = new java.io.File(sub, "db/setup.sql");
                            if (checkSub.exists()) {
                                return sub.getAbsolutePath().replace("\\", "/");
                            }
                        }
                    }

                    current = current.getParentFile();
                }
            }
        } catch (Exception e) {
            System.err.println(
                    "DBConnection: Error auto-detecting project directory via class location: " + e.getMessage());
        }

        // 4. Fallback to user.dir
        String userDir = System.getProperty("user.dir");
        if (userDir != null) {
            try {
                java.io.File current = new java.io.File(userDir);
                while (current != null) {
                    java.io.File check = new java.io.File(current, "db/setup.sql");
                    if (check.exists()) {
                        return current.getAbsolutePath().replace("\\", "/");
                    }

                    java.io.File[] subDirs = current.listFiles(java.io.File::isDirectory);
                    if (subDirs != null) {
                        for (java.io.File sub : subDirs) {
                            java.io.File checkSub = new java.io.File(sub, "db/setup.sql");
                            if (checkSub.exists()) {
                                return sub.getAbsolutePath().replace("\\", "/");
                            }
                        }
                    }
                    current = current.getParentFile();
                }
            } catch (Exception e) {
                System.err.println(
                        "DBConnection: Error auto-detecting project directory via user.dir: " + e.getMessage());
            }
        }

        // 5. Ultimate fallback
        return "E:/gtudemo-main/gtudemo-main";
    }

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        return value;
    }
}
