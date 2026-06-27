package com.gtu.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

/**
 * LogoutServlet
 * Invalidates the session and redirects to the login page.
 */
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Clear all session data
        }

        // Redirect to login page with logout message
        response.sendRedirect(request.getContextPath() + "/studentportal/login.jsp?logout=true");
    }
}
