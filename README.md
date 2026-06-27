# GTU Student Portal Demo — Java Web Project

A demo of the GTU (Gujarat Technological University) website with Student Portal
built using **Java Servlets + JSP + MySQL + Apache Tomcat**.

---

## Project Structure

```
GTUDemo/
├── src/
│   └── main/
│       ├── java/com/gtu/
│       │   ├── model/
│       │   │   └── Student.java          ← Student data model (POJO)
│       │   ├── dao/
│       │   │   ├── DBConnection.java     ← MySQL connection helper
│       │   │   └── StudentDAO.java       ← Database queries
│       │   └── servlet/
│       │       ├── LoginServlet.java     ← Handles login form POST
│       │       └── LogoutServlet.java    ← Clears session, redirects
│       └── webapp/
│           ├── index.jsp                 ← GTU Main Homepage
│           ├── studentportal/
│           │   ├── login.jsp             ← Student Login Page
│           │   ├── dashboard.jsp         ← Dashboard (after login)
│           │   ├── profile.jsp           ← Student Profile
│           │   └── result.jsp            ← Semester Results
│           ├── css/
│           │   ├── main.css              ← Homepage styles
│           │   ├── portal.css            ← Login page styles
│           │   └── dashboard.css         ← Dashboard/Profile/Result styles
│           ├── js/
│           │   └── main.js               ← Homepage scripts
│           └── WEB-INF/
│               └── web.xml               ← Servlet config
└── db/
    └── setup.sql                         ← Database creation + sample data
```

---

## SETUP GUIDE (Step by Step)

### STEP 1 — Install Required Software

| Tool | Download Link |
|------|--------------|
| JDK 17+ | https://adoptium.net/ |
| Eclipse IDE for Enterprise Java | https://www.eclipse.org/downloads/ |
| Apache Tomcat 9 | https://tomcat.apache.org/download-90.cgi |
| MySQL Community Server | https://dev.mysql.com/downloads/mysql/ |
| MySQL Workbench | https://dev.mysql.com/downloads/workbench/ |
| MySQL JDBC Connector/J | https://dev.mysql.com/downloads/connector/j/ |

---

### STEP 2 — Set Up the Database

1. Open **MySQL Workbench** and connect to your local MySQL server
2. Open the file `db/setup.sql` and run it (Ctrl+Shift+Enter)
3. This will:
   - Create database `gtu_student_db`
   - Create `students` table
   - Insert 3 dummy students for testing

**Demo Login Credentials after running setup.sql:**

| Enrollment No. | Password |
|---------------|----------|
| 186640307036  | 62914366  |
| 216640307036  | 62914366  |

---

### STEP 3 — Create Project in Eclipse

1. Open Eclipse
2. Go to **File → New → Dynamic Web Project**
3. Project name: `GTUDemo`
4. Target runtime: **Apache Tomcat v9.0** (click "New Runtime..." if not listed)
5. Click **Finish**

---

### STEP 4 — Copy Source Files

Copy files from this project into Eclipse's project directory:

```
src/main/java/  →  Eclipse's  Java Resources/src/
src/main/webapp/ →  Eclipse's  WebContent/
```

Or in Eclipse:
- Right-click the project → **Import → File System** → select the src folder

---

### STEP 5 — Add MySQL JDBC Driver

1. Download `mysql-connector-j-X.X.X.jar` from MySQL website
2. Copy the `.jar` file into:
   ```
   WebContent/WEB-INF/lib/
   ```
3. Right-click the jar → **Build Path → Add to Build Path**

---

### STEP 6 — Update DB Password in DBConnection.java

Open `src/com/gtu/dao/DBConnection.java` and change:

```java
private static final String DB_USER = "root";       // your MySQL username
private static final String DB_PASS = "password";   // YOUR actual password here
```

---

### STEP 7 — Configure Tomcat in Eclipse

1. Go to **Window → Show View → Servers**
2. Right-click in Servers panel → **New → Server**
3. Choose **Apache → Tomcat v9.0**
4. Browse to your Tomcat install directory
5. Add `GTUDemo` to the server

---

### STEP 8 — Run the Project

1. Right-click the project → **Run As → Run on Server**
2. Choose Tomcat 9
3. Open browser and go to:

```
http://localhost:8080/GTUDemo/
```

---

## Page Flow

```
http://localhost:8080/GTUDemo/
        │
        ├── [GTU Main Homepage - index.jsp]
        │         │
        │         └── Click "Student Login" button
        │
        ▼
http://localhost:8080/GTUDemo/studentportal/login.jsp
        │
        ├── Enter Enrollment: 186640307036
        ├── Enter Password: 62914366
        └── Click Login
        │
        ▼ (LoginServlet.java checks DB)
        │
        └── SUCCESS →
http://localhost:8080/GTUDemo/studentportal/dashboard.jsp
                │
                ├── /profile.jsp      ← Student Profile
                ├── /result.jsp       ← Semester Results
                ├── /hallticket.jsp   ← (add later)
                └── /examform.jsp     ← (add later)
```

---

## Common Issues & Fixes

| Problem | Fix |
|---------|-----|
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | Add mysql-connector-j.jar to WEB-INF/lib |
| `Communications link failure` | Make sure MySQL is running on port 3306 |
| 404 on login page | Make sure studentportal/ folder is inside WebContent |
| Login always fails | Check DB password in DBConnection.java |
| Tomcat port conflict | Change Tomcat port to 8081 in server.xml |

---

## Demo Credentials (repeat for quick reference)

```
Enrollment: 186640307036   Password: 62914366   (Patel Parthkumar Sureshbhai - CE, Sem 5)
Enrollment: 216640307036   Password: 62914366   (Patel Parthkumar Sureshbhai - IT, Sem 5)
```
# gtudemo
