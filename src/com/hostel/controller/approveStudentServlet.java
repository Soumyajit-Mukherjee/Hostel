package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/approveStudentServlet")
public class approveStudentServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int studentId = Integer.parseInt(request.getParameter("id"));
		String action = request.getParameter("action");

		Connection con = null;
		PreparedStatement psStudent = null;
		PreparedStatement psRoomUpdate = null;

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");

			if ("approve".equals(action)) {

				// Step 1: Find available rooms
				String roomQuery = "SELECT room_no FROM room WHERE occupied < 3 AND status = 'available'";
				Statement roomStmt = con.createStatement();
				ResultSet roomRs = roomStmt.executeQuery(roomQuery);

				ArrayList<Integer> availableRooms = new ArrayList<>();
				while (roomRs.next()) {
					availableRooms.add(roomRs.getInt("room_no"));
				}

				if (availableRooms.isEmpty()) {
					request.setAttribute("error", "No rooms available for allotment.");
					request.getRequestDispatcher("pages/approve_students.jsp").forward(request, response);
					return;
				}

				// Shuffle and pick a room
				Collections.shuffle(availableRooms);
				int allottedRoom = availableRooms.get(0);

				// Step 2: Approve student, assign room, and set meal_status = 'on'
				String updateStudent = "UPDATE student SET status='approved', role='boarder', room_no=?, meal_status='on' WHERE id=?";
				psStudent = con.prepareStatement(updateStudent);
				psStudent.setInt(1, allottedRoom);
				psStudent.setInt(2, studentId);
				psStudent.executeUpdate();

				// Step 3: Increment room occupancy
				String updateRoom = "UPDATE room SET occupied = occupied + 1 WHERE room_no = ?";
				psRoomUpdate = con.prepareStatement(updateRoom);
				psRoomUpdate.setInt(1, allottedRoom);
				psRoomUpdate.executeUpdate();

			} else if ("reject".equals(action)) {
				// Reject student
				String rejectStudent = "UPDATE student SET status='rejected' WHERE id=?";
				psStudent = con.prepareStatement(rejectStudent);
				psStudent.setInt(1, studentId);
				psStudent.executeUpdate();
			}

			response.sendRedirect("pages/approve_students.jsp");

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Error occurred: " + e.getMessage());
			request.getRequestDispatcher("pages/approve_students.jsp").forward(request, response);
		} finally {
			try {
				if (psStudent != null)
					psStudent.close();
				if (psRoomUpdate != null)
					psRoomUpdate.close();
				if (con != null)
					con.close();
			} catch (SQLException se) {
				se.printStackTrace();
			}
		}
	}
}
