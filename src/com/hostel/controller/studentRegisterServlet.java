package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

import com.hostel.dao.studentDAO;
import com.hostel.model.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/studentRegisterServlet")
public class studentRegisterServlet extends HttpServlet {

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

		// Check password confirmation
		if (!password.equals(confirmPassword)) {
			request.setAttribute("error", "Passwords do not match!");
			request.getRequestDispatcher("pages/student_register.jsp").forward(request, response);
			return;
		}

		// Create student object with room_no=0 and status='pending'
		student student = new student(fullName, username, email, phone, address, dob, role, password, 0, "pending",
				"off", course, department);

		try {
			// Load JDBC driver
			Class.forName("com.mysql.cj.jdbc.Driver");

			// Connect to DB
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel_management", "root",
					"Soumyajit@123");

			// Instantiate DAO and register student
			studentDAO dao = new studentDAO(con);
			boolean status = dao.registerStudent(student);

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
		}
	}
}
