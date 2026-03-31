package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

import com.hostel.dao.studentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/approveCommitteeServlet")
public class approveCommitteeServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String username = request.getParameter("username");
		String newRole = request.getParameter("role");

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel_management", "root",
					"Soumyajit@123");

			studentDAO dao = new studentDAO(conn);
			boolean updated = dao.updateStudentRole(username, newRole);

			if (updated) {
				response.sendRedirect("pages/approve_committee.jsp?searchUsername=" + username
						+ "&success=Role updated successfully");
			} else {
				response.sendRedirect(
						"pages/approve_committee.jsp?searchUsername=" + username + "&error=Failed to update role");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("pages/approve_committee.jsp?error=Internal server error");
		}
	}
}
