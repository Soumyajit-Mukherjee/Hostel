package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/BoarderMealChargeRequestServlet")
public class BoarderMealChargeRequestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		String username = (String) session.getAttribute("username");

		// Security check: Redirect if not logged in
		if (username == null) {
			response.sendRedirect("student_login.jsp");
			return;
		}

		double amount = 0;
		try {
			amount = Double.parseDouble(request.getParameter("amount"));
		} catch (NumberFormatException e) {
			response.sendRedirect("pages/meal_charge_request.jsp?message=Invalid+amount");
			return;
		}

		Connection conn = null;
		PreparedStatement ps = null;

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

			// 5. Insert Meal Charge Request
			String sql = "INSERT INTO boarder_meal_charge (username, amount, status) VALUES (?, ?, 'pending')";
			ps = conn.prepareStatement(sql);
			ps.setString(1, username);
			ps.setDouble(2, amount);

			int rows = ps.executeUpdate();

			if (rows > 0) {
				response.sendRedirect("pages/meal_charge_request.jsp?message=Total+amount+submitted+successfully");
			} else {
				response.sendRedirect("pages/meal_charge_request.jsp?message=Failed+to+submit");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("pages/error.jsp");
		} finally {
			// 6. Safely close database connections to prevent memory leaks on Render
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
