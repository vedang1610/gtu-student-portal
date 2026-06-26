package com.gtu.servlet;

import com.gtu.dao.StudentDAO;
import com.gtu.model.Student;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

/**
 * LoginServlet
 * 
 * Handles student login form submission.
 * URL: /LoginServlet  (mapped from login form action)
 * 
 * Flow:
 *   1. Reads enrollment number + password from form
 *   2. Calls StudentDAO.login() to verify against DB
 *   3. If valid → creates session, redirects to dashboard
 *   4. If invalid → sends error back to login page
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read form data
        String enrollmentNo = request.getParameter("username").trim();
        String password     = request.getParameter("password").trim();

        // Basic validation
        if (enrollmentNo.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Please enter both Enrollment Number and Password.");
            request.getRequestDispatcher("studentportal/login.jsp").forward(request, response);
            return;
        }

        // Check credentials in DB
        StudentDAO dao = new StudentDAO();
        Student student = dao.login(enrollmentNo, password);

        if (student != null) {
            // ✅ LOGIN SUCCESS
            // Create session and store student object
            HttpSession session = request.getSession(true);
            session.setAttribute("student", student);
            session.setMaxInactiveInterval(20 * 60); // 20 minutes timeout

            // Redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/studentportal/dashboard.jsp");

        } else {
            // ❌ LOGIN FAILED
            request.setAttribute("error", "Invalid Enrollment Number or Password. Please try again.");
            request.getRequestDispatcher("studentportal/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // If someone hits /LoginServlet via GET, redirect to login page
        response.sendRedirect(request.getContextPath() + "/studentportal/login.jsp");
    }
}
