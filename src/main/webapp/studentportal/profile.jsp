<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.gtu.model.Student" %>
<%
  Student student = (Student) session.getAttribute("student");
  if (student == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Profile – GTU Student Portal</title>
  <link rel="stylesheet" href="../css/portal.css">
  <link rel="stylesheet" href="../css/dashboard.css">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="dashboard-body">

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

<nav class="dash-navbar">
  <div class="dash-nav-left">
    <span class="dash-gtu-logo">GTU</span>
    <span class="dash-portal-title">Student Portal</span>
  </div>
  <div class="dash-nav-right">
    <div class="dash-user-info">
      <i class="fas fa-user-circle dash-avatar"></i>
      <div>
        <span class="dash-username"><%= student.getFullName() %></span>
        <span class="dash-enrollment"><%= student.getEnrollmentNo() %></span>
      </div>
    </div>
    <a href="../LogoutServlet" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
  </div>
</nav>

<div class="dash-layout">
  <aside class="dash-sidebar">
    <div class="sidebar-avatar-wrap">
      <div class="sidebar-avatar"><i class="fas fa-user-circle"></i></div>
      <p class="sidebar-name"><%= student.getFullName() %></p>
      <p class="sidebar-branch"><%= student.getBranch() %></p>
      <p class="sidebar-sem">Semester <%= student.getCurrentSemester() %></p>
    </div>
    <ul class="sidebar-menu">
      <li><a href="dashboard.jsp"><i class="fas fa-th-large"></i> Dashboard</a></li>
      <li class="active"><a href="profile.jsp"><i class="fas fa-id-card-alt"></i> My Profile</a></li>
      <li><a href="result.jsp"><i class="fas fa-chart-bar"></i> Results</a></li>
      <li><a href="hallticket.jsp"><i class="fas fa-ticket-alt"></i> Hall Ticket</a></li>
      <li><a href="examform.jsp"><i class="fas fa-file-signature"></i> Exam Form</a></li>
      <li><a href="feepayment.jsp"><i class="fas fa-wallet"></i> Fee Payment</a></li>
      <li><a href="timetable.jsp"><i class="fas fa-calendar-week"></i> Time Table</a></li>
      <li><a href="notifications.jsp"><i class="fas fa-bell"></i> Notifications</a></li>
      <li><a href="changepassword.jsp"><i class="fas fa-key"></i> Change Password</a></li>
    </ul>
  </aside>

  <main class="dash-main">
    <div class="page-header">
      <h2><i class="fas fa-id-card-alt"></i> Student Profile</h2>
      <p>Your personal and academic information</p>
    </div>

    <div class="profile-card">
      <!-- Profile Header -->
      <div class="profile-header">
        <div class="profile-pic-wrap">
          <div class="profile-pic-placeholder">
            <i class="fas fa-user"></i>
          </div>
          <p class="profile-pic-note">Student Photo</p>
        </div>
        <div class="profile-header-info">
          <h2><%= student.getFullName() %></h2>
          <p class="profile-enroll"><i class="fas fa-id-badge"></i> <%= student.getEnrollmentNo() %></p>
          <p><i class="fas fa-university"></i> <%= student.getCollegeName() %></p>
          <span class="status-active"><i class="fas fa-circle"></i> Active Student</span>
        </div>
      </div>

      <!-- Profile Details Grid -->
      <div class="profile-section">
        <h3 class="profile-section-title"><i class="fas fa-user-tag"></i> Personal Information</h3>
        <div class="profile-grid">
          <div class="profile-field">
            <label>Full Name</label>
            <span><%= student.getFullName() %></span>
          </div>
          <div class="profile-field">
            <label>Date of Birth</label>
            <span><%= student.getDob() %></span>
          </div>
          <div class="profile-field">
            <label>Gender</label>
            <span><%= student.getGender() %></span>
          </div>
          <div class="profile-field">
            <label>Mobile Number</label>
            <span><%= student.getMobile() %></span>
          </div>
          <div class="profile-field">
            <label>Email Address</label>
            <span><%= student.getEmail() %></span>
          </div>
          <div class="profile-field">
            <label>Category</label>
            <span><%= student.getCategory() %></span>
          </div>
        </div>
      </div>

      <div class="profile-section">
        <h3 class="profile-section-title"><i class="fas fa-graduation-cap"></i> Academic Information</h3>
        <div class="profile-grid">
          <div class="profile-field">
            <label>Enrollment Number</label>
            <span><%= student.getEnrollmentNo() %></span>
          </div>
          <div class="profile-field">
            <label>Program</label>
            <span><%= student.getProgram() %></span>
          </div>
          <div class="profile-field">
            <label>Branch</label>
            <span><%= student.getBranch() %></span>
          </div>
          <div class="profile-field">
            <label>Current Semester</label>
            <span>Semester <%= student.getCurrentSemester() %></span>
          </div>
          <div class="profile-field">
            <label>Admission Year</label>
            <span><%= student.getAdmissionYear() %></span>
          </div>
          <div class="profile-field">
            <label>College Name</label>
            <span><%= student.getCollegeName() %></span>
          </div>
          <div class="profile-field">
            <label>CGPA</label>
            <span><%= student.getCgpa() %></span>
          </div>
          <div class="profile-field">
            <label>Active Backlogs</label>
            <span><%= student.getBacklogs() %></span>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<footer class="portal-footer">
  <p>©All rights reserved – Gujarat Technological University</p>
</footer>

<script>
    // Track session status for back button / logout check
    localStorage.setItem('isLoggedIn', 'true');

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
        window.location.href = '../LogoutServlet';
    }, 20 * 60 * 1000);
</script>
</body>
</html>
