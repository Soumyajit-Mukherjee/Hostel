package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;

import com.hostel.dao.studentDAO;
import com.hostel.model.student;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UpdateMealChargeServlet")
public class UpdateMealChargeServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String username = request.getParameter("username");
		double amount = Double.parseDouble(request.getParameter("amount"));
		Connection con = null;
		studentDAO dao = new studentDAO(con);
		student student = dao.getStudentByUsername(username);

		if (student != null) {
			double updated = student.getMealCharge() - amount;
			if (updated < 0)
				updated = 0;

			dao.updateMealCharge(username, updated);
			response.sendRedirect(
					"pages/boarder_meal_charge.jsp?searchUsername=" + username + "&success=Meal charge updated.");
		} else {
			response.sendRedirect("pages/boarder_meal_charge.jsp?error=Boarder not found");
		}
	}
}
