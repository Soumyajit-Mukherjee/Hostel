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

@WebServlet("/MealChargeApprovalServlet")
public class MealChargeApprovalServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String DB_URL = "jdbc:mysql://localhost:3306/hostel_management";
	private static final String DB_USER = "root";
	private static final String DB_PASS = "Soumyajit@123";

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action"); // "approve" or "reject"
		String username = request.getParameter("username"); // auditor who submitted

		try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

			int rowsAffected = 0;

			if (action.equalsIgnoreCase("approve")) {
				// Step 1: Get the amount for the given auditor where status is pending
				String getAmountSQL = "SELECT amount FROM total_meal_charge WHERE username = ? AND status = 'pending'";
				PreparedStatement getPs = conn.prepareStatement(getAmountSQL);
				getPs.setString(1, username);
				ResultSet rs = getPs.executeQuery();

				if (rs.next()) {
					double amount = rs.getDouble("amount");
					rs.close();
					getPs.close();

					// Step 2: Add amount to all students
					String updateStudentSQL = "UPDATE student SET meal_charge = COALESCE(meal_charge, 0) + ?";

					PreparedStatement updateStudentPs = conn.prepareStatement(updateStudentSQL);
					updateStudentPs.setDouble(1, amount);
					int updatedCount = updateStudentPs.executeUpdate();
					updateStudentPs.close();

					// Step 3: Mark the row as approved
					String updateStatusSQL = "UPDATE total_meal_charge SET status = 'approved' WHERE username = ? AND status = 'pending'";
					PreparedStatement updateStatusPs = conn.prepareStatement(updateStatusSQL);
					updateStatusPs.setString(1, username);
					int statusUpdated = updateStatusPs.executeUpdate();
					updateStatusPs.close();

					if (updatedCount > 0 && statusUpdated > 0) {
						rowsAffected = 1;
					}
				} else {
					rs.close();
					getPs.close();
				}

			} else if (action.equalsIgnoreCase("reject")) {
				// Just reject the pending charge
				String rejectSQL = "UPDATE total_meal_charge SET status = 'rejected' WHERE username = ? AND status = 'pending'";
				PreparedStatement ps = conn.prepareStatement(rejectSQL);
				ps.setString(1, username);
				rowsAffected = ps.executeUpdate();
				ps.close();
			}

			// Redirect result
			if (rowsAffected > 0) {
				response.sendRedirect("pages/update_meal_charge.jsp?msg=success");
			} else {
				response.sendRedirect("pages/update_meal_charge.jsp?msg=error");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("pages/update_meal_charge.jsp?msg=exception");
		}
	}
}
