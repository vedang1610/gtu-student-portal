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
    private static final String DB_USER = "sa";
    private static final String DB_PASS = "";
    private static final String DB_URL  = "jdbc:h2:~/gtu_student_db;MODE=MySQL;DATABASE_TO_UPPER=FALSE";
    private static final String JDBC_DRIVER = "org.h2.Driver";

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
                    System.out.println("H2 database tables not found. Initializing schema...");
                    try (Statement stmt = conn.createStatement()) {
                        stmt.execute("RUNSCRIPT FROM '" + PROJECT_DIR + "/db/setup.sql'");
                        System.out.println("H2 database schema initialized successfully.");
                    }
                }

                // Update existing database data to match new college names
                try (Statement stmt = conn.createStatement()) {
                    stmt.executeUpdate("UPDATE students SET college_name = 'Atul Politech Collage' WHERE college_name = 'Sardar Patel College of Engineering, Bakrol'");
                    stmt.executeUpdate("UPDATE students SET college_name = 'Shree Swaminarayan Institute of Technology' WHERE college_name = 'L.D. College of Engineering, Ahmedabad'");
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
            throw new SQLException("H2 JDBC Driver not found!", e);
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
                    
                    // Check if current directory has a subdirectory (like gtudemo-main) containing db/setup.sql
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
            System.err.println("DBConnection: Error auto-detecting project directory via class location: " + e.getMessage());
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
                System.err.println("DBConnection: Error auto-detecting project directory via user.dir: " + e.getMessage());
            }
        }
        
        // 5. Ultimate fallback
        return "E:/gtudemo-main/gtudemo-main";
    }
}
