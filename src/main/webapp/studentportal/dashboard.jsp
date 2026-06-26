<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.gtu.model.Student" %>
<%@ page import="com.gtu.dao.StudentDAO" %>
<%
  // Session security check
  Student student = (Student) session.getAttribute("student");
  if (student == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  // Calculate Term End safely
  String termEnd = "";
  try {
    int startYear = Integer.parseInt(student.getAdmissionYear());
    int years = (student.getProgram() != null && (student.getProgram().equalsIgnoreCase("DI") || student.getProgram().toLowerCase().contains("diploma"))) ? 3 : 4;
    termEnd = String.valueOf(startYear + years);
  } catch (Exception e) {
    termEnd = "2026";
  }

  // Fetch dynamic exam results JSON from the database
  String resultsJson = new StudentDAO().getStudentResultsJson(student.getEnrollmentNo());
  StudentDAO.LatestResult latestResult = new StudentDAO().getLatestExamResult(student.getEnrollmentNo());

  // Calculate Academic Status (Completed or Running)
  int finalSem = 8;
  if (student.getProgram() != null && (student.getProgram().equalsIgnoreCase("DI") || student.getProgram().toLowerCase().contains("diploma"))) {
    finalSem = 6;
  }
  int currentSem = student.getCurrentSemester();
  int lastAppearedSem = (latestResult != null) ? latestResult.lastSem : 0;
  boolean isCompleted = (currentSem >= finalSem) || (lastAppearedSem >= finalSem);
  String academicStatus = isCompleted ? "Completed" : "Running";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GTU Student Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS Reset and Variables */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        :root {
            --primary-orange: #ff7443;
            --sidebar-bg: #404a57;
            --sidebar-hover: #505c6a;
            --bg-light: #f2f5f9;
            --text-dark: #333;
            --text-light: #fff;
            --border-color: #ddd;
            --table-cyan: #5ce0e0;
        }

        body {
            background-color: var(--bg-light);
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
        }

        /* Top Header */
        .top-header {
            background-color: var(--primary-orange);
            color: var(--text-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 5px 20px;
            height: 45px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            z-index: 10;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 15px;
            font-weight: bold;
            font-size: 1rem;
        }

        .header-right button {
            background-color: #343a40;
            color: white;
            border: none;
            padding: 4px 12px;
            margin-left: 10px;
            border-radius: 3px;
            cursor: pointer;
            font-size: 0.8rem;
        }
        .header-right button:hover {
            background-color: #495057;
        }

        /* Main Container */
        .main-container {
            display: flex;
            flex: 1;
            overflow: hidden;
        }

        /* Sidebar */
        .sidebar {
            width: 230px;
            background-color: var(--sidebar-bg);
            color: var(--text-light);
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }

        .profile-section {
            padding: 15px 10px;
            text-align: center;
            border-bottom: 1px solid #555;
        }

        .profile-avatar-initial {
            width: 65px;
            height: 65px;
            border-radius: 50%;
            background-color: var(--primary-orange);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 8px auto;
            font-size: 1.8rem;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            border: 2px solid white;
        }

        .profile-avatar-initial:hover .avatar-hover-label {
            display: block !important;
        }

        .enrollment {
            font-size: 0.8rem;
            margin-bottom: 3px;
            font-weight: bold;
        }

        .student-name {
            font-size: 0.8rem;
            line-height: 1.2;
        }

        .nav-menu {
            list-style: none;
            flex: 1;
        }

        .nav-menu li a {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            color: #d1d5db;
            text-decoration: none;
            font-size: 0.8rem;
            border-left: 3px solid transparent;
        }

        .nav-menu li a i {
            width: 20px;
            text-align: center;
            margin-right: 8px;
        }

        .nav-menu li.active a {
            background-color: var(--primary-orange);
            color: white;
            border-left: 3px solid #c95c35;
        }

        .nav-menu li a:hover:not(.active) {
            background-color: var(--sidebar-hover);
            color: white;
        }

        /* Content Area */
        .content-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            background-color: white; 
        }

        /* ----- HOME VIEW CSS ----- */
        .home-view {
            background-color: var(--bg-light);
            min-height: 100%;
            display: flex;
            flex-direction: column;
        }

        .alert-banner {
            text-align: center;
            color: red;
            padding: 10px;
            font-weight: bold;
            font-size: 0.85rem;
        }

        .alert-success-banner {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            padding: 10px 20px;
            margin: 15px 15px 5px 15px;
            border-radius: 4px;
            font-size: 0.85rem;
        }

        .alert-error-banner {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            padding: 10px 20px;
            margin: 15px 15px 5px 15px;
            border-radius: 4px;
            font-size: 0.85rem;
        }

        .panels-wrapper {
            display: flex;
            padding: 20px 15px 15px 15px;
            gap: 15px;
            align-items: flex-start;
        }

        .panel {
            flex: 1;
            background: white;
            border: 1px solid var(--border-color);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .panel-header {
            background-color: var(--primary-orange);
            color: white;
            padding: 8px;
            text-align: center;
            font-weight: bold;
            font-size: 0.85rem;
        }

        .home-view table { width: 100%; border-collapse: collapse; font-size: 0.75rem; }
        .home-view table td { border: 1px solid var(--border-color); padding: 5px 10px; text-align: left; }
        .home-view table td:first-child { width: 35%; color: #555; background-color: #fafafa; }
        
        .edit-icon { float: right; color: #17a2b8; cursor: pointer; }

        .badge-blue { background-color: #007bff; color: white; padding: 2px 6px; border-radius: 3px; }
        .badge-completed { background-color: #28a745; color: white; padding: 2px 6px; border-radius: 3px; }
        .badge-green { background-color: #28a745; color: white; padding: 2px 6px; border-radius: 50%; width: 18px; height: 18px; display: inline-block; text-align: center; line-height: 14px;}

        /* ----- EDIT FORMS CSS ----- */
        .edit-view {
            display: none;
            padding: 20px;
            background-color: var(--bg-light);
            min-height: 100%;
        }

        .edit-form-container {
            width: 85%;
            margin: 0 auto;
            border: 1px solid #ccc;
            background: #fff;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            font-size: 0.8rem;
        }

        .edit-form-header {
            padding: 12px;
            color: #fff;
            text-align: center;
            font-weight: bold;
            font-size: 0.9rem;
        }
        
        .header-cyan { background-color: #5bc0de; }
        .header-green { background-color: #40c49d; }
        .header-red { background-color: #f05a5a; }

        .edit-form-info {
            text-align: center;
            color: #0000ee;
            font-size: 0.8rem;
            padding: 8px;
            border-bottom: 1px solid #ccc;
        }

        .edit-form-table { width: 100%; border-collapse: collapse; }
        .edit-form-table td { border: 1px solid #ccc; padding: 8px 12px; }
        .edit-form-table td:first-child { width: 25%; background-color: #fff; color: #333; }
        
        .edit-form-table input[type="text"], .edit-form-table input[type="password"] {
            width: 250px;
            padding: 4px;
            border: 1px solid #aaa;
        }
        
        .edit-form-table input[type="radio"] { margin-right: 3px; margin-left: 10px; vertical-align: middle;}
        .edit-form-table input[type="radio"]:first-child { margin-left: 0; }

        .verify-link {
            color: #337ab7;
            font-size: 0.75rem;
            text-decoration: none;
            display: block; /* Forces it to drop below the input */
            margin-top: 5px;
        }

        .edit-form-actions {
            text-align: center;
            padding: 12px;
            border-top: 1px solid #ccc;
        }

        .btn-green {
            background-color: #5cb85c;
            color: white;
            border: 1px solid #4cae4c;
            padding: 6px 15px;
            cursor: pointer;
            border-radius: 3px;
            margin: 0 5px;
            font-weight: bold;
        }
        .btn-green:hover { background-color: #449d44; }


        /* ----- RESULTS VIEW CSS ----- */
        .results-view {
            display: none;
            padding: 10px 30px;
            color: var(--text-dark);
        }

        .results-header-title { text-align: center; font-size: 1.1rem; font-weight: bold; margin-bottom: 5px; color: #444; }
        .control-group { display: flex; align-items: center; margin-bottom: 5px; font-size: 0.8rem; font-weight: bold; }
        .control-group label { width: 100px; }
        .control-group .inputs { display: flex; align-items: center; gap: 10px; }
        .radio-btn { font-weight: normal; }
        select { padding: 3px; font-size: 0.8rem; width: 230px; }
        
        .search-btn {
            background-color: #0078d7; color: white; border: none; padding: 4px 12px;
            border-radius: 3px; cursor: pointer; margin-left: 5px; font-weight: bold; font-size: 0.8rem;
        }

        .student-details { margin-top: 5px; margin-bottom: 10px; font-size: 0.75rem; line-height: 1.5; font-weight: bold; }
        .student-details span { font-weight: normal; margin-left: 15px; }

        .results-table { width: 100%; border-collapse: collapse; font-size: 0.7rem; margin-bottom: 10px; }
        .results-table th, .results-table td { border: 1px solid #aaa; padding: 4px; text-align: center; }
        .results-table th { background-color: var(--table-cyan); color: #444; font-weight: bold; }
        .results-table td:nth-child(2) { text-align: left; }
        .table-footer { background-color: #f9f9f9; font-weight: bold; }

        .status-banner { border: 1px solid #f39c12; padding: 5px; text-align: center; font-weight: bold; font-size: 0.85rem; margin-bottom: 5px; }
        .status-pass { color: #28a745; }
        .status-fail { color: #dc3545; }

        .print-btn { text-align: center; margin-bottom: 10px; }
        .print-btn a { color: #0078d7; text-decoration: underline; font-size: 0.8rem; cursor: pointer; border: 1px solid #b3d4fc; padding: 2px 15px; display: inline-block; }

        /* Footer */
        .footer { background-color: var(--primary-orange); color: white; text-align: center; padding: 5px; font-size: 0.75rem; margin-top: auto; width: 100%; }

        /* Print Media Styles */
        @media print {
            body {
                background-color: white !important;
                color: black !important;
            }
            .top-header, .sidebar, .footer, .control-group, .print-btn, .home-view, .edit-view {
                display: none !important;
            }
            .main-container, .content-area {
                display: block !important;
                padding: 0 !important;
                margin: 0 !important;
                border: none !important;
                box-shadow: none !important;
            }
            .results-view {
                display: block !important;
                position: static !important;
                width: 100% !important;
                padding: 0 !important;
                margin: 0 !important;
                box-shadow: none !important;
                background: white !important;
            }
            .results-table th {
                background-color: #5ce0e0 !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
            .status-banner {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
            .results-header-title {
                color: black !important;
                font-size: 1.4rem !important;
                font-weight: bold !important;
                margin-bottom: 15px !important;
            }
            .results-header-title span {
                color: black !important;
                font-size: 1.8rem !important;
                font-weight: bold !important;
            }
            .print-only-college {
                display: block !important;
            }
        }
    </style>
</head>
<body>

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

    <header class="top-header">
        <div class="header-left">
            <i class="fas fa-bars"></i>
            <span>GUJARAT TECHNOLOGICAL UNIVERSITY</span>
        </div>
        <div class="header-right">
            <span id="header-timer-display" style="font-family: monospace; font-size: 0.9rem; font-weight: bold; background-color: rgba(255, 255, 255, 0.2); padding: 4px 8px; border-radius: 3px; color: white; display: inline-flex; align-items: center; gap: 5px; vertical-align: middle; margin-right: 5px;">
                <i class="fas fa-clock"></i> 20:00
            </span>
            <button onclick="openEdit('password')">Reset Password</button>
            <button onclick="window.location.href='../LogoutServlet'">Logout</button>
        </div>
    </header>

    <div class="main-container">
        
        <aside class="sidebar">
            <div class="profile-section">
                <form id="avatarForm" action="${pageContext.request.contextPath}/UpdateStudentServlet" method="post" style="margin: 0; padding: 0;">
                    <input type="hidden" name="action" value="updateAvatar">
                    <input type="hidden" name="avatarData" id="avatarData">
                    <input type="file" id="avatarFile" accept="image/*" style="display: none;" onchange="handleAvatarFileChange(this)">
                    
                    <div class="profile-avatar-initial" onclick="document.getElementById('avatarFile').click()" style="cursor: pointer; position: relative; overflow: hidden;" title="Click to upload profile picture">
                        <% if (student.getProfileImage() != null && !student.getProfileImage().trim().isEmpty()) { %>
                            <img src="<%= student.getProfileImage() %>" style="width: 100%; height: 100%; object-fit: cover;" id="sidebar-avatar-img">
                        <% } else { %>
                            <%= student.getFullName() != null && !student.getFullName().trim().isEmpty() ? student.getFullName().trim().substring(0, 1).toUpperCase() : "S" %>
                        <% } %>
                        <div style="position: absolute; bottom: 0; left: 0; right: 0; background: rgba(0,0,0,0.5); color: white; font-size: 8px; padding: 2px 0; display: none; font-weight: normal; line-height: 1.2;" class="avatar-hover-label">Edit</div>
                    </div>
                </form>
                <div class="enrollment"><%= student.getEnrollmentNo() %></div>
                <div class="student-name"><%= student.getFullName() %></div>
            </div>
            <ul class="nav-menu">
                <li id="nav-home" class="active"><a href="#"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="#"><i class="fas fa-certificate"></i> Certificate Request</a></li>
                <li><a href="#"><i class="fas fa-book"></i> Syllabus Endorsement</a></li>
                <li><a href="#"><i class="fas fa-file-alt"></i> Examform</a></li>
                <li><a href="#"><i class="fas fa-copy"></i> Answer Sheet View</a></li>
                <li><a href="#"><i class="fas fa-graduation-cap"></i> Convocation</a></li>
                <li><a href="#"><i class="fas fa-history"></i> Recheck/Reassess History</a></li>
                <li><a href="#"><i class="fas fa-id-card"></i> Degree Verification</a></li>
                <li><a href="#"><i class="fas fa-chart-line"></i> Marksheet Tracker</a></li>
                <li><a href="#"><i class="fas fa-search"></i> Certificate Tracking</a></li>
                <li id="nav-results"><a href="#"><i class="fas fa-poll"></i> My Results</a></li>
                <li><a href="#"><i class="fas fa-star"></i> Grade History</a></li>
                <li><a href="#"><i class="fas fa-laptop"></i> MOOCs Registration</a></li>
                <li><a href="#"><i class="fas fa-file-signature"></i> MBMR Applications</a></li>
                <li><a href="#"><i class="fas fa-rupee-sign"></i> Check Payment Status</a></li>
                <li><a href="#"><i class="fas fa-list"></i> View my last 10 logs</a></li>
            </ul>
        </aside>

        <main class="content-area">
            
            <!-- UPDATE STATUS BANNERS -->
            <%
              String status = request.getParameter("status");
              String msg = request.getParameter("message");
              if (status != null && msg != null) {
                String alertClass = "success".equals(status) ? "alert-success-banner" : "alert-error-banner";
            %>
              <div class="<%= alertClass %>" id="alert-status-banner">
                  <i class="fas <%= "success".equals(status) ? "fa-check-circle" : "fa-exclamation-circle" %>"></i>
                  <%= msg %>
                  <span style="float: right; cursor: pointer; font-weight: bold;" onclick="document.getElementById('alert-status-banner').style.display='none'">&times;</span>
              </div>
            <%
              }
            %>

            <div id="home-view" class="home-view" style="display: flex;">
                <% if (student.getAccountDetail() == null || student.getAccountDetail().trim().isEmpty()) { %>
                <div class="alert-banner" onclick="openEdit('profile')" style="cursor: pointer;">
                    Click here to submit your Bank Account Details.
                </div>
                <% } %>
                <div class="panels-wrapper">
                    <div class="panel">
                        <div class="panel-header">Personal Info</div>
                        <div style="padding: 10px;">
                            <table>
                                <tbody>
                                    <tr><td>Name :</td><td><%= student.getFullName() %></td></tr>
                                    <tr><td>ABC ID :</td><td><%= student.getAbcId() != null ? student.getAbcId() : "" %> <i class="fas fa-edit edit-icon" onclick="openEdit('profile')"></i></td></tr>
                                    <tr><td>Aadhaar No :</td><td><%= student.getAadhaarNo() != null ? student.getAadhaarNo() : "" %> <i class="fas fa-edit edit-icon" onclick="openEdit('profile')"></i></td></tr>
                                    <tr><td>Date of Birth :</td><td><%= student.getDob() != null ? student.getDob() : "" %> <i class="fas fa-edit edit-icon" onclick="openEdit('profile')"></i></td></tr>
                                    <tr><td>Gender :</td><td><%= student.getGender() != null ? student.getGender() : "" %> <i class="fas fa-edit edit-icon" onclick="openEdit('profile')"></i></td></tr>
                                    <tr><td>Mobile No :</td><td><%= student.getMobile() != null ? student.getMobile() : "" %> <i class="fas fa-edit edit-icon" onclick="openEdit('mobile')"></i></td></tr>
                                    <tr><td>Email :</td><td><%= student.getEmail() != null ? student.getEmail() : "" %> <i class="fas fa-edit edit-icon" onclick="openEdit('email')"></i></td></tr>
                                    <tr><td>Parent's Mobile No. :</td><td><%= student.getParentMobile() != null ? student.getParentMobile() : "" %> <i class="fas fa-edit edit-icon" onclick="openEdit('profile')"></i></td></tr>
                                    <tr><td>Parent's Email :</td><td><%= student.getParentEmail() != null ? student.getParentEmail() : "" %> <i class="fas fa-edit edit-icon" onclick="openEdit('profile')"></i></td></tr>
                                    <tr><td>Account Detail :</td><td><%= student.getAccountDetail() != null ? student.getAccountDetail() : "" %> <i class="fas fa-edit edit-icon" onclick="openEdit('profile')"></i></td></tr>
                                    <tr><td>Password :</td><td>********** <i class="fas fa-edit edit-icon" onclick="openEdit('password')"></i></td></tr>
                                    <tr><td>Address :</td><td><%= student.getAddress() != null ? student.getAddress() : "" %> <i class="fas fa-edit edit-icon" onclick="openEdit('profile')"></i></td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="panel">
                        <div class="panel-header">Academic Info</div>
                        <div style="padding: 10px;">
                            <table>
                                <tbody>
                                    <tr><td>Course:</td><td><%= student.getProgram() %></td></tr>
                                    <tr><td>Branch:</td><td><%= student.getBranch() %></td></tr>
                                    <tr><td>College:</td><td><%= student.getCollegeName() %></td></tr>
                                     <tr><td>Academic Status:</td><td>
                                         <span class="<%= academicStatus.equals("Completed") ? "badge-completed" : "badge-blue" %>">
                                             <%= academicStatus %>
                                         </span>
                                     </td></tr>
                                    <tr><td>Last Appeared Exam:</td><td><%= latestResult.examName %></td></tr>
                                    <tr><td>CPI:</td><td><%= latestResult.cpi %></td></tr>
                                    <tr><td>CGPA:</td><td><%= latestResult.cgpa %></td></tr>
                                    <tr><td>Final Sem:</td><td><span class="badge-green"><%= latestResult.lastSem %></span></td></tr>
                                    <tr><td>Term End:</td><td><%= termEnd %></td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- EDIT PROFILE VIEW -->
            <div id="edit-profile-view" class="edit-view">
                <div class="edit-form-container">
                    <div class="edit-form-header header-cyan">Edit Profile Info</div>
                    <div class="edit-form-info">Please submit your latest/valid information here.</div>
                    <form action="${pageContext.request.contextPath}/UpdateStudentServlet" method="post">
                        <input type="hidden" name="action" value="updateProfile">
                        <table class="edit-form-table">
                            <tr>
                                <td>Aadhaar No.:</td>
                                <td><input type="text" name="aadhaarNo" value="<%= student.getAadhaarNo() != null ? student.getAadhaarNo() : "" %>" readonly style="background-color: #f5f5f5;"> (Read-Only)</td>
                            </tr>
                            <tr>
                                <td>ABC ID:</td>
                                <td><input type="text" name="abcId" value="<%= student.getAbcId() != null ? student.getAbcId() : "" %>" required></td>
                            </tr>
                            <tr>
                                <td>Date of Birth:</td>
                                <td><input type="text" name="dob" value="<%= student.getDob() != null ? student.getDob() : "" %>" required></td>
                            </tr>
                            <tr>
                                <td>Gender:</td>
                                <td>
                                    <input type="radio" name="gender" value="Female" <%= "Female".equalsIgnoreCase(student.getGender()) ? "checked" : "" %>>Female 
                                    <input type="radio" name="gender" value="Male" <%= "Male".equalsIgnoreCase(student.getGender()) || student.getGender() == null ? "checked" : "" %>>Male 
                                    <input type="radio" name="gender" value="Other" <%= "Other".equalsIgnoreCase(student.getGender()) ? "checked" : "" %>>Other
                                </td>
                            </tr>
                            <tr>
                                <td>Parent's Mobile No.:</td>
                                <td><input type="text" name="parentMobile" value="<%= student.getParentMobile() != null ? student.getParentMobile() : "" %>" required></td>
                            </tr>
                            <tr>
                                <td>Parent's Email:</td>
                                <td><input type="text" name="parentEmail" value="<%= student.getParentEmail() != null ? student.getParentEmail() : "" %>" style="width: 350px;" required></td>
                            </tr>
                            <tr>
                                <td>Bank Account Detail:</td>
                                <td><input type="text" name="accountDetail" value="<%= student.getAccountDetail() != null ? student.getAccountDetail() : "" %>" style="width: 350px;" required></td>
                            </tr>
                            <tr>
                                <td>Address:</td>
                                <td><input type="text" name="address" value="<%= student.getAddress() != null ? student.getAddress() : "" %>" style="width: 350px;" required></td>
                            </tr>
                        </table>
                        <div class="edit-form-actions">
                            <button type="submit" class="btn-green">Submit Profile</button>
                            <button type="button" class="btn-green" onclick="showHome()">Back to Home</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- EDIT MOBILE VIEW -->
            <div id="edit-mobile-view" class="edit-view">
                <div class="edit-form-container">
                    <div class="edit-form-header header-green">Update Registered Mobile No</div>
                    <form action="${pageContext.request.contextPath}/UpdateStudentServlet" method="post">
                        <input type="hidden" name="action" value="updateMobile">
                        <table class="edit-form-table">
                            <tr>
                                <td>Current Mobile No.:</td>
                                <td><%= student.getMobile() != null ? student.getMobile() : "" %></td>
                            </tr>
                            <tr>
                                <td>New Mobile No</td>
                                <td>
                                    <input type="text" name="newMobile" style="width: 100%;" required>
                                    <a href="#" class="verify-link" onclick="alert('Mock Verification OTP has been sent to the new mobile number!')">Verify</a>
                                </td>
                            </tr>
                            <tr>
                                <td>Verification Code</td>
                                <td><input type="text" style="width: 100%;" placeholder="Enter any 4-digit code (e.g. 1234)"></td>
                            </tr>
                        </table>
                        <div class="edit-form-actions">
                            <button type="submit" class="btn-green">Update</button>
                            <button type="button" class="btn-green" onclick="showHome()">Back to Home</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- EDIT EMAIL VIEW -->
            <div id="edit-email-view" class="edit-view">
                <div class="edit-form-container">
                    <div class="edit-form-header header-red">Update Registered Email Id</div>
                    <form action="${pageContext.request.contextPath}/UpdateStudentServlet" method="post">
                        <input type="hidden" name="action" value="updateEmail">
                        <table class="edit-form-table">
                            <tr>
                                <td>Email:</td>
                                <td><%= student.getEmail() != null ? student.getEmail() : "" %></td>
                            </tr>
                            <tr>
                                <td>New Email Id</td>
                                <td>
                                    <input type="text" name="newEmail" style="width: 100%;" required>
                                    <a href="#" class="verify-link" onclick="alert('Mock Verification OTP has been sent to the new email address!')">Verify</a>
                                </td>
                            </tr>
                            <tr>
                                <td>Verification Code</td>
                                <td><input type="text" style="width: 100%;" placeholder="Enter any 4-digit code (e.g. 1234)"></td>
                            </tr>
                        </table>
                        <div class="edit-form-actions">
                            <button type="submit" class="btn-green">Submit</button>
                            <button type="button" class="btn-green" onclick="showHome()">Back to Home</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- RESET PASSWORD VIEW -->
            <div id="edit-password-view" class="edit-view">
                <div class="edit-form-container">
                    <div class="edit-form-header" style="background-color: #343a40;">Reset Password</div>
                    <form action="${pageContext.request.contextPath}/UpdateStudentServlet" method="post">
                        <input type="hidden" name="action" value="resetPassword">
                        <table class="edit-form-table">
                            <tr>
                                <td>Current Password:</td>
                                <td><input type="password" name="currentPassword" required></td>
                            </tr>
                            <tr>
                                <td>New Password:</td>
                                <td><input type="password" name="newPassword" required></td>
                            </tr>
                            <tr>
                                <td>Confirm New Password:</td>
                                <td><input type="password" name="confirmPassword" required></td>
                            </tr>
                        </table>
                        <div class="edit-form-actions">
                            <button type="submit" class="btn-green">Update Password</button>
                            <button type="button" class="btn-green" onclick="showHome()">Back to Home</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- RESULTS VIEW -->
            <div id="results-view" class="results-view">
                <div class="results-header-title">
                    <span style="color: #666; font-size: 1.3rem;">GUJARAT TECHNOLOGICAL UNIVERSITY</span><br>
                    Student Result
                </div>
                <hr style="border: 0; border-top: 1px solid #ddd; margin-bottom: 10px;">

                <div class="control-group">
                    <label>Select Session</label>
                    <div class="inputs">
                        <span class="radio-btn"><input type="radio" name="session" checked> Current (S2025)</span>
                        <span class="radio-btn"><input type="radio" name="session"> Archive</span>
                    </div>
                </div>
                <div class="control-group">
                    <label>Exam</label>
                    <div class="inputs">
                        <select id="exam-select">
                            <option value="sem6_reg">DIPL SEM 6 - Regular (MAY 2022)</option>
                            <option value="sem5_reg">DIPL SEM 5 - Regular (DEC 2021)</option>
                            <option value="sem4_reg">DIPL SEM 4 - Regular (MAY 2021)</option>
                            <option value="sem3_rem">DIPL SEM 3 - Remedial (MAY 2021)</option>
                            <option value="sem3_reg">DIPL SEM 3 - Regular (JAN 2021)</option>
                            <option value="sem2_reg">DIPL SEM 2 - Regular (MAY 2020)</option>
                            <option value="sem1_rem">DIPL SEM 1 - Remedial (DEC 2019)</option>
                            <option value="sem1_reg">DIPL SEM 1 - Regular (DEC 2018)</option>
                        </select>
                        <button class="search-btn" onclick="renderResult()">Search</button>
                    </div>
                </div>

                <div class="student-details">
                    <div>Name <span><%= student.getFullName() %></span></div>
                    <div>Enrollment No. <span><%= student.getEnrollmentNo() %></span></div>
                    <div>Declared On <span id="lbl-declared">30 Jul 2022</span></div>
                    <div>Exam <span id="lbl-exam">DIPL SEM 6 - Regular (MAY 2022)</span></div>
                    <div>Branch <span><%= student.getBranch() %></span></div>
                    <div class="print-only-college" style="display: none;">College Name <span><%= student.getCollegeName() %></span></div>
                </div>

                <table class="results-table">
                    <thead>
                        <tr>
                            <th rowspan="2" style="width:10%">SUBJECT CODE</th>
                            <th rowspan="2" style="text-align: left; width: 40%">SUBJECT NAME</th>
                            <th rowspan="2" style="width:8%">ESE ABSENT</th>
                            <th colspan="3">Theory Grade</th>
                            <th colspan="3">Practical Grade</th>
                            <th rowspan="2" style="width:8%">Subject Grade</th>
                        </tr>
                        <tr>
                            <th>ESE</th><th>PA</th><th>TOTAL</th>
                            <th>ESE</th><th>PA</th><th>TOTAL</th>
                        </tr>
                    </thead>
                    <tbody id="results-tbody">
                    </tbody>
                    <tfoot class="table-footer">
                        <tr>
                            <td colspan="3" id="lbl-sem-backlog" style="text-align: center;">Current Sem. Backlog: 0</td>
                            <td colspan="3" id="lbl-tot-backlog" style="text-align: center;">Total Backlog: 0</td>
                            <td colspan="2" id="lbl-spi" style="text-align: center;">SPI: 7.84</td>
                            <td colspan="3" id="lbl-cpi-cgpa" style="text-align: center;">CPI: 7.54 &nbsp;&nbsp;&nbsp;&nbsp; CGPA: 7.51</td>
                        </tr>
                    </tfoot>
                </table>

                <div id="status-banner" class="status-banner status-pass">
                    Congratulation!! You have passed this exam.
                </div>
                
                <div class="print-btn">
                    <a onclick="window.print()">Print</a>
                </div>
            </div>

            <footer class="footer">
                2018 - gtu.ac.in
            </footer>
        </main>
    </div>

    <script id="results-data" type="application/json"><%= resultsJson %></script>

    <script>
        // Track session status for back button / logout check
        localStorage.setItem('isLoggedIn', 'true');

        // History navigation helper to go back to dashboard home without logging out
        function pushViewHistory(viewName) {
            if (window.history.pushState) {
                if (!window.history.state || window.history.state.view !== viewName) {
                    window.history.pushState({ view: viewName }, '');
                }
            }
        }

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
        (function() {
            let totalSeconds = 20 * 60;
            const timerDisplay = document.getElementById('header-timer-display');

            const interval = setInterval(function() {
                totalSeconds--;
                if (totalSeconds <= 0) {
                    clearInterval(interval);
                    if (timerDisplay) {
                        timerDisplay.innerHTML = '<i class="fas fa-clock"></i> 00:00';
                    }
                    window.location.href = '../LogoutServlet';
                    return;
                }
                
                const minutes = Math.floor(totalSeconds / 60);
                const seconds = totalSeconds % 60;
                
                const minStr = minutes < 10 ? '0' + minutes : minutes;
                const secStr = seconds < 10 ? '0' + seconds : seconds;
                
                if (timerDisplay) {
                    timerDisplay.innerHTML = '<i class="fas fa-clock"></i> ' + minStr + ':' + secStr;
                }
            }, 1000);
        })();

        // Database for results 

        const resultDatabase = JSON.parse(document.getElementById('results-data').textContent);

        // Populate exam-select dropdown dynamically from the database
        function populateExamSelect() {
            const select = document.getElementById('exam-select');
            if (select) {
                select.innerHTML = '';
                const examKeys = Object.keys(resultDatabase);
                if (examKeys.length === 0) {
                    const opt = document.createElement('option');
                    opt.value = '';
                    opt.innerText = 'No exam results found';
                    select.appendChild(opt);
                    return;
                }
                examKeys.forEach(key => {
                    const opt = document.createElement('option');
                    opt.value = key;
                    opt.innerText = resultDatabase[key].name;
                    select.appendChild(opt);
                });
            }
        }

        // UI View Toggles
        document.addEventListener('DOMContentLoaded', () => {
            populateExamSelect();
            const navItems = document.querySelectorAll('.nav-menu li');
            
            navItems.forEach(item => {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    navItems.forEach(nav => nav.classList.remove('active'));
                    this.classList.add('active');

                    if(this.id === 'nav-results') {
                        hideAllViews();
                        document.getElementById('results-view').style.display = 'block';
                        renderResult(); // Auto-load default
                        pushViewHistory('results');
                    } else if(this.id === 'nav-home') {
                        showHome();
                    }
                });
            });

            // Clear URL query parameters so refresh doesn't show the success/error banner again
            if (window.history.replaceState) {
                const url = new URL(window.location);
                const hasBannerParams = url.searchParams.has('status') || url.searchParams.has('message');
                if (hasBannerParams) {
                    url.searchParams.delete('status');
                    url.searchParams.delete('message');
                }
                window.history.replaceState({ view: 'home' }, document.title, url.pathname + url.search);
            } else {
                if (window.history.replaceState) {
                    window.history.replaceState({ view: 'home' }, '');
                }
            }

            // Popstate event listener to go back to dashboard home without logging out
            window.addEventListener('popstate', function(event) {
                if (event.state && event.state.view) {
                    const view = event.state.view;
                    if (view === 'home') {
                        showHome(false);
                    } else if (view === 'results') {
                        hideAllViews();
                        document.getElementById('results-view').style.display = 'block';
                        renderResult();
                        document.querySelectorAll('.nav-menu li').forEach(nav => nav.classList.remove('active'));
                        document.getElementById('nav-results').classList.add('active');
                    } else if (view === 'profile' || view === 'mobile' || view === 'email' || view === 'password') {
                        openEdit(view, false);
                    }
                } else {
                    showHome(false);
                }
            });
        });

        // Hides all right-side main panels
        function hideAllViews() {
            document.getElementById('home-view').style.display = 'none';
            document.getElementById('results-view').style.display = 'none';
            document.getElementById('edit-profile-view').style.display = 'none';
            document.getElementById('edit-mobile-view').style.display = 'none';
            document.getElementById('edit-email-view').style.display = 'none';
            document.getElementById('edit-password-view').style.display = 'none';
        }

        // Return to main home dashboard
        function showHome(pushHistory = true) {
            hideAllViews();
            document.getElementById('home-view').style.display = 'flex';
            
            // Fix sidebar active state
            document.querySelectorAll('.nav-menu li').forEach(nav => nav.classList.remove('active'));
            document.getElementById('nav-home').classList.add('active');

            if (pushHistory) {
                pushViewHistory('home');
            }
        }

        // Open specific edit view
        function openEdit(type, pushHistory = true) {
            hideAllViews();
            if(type === 'profile') {
                document.getElementById('edit-profile-view').style.display = 'block';
            } else if(type === 'mobile') {
                document.getElementById('edit-mobile-view').style.display = 'block';
            } else if(type === 'email') {
                document.getElementById('edit-email-view').style.display = 'block';
            } else if(type === 'password') {
                document.getElementById('edit-password-view').style.display = 'block';
            }
            if (pushHistory) {
                pushViewHistory(type);
            }
        }

        // Search engine logic for results
        function renderResult() {
            const selectVal = document.getElementById('exam-select').value;
            if (!selectVal || !resultDatabase[selectVal]) {
                return;
            }
            const data = resultDatabase[selectVal]; 

            document.getElementById('lbl-declared').innerText = data.declared;
            document.getElementById('lbl-exam').innerText = data.name;
            
            const tbody = document.getElementById('results-tbody');
            tbody.innerHTML = '';
            data.subjects.forEach(sub => {
                const tr = document.createElement('tr');
                tr.innerHTML = 
                    '<td>' + sub.c + '</td>' +
                    '<td style="text-align: left;">' + sub.n + '</td>' +
                    '<td>' + sub.eA + '</td>' +
                    '<td>' + sub.te + '</td><td>' + sub.tp + '</td><td>' + sub.tt + '</td>' +
                    '<td>' + sub.pe + '</td><td>' + sub.pp + '</td><td>' + sub.pt + '</td>' +
                    '<td>' + sub.sg + '</td>';
                tbody.appendChild(tr);
            });

            document.getElementById('lbl-sem-backlog').innerText = "Current Sem. Backlog: " + data.semB;
            document.getElementById('lbl-tot-backlog').innerText = "Total Backlog: " + data.totB;
            document.getElementById('lbl-spi').innerText = "SPI: " + data.spi;
            document.getElementById('lbl-cpi-cgpa').innerHTML = "CPI: " + data.cpi + (data.cgpa ? '&nbsp;&nbsp;&nbsp;&nbsp; CGPA: ' + data.cgpa : '');

            const banner = document.getElementById('status-banner');
            banner.innerText = data.status;
            banner.className = data.passed ? 'status-banner status-pass' : 'status-banner status-fail';
        }

        // Handle profile picture upload
        function handleAvatarFileChange(input) {
            if (input.files && input.files[0]) {
                const file = input.files[0];
                if (!file.type.startsWith('image/')) {
                    alert('Please select an image file.');
                    return;
                }
                if (file.size > 1024 * 1024) {
                    alert('Please select an image smaller than 1MB.');
                    return;
                }
                const reader = new FileReader();
                reader.onload = function(e) {
                    const base64Data = e.target.result;
                    document.getElementById('avatarData').value = base64Data;
                    document.getElementById('avatarForm').submit();
                };
                reader.readAsDataURL(file);
            }
        }

        // Automatically hide update status banner after 5 seconds (5000ms)
        window.addEventListener('DOMContentLoaded', () => {
            const alertBanner = document.getElementById('alert-status-banner');
            if (alertBanner) {
                setTimeout(() => {
                    alertBanner.style.display = 'none';
                }, 5000);
            }
        });
    </script>
</body>
</html>
