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
  <title>Results – GTU Student Portal</title>
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
      <li><a href="profile.jsp"><i class="fas fa-id-card-alt"></i> My Profile</a></li>
      <li class="active"><a href="result.jsp"><i class="fas fa-chart-bar"></i> Results</a></li>
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
      <h2><i class="fas fa-chart-bar"></i> Semester Results</h2>
      <p>Your academic performance — semester wise</p>
    </div>

    <!-- CPI Summary -->
    <div class="result-cpi-bar">
      <div class="cpi-item">
        <span class="cpi-val"><%= student.getCgpa() %></span>
        <span class="cpi-label">Overall CGPA / CPI</span>
      </div>
      <div class="cpi-item">
        <span class="cpi-val">8.42</span>
        <span class="cpi-label">Latest SPI (Sem 5)</span>
      </div>
      <div class="cpi-item">
        <span class="cpi-val">0</span>
        <span class="cpi-label">Active Backlogs</span>
      </div>
    </div>

    <!-- SEM 5 RESULT TABLE -->
    <div class="result-block">
      <div class="result-block-header">
        <h3><i class="fas fa-layer-group"></i> Semester 5 Result – Winter 2025</h3>
        <div class="result-spi">SPI: <strong>8.42</strong> &nbsp;|&nbsp; Result: <span class="badge-pass">PASS</span></div>
      </div>
      <table class="result-table">
        <thead>
          <tr>
            <th>Sub Code</th>
            <th>Subject Name</th>
            <th>Credits</th>
            <th>Internal</th>
            <th>External</th>
            <th>Total</th>
            <th>Grade</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>3150703</td>
            <td>Cloud Computing</td>
            <td>4</td>
            <td>27</td>
            <td>62</td>
            <td>89</td>
            <td>AA</td>
            <td><span class="badge-pass">PASS</span></td>
          </tr>
          <tr>
            <td>3150702</td>
            <td>Machine Learning</td>
            <td>4</td>
            <td>25</td>
            <td>58</td>
            <td>83</td>
            <td>AB</td>
            <td><span class="badge-pass">PASS</span></td>
          </tr>
          <tr>
            <td>3150704</td>
            <td>Data Science</td>
            <td>4</td>
            <td>26</td>
            <td>55</td>
            <td>81</td>
            <td>BB</td>
            <td><span class="badge-pass">PASS</span></td>
          </tr>
          <tr>
            <td>3150705</td>
            <td>Web Technology</td>
            <td>3</td>
            <td>24</td>
            <td>60</td>
            <td>84</td>
            <td>AB</td>
            <td><span class="badge-pass">PASS</span></td>
          </tr>
          <tr>
            <td>3150706</td>
            <td>Software Engineering</td>
            <td>3</td>
            <td>22</td>
            <td>50</td>
            <td>72</td>
            <td>BC</td>
            <td><span class="badge-pass">PASS</span></td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- SEM 4 RESULT TABLE -->
    <div class="result-block">
      <div class="result-block-header">
        <h3><i class="fas fa-layer-group"></i> Semester 4 Result – Summer 2025</h3>
        <div class="result-spi">SPI: <strong>7.91</strong> &nbsp;|&nbsp; Result: <span class="badge-pass">PASS</span></div>
      </div>
      <table class="result-table">
        <thead>
          <tr>
            <th>Sub Code</th>
            <th>Subject Name</th>
            <th>Credits</th>
            <th>Internal</th>
            <th>External</th>
            <th>Total</th>
            <th>Grade</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>3140705</td>
            <td>Database Management System</td>
            <td>4</td>
            <td>25</td>
            <td>56</td>
            <td>81</td>
            <td>BB</td>
            <td><span class="badge-pass">PASS</span></td>
          </tr>
          <tr>
            <td>3140706</td>
            <td>Operating System</td>
            <td>4</td>
            <td>23</td>
            <td>52</td>
            <td>75</td>
            <td>BC</td>
            <td><span class="badge-pass">PASS</span></td>
          </tr>
          <tr>
            <td>3140701</td>
            <td>Analysis of Algorithm</td>
            <td>4</td>
            <td>24</td>
            <td>54</td>
            <td>78</td>
            <td>BB</td>
            <td><span class="badge-pass">PASS</span></td>
          </tr>
          <tr>
            <td>3140702</td>
            <td>Computer Networks</td>
            <td>3</td>
            <td>22</td>
            <td>48</td>
            <td>70</td>
            <td>BC</td>
            <td><span class="badge-pass">PASS</span></td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="result-note">
      <i class="fas fa-info-circle"></i>
      Grading System: AA(10), AB(9), BB(8), BC(7), CC(6), CD(5), DD(4), FF(0/FAIL)
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
