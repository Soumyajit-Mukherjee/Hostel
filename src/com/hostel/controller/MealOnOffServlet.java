package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;

import com.hostel.dao.dbconnection;
import com.hostel.dao.studentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MealOnOffServlet")
public class MealOnOffServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String status = request.getParameter("meal_on_off");
		HttpSession session = request.getSession(false);
		String username = (String) session.getAttribute("username");

		if (username == null) {
			response.sendRedirect("pages/student_login.jsp");
			return;
		}

		Connection conn = dbconnection.getConnection();
		studentDAO dao = new studentDAO(conn);
		boolean updated = dao.updateMealStatus(username, status);

		if (updated) {
			// session.setAttribute("message", "Meal status updated to " +
			// status.toUpperCase());
			response.sendRedirect("pages/meal_on_off.jsp?msg=success");
		} else {
			// session.setAttribute("message", "Failed to update meal status.");
			response.sendRedirect("pages/meal_on_off.jsp?msg=error");
		}

	}
}
