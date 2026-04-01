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

        // Define JDBC objects here to ensure they are accessible in the 'finally' block
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // 1. Fetch Cloud Credentials (from Render Environment Variables)
            String host = System.getenv("DB_HOST");
            String port = System.getenv("DB_PORT");
            String dbName = System.getenv("DB_NAME");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASS");
            
            // Construct URL with Aiven's mandatory SSL mode
            String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?sslmode=REQUIRED";

            // 2. Load the Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 3. Connect to the Database
            conn = DriverManager.getConnection(url, user, pass);

            // 4. Execute Login Query
            String query = "SELECT * FROM admin WHERE username=? AND password=?";
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {
                // Get the session
                HttpSession session = request.getSession();

                // Set the admin username
                session.setAttribute("username", username);

                // DESTROY PREVIOUS ROLES
                // Ensures session cleanup for role-based access
                session.removeAttribute("role");

                // Redirect to dashboard
                response.sendRedirect("pages/admin_dashboard.jsp");
            } else {
                // Redirect to index with error parameter
                response.sendRedirect("index.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("pages/error.jsp");
        } finally {
            // 5. Safely close database connections to prevent memory leaks on Render
            try {
                if (rs != null) rs.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (ps != null) ps.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
