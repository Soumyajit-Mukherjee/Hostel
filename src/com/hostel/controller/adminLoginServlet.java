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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            // 1. Load the Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Fetch Cloud Credentials (from Render Environment Variables)
            String dbUrl = System.getenv("DB_URL"); 
            String dbUser = System.getenv("DB_USER");
            String dbPass = System.getenv("DB_PASS");

            // 4. Connect to the Database
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            // 5. Execute Login Query
            String query = "SELECT * FROM admin WHERE username=? AND password=?";
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {
                // Get the session
                HttpSession session = request.getSession();

                // Set the new admin username
                session.setAttribute("username", username);

                // DESTROY PREVIOUS ROLES ---
                // This ensures that if an "auditor" or "mess prefect" logged out,
                // their role is completely erased from this browser session.
                session.removeAttribute("role");

                // Redirect to dashboard
                response.sendRedirect("pages/admin_dashboard.jsp");
            } else {
                response.sendRedirect("pages/error.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("pages/error.jsp");
        } finally {
            // 6. Safely close database connections to prevent memory leaks on Render
            try {
                if (rs != null)
                    rs.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (ps != null)
                    ps.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (conn != null)
                    conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
