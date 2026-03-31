package com.hostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.hostel.model.student;

public class studentDAO {
	private Connection conn;

	public studentDAO(Connection conn) {
		this.conn = conn;
	}

	public boolean registerStudent(student s) {
		boolean success = false;
		try {
			String sql = "INSERT INTO student(full_name, username, email, phone, address, dob, role, password, room_no, status, meal_status, course, department) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, s.getFullname());
			ps.setString(2, s.getUsername());
			ps.setString(3, s.getEmail());
			ps.setString(4, s.getPhone());
			ps.setString(5, s.getAddress());
			ps.setString(6, s.getDob());
			ps.setString(7, s.getRole());
			ps.setString(8, s.getPassword());
			ps.setInt(9, s.getRoom());
			ps.setString(10, s.getStatus());
			ps.setString(11, s.getMealStatus());
			ps.setString(12, s.getCourse());
			ps.setString(13, s.getDepartment());

			int rows = ps.executeUpdate();
			if (rows > 0) {
				success = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return success;
	}

	public boolean updateMealStatus(String username, String mealStatus) {
		boolean success = false;
		try {
			String sql = "UPDATE student SET meal_status = ? WHERE username = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, mealStatus);
			ps.setString(2, username);
			int rows = ps.executeUpdate();
			if (rows > 0) {
				success = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return success;
	}

	public student getStudentByUsername(String username) {
		student student = null;
		try (Connection conn = dbconnection.getConnection()) {
			String sql = "SELECT * FROM student WHERE username = ?";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setString(1, username);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				student = new student();
				student.setUsername(rs.getString("username"));
				student.setMealCharge(rs.getDouble("meal_charge"));
				student.setPhone(rs.getString("phone"));
				student.setRole(rs.getString("role"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return student;
	}

	public void updateMealCharge(String username, double newCharge) {
		try (Connection conn = dbconnection.getConnection()) {
			String sql = "UPDATE student SET meal_charge = ? WHERE username = ?";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setDouble(1, newCharge);
			stmt.setString(2, username);
			stmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public boolean updateStudentRole(String username, String newRole) {
		String sql = "UPDATE student SET role = ? WHERE username = ?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, newRole);
			ps.setString(2, username);
			return ps.executeUpdate() > 0;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

}
