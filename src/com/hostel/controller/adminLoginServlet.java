package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/adminLoginServlet")
public class adminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // FIX FOR 405 ERROR: Handle direct URL access or page refreshes
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirecting to the login page if someone tries to access this servlet via GET
        response.sendRedirect("index.jsp"); 
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // 1. Load the Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Fetch Cloud Credentials (from Render Environment Variables)
            String dbUrl = System.getenv("DB_URL"); 
            String dbUser = System.getenv("DB_USER");
            String dbPass = System.getenv("DB_PASS");

            // 3. Fallback for Localhost (if cloud variables aren't found)
            if (dbUrl == null || dbUrl.isEmpty()) {
                dbUrl = "jdbc:mysql://localhost:3306/hostel_management";
                dbUser = "root";
                dbPass = "Soumyajit@123";
            }

            // 4. Connect to the Database
            // Note: Ensure Render's DB_URL includes ?ssl-mode=REQUIRED&trustServerCertificate=true
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            // 5. Execute Login Query
            String query = "SELECT * FROM admin WHERE username=? AND password=?";
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                
                // Clear any existing roles to prevent session overlap
                session.removeAttribute("role");

                // Redirect to dashboard
                response.sendRedirect("pages/admin_dashboard.jsp");
            } else {
                // Invalid credentials
                response.sendRedirect("pages/error.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Log the error to Render's console and redirect to error page
            response.sendRedirect("pages/error.jsp");
        } finally {
            // 6. Safely close connections
            try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
