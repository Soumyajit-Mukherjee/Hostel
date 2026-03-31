package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

	private static final String DB_URL = "jdbc:mysql://localhost:3306/hostel_management";
	private static final String DB_USER = "root";
	private static final String DB_PASS = "Soumyajit@123"; // Replace with your actual DB password

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

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

			// Get student_id of the manager/prefect
			String getIdSql = "SELECT id FROM student WHERE username = ?";
			PreparedStatement getIdStmt = conn.prepareStatement(getIdSql);
			getIdStmt.setString(1, username);
			ResultSet idRs = getIdStmt.executeQuery();

			int studentId = -1;
			if (idRs.next()) {
				studentId = idRs.getInt("id");
			} else {
				throw new Exception("Student ID not found for username: " + username);
			}

			// Count boarders whose meal_status is ON
			String countSql = "SELECT COUNT(*) AS total FROM student WHERE meal_status = 'on'";
			PreparedStatement countStmt = conn.prepareStatement(countSql);
			ResultSet countRs = countStmt.executeQuery();

			int totalMeals = 0;
			if (countRs.next()) {
				totalMeals = countRs.getInt("total");
			}

			// Insert into meal_count table using the SELECTED date
			String insertSql = "INSERT INTO meal_count (student_id, manager_username, meal_date, meal_type, total_meals) VALUES (?, ?, ?, ?, ?)";
			PreparedStatement insertStmt = conn.prepareStatement(insertSql);
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

			// Clean up database resources
			idRs.close();
			getIdStmt.close();
			countRs.close();
			countStmt.close();
			insertStmt.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("pages/count_meal.jsp?msg=exception");
		}
	}
}