package com.gtu.servlet;

import com.gtu.dao.StudentDAO;
import com.gtu.model.Student;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

/**
 * UpdateStudentServlet
 * 
 * Handles profile edits, mobile, email, and password updates.
 * URL: /UpdateStudentServlet
 */
@WebServlet("/UpdateStudentServlet")
public class UpdateStudentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student") == null) {
            response.sendRedirect(request.getContextPath() + "/studentportal/login.jsp");
            return;
        }

        Student student = (Student) session.getAttribute("student");
        String enrollmentNo = student.getEnrollmentNo();

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/studentportal/dashboard.jsp?status=error&message=No action specified");
            return;
        }

        StudentDAO dao = new StudentDAO();
        boolean success = false;
        String message = "";

        if ("updateProfile".equals(action)) {
            String dob = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String parentMobile = request.getParameter("parentMobile");
            String parentEmail = request.getParameter("parentEmail");
            String abcId = request.getParameter("abcId");
            String accountDetail = request.getParameter("accountDetail");
            String address = request.getParameter("address");

            success = dao.updateProfile(enrollmentNo, dob, gender, parentMobile, parentEmail, abcId, accountDetail, address);
            if (success) {
                message = "Profile details updated successfully.";
            } else {
                message = "Failed to update profile details.";
            }

        } else if ("updateMobile".equals(action)) {
            String newMobile = request.getParameter("newMobile");
            if (newMobile == null || newMobile.trim().isEmpty()) {
                message = "Mobile number cannot be empty.";
            } else {
                success = dao.updateMobile(enrollmentNo, newMobile);
                if (success) {
                    message = "Mobile number updated successfully.";
                } else {
                    message = "Failed to update mobile number.";
                }
            }

        } else if ("updateEmail".equals(action)) {
            String newEmail = request.getParameter("newEmail");
            if (newEmail == null || newEmail.trim().isEmpty()) {
                message = "Email address cannot be empty.";
            } else {
                success = dao.updateEmail(enrollmentNo, newEmail);
                if (success) {
                    message = "Email address updated successfully.";
                } else {
                    message = "Failed to update email address.";
                }
            }

        } else if ("resetPassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (currentPassword == null || newPassword == null || confirmPassword == null ||
                currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
                message = "All password fields are required.";
            } else if (!newPassword.equals(confirmPassword)) {
                message = "New password and confirmation password do not match.";
            } else {
                // Verify current password by attempting login
                if (dao.login(enrollmentNo, currentPassword) == null) {
                    message = "Incorrect current password.";
                } else {
                    success = dao.updatePassword(enrollmentNo, newPassword);
                    if (success) {
                        message = "Password updated successfully.";
                    } else {
                        message = "Failed to update password.";
                    }
                }
            }
        } else if ("updateAvatar".equals(action)) {
            String avatarData = request.getParameter("avatarData");
            if (avatarData == null || avatarData.trim().isEmpty()) {
                message = "No image data received.";
            } else {
                success = dao.updateProfileImage(enrollmentNo, avatarData);
                if (success) {
                    message = "Profile picture updated successfully.";
                } else {
                    message = "Failed to update profile picture.";
                }
            }
        }

        if (success) {
            // Update the setup.sql file directly
            com.gtu.dao.SQLFileUpdater.updateStudentInSQL(enrollmentNo);

            // Update the student object in the session with fresh database values
            Student updatedStudent = dao.getStudentByEnrollment(enrollmentNo);
            session.setAttribute("student", updatedStudent);
            response.sendRedirect(request.getContextPath() + "/studentportal/dashboard.jsp?status=success&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
        } else {
            response.sendRedirect(request.getContextPath() + "/studentportal/dashboard.jsp?status=error&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/studentportal/dashboard.jsp");
    }
}
