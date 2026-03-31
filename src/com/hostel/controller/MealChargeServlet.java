package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MealChargeServlet")
public class MealChargeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String DB_URL = "jdbc:mysql://localhost:3306/hostel_management";
	private static final String DB_USER = "root";
	private static final String DB_PASS = "Soumyajit@123"; // ← Your DB password

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		String username = (String) request.getSession().getAttribute("username");

		if (username == null) {
			response.sendRedirect("student_login.jsp");
			return;
		}

		double amount = Double.parseDouble(request.getParameter("amount"));

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

			String sql = "INSERT INTO total_meal_charge (username, amount, status) VALUES (?, ?, 'pending')";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, username);
			ps.setDouble(2, amount);

			int rows = ps.executeUpdate();

			if (rows > 0) {
				response.sendRedirect("pages/meal_charge.jsp?message=Total+amount+submitted+successfully");
			} else {
				response.sendRedirect("pages/meal_charge.jsp?message=Failed+to+submit");
			}

			ps.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("pages/error.jsp");
		}
	}
}
