package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.hostel.dao.studentDAO;
import com.hostel.model.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/studentRegisterServlet")
public class studentRegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String fullName = request.getParameter("full_name");
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String dob = request.getParameter("dob");
		String course = request.getParameter("course");
		String department = request.getParameter("department");
		String role = request.getParameter("role");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirm_password");

		// Check password confirmation safely
		if (password == null || !password.equals(confirmPassword)) {
			request.setAttribute("error", "Passwords do not match!");
			request.getRequestDispatcher("pages/student_register.jsp").forward(request, response);
			return;
		}

		// Create student object with room_no=0 and status='pending'
		student newStudent = new student(fullName, username, email, phone, address, dob, role, password, 0, "pending",
				"off", course, department);

		Connection conn = null;

		try {
			// 1. Load JDBC driver
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

			// 4. Connect to DB
			conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

			// 5. Instantiate DAO and register student
			studentDAO dao = new studentDAO(conn);
			boolean status = dao.registerStudent(newStudent);

			if (status) {
				// Registration successful, redirect to login
				response.sendRedirect("pages/index.jsp");
			} else {
				// Registration failed, show error
				request.setAttribute("error", "Registration failed. Try again.");
				request.getRequestDispatcher("pages/student_register.jsp").forward(request, response);
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Something went wrong. Try again.");
			request.getRequestDispatcher("pages/student_register.jsp").forward(request, response);
		} finally {
			// 6. Safely close database connections to prevent memory leaks on Render
			try {
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
