<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.gtu.dao.StudentDAO, com.gtu.model.Student" %>
        <% // Fetch enrollment parameter String enrollmentNo=request.getParameter("enrollmentNo"); Student student=null;
            if (enrollmentNo !=null && !enrollmentNo.trim().isEmpty()) { StudentDAO dao=new StudentDAO();
            student=dao.getStudentByEnrollment(enrollmentNo.trim()); } // Redirect back to login if student is not found
            or not provided if (student==null) { response.sendRedirect("login.jsp"); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Student Password Recovery – GTU</title>
                <!-- FontAwesome for icons -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <!-- Premium Font family Inter -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
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
                    .recovery-card {
                        background: #ffffff;
                        width: 100%;
                        max-width: 650px;
                        /* Spacious width to fit layout tables and agreement text */
                        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
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
                        background-color: #ff7e54;
                        /* Match GTU Orange */
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

                    /* Error/Success Alert Boxes */
                    .alert-box {
                        border-radius: 4px;
                        padding: 12px 15px;
                        margin-bottom: 20px;
                        font-size: 13px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        line-height: 1.5;
                    }

                    .alert-error {
                        background-color: #fee2e2;
                        color: #b91c1c;
                        border: 1px solid #fecaca;
                    }

                    .alert-success {
                        background-color: #ecfdf5;
                        color: #047857;
                        border: 1px solid #a7f3d0;
                    }

                    /* Structured Key-Value Table */
                    .details-table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 20px;
                        font-size: 13.5px;
                    }

                    .details-table th,
                    .details-table td {
                        padding: 12px 15px;
                        border: 1px solid #e5e7eb;
                        text-align: left;
                        vertical-align: top;
                    }

                    .details-table th {
                        background-color: #f9fafb;
                        color: #374151;
                        font-weight: 600;
                        width: 150px;
                    }

                    .details-table td {
                        color: #111827;
                    }

                    /* Styled inline link */
                    .inline-link {
                        color: #337ab7;
                        text-decoration: none;
                        font-size: 12px;
                        font-weight: 500;
                        margin-left: 5px;
                        display: inline-block;
                    }

                    .inline-link:hover {
                        text-decoration: underline;
                        color: #23527c;
                    }

                    /* Styled green link */
                    .green-link {
                        color: #198754;
                        /* Bootstrap success green */
                        text-decoration: none;
                        font-size: 12px;
                        font-weight: 600;
                        display: inline-block;
                    }

                    .green-link:hover {
                        text-decoration: underline;
                        color: #157347;
                        /* Darker green hover */
                    }

                    .note-subtext {
                        font-size: 11.5px;
                        color: #666;
                        margin-top: 4px;
                        font-style: italic;
                    }

                    /* Agreement Block & Detailed Text */
                    .agreement-block {
                        background-color: #fcfcfc;
                        border: 1px solid #e5e7eb;
                        border-radius: 4px;
                        padding: 15px;
                        margin-bottom: 20px;
                        max-height: 150px;
                        overflow-y: auto;
                        /* scrollable for legal text ease */
                    }

                    .checkbox-container {
                        display: flex;
                        align-items: flex-start;
                        gap: 10px;
                        cursor: pointer;
                        user-select: none;
                    }

                    .checkbox-container input {
                        margin-top: 3px;
                        cursor: pointer;
                    }

                    .checkbox-label {
                        font-size: 11.5px;
                        color: #4b5563;
                        line-height: 1.6;
                        text-align: justify;
                    }

                    /* Institute update link section */
                    .institute-update-section {
                        margin-bottom: 25px;
                        text-align: right;
                        font-size: 12px;
                        color: #555;
                    }

                    /* Captcha Block */
                    .captcha-section-wrapper {
                        background-color: #fff8f6;
                        border: 1px solid #ffe2db;
                        border-radius: 6px;
                        padding: 15px 20px;
                        margin-bottom: 25px;
                    }

                    .captcha-label {
                        display: block;
                        font-size: 13px;
                        font-weight: 600;
                        color: #374151;
                        margin-bottom: 8px;
                    }

                    .captcha-row {
                        display: flex;
                        align-items: center;
                        gap: 15px;
                    }

                    .captcha-input {
                        flex: 1;
                        max-width: 180px;
                    }

                    .form-control {
                        width: 100%;
                        padding: 10px 12px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        font-size: 13px;
                        color: #333;
                        outline: none;
                        transition: border-color 0.2s, box-shadow 0.2s;
                    }

                    .form-control:focus {
                        border-color: #ff7e54;
                        box-shadow: 0 0 0 2px rgba(255, 126, 84, 0.15);
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

                    /* Buttons footer alignment */
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

                    .btn-primary:disabled {
                        background-color: #ffbba3;
                        cursor: not-allowed;
                        box-shadow: none;
                    }

                    /* Spinner for loading state */
                    .spinner {
                        display: inline-block;
                        width: 14px;
                        height: 14px;
                        border: 2px solid rgba(255, 255, 255, .3);
                        border-radius: 50%;
                        border-top-color: #fff;
                        animation: spin 0.8s linear infinite;
                        margin-right: 8px;
                    }

                    @keyframes spin {
                        to {
                            transform: rotate(360deg);
                        }
                    }
                </style>
            </head>

            <body>

                <div class="recovery-card">
                    <!-- Header (GTU Logo and Title) -->
                    <div class="card-header">
                        <img src="../images/gtulogo.jpeg" alt="GTU Logo">
                        <h2>GUJARAT TECHNOLOGICAL UNIVERSITY<br><span
                                style="font-size: 14px; font-weight: normal; opacity: 0.9;">Forgot Password - Student
                                Recovery Portal</span></h2>
                    </div>

                    <div class="card-body">
                        <!-- Dynamic Notification Alerts -->
                        <div class="alert-box alert-error" id="recovery-error-alert" style="display: none;"></div>
                        <div class="alert-box alert-success" id="recovery-success-alert" style="display: none;"></div>

                        <!-- Form recovery container -->
                        <form id="recoveryForm" onsubmit="handlePasswordRecovery(event)">

                            <!-- Student Details Table -->
                            <table class="details-table" id="detailsTableContainer">
                                <tr>
                                    <th>Enrollment No</th>
                                    <td>
                                        <%= student.getEnrollmentNo() %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Name</th>
                                    <td>
                                        <%= student.getFullName() %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Email</th>
                                    <td>
                                        <%= student.getEmail() %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Mobile</th>
                                    <td>
                                        <span id="mobileText">
                                            <%= student.getMobile() %>
                                        </span>
                                        <a href="#" class="inline-link"
                                            onclick="alert('Please contact your college administrator to submit a request for updating your mobile number in the GTU database.')">Click
                                            Here, If it is not your mobile no. or you want to change your mobile no in
                                            GTU database.</a>
                                        <div class="note-subtext">(You will receive your password on this mobile no.)
                                        </div>
                                    </td>
                                </tr>
                            </table>

                            <!-- Legal Terms Scrollable Checkbox Agreement -->
                            <div class="agreement-block" id="agreementContainer">
                                <label class="checkbox-container">
                                    <input type="checkbox" id="agreementCheckbox" required>
                                    <span class="checkbox-label">
                                        I agree that I have submitted my own detail, the detail are right as per my
                                        confirmation. If this information will be wrong then I may be bound with legal
                                        affairs or advocate illegal activity. I am also confirmed that I register here
                                        for my own re-check/re-assess, if i found with registering other's information,
                                        then GTU can claim illegal activity to me. I must use every effort to keep my
                                        password safe and should not disclose it to any other person. I shall also not
                                        permit, either directly or indirectly, any other person to utilize my User ID or
                                        password. GTU not responsible, if any other person misuses the service by
                                        logging into your account.
                                    </span>
                                </label>
                            </div>

                            <!-- Institute Update Link (Only Click Here is green, other text is normal) -->
                            <div class="institute-update-section" id="instituteLinkContainer">
                                <a href="updatemobilenoemailinst.jsp?Mapreg=zKGEb3QbJ1%2bDaxwV4b7Z0A%3d%3d&stname=eNxmwPxykce%2fpzsRxSb2KzCHJbh4eiCRf0T0zdsVY2A%3d&enrollmentNo=<%= student.getEnrollmentNo() %>"
                                    class="green-link">Click Here</a>, To Update Mobile No. and Email-Id by Institute
                            </div>

                            <!-- Captcha code segment -->
                            <div class="captcha-section-wrapper" id="captchaSectionContainer">
                                <label class="captcha-label" for="recoveryCaptchaInput">Captcha Code</label>
                                <div class="captcha-row">
                                    <div class="captcha-input">
                                        <input type="text" class="form-control" id="recoveryCaptchaInput"
                                            placeholder="Captcha Code" required autocomplete="off">
                                    </div>
                                    <div class="captcha-box" id="recoveryCaptchaText">3985</div>
                                    <a href="#" class="refresh-icon" onclick="refreshRecoveryCaptcha(event)"
                                        title="Refresh Captcha">&#8635;</a>
                                </div>
                            </div>

                            <!-- Action Button Row -->
                            <div class="button-row">
                                <button type="button" class="btn btn-secondary"
                                    onclick="window.location.href='login.jsp'">Previous</button>
                                <button type="submit" class="btn btn-primary" id="recoverySubmitBtn">Get
                                    Password</button>
                            </div>

                        </form>
                    </div>
                </div>

                <script>
                    // Generate random 4-digit captcha
                    function generateRecoveryCaptcha() {
                        const captchaBox = document.getElementById('recoveryCaptchaText');
                        if (captchaBox) {
                            const randomNum = Math.floor(1000 + Math.random() * 9000);
                            captchaBox.innerText = randomNum;
                        }
                    }

                    function refreshRecoveryCaptcha(e) {
                        e.preventDefault();
                        generateRecoveryCaptcha();
                    }

                    // Initialize captcha on load
                    window.addEventListener('DOMContentLoaded', () => {
                        generateRecoveryCaptcha();
                    });

                    // Handle recovery submission
                    function handlePasswordRecovery(e) {
                        e.preventDefault();

                        const captchaInput = document.getElementById('recoveryCaptchaInput').value.trim();
                        const captchaText = document.getElementById('recoveryCaptchaText').innerText.trim();
                        const checkbox = document.getElementById('agreementCheckbox');

                        const errorAlert = document.getElementById('recovery-error-alert');
                        const successAlert = document.getElementById('recovery-success-alert');
                        const submitBtn = document.getElementById('recoverySubmitBtn');

                        errorAlert.style.display = 'none';
                        successAlert.style.display = 'none';

                        // Validate agreement checked
                        if (!checkbox.checked) {
                            errorAlert.innerHTML = '<i class="fas fa-exclamation-circle"></i> You must agree to the GTU terms and guidelines by checking the checkbox.';
                            errorAlert.style.display = 'flex';
                            return;
                        }

                        // Validate captcha
                        if (captchaInput !== captchaText) {
                            errorAlert.innerHTML = '<i class="fas fa-exclamation-circle"></i> Invalid Captcha Code. Please try again.';
                            errorAlert.style.display = 'flex';
                            generateRecoveryCaptcha();
                            document.getElementById('recoveryCaptchaInput').value = "";
                            document.getElementById('recoveryCaptchaInput').focus();
                            return;
                        }

                        // Mock successful recovery state
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<span class="spinner"></span>Processing Request...';

                        setTimeout(() => {
                            successAlert.innerHTML = '<i class="fas fa-check-circle"></i> Your password has been successfully sent to your registered mobile number: <strong>' + document.getElementById('mobileText').innerText + '</strong>.';
                            successAlert.style.display = 'flex';

                            // Hide input sections
                            document.getElementById('detailsTableContainer').style.display = 'none';
                            document.getElementById('agreementContainer').style.display = 'none';
                            document.getElementById('instituteLinkContainer').style.display = 'none';
                            document.getElementById('captchaSectionContainer').style.display = 'none';

                            // Hide submit button, only leave "Previous" button styled as Close/Back
                            submitBtn.style.display = 'none';
                        }, 1200); // Premium delay simulation
                    }
                </script>

            </body>

            </html>