package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.hostel.dao.studentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SelectManagerServlet")
public class SelectManagerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String username = request.getParameter("username");
		String newRole = request.getParameter("role");

		Connection conn = null;

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

			// 5. Execute DAO Update
			studentDAO dao = new studentDAO(conn);
			boolean updated = dao.updateStudentRole(username, newRole);

			if (updated) {
				response.sendRedirect(
						"pages/select_manager.jsp?searchUsername=" + username + "&success=Updated successfully");
			} else {
				response.sendRedirect(
						"pages/select_manager.jsp?searchUsername=" + username + "&error=Failed to update");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("pages/select_manager.jsp?error=Internal server error");
		} finally {
			// 6. Safely close database connections to prevent memory leaks on Render
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
