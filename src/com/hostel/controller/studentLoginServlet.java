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
import jakarta.servlet.http.HttpSession;

@WebServlet("/studentLoginServlet")
public class studentLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String DB_URL = "jdbc:mysql://localhost:3306/hostel_management";
	private static final String DB_USER = "root";
	private static final String DB_PASS = "Soumyajit@123"; // Replace with your actual password

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String role = request.getParameter("role");

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");

			Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

			// Check approved students only
			String sql = "SELECT * FROM student WHERE username=? AND password=? AND role=? AND status = 'approved'";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, username);
			ps.setString(2, password);
			ps.setString(3, role);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				HttpSession session = request.getSession();
				session.setAttribute("username", username);
				session.setAttribute("role", role);

				// Redirect based on role
				switch (role) {
				case "mess prefect":
					response.sendRedirect("pages/mess_prefect_dashboard.jsp");
					break;
				case "maintenance":
					response.sendRedirect("pages/maintenance_dashboard.jsp");
					break;
				case "manager":
					response.sendRedirect("pages/manager_dashboard.jsp");
					break;
				case "auditor":
					response.sendRedirect("pages/auditor_dashboard.jsp");
					break;
				case "librarian":
					response.sendRedirect("pages/librarian_dashboard.jsp");
					break;
				case "gardener/game prefect":
					response.sendRedirect("pages/garden_dashboard.jsp");
					break;
				default:
					response.sendRedirect("pages/student_dashboard.jsp"); // normal boarder
					break;
				}
			} else {
				response.sendRedirect("pages/error.jsp"); // wrong credentials or not approved
			}

			rs.close();
			ps.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("pages/error.jsp");
		}
	}
}
