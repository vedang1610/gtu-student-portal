<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gujarat Technological University</title>
  <link rel="stylesheet" href="css/main.css">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>

<!-- TOP BAR -->
<div class="top-bar">
  <div class="top-bar-left">
    <span><i class="fas fa-phone"></i> +079-23267521/570</span>
    <span><i class="fas fa-envelope"></i> <a href="mailto:info@gtu.ac.in">info@gtu.ac.in</a></span>
  </div>
  <div class="top-bar-right">
    <a href="#">Select Language ▼</a>
    <a href="#">Software For Disabled</a>
    <span class="font-size-ctrl">
      <a href="#" onclick="changeFontSize(1.1)">A+</a>
      <a href="#" onclick="changeFontSize(1)">A</a>
      <a href="#" onclick="changeFontSize(0.9)">A-</a>
    </span>
  </div>
</div>

<!-- HEADER -->
<header class="header">
  <div class="header-inner">
    <div class="logo-area">
      <img src="images/gtulogo.jpeg" alt="GTU Logo" class="logo" onerror="this.style.display='none'">
      <div class="logo-text">
        <h1>Gujarat Technological University</h1>
        <p>ગુજરાત ટેક્નોલૉજિકલ યુનિવર્સિટી</p>
      </div>
    </div>
    <div class="header-links">
      <a href="#"><img src="images/iqac.png" alt="IQAC" onerror="this.style.display='none'"> IQAC</a>
      <a href="#">NIRF</a>
    </div>
  </div>
</header>

<!-- NAVBAR -->
<nav class="navbar">
  <ul>
    <li class="dropdown">
      <a href="#">About Us <i class="fas fa-chevron-down"></i></a>
      <div class="dropdown-content">
        <a href="#">About GTU</a>
        <a href="#">Vice Chancellor's Message</a>
        <a href="#">Organizational Structure</a>
        <a href="#">Acts & Statutes</a>
        <a href="#">Annual Reports</a>
      </div>
    </li>
    <li class="dropdown">
      <a href="#">Administrative Sections <i class="fas fa-chevron-down"></i></a>
      <div class="dropdown-content">
        <a href="#">Establishment Section</a>
        <a href="#">Accounts Section</a>
        <a href="#">Legal Section</a>
        <a href="#">IT Department</a>
      </div>
    </li>
    <li class="dropdown">
      <a href="#">Academic Wing <i class="fas fa-chevron-down"></i></a>
      <div class="dropdown-content">
        <a href="#">Curriculum Development</a>
        <a href="#">Examination</a>
        <a href="#">PhD Program</a>
      </div>
    </li>
    <li class="dropdown">
      <a href="#">Affiliated Institutes <i class="fas fa-chevron-down"></i></a>
      <div class="dropdown-content">
        <a href="#">Institute List</a>
        <a href="#">College Dashboard</a>
      </div>
    </li>

    <!-- STUDENT CORNER - HIGHLIGHTED -->
    <li class="dropdown student-corner-nav">
      <a href="#">Student Corner <i class="fas fa-chevron-down"></i></a>
      <div class="dropdown-content">
        <!-- STUDENT PORTAL LINK — KEY ENTRY POINT -->
        <a href="http://student.gtu.ac.in/Login.aspx" class="portal-link" target="_blank">
          <i class="fas fa-user-graduate"></i> <strong>Student Portal Login</strong>
        </a>
        <a href="#">Scholarships</a>
        <a href="#">Anti-Ragging</a>
        <a href="#">Grievance Cell</a>
        <a href="#">Result</a>
        <a href="#">GTU e-Learning</a>
      </div>
    </li>

    <li class="dropdown">
      <a href="#">Research & Innovation <i class="fas fa-chevron-down"></i></a>
      <div class="dropdown-content">
        <a href="#">Research Projects</a>
        <a href="#">Innovation Council</a>
        <a href="#">Publications</a>
      </div>
    </li>
    <li class="dropdown">
      <a href="#">Downloads <i class="fas fa-chevron-down"></i></a>
      <div class="dropdown-content">
        <a href="#">Circulars</a>
        <a href="#">Syllabus</a>
        <a href="#">Forms</a>
      </div>
    </li>
    <li class="dropdown">
      <a href="#">Quick Links <i class="fas fa-chevron-down"></i></a>
      <div class="dropdown-content">
        <a href="#">Time Table</a>
        <a href="#">Exam Schedule</a>
        <a href="#">Hall Ticket</a>
        <a href="#">Result</a>
      </div>
    </li>
    <li><a href="#">Contact Us</a></li>
  </ul>
</nav>

