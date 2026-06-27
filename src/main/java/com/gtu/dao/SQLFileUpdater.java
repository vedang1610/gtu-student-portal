package com.gtu.dao;

import com.gtu.model.Student;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SQLFileUpdater {

    private static String escape(String s) {
        if (s == null) return "";
        return s.replace("'", "\\'");
    }

    public static synchronized void updateStudentInSQL(String enrollmentNo) {
        try {
            // 1. Fetch password from database
            String password = "";
            String pwdSql = "SELECT password FROM students WHERE enrollment_no = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(pwdSql)) {
                ps.setString(1, enrollmentNo);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        password = rs.getString("password");
                    }
                }
            }

            // 2. Fetch student details
            Student student = new StudentDAO().getStudentByEnrollment(enrollmentNo);
            if (student == null) {
                System.err.println("SQLFileUpdater: Student not found in database: " + enrollmentNo);
                return;
            }

            String imageValue = "NULL";
            if (student.getProfileImage() != null && !student.getProfileImage().trim().isEmpty()) {
                imageValue = "'" + escape(student.getProfileImage()) + "'";
            }

            // 3. Format new SQL block
            String newBlock = String.format(Locale.US,
                "(\n" +
                "    '%s', '%s',\n" +
                "    '%s', '%s', '%s',\n" +
                "    '%s', '%s',\n" +
                "    '%s', '%s',\n" +
                "    '%s',\n" +
                "    %d, '%s', %.2f, %d, '%s',\n" +
                "    '%s', '%s', '%s', '%s', '%s', '%s', %s\n" +
                ")",
                escape(student.getEnrollmentNo()),
                escape(password),
                escape(student.getFullName()),
                escape(student.getEmail()),
                escape(student.getMobile()),
                escape(student.getDob()),
                escape(student.getGender()),
                escape(student.getBranch()),
                escape(student.getProgram()),
                escape(student.getCollegeName()),
                student.getCurrentSemester(),
                escape(student.getAdmissionYear()),
                student.getCgpa(),
                student.getBacklogs(),
                escape(student.getCategory()),
                escape(student.getAbcId()),
                escape(student.getAadhaarNo()),
                escape(student.getParentMobile()),
                escape(student.getParentEmail()),
                escape(student.getAccountDetail()),
                escape(student.getAddress()),
                imageValue
            );

            // 4. Locate and update setup.sql
            String projectDir = DBConnection.PROJECT_DIR;
            File sqlFile = new File(projectDir, "db/setup.sql");
            if (!sqlFile.exists()) {
                System.err.println("SQLFileUpdater: setup.sql not found at: " + sqlFile.getAbsolutePath());
                return;
            }

            String content = new String(Files.readAllBytes(sqlFile.toPath()), StandardCharsets.UTF_8);

            // Find start of the block
            int startIdx = -1;
            Pattern pattern = Pattern.compile("\\(\\r?\\n\\s*'" + Pattern.quote(enrollmentNo) + "'");
            Matcher matcher = pattern.matcher(content);
            if (matcher.find()) {
                startIdx = matcher.start();
            }

            if (startIdx != -1) {
                int depth = 0;
                int endIdx = -1;
                for (int i = startIdx; i < content.length(); i++) {
                    char c = content.charAt(i);
                    if (c == '(') {
                        depth++;
                    } else if (c == ')') {
                        depth--;
                        if (depth == 0) {
                            endIdx = i;
                            break;
                        }
                    }
                }

                if (endIdx != -1) {
                    String newContent = content.substring(0, startIdx) + newBlock + content.substring(endIdx + 1);
                    Files.write(sqlFile.toPath(), newContent.getBytes(StandardCharsets.UTF_8));
                    System.out.println("SQLFileUpdater: Successfully updated student " + enrollmentNo + " in setup.sql");
                } else {
                    System.err.println("SQLFileUpdater: Failed to locate matching closing parenthesis for student: " + enrollmentNo);
                }
            } else {
                System.err.println("SQLFileUpdater: Failed to locate student block in setup.sql for enrollment: " + enrollmentNo);
            }

        } catch (Exception e) {
            System.err.println("SQLFileUpdater: Error updating SQL file: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
