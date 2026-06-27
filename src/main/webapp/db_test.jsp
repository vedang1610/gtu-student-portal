<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.gtu.dao.DBConnection" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Diagnostic Panel</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background-color: #f7f9fa; color: #333; }
        .card { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); max-width: 800px; margin: 0 auto; }
        h2 { color: #ff7e54; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .status { padding: 10px; border-radius: 4px; font-weight: bold; margin-bottom: 15px; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        .btn { background-color: #ff7e54; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: bold; }
        .btn:hover { background-color: #e66a42; }
        pre { background: #f4f4f4; padding: 15px; border-radius: 4px; overflow-x: auto; font-size: 13px; }
    </style>
</head>
<body>

<div class="card">
    <h2>Database Connection & Diagnostic Panel</h2>

    <%
        String action = request.getParameter("action");
        String message = "";
        String errorMsg = "";
        boolean isConnected = false;

        // Verify connection first
        try (Connection conn = DBConnection.getConnection()) {
            isConnected = true;
        } catch (Exception e) {
            errorMsg = "Connection failed: " + e.getMessage();
        }
    %>

    <% if (isConnected) { %>
        <div class="status success">✓ Connected to Database Successfully</div>
    <% } else { %>
        <div class="status error">✗ Database Connection Failed: <%= errorMsg %></div>
    <% } %>

    <%
        // Handle Re-Initialization Action
        if ("initialize".equals(action) && isConnected) {
            try (Connection conn = DBConnection.getConnection()) {
                String sqlPath = DBConnection.PROJECT_DIR + "/db/setup.sql";
                File file = new File(sqlPath);
                if (!file.exists()) {
                    // Fallback check in web context
                    sqlPath = session.getServletContext().getRealPath("/") + "db/setup.sql";
                    file = new File(sqlPath);
                }

                if (file.exists()) {
                    try (Statement stmt = conn.createStatement();
                         BufferedReader br = new BufferedReader(new FileReader(file))) {
                        StringBuilder sb = new StringBuilder();
                        String line;
                        int statementsExecuted = 0;
                        int statementsFailed = 0;

                        // Temporary drop tables to allow clean schema setup
                        try {
                            stmt.execute("DROP TABLE IF EXISTS exam_subjects");
                            stmt.execute("DROP TABLE IF EXISTS exam_results");
                            stmt.execute("DROP TABLE IF EXISTS students");
                        } catch (Exception dropEx) {
                            // Ignore if tables don't exist yet
                        }

                        while ((line = br.readLine()) != null) {
                            String trimmed = line.trim();
                            if (trimmed.isEmpty() || trimmed.startsWith("--") || trimmed.startsWith("//") || trimmed.startsWith("#")) {
                                continue;
                            }
                            sb.append(line).append("\n");
                            if (trimmed.endsWith(";")) {
                                String sql = sb.toString().trim();
                                sql = sql.substring(0, sql.length() - 1).trim();
                                if (!sql.isEmpty()) {
                                    try {
                                        stmt.execute(sql);
                                        statementsExecuted++;
                                    } catch (SQLException e) {
                                        statementsFailed++;
                                    }
                                }
                                sb = new StringBuilder();
                            }
                        }
                        message = "Database schema initialized successfully! Executed: " + statementsExecuted + " statements (Failed: " + statementsFailed + ").";
                    }
                } else {
                    errorMsg = "SQL Setup Script not found at: " + sqlPath;
                }
            } catch (Exception e) {
                errorMsg = "Initialization error: " + e.getMessage();
            }
        }
    %>

    <% if (!message.isEmpty()) { %>
        <div class="status success"><%= message %></div>
    <% } %>
    <% if (!errorMsg.isEmpty()) { %>
        <div class="status error"><%= errorMsg %></div>
    <% } %>

    <h3>1. Database Statistics</h3>
    <table>
        <tr>
            <th>Table Name</th>
            <th>Row Count</th>
            <th>Status</th>
        </tr>
        <%
            if (isConnected) {
                String[] tables = {"students", "exam_results", "exam_subjects"};
                try (Connection conn = DBConnection.getConnection();
                     Statement stmt = conn.createStatement()) {
                    for (String table : tables) {
                        int count = -1;
                        String status = "Table Not Found";
                        try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + table)) {
                            if (rs.next()) {
                                count = rs.getInt(1);
                                status = "OK";
                            }
                        } catch (Exception e) {
                            // Table might not exist
                        }
        %>
                        <tr>
                            <td><strong><%= table %></strong></td>
                            <td><%= (count != -1) ? count : "N/A" %></td>
                            <td style="color: <%= "OK".equals(status) ? "green" : "red" %>; font-weight: bold;"><%= status %></td>
                        </tr>
        <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='3' class='error'>Error fetching stats: " + e.getMessage() + "</td></tr>");
                }
            }
        %>
    </table>

    <br>
    <h3>2. Actions</h3>
    <form method="post" action="db_test.jsp?action=initialize">
        <p>If the tables are empty or not initialized, click the button below to execute `db/setup.sql` directly on the cloud database:</p>
        <button type="submit" class="btn" onclick="return confirm('Warning: This will drop existing students tables and reset the schema. Proceed?')">
            Reset & Initialize Database Schema
        </button>
    </form>

    <br>
    <h3>3. Connection Parameters Check</h3>
    <pre>
PROJECT_DIR: <%= DBConnection.PROJECT_DIR %>
JDBC_DRIVER: com.mysql.cj.jdbc.Driver
DB_URL:      jdbc:mysql://setup-patelvedang20001016-581b.l.aivencloud.com:12250/defaultdb...
    </pre>
</div>

</body>
</html>
