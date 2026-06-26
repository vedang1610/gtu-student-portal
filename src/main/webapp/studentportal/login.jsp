<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.gtu.model.Student" %>
<%
  Student loggedInStudent = (Student) session.getAttribute("student");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GTU Login Portal</title>
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
            padding: 10px;
            overflow: hidden;
        }

        /* Main Card Container */
        .login-card {
            background: #ffffff;
            width: 100%;
            max-width: 380px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            overflow: hidden;
            border-radius: 8px; /* Slightly smoother rounded corners for premium feel */
        }

        /* Header Section */
        .card-header {
            background-color: #ff7e54; /* Match GTU Orange */
            text-align: center;
            padding: 15px 15px;
            color: #ffffff;
        }

        .card-header img {
            width: 45px;
            height: auto;
            margin-bottom: 8px;
        }

        .card-header h2 {
            font-size: 15px;
            font-weight: 600; /* Match Inter weight */
            line-height: 1.3;
            letter-spacing: 0.5px;
        }

        /* Form Body Section */
        .card-body {
            padding: 15px 20px;
        }

        /* Error and success message styling */
        .login-error {
            background-color: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecaca;
            border-radius: 4px;
            padding: 10px 12px;
            margin-bottom: 10px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
            line-height: 1.4;
        }

        .login-success {
            background-color: #ecfdf5;
            color: #047857;
            border: 1px solid #a7f3d0;
            border-radius: 4px;
            padding: 10px 12px;
            margin-bottom: 10px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
            line-height: 1.4;
        }

        .input-group {
            margin-bottom: 10px;
        }

        .form-control {
            width: 100%;
            padding: 8px 10px;
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

        /* Captcha Row */
        .captcha-row {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
        }

        .captcha-input {
            flex: 1;
            margin-right: 15px;
        }

        .captcha-box {
            width: 90px;
            padding: 6px;
            border: 1px solid #ff7e54; /* Orange border matching theme */
            text-align: center;
            font-size: 16px;
            font-weight: bold;
            font-style: italic;
            letter-spacing: 2px;
            position: relative;
            background: #fff5f2;
            color: #d84b20;
            user-select: none;
            border-radius: 4px;
        }

        /* Strikethrough line for Captcha */
        .captcha-box::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 5%;
            right: 5%;
            border-top: 2px solid rgba(216, 75, 32, 0.6);
            transform: rotate(-8deg);
        }

        .refresh-icon {
            color: #ff7e54;
            cursor: pointer;
            font-size: 18px;
            margin-left: 10px;
            text-decoration: none;
            transition: transform 0.2s;
        }

        .refresh-icon:hover {
            transform: rotate(30deg);
        }

        /* Links and Buttons (Styled Blue as requested) */
        .forgot-password {
            text-align: right;
            margin-bottom: 10px;
        }

        .forgot-password a, 
        .create-account a {
            color: #337ab7; /* Standard Blue Color */
            text-decoration: none;
            font-size: 12px;
            font-weight: 500;
        }

        .forgot-password a:hover, 
        .create-account a:hover {
            text-decoration: underline;
            color: #23527c; /* Darker blue hover */
        }

        .submit-btn {
            width: 100%;
            padding: 9px;
            background-color: #ff7e54;
            color: #ffffff;
            border: none;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s, box-shadow 0.2s;
        }

        .submit-btn:hover {
            background-color: #e66a42;
            box-shadow: 0 2px 4px rgba(230, 106, 66, 0.2);
        }

        /* Informational Text Sections */
        .info-block {
            margin-top: 10px;
            text-align: center;
            font-size: 11.5px;
            color: #666;
            line-height: 1.4;
            border-top: 1px solid #eee;
            padding-top: 10px;
        }

        .info-block strong {
            color: #333;
        }

        .create-account {
            margin-top: 8px;
            text-align: center;
        }

        .note-block {
            margin-top: 10px;
            text-align: center;
            font-size: 11px;
            color: #666;
            line-height: 1.5;
            background-color: #fcfcfc;
            padding: 8px;
            border-radius: 4px;
            border: 1px dashed #ddd;
        }

        .faq-section {
            margin-top: 8px;
            text-align: center;
        }

        .faq-section a {
            color: #b91c1c;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
        }

        .faq-section a:hover {
            text-decoration: underline;
        }

        .footer-text {
            margin-top: 10px;
            text-align: center;
            font-size: 10.5px;
            color: #888;
        }

        /* Registration Modal Overlay */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.55);
            display: none; /* hidden by default */
            justify-content: center;
            align-items: center;
            z-index: 1000;
            backdrop-filter: blur(4px); /* Glassmorphic background blur */
            padding: 20px;
        }

        /* Modal Card layout (matches the login card theme) */
        .modal-card {
            background: #ffffff;
            width: 100%;
            max-width: 380px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            border-radius: 8px;
            overflow: hidden;
            animation: slideDown 0.3s ease-out;
        }

        @keyframes slideDown {
            from {
                transform: translateY(-30px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-header {
            background-color: #ff7e54; /* Match GTU Orange */
            text-align: center;
            padding: 25px 20px;
            color: #ffffff;
            position: relative; /* Enabled positioning for the close icon */
        }

        .modal-header h3 {
            font-size: 18px;
            font-weight: 600;
        }

        /* Top-right close icon styled nicely */
        .modal-close-icon {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 22px;
            color: #ffffff;
            cursor: pointer;
            opacity: 0.8;
            transition: opacity 0.2s, transform 0.2s;
            line-height: 1;
            user-select: none;
        }

        .modal-close-icon:hover {
            opacity: 1;
            transform: scale(1.1);
        }

        .modal-body {
            padding: 25px 30px;
        }

        /* Centered instruction text just above the input field */
        .modal-prompt-text {
            text-align: center;
            margin-bottom: 15px;
            font-size: 13px;
            color: #555;
            font-weight: 500;
            line-height: 1.4;
        }

        .modal-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 20px;
        }

        .modal-btn {
            padding: 10px 18px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: background-color 0.2s, box-shadow 0.2s;
        }

        .modal-btn-cancel {
            background-color: #f3f4f6;
            color: #4b5563;
            border: 1px solid #d1d5db;
        }

        .modal-btn-cancel:hover {
            background-color: #e5e7eb;
        }

        .modal-btn-submit {
            background-color: #ff7e54;
            color: #ffffff;
        }

        .modal-btn-submit:hover {
            background-color: #e66a42;
            box-shadow: 0 2px 4px rgba(230, 106, 66, 0.2);
        }

        /* Loading spinner for verification states */
        .spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 0.8s linear infinite;
            margin-right: 8px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body data-logged-in="<%= loggedInStudent != null %>">

    <!-- Session Expired Modal Overlay -->
    <div id="sessionExpiredModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.65); backdrop-filter:blur(5px); z-index:9999; justify-content:center; align-items:center; color:#333;">
        <div style="background:#fff; padding:30px; border-radius:8px; max-width:400px; width:90%; text-align:center; box-shadow:0 4px 15px rgba(0,0,0,0.2); font-family:'Inter', Arial, sans-serif;">
            <div style="color:#ff7e54; font-size:40px; margin-bottom:15px;">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3 style="margin-bottom:10px; font-size:18px; font-weight:600;">Session Expired</h3>
            <p style="font-size:14px; color:#666; margin-bottom:20px; line-height:1.5;">For your security, you have been logged out. Please click below to exit.</p>
            <button onclick="window.location.href='<%= request.getContextPath() %>/LogoutServlet'" style="background:#ff7e54; color:#fff; border:none; padding:10px 20px; border-radius:4px; font-size:14px; font-weight:600; cursor:pointer; width:100%; transition:background 0.2s;">
                Logout & Exit
            </button>
        </div>
    </div>

    <!-- Main Login Card -->
    <% if (loggedInStudent != null) { %>
    <div class="login-card">
        <div class="card-header">
            <img src="../images/gtulogo.jpeg" alt="GTU Logo" id="logoImage">
            <h2>GUJARAT TECHNOLOGICAL<br>UNIVERSITY.</h2>
        </div>
        <div class="card-body" style="text-align: center;">
            <div class="login-success" style="margin-bottom: 20px; display: flex; justify-content: center; gap: 8px;">
                <i class="fas fa-check-circle"></i> You are already logged in.
            </div>
            <p style="font-size: 14px; color: #333; margin-bottom: 10px;">
                Logged in as: <strong><%= loggedInStudent.getFullName() %></strong>
            </p>
            <p style="font-size: 13px; color: #666; margin-bottom: 25px;">
                Enrollment No: <strong><%= loggedInStudent.getEnrollmentNo() %></strong>
            </p>
            
            <button onclick="window.location.href='dashboard.jsp'" class="submit-btn" style="background-color: #2e7d32; margin-bottom: 12px; box-shadow: 0 2px 4px rgba(46, 125, 50, 0.2); height: auto; text-align: center; display: block; width: 100%;">
                <i class="fas fa-tachometer-alt"></i> Go to Dashboard
            </button>
            
            <button onclick="window.location.href='../LogoutServlet'" class="submit-btn" style="background-color: #d32f2f; box-shadow: 0 2px 4px rgba(211, 47, 47, 0.2); height: auto; text-align: center; display: block; width: 100%;">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </div>
    </div>
    <% } else { %>
    <div class="login-card">
        <div class="card-header">
            <!-- Points to our locally downloaded logo inside src/main/webapp/images/ -->
            <img src="../images/gtulogo.jpeg" alt="GTU Logo" id="logoImage">
            <h2>GUJARAT TECHNOLOGICAL<br>UNIVERSITY.</h2>
        </div>

        <div class="card-body">
            <!-- JSP Error Message Container -->
            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <div class="login-error" id="server-error-message">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
            <% } %>

            <!-- Dynamic JS Error Container -->
            <div class="login-error" id="js-error-message" style="display: none;"></div>

            <form id="loginForm" action="${pageContext.request.contextPath}/LoginServlet" method="post">
                <div class="input-group">
                    <input type="text" class="form-control" id="username" name="username" placeholder="Enrollment No/Username" required autocomplete="username">
                </div>
                <div class="input-group">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required autocomplete="current-password">
                </div>

                <div class="captcha-row">
                    <div class="captcha-input">
                        <input type="text" class="form-control" id="captchaInput" placeholder="Captcha Code" required autocomplete="off">
                    </div>
                    <div class="captcha-box" id="captchaText">1643</div>
                    <a href="#" class="refresh-icon" onclick="refreshCaptcha(event)" title="Refresh Captcha">&#8635;</a>
                </div>

                <div class="forgot-password">
                    <!-- Calls handleForgotPassword javascript check on click -->
                    <a href="forgotPassword.jsp" onclick="handleForgotPassword(event)">Forgot Password?</a>
                </div>

                <button type="submit" class="submit-btn"> Login </button>
            </form>

            <div class="note-block">
                <strong>Note :</strong> Students who have already registered themselves for recheck/reassessment can use the same username and password to login to this portal.
            </div>

            <div class="faq-section">
                <a href="../assets/StudentProfileGuideGTU.pdf" target="_blank">FAQs</a>
            </div>

            <div class="footer-text">
                Last Updated on- 22 Jun 2026 - S01
            </div>
        </div>
    </div>
    <% } %>

    <!-- Registration Modal Overlay -->
    <div class="modal-overlay" id="registerModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Student Profile Registration</h3>
                <!-- Close icon in the top right corner of the colored panel -->
                <span class="modal-close-icon" onclick="closeRegisterModal()">&times;</span>
            </div>
            <div class="modal-body">
                <!-- Modal Message Containers -->
                <div class="login-error" id="modal-error-message" style="display: none;"></div>
                <div class="login-success" id="modal-success-message" style="display: none;"></div>

                <form id="modalRegisterForm" onsubmit="handleRegistrationSubmit(event)">
                    <!-- Instruction prompt text centered just above the input field -->
                    <div class="modal-prompt-text" id="modalPromptText">
                        Enter your GTU Enrollment No.
                    </div>
                    
                    <div class="input-group" id="modalInputContainer">
                        <input type="text" class="form-control" id="modalEnrollmentNo" placeholder="Enrollment No" required autocomplete="off">
                    </div>
                    
                    <div class="modal-buttons">
                        <button type="button" class="modal-btn modal-btn-cancel" id="modalCancelBtn" onclick="closeRegisterModal()">Cancel</button>
                        <button type="submit" class="modal-btn modal-btn-submit" id="modalSubmitBtn">Submit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Track login state in localStorage for back button verification on secure pages
        const isLoggedIn = document.body.getAttribute('data-logged-in') === 'true';
        localStorage.setItem('isLoggedIn', isLoggedIn ? 'true' : 'false');

        if (isLoggedIn) {
            function checkSessionStatus() {
                if (localStorage.getItem('isLoggedIn') !== 'true') {
                    const modal = document.getElementById('sessionExpiredModal');
                    if (modal) {
                        modal.style.display = 'flex';
                    }
                }
            }

            window.addEventListener('pageshow', function(event) {
                checkSessionStatus();
            });

            // 20-minute session countdown timer
            setTimeout(function() {
                window.location.href = '<%= request.getContextPath() %>/LogoutServlet';
            }, 20 * 60 * 1000);
        }

        // Force reload from server on pageshow/back button
        window.addEventListener('pageshow', function(event) {
            if (event.persisted) {
                window.location.reload();
            }
        });

        // Generate a random 4-digit captcha code
        function generateCaptcha() {
            const captchaBox = document.getElementById('captchaText');
            if (captchaBox) {
                const randomNum = Math.floor(1000 + Math.random() * 9000);
                captchaBox.innerText = randomNum;
            }
        }

        // Handle captcha refresh button click
        function refreshCaptcha(e) {
            e.preventDefault();
            generateCaptcha();
        }

        // Initialize captcha on page load
        window.addEventListener('DOMContentLoaded', () => {
            generateCaptcha();
        });

        // Handle login form submission and perform client-side validation
        const loginForm = document.getElementById('loginForm');
        if (loginForm) {
            loginForm.addEventListener('submit', function(e) {
                const captchaInput = document.getElementById('captchaInput').value.trim();
                const captchaText = document.getElementById('captchaText').innerText.trim();
                
                // Hide previous server error if present
                const serverError = document.getElementById('server-error-message');
                if (serverError) {
                    serverError.style.display = 'none';
                }

                // Hide previous JS error
                const jsError = document.getElementById('js-error-message');
                jsError.style.display = 'none';

                if (captchaInput !== captchaText) {
                    e.preventDefault(); // Stop submission
                    
                    // Show JS captcha error
                    jsError.innerHTML = '<i class="fas fa-exclamation-circle"></i> Invalid Captcha Code. Please try again.';
                    jsError.style.display = 'flex';
                    
                    // Regenerate captcha and clear field
                    generateCaptcha();
                    document.getElementById('captchaInput').value = "";
                    document.getElementById('captchaInput').focus();
                }
            });
        }

        // Handle Forgot Password link click with alert validation
        function handleForgotPassword(e) {
            const username = document.getElementById('username').value.trim();
            const captchaInput = document.getElementById('captchaInput').value.trim();
            const captchaText = document.getElementById('captchaText').innerText.trim();

            if (!username || !captchaInput) {
                e.preventDefault();
                alert("Please Enter Enrollment Number and Captcha Code then click on Forgot Password.");
                return;
            }

            if (captchaInput !== captchaText) {
                e.preventDefault();
                alert("Invalid Captcha Code. Please try again.");
                generateCaptcha();
                document.getElementById('captchaInput').value = "";
                document.getElementById('captchaInput').focus();
                return;
            }

            // Captcha & enrollment number validated: go to forgotPassword.jsp
            e.preventDefault();
            window.location.href = "forgotPassword.jsp?enrollmentNo=" + encodeURIComponent(username);
        }

        // ==========================================
        // Registration Modal JavaScript Logic
        // ==========================================

        function openRegisterModal(e) {
            e.preventDefault(); // Stop default link jump
            const modal = document.getElementById('registerModal');
            
            // Clear prior states/messages/inputs
            document.getElementById('modalEnrollmentNo').value = "";
            document.getElementById('modal-error-message').style.display = 'none';
            document.getElementById('modal-success-message').style.display = 'none';
            document.getElementById('modalInputContainer').style.display = 'block';
            document.getElementById('modalPromptText').style.display = 'block'; // Reset prompt visibility
            
            // Reset buttons
            const submitBtn = document.getElementById('modalSubmitBtn');
            submitBtn.style.display = 'block';
            submitBtn.innerHTML = 'Submit';
            submitBtn.disabled = false;
            
            const cancelBtn = document.getElementById('modalCancelBtn');
            cancelBtn.innerHTML = 'Cancel';
            
            // Display modal
            modal.style.display = 'flex';
            document.getElementById('modalEnrollmentNo').focus();
        }

        function closeRegisterModal() {
            document.getElementById('registerModal').style.display = 'none';
        }

        // Mock validation for student profile registration
        function handleRegistrationSubmit(e) {
            e.preventDefault();
            const enrollmentInput = document.getElementById('modalEnrollmentNo').value.trim();
            
            const errorContainer = document.getElementById('modal-error-message');
            const successContainer = document.getElementById('modal-success-message');
            const submitBtn = document.getElementById('modalSubmitBtn');
            const cancelBtn = document.getElementById('modalCancelBtn');
            const inputContainer = document.getElementById('modalInputContainer');
            const promptText = document.getElementById('modalPromptText');

            errorContainer.style.display = 'none';
            successContainer.style.display = 'none';

            // List of valid test enrollment numbers in the database
            const validEnrollments = ['186640307036', '216640307036'];

            // Loading state
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner"></span>Verifying...';

            setTimeout(() => {
                if (validEnrollments.includes(enrollmentInput)) {
                    // Success Flow
                    successContainer.innerHTML = '<i class="fas fa-check-circle"></i> OTP has been successfully sent to your registered Email ID and Mobile Number. Please verify to complete registration.';
                    successContainer.style.display = 'flex';
                    
                    // Hide inputs, prompt, and submit button
                    inputContainer.style.display = 'none';
                    promptText.style.display = 'none';
                    submitBtn.style.display = 'none';
                    cancelBtn.innerHTML = 'Close';
                } else {
                    // Error Flow
                    errorContainer.innerHTML = '<i class="fas fa-exclamation-circle"></i> Enrollment number not found or not registered with GTU. Please verify your number.';
                    errorContainer.style.display = 'flex';
                    
                    // Reset submit button
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = 'Submit';
                }
            }, 1000); // 1-second simulated delay for a premium feel
        }
    </script>

</body>
</html>
