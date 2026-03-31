package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MealCountServlet")
public class MealCountServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("username") == null) {
			response.sendRedirect("pages/index.jsp"); // Fixed redirect path to go to root index
			return;
		}

		String username = (String) session.getAttribute("username");
		String mealType = request.getParameter("meal_type"); // "morning" or "night"

		// --- THE FIX: GRAB THE DATE FROM THE UI ---
		String dateStr = request.getParameter("meal_date");
		LocalDate date;

		// Parse the date from the form. If for some reason it's missing, fallback to
		// today.
		if (dateStr != null && !dateStr.isEmpty()) {
			date = LocalDate.parse(dateStr);
		} else {
			date = LocalDate.now();
		}

		Connection conn = null;
		PreparedStatement getIdStmt = null;
		ResultSet idRs = null;
		PreparedStatement countStmt = null;
		ResultSet countRs = null;
		PreparedStatement insertStmt = null;

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

			// Get student_id of the manager/prefect
			String getIdSql = "SELECT id FROM student WHERE username = ?";
			getIdStmt = conn.prepareStatement(getIdSql);
			getIdStmt.setString(1, username);
			idRs = getIdStmt.executeQuery();

			int studentId = -1;
			if (idRs.next()) {
				studentId = idRs.getInt("id");
			} else {
				throw new Exception("Student ID not found for username: " + username);
			}

			// Count boarders whose meal_status is ON
			String countSql = "SELECT COUNT(*) AS total FROM student WHERE meal_status = 'on'";
			countStmt = conn.prepareStatement(countSql);
			countRs = countStmt.executeQuery();

			int totalMeals = 0;
			if (countRs.next()) {
				totalMeals = countRs.getInt("total");
			}

			// Insert into meal_count table using the SELECTED date
			String insertSql = "INSERT INTO meal_count (student_id, manager_username, meal_date, meal_type, total_meals) VALUES (?, ?, ?, ?, ?)";
			insertStmt = conn.prepareStatement(insertSql);
			insertStmt.setInt(1, studentId);
			insertStmt.setString(2, username);
			insertStmt.setDate(3, java.sql.Date.valueOf(date)); // Saves the exact date chosen in UI
			insertStmt.setString(4, mealType);
			insertStmt.setInt(5, totalMeals);

			int rowsInserted = insertStmt.executeUpdate();

			if (rowsInserted > 0) {
				response.sendRedirect("pages/count_meal.jsp?msg=success");
			} else {
				response.sendRedirect("pages/count_meal.jsp?msg=error");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("pages/count_meal.jsp?msg=exception");
		} finally {
			// 5. Safely close database connections to prevent memory leaks on Render
			try {
				if (idRs != null)
					idRs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			try {
				if (getIdStmt != null)
					getIdStmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			try {
				if (countRs != null)
					countRs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			try {
				if (countStmt != null)
					countStmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			try {
				if (insertStmt != null)
					insertStmt.close();
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
