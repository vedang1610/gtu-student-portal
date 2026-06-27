<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.gtu.dao.StudentDAO, com.gtu.model.Student" %>
<%
    // Fetch enrollment parameter
    String enrollmentNo = request.getParameter("enrollmentNo");
    Student student = null;
    
    if (enrollmentNo != null && !enrollmentNo.trim().isEmpty()) {
        StudentDAO dao = new StudentDAO();
        student = dao.getStudentByEnrollment(enrollmentNo.trim());
    }
    
    // Redirect back to login if student is not found or not provided
    if (student == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Handle DB POST update request
    String successMessage = null;
    String errorMessage = null;
    boolean isSuccess = false;
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newEmail = request.getParameter("newEmail");
        String newMobile = request.getParameter("newMobile");
        String captchaInput = request.getParameter("captchaInput");
        String captchaText = request.getParameter("captchaText");

        if (newEmail == null || newEmail.trim().isEmpty() || newMobile == null || newMobile.trim().isEmpty()) {
            errorMessage = "New Email and New Mobile number are required.";
        } else if (captchaInput == null || !captchaInput.trim().equals(captchaText)) {
            errorMessage = "Invalid Captcha Code. Please try again.";
        } else {
            StudentDAO dao = new StudentDAO();
            boolean emailOk = dao.updateEmail(student.getEnrollmentNo(), newEmail.trim());
            boolean mobileOk = dao.updateMobile(student.getEnrollmentNo(), newMobile.trim());
            
            if (emailOk && mobileOk) {
                successMessage = "Your Data approved and updated successfully by institute";
                isSuccess = true;
                // Reload student object
                student = dao.getStudentByEnrollment(student.getEnrollmentNo());
            } else {
                errorMessage = "Failed to update information. Please verify your data and try again.";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request to Institute to Update Info – GTU</title>
    <!-- FontAwesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Premium Font family Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* CSS Reset and Global Styles */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Inter', Arial, Helvetica, sans-serif;
        }

        body {
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        /* Large Card (Big Modal Style on screen) */
        .request-card {
            background: #ffffff;
            width: 100%;
            max-width: 650px; /* Spacious width matching the recovery card */
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            border-radius: 8px;
            overflow: hidden;
            animation: slideDown 0.3s ease-out;
        }

        @keyframes slideDown {
            from {
                transform: translateY(-25px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        /* Header (Matching Login Card Theme) */
        .card-header {
            background-color: #ff7e54; /* Match GTU Orange */
            text-align: center;
            padding: 20px 30px;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .card-header img {
            width: 50px;
            height: auto;
        }

        .card-header h2 {
            font-size: 18px;
            font-weight: 600;
            text-align: left;
            line-height: 1.3;
        }

        .card-body {
            padding: 30px 40px;
        }

        /* Message Boxes */
        .message-box {
            border-radius: 4px;
            padding: 15px 20px;
            margin-bottom: 25px;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            line-height: 1.5;
            text-align: center;
            justify-content: center;
        }

        .message-error {
            background-color: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        .message-success {
            background-color: #ecfdf5;
            color: #047857;
            border: 1px solid #a7f3d0;
        }

        /* Readonly displays for student details */
        .details-display-block {
            border: 1px solid #e5e7eb;
            background-color: #f9fafb;
            border-radius: 6px;
            padding: 15px 20px;
            margin-bottom: 20px;
            font-size: 14.5px;
            color: #374151;
        }

        .details-row {
            display: flex;
            margin-bottom: 10px;
            line-height: 1.5;
        }

        .details-row:last-child {
            margin-bottom: 0;
        }

        .details-label {
            font-weight: 600;
            width: 150px;
        }

        .details-value {
            color: #111827;
        }

        /* Input Controls styling */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 13.5px;
            color: #333;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-control:focus {
            border-color: #ff7e54;
            box-shadow: 0 0 0 2px rgba(255, 126, 84, 0.15);
        }

        .note-subtext {
            font-size: 11.5px;
            color: #666;
            margin-top: 5px;
            line-height: 1.5;
        }

        /* Captcha Block */
        .captcha-section-wrapper {
            background-color: #fff8f6;
            border: 1px solid #ffe2db;
            border-radius: 6px;
            padding: 15px 20px;
            margin-bottom: 25px;
        }

        .captcha-row {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .captcha-input-container {
            flex: 1;
            max-width: 180px;
        }

        .captcha-box {
            width: 100px;
            padding: 9px;
            border: 1px solid #ff7e54;
            text-align: center;
            font-size: 18px;
            font-weight: bold;
            font-style: italic;
            letter-spacing: 2px;
            position: relative;
            background: #fff;
            color: #d84b20;
            user-select: none;
            border-radius: 4px;
        }

        /* Captcha strike line */
        .captcha-box::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 5%;
            right: 5%;
            border-top: 2px solid rgba(216, 75, 32, 0.6);
            transform: rotate(-6deg);
        }

        .refresh-icon {
            color: #ff7e54;
            cursor: pointer;
            font-size: 18px;
            text-decoration: none;
            transition: transform 0.2s;
        }

        .refresh-icon:hover {
            transform: rotate(30deg);
        }

        /* Footer buttons styling */
        .button-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #eee;
            padding-top: 20px;
        }

        .btn {
            padding: 10px 24px;
            border-radius: 4px;
            font-size: 13.5px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: background-color 0.2s, box-shadow 0.2s;
        }

        .btn-secondary {
            background-color: #f3f4f6;
            color: #4b5563;
            border: 1px solid #d1d5db;
        }

        .btn-secondary:hover {
            background-color: #e5e7eb;
        }

        .btn-primary {
            background-color: #ff7e54;
            color: #ffffff;
        }

        .btn-primary:hover {
            background-color: #e66a42;
            box-shadow: 0 2px 4px rgba(230, 106, 66, 0.2);
        }
    </style>
</head>
<body>

    <div class="request-card">
        <!-- Header (GTU Logo and Request Title) -->
        <div class="card-header">
            <img src="../images/gtulogo.jpeg" alt="GTU Logo">
            <h2>GUJARAT TECHNOLOGICAL UNIVERSITY<br><span style="font-size: 14px; font-weight: normal; opacity: 0.9;">Request to institute to update mobile and email Info</span></h2>
        </div>

        <div class="card-body">
            <!-- Dynamic Message Banners -->
            <% if (errorMessage != null) { %>
                <div class="message-box message-error">
                    <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
                </div>
            <% } %>

            <% if (successMessage != null) { %>
                <div class="message-box message-success">
                    <i class="fas fa-check-circle"></i> <%= successMessage %>
                </div>
            <% } %>

            <!-- Main Request Form -->
            <form id="updateRequestForm" method="post" action="updatemobilenoemailinst.jsp?Mapreg=<%= request.getParameter("Mapreg") %>&stname=<%= request.getParameter("stname") %>&enrollmentNo=<%= student.getEnrollmentNo() %>" onsubmit="return validateFormSubmit()">
                
                <!-- Display Readonly Student Identifiers -->
                <div class="details-display-block">
                    <div class="details-row">
                        <div class="details-label">Enrollment No. :</div>
                        <div class="details-value"><%= student.getEnrollmentNo() %></div>
                    </div>
                    <div class="details-row">
                        <div class="details-label">Name :</div>
                        <div class="details-value"><%= student.getFullName() %></div>
                    </div>
                </div>

                <% if (!isSuccess) { %>
                    <!-- Input fields only visible before successful update -->
                    <div class="form-group">
                        <label for="newEmail">New Email :</label>
                        <input type="email" class="form-control" id="newEmail" name="newEmail" placeholder="Enter new email address" required autocomplete="off">
                    </div>

                    <div class="form-group">
                        <label for="newMobile">New Mobile :</label>
                        <input type="tel" class="form-control" id="newMobile" name="newMobile" placeholder="Enter new mobile number" required autocomplete="off">
                        <div class="note-subtext">(After update your new mobile then you will receive you Verification code on this mobile no.)</div>
                    </div>

                    <!-- Captcha parameters -->
                    <input type="hidden" id="captchaText" name="captchaText" value="">

                    <div class="captcha-section-wrapper">
                        <label class="captcha-label" for="captchaInput">Captcha Code</label>
                        <div class="captcha-row">
                            <div class="captcha-input-container">
                                <input type="text" class="form-control" id="captchaInput" name="captchaInput" placeholder="Captcha Code" required autocomplete="off">
                            </div>
                            <div class="captcha-box" id="captchaBox">6129</div>
                            <a href="#" class="refresh-icon" onclick="refreshCaptcha(event)" title="Refresh Captcha">&#8635;</a>
                        </div>
                    </div>
                <% } %>

                <!-- Navigation buttons -->
                <div class="button-row">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='forgotPassword.jsp?enrollmentNo=<%= student.getEnrollmentNo() %>'">
                        <%= isSuccess ? "Back to Recovery" : "Previous" %>
                    </button>
                    <% if (!isSuccess) { %>
                        <button type="submit" class="btn btn-primary" id="submitBtn">Submit</button>
                    <% } %>
                </div>

            </form>
        </div>
    </div>

    <script>
        // Generate random 4-digit captcha code
        function generateCaptcha() {
            const captchaBox = document.getElementById('captchaBox');
            const hiddenCaptcha = document.getElementById('captchaText');
            if (captchaBox && hiddenCaptcha) {
                const randomNum = Math.floor(1000 + Math.random() * 9000);
                captchaBox.innerText = randomNum;
                hiddenCaptcha.value = randomNum;
            }
        }

        function refreshCaptcha(e) {
            e.preventDefault();
            generateCaptcha();
        }

        // Initialize captcha on load
        window.addEventListener('DOMContentLoaded', () => {
            generateCaptcha();
        });

        // Client-side verification check
        function validateFormSubmit() {
            const captchaInput = document.getElementById('captchaInput').value.trim();
            const captchaText = document.getElementById('captchaBox').innerText.trim();

            if (captchaInput !== captchaText) {
                alert("Invalid Captcha Code. Please try again.");
                generateCaptcha();
                document.getElementById('captchaInput').value = "";
                document.getElementById('captchaInput').focus();
                return false; // prevent submission
            }
            return true;
        }
    </script>

</body>
</html>
