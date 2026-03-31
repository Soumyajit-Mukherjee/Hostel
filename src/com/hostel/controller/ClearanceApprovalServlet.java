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

@WebServlet("/ClearanceApprovalServlet")
public class ClearanceApprovalServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String DB_URL = "jdbc:mysql://localhost:3306/hostel_management";
	private static final String DB_USER = "root";
	private static final String DB_PASS = "Soumyajit@123";

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action"); // "approve" or "reject"
		String username = request.getParameter("username");

		try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
			String updateStatusSQL = "UPDATE clearance SET status = ? WHERE username = ?";
			PreparedStatement ps = conn.prepareStatement(updateStatusSQL);
			String newStatus = action.equalsIgnoreCase("approve") ? "approved" : "rejected";
			ps.setString(1, newStatus);
			ps.setString(2, username);
			int statusUpdated = ps.executeUpdate();
			ps.close();

			if (statusUpdated > 0) {
				response.sendRedirect("pages/admin_clearance.jsp?msg=success");
			} else {
				response.sendRedirect("pages/admin_clearance.jsp?msg=error");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("pages/admin_clearance.jsp?msg=exception");
		}
	}
}
