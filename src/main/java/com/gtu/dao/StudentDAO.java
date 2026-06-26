package com.gtu.dao;

import com.gtu.model.Student;
import java.sql.*;

/**
 * StudentDAO - Data Access Object for Student table
 * All database queries related to students go here.
 */
public class StudentDAO {

    /**
     * Validates login credentials.
     * Returns a Student object if login is correct, null otherwise.
     */
    public Student login(String enrollmentNo, String password) {
        Student student = null;

        // NOTE: In production, NEVER store plain-text passwords.
        // Use BCrypt or SHA-256 hashing. For demo, plain-text is used.
        String sql = "SELECT * FROM students WHERE enrollment_no = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, enrollmentNo);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                student = mapResultSetToStudent(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return student;
    }

    /**
     * Fetch student by enrollment number (for profile page).
     */
    public Student getStudentByEnrollment(String enrollmentNo) {
        Student student = null;
        String sql = "SELECT * FROM students WHERE enrollment_no = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, enrollmentNo);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                student = mapResultSetToStudent(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return student;
    }

    /**
     * Maps a ResultSet row to a Student object.
     * Column names must match your 'students' table schema.
     */
    private Student mapResultSetToStudent(ResultSet rs) throws SQLException {
        return new Student(
            rs.getInt("id"),
            rs.getString("enrollment_no"),
            rs.getString("full_name"),
            rs.getString("email"),
            rs.getString("mobile"),
            rs.getString("dob"),
            rs.getString("gender"),
            rs.getString("branch"),
            rs.getString("program"),
            rs.getString("college_name"),
            rs.getInt("current_semester"),
            rs.getString("admission_year"),
            rs.getDouble("cgpa"),
            rs.getInt("backlogs"),
            rs.getString("category"),
            rs.getString("abc_id"),
            rs.getString("aadhaar_no"),
            rs.getString("parent_mobile"),
            rs.getString("parent_email"),
            rs.getString("account_detail"),
            rs.getString("address"),
            rs.getString("profile_image")
        );
    }

