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

@WebServlet("/ClearanceRequestServlet")
public class ClearanceRequestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String DB_URL = "jdbc:mysql://localhost:3306/hostel_management";
	private static final String DB_USER = "root";
	private static final String DB_PASS = "Soumyajit@123";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		String username = (String) request.getSession().getAttribute("username");

		if (username == null) {
			response.sendRedirect("student_login.jsp");
			return;
		}

		String purpose = request.getParameter("purpose");
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

			String sql = "INSERT INTO clearance (username, purpose, status) VALUES (?, ?, 'pending')";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, username);
			ps.setString(2, purpose);
			int rows = ps.executeUpdate();

			if (rows > 0) {
				response.sendRedirect("pages/clearance.jsp?message=Submitted+successfully");
			} else {
				response.sendRedirect("pages/clearance.jsp?message=Failed+to+submit");
			}
			ps.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("pages/error.jsp");
		}
	}
}