<!-- STUDENT PORTAL BANNER (prominent button) -->
<div class="portal-banner">
  <div class="portal-banner-inner">
    <div class="portal-banner-text">
      <i class="fas fa-user-graduate portal-banner-icon"></i>
      <div>
        <h2>Student's Portal</h2>
        <p>Access your profile, results, hall tickets, exam forms & more</p>
      </div>
    </div>
    <a href="studentportal/login.jsp" class="btn-portal-enter">
      <i class="fas fa-sign-in-alt"></i> Student Login
    </a>
  </div>
</div>

<!-- MAIN CONTENT -->
<div class="main-container">

  <!-- LEFT: News & Notices -->
  <div class="news-section">
    <div class="section-header">
      <h3><i class="fas fa-newspaper"></i> News Corner</h3>
      <span class="marquee-label">Exam Schedule, Guidelines & Circulars</span>
    </div>

    <div class="news-ticker">
      <div class="news-item">
        <span class="news-date">17-Jan-2026</span>
        <a href="#">Circular for 15th Annual Convocation-2026 – Students Entry Pass</a>
      </div>
      <div class="news-item">
        <span class="news-date">08-Jun-2026</span>
        <a href="#">UFM Notification No: 134/2026</a>
      </div>
      <div class="news-item">
        <span class="news-date">10-Apr-2026</span>
        <a href="#">UFM Notification No: 79/2026</a>
      </div>
      <div class="news-item">
        <span class="news-date">27-Mar-2026</span>
        <a href="#">Circular – UFM Hearing of student WINTER-2025 Phase-III</a>
      </div>
      <div class="news-item">
        <span class="news-date">20-Feb-2026</span>
        <a href="#">UFM Hearing of student WINTER-2025 Phase-II</a>
      </div>
      <div class="news-item">
        <span class="news-date">03-Jan-2026</span>
        <a href="#">Circular – UFM Hearing of student WINTER-2025 Phase-I</a>
      </div>
    </div>
    <a href="#" class="view-all">VIEW ALL</a>

    <!-- New Horizons -->
    <div class="section-header mt-20">
      <h3><i class="fas fa-star"></i> New Horizons</h3>
    </div>
    <div class="year-filter">
      <label>Select Year:</label>
      <select>
        <option>2026</option><option>2025</option><option>2024</option>
        <option>2023</option><option>2022</option><option>2021</option>
      </select>
    </div>
    <a href="#" class="view-all">VIEW ALL</a>
  </div>

  <!-- RIGHT: Quick Access Cards -->
  <div class="quick-access">
    <h3 class="qa-title"><i class="fas fa-bolt"></i> Quick Access</h3>
    <div class="qa-grid">
      <a href="studentportal/login.jsp" class="qa-card student-portal-card">
        <i class="fas fa-user-graduate"></i>
        <span>Student Portal</span>
      </a>
      <a href="#" class="qa-card">
        <i class="fas fa-file-alt"></i>
        <span>Results</span>
      </a>
      <a href="#" class="qa-card">
        <i class="fas fa-id-card"></i>
        <span>Hall Ticket</span>
      </a>
      <a href="#" class="qa-card">
        <i class="fas fa-calendar-alt"></i>
        <span>Exam Schedule</span>
      </a>
      <a href="#" class="qa-card">
        <i class="fas fa-book"></i>
        <span>Syllabus</span>
      </a>
      <a href="#" class="qa-card">
        <i class="fas fa-download"></i>
        <span>Downloads</span>
      </a>
    </div>
  </div>

</div>

<!-- FOOTER -->
<footer class="footer">
  <div class="footer-inner">
    <div class="footer-col">
      <h4>Address</h4>
      <p>Gujarat Technological University, GTU Campus,<br>
      Nr. Visat Three Road, Visat-Gandhinagar Road,<br>
      Chandkheda, Ahmedabad-382424, Gujarat, India.</p>
      <p><i class="fas fa-phone"></i> +079-23267521/570</p>
      <p><i class="fas fa-envelope"></i> info@gtu.ac.in</p>
      <p><i class="fas fa-envelope"></i> registrar@gtu.ac.in</p>
    </div>
    <div class="footer-col">
      <h4>Contact</h4>
      <a href="#">Chandkheda</a><br>
      <a href="#">Gandhinagar</a>
    </div>
    <div class="footer-col">
      <h4>GTU Song</h4>
      <a href="#">▶ Play</a><br>
      <a href="#">⬇ Download</a>
    </div>
    <div class="footer-col">
      <h4>GTU Documentary</h4>
      <a href="#">GTU Coffee Table Book</a><br>
      <a href="#">Documentary – Gujarati</a><br>
      <a href="#">Documentary – English</a>
    </div>
  </div>
  <div class="footer-bottom">
    <p>©All rights reserved Gujarat Technological University</p>
    <p>Today's Count (21 Jun 2026) – 2276635 | Till Yesterday Total Count – 4480744</p>
  </div>
</footer>

<script src="js/main.js"></script>
</body>
</html>