    /**
     * Updates student profile information.
     */
    public boolean updateProfile(String enrollmentNo, String dob, String gender, 
                                 String parentMobile, String parentEmail, 
                                 String abcId, String accountDetail, String address) {
        String sql = "UPDATE students SET dob = ?, gender = ?, parent_mobile = ?, " +
                     "parent_email = ?, abc_id = ?, account_detail = ?, address = ? WHERE enrollment_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dob);
            ps.setString(2, gender);
            ps.setString(3, parentMobile);
            ps.setString(4, parentEmail);
            ps.setString(5, abcId);
            ps.setString(6, accountDetail);
            ps.setString(7, address);
            ps.setString(8, enrollmentNo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates student mobile number.
     */
    public boolean updateMobile(String enrollmentNo, String newMobile) {
        String sql = "UPDATE students SET mobile = ? WHERE enrollment_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newMobile);
            ps.setString(2, enrollmentNo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates student email address.
     */
    public boolean updateEmail(String enrollmentNo, String newEmail) {
        String sql = "UPDATE students SET email = ? WHERE enrollment_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newEmail);
            ps.setString(2, enrollmentNo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates student password.
     */
    public boolean updatePassword(String enrollmentNo, String newPassword) {
        String sql = "UPDATE students SET password = ? WHERE enrollment_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, enrollmentNo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates student profile image.
     */
    public boolean updateProfileImage(String enrollmentNo, String profileImage) {
        String sql = "UPDATE students SET profile_image = ? WHERE enrollment_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, profileImage);
            ps.setString(2, enrollmentNo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Fetch exam results for a student and format it as a JSON string matching the original JS layout.
     */
    public String getStudentResultsJson(String enrollmentNo) {
        StringBuilder json = new StringBuilder();
        json.append("{\n");

        String resultsSql = "SELECT * FROM exam_results WHERE enrollment_no = ? ORDER BY id DESC";
        String subjectsSql = "SELECT * FROM exam_subjects WHERE exam_result_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psResults = conn.prepareStatement(resultsSql)) {

            psResults.setString(1, enrollmentNo);
            try (ResultSet rsResults = psResults.executeQuery()) {
                boolean firstResult = true;

                while (rsResults.next()) {
                    if (!firstResult) {
                        json.append(",\n");
                    }
                    firstResult = false;

                    int resultId = rsResults.getInt("id");
                    String examKey = rsResults.getString("exam_key");
                    String declaredDate = rsResults.getString("declared_date");
                    String examName = rsResults.getString("exam_name");
                    String semBacklog = rsResults.getString("sem_backlog");
                    String totBacklog = rsResults.getString("tot_backlog");
                    String spi = rsResults.getString("spi");
                    String cpi = rsResults.getString("cpi");
                    String cgpa = rsResults.getString("cgpa");
                    String examStatus = rsResults.getString("exam_status");
                    boolean passed = rsResults.getBoolean("passed");

                    json.append("  \"").append(examKey).append("\": {\n");
                    json.append("    \"declared\": \"").append(declaredDate).append("\",\n");
                    json.append("    \"name\": \"").append(examName).append("\",\n");
                    json.append("    \"subjects\": [\n");

                    try (PreparedStatement psSubjects = conn.prepareStatement(subjectsSql)) {
                        psSubjects.setInt(1, resultId);
                        try (ResultSet rsSubjects = psSubjects.executeQuery()) {
                            boolean firstSubject = true;
                            while (rsSubjects.next()) {
                                if (!firstSubject) {
                                    json.append(",\n");
                                }
                                firstSubject = false;

                                json.append("      {")
                                    .append("\"c\": \"").append(rsSubjects.getString("subject_code")).append("\", ")
                                    .append("\"n\": \"").append(rsSubjects.getString("subject_name")).append("\", ")
                                    .append("\"eA\": \"").append(rsSubjects.getString("ese_ab")).append("\", ")
                                    .append("\"te\": \"").append(rsSubjects.getString("theory_ese")).append("\", ")
                                    .append("\"tp\": \"").append(rsSubjects.getString("theory_pa")).append("\", ")
                                    .append("\"tt\": \"").append(rsSubjects.getString("theory_total")).append("\", ")
                                    .append("\"pe\": \"").append(rsSubjects.getString("practical_ese")).append("\", ")
                                    .append("\"pp\": \"").append(rsSubjects.getString("practical_pa")).append("\", ")
                                    .append("\"pt\": \"").append(rsSubjects.getString("practical_total")).append("\", ")
                                    .append("\"sg\": \"").append(rsSubjects.getString("subject_grade")).append("\"")
                                    .append("}");
                            }
                        }
                    }

                    json.append("\n    ],\n");
                    json.append("    \"semB\": \"").append(semBacklog).append("\",\n");
                    json.append("    \"totB\": \"").append(totBacklog).append("\",\n");
                    json.append("    \"spi\": \"").append(spi).append("\",\n");
                    json.append("    \"cpi\": \"").append(cpi).append("\",\n");
                    json.append("    \"cgpa\": \"").append(cgpa).append("\",\n");
                    json.append("    \"status\": \"").append(examStatus).append("\",\n");
                    json.append("    \"passed\": ").append(passed).append("\n");
                    json.append("  }");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        json.append("\n}");
        return json.toString();
    }

    public static class LatestResult {
        public String cpi = "0.00";
        public String cgpa = "0.00";
        public int lastSem = 1;
        public String examName = "";
    }

    public LatestResult getLatestExamResult(String enrollmentNo) {
        LatestResult res = new LatestResult();
        String sql = "SELECT cpi, cgpa, exam_key, exam_name FROM exam_results WHERE enrollment_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, enrollmentNo);
            try (ResultSet rs = ps.executeQuery()) {
                int maxSem = -1;
                while (rs.next()) {
                    String examKey = rs.getString("exam_key");
                    int sem = 1;
                    if (examKey != null) {
                        java.util.regex.Matcher m = java.util.regex.Pattern.compile("\\d+").matcher(examKey);
                        if (m.find()) {
                            sem = Integer.parseInt(m.group());
                        }
                    }
                    if (sem > maxSem) {
                        maxSem = sem;
                        res.cpi = rs.getString("cpi") != null ? rs.getString("cpi") : "0.00";
                        res.cgpa = rs.getString("cgpa") != null ? rs.getString("cgpa") : "0.00";
                        res.lastSem = sem;
                        res.examName = rs.getString("exam_name") != null ? rs.getString("exam_name") : "";
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }
}
