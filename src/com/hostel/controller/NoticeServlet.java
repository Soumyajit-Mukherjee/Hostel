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

@WebServlet("/NoticeServlet")
public class NoticeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// Database Credentials
	private static final String DB_URL = "jdbc:mysql://localhost:3306/hostel_management";
	private static final String DB_USER = "root";
	private static final String DB_PASSWORD = "Soumyajit@123";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. Authenticate the User
		HttpSession session = request.getSession(false);
		String currentUser = (session != null) ? (String) session.getAttribute("username") : null;

		// If no user is logged in, kick them out to the login page immediately
		if (currentUser == null || currentUser.trim().isEmpty()) {
			response.sendRedirect("../index.jsp");
			return;
		}

		// 2. Extract form parameters
		String action = request.getParameter("action");
		String noticeIdStr = request.getParameter("notice_id");
		String noticeText = request.getParameter("notice_text");

		String redirectPage = "pages/manage_notices.jsp";

		try {
			// Load JDBC Driver
			Class.forName("com.mysql.cj.jdbc.Driver");

			// Open Database Connection
			try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

				PreparedStatement ps = null;
				int rowsAffected = 0;

				// 3. Route the logic based on the action securely
				if ("add".equals(action)) {

					// --- CREATE NEW NOTICE (Saves the Author) ---
					String sql = "INSERT INTO notices (notice_text, posted_by) VALUES (?, ?)";
					ps = conn.prepareStatement(sql);
					ps.setString(1, noticeText);
					ps.setString(2, currentUser); // Tag the notice with the logged-in user
					ps.executeUpdate();

					response.sendRedirect(redirectPage + "?msg=added");

				} else if ("update".equals(action)) {

					// --- UPDATE EXISTING NOTICE (Strictly limits to Author) ---
					int noticeId = Integer.parseInt(noticeIdStr);
					String sql = "UPDATE notices SET notice_text = ? WHERE id = ? AND posted_by = ?";
					ps = conn.prepareStatement(sql);
					ps.setString(1, noticeText);
					ps.setInt(2, noticeId);
					ps.setString(3, currentUser); // Security barrier

					rowsAffected = ps.executeUpdate();

					// If rowsAffected is 0, it means the ID didn't exist OR they aren't the author
					if (rowsAffected > 0) {
						response.sendRedirect(redirectPage + "?msg=updated");
					} else {
						response.sendRedirect(redirectPage + "?msg=error");
					}

				} else if ("delete".equals(action)) {

					// --- DELETE NOTICE (Strictly limits to Author) ---
					int noticeId = Integer.parseInt(noticeIdStr);
					String sql = "DELETE FROM notices WHERE id = ? AND posted_by = ?";
					ps = conn.prepareStatement(sql);
					ps.setInt(1, noticeId);
					ps.setString(2, currentUser); // Security barrier

					rowsAffected = ps.executeUpdate();

					if (rowsAffected > 0) {
						response.sendRedirect(redirectPage + "?msg=deleted");
					} else {
						response.sendRedirect(redirectPage + "?msg=error");
					}

				} else {
					// Invalid action fallback
					response.sendRedirect(redirectPage + "?msg=error");
				}

				// Close statement
				if (ps != null) {
					ps.close();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(redirectPage + "?msg=error");
		}
	}
}