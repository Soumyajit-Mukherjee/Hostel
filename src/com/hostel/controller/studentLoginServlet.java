package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/studentLoginServlet")
public class studentLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String role = request.getParameter("role");

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
			conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

			// Check approved students only
			String sql = "SELECT * FROM student WHERE username=? AND password=? AND role=? AND status = 'approved'";
			ps = conn.prepareStatement(sql);
			ps.setString(1, username);
			ps.setString(2, password);
			ps.setString(3, role);

			rs = ps.executeQuery();

			if (rs.next()) {
				HttpSession session = request.getSession();
				session.setAttribute("username", username);
				session.setAttribute("role", role);

				// Redirect based on role
				// Note: Added .toLowerCase() just in case the HTML form sends "Manager" with a
				// capital letter
				switch (role.toLowerCase()) {
				case "mess prefect":
					response.sendRedirect("pages/mess_prefect_dashboard.jsp");
					break;
				case "maintenance":
					response.sendRedirect("pages/maintenance_dashboard.jsp");
					break;
				case "manager":
					response.sendRedirect("pages/manager_dashboard.jsp");
					break;
				case "auditor":
					response.sendRedirect("pages/auditor_dashboard.jsp");
					break;
				case "librarian":
					response.sendRedirect("pages/librarian_dashboard.jsp");
					break;
				case "gardener/game prefect":
					response.sendRedirect("pages/garden_dashboard.jsp");
					break;
				default:
					response.sendRedirect("pages/student_dashboard.jsp"); // normal boarder
					break;
				}
			} else {
				response.sendRedirect("pages/error.jsp"); // wrong credentials or not approved
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("pages/error.jsp");
		} finally {
			// 5. Safely close database connections to prevent memory leaks on Render
			try {
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			try {
				if (ps != null)
					ps.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
