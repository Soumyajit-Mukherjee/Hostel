package com.hostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.hostel.model.admin;

public class adminDAO {
	private Connection conn;

	public adminDAO(Connection conn) {
		this.conn = conn;
	}

	public boolean registerAdmin(admin admin) {
		boolean success = false;
		try {
			String sql = "insert into admin(full_name, username, email, phone, password) values(?, ?, ?, ?, ?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, admin.getFullname());
			ps.setString(2, admin.getUsername());
			ps.setString(3, admin.getEmail());
			ps.setString(4, admin.getPhone());
			ps.setString(5, admin.getPassword());
			int rows = ps.executeUpdate();
			if (rows > 0) {
				success = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return success;
	}
}
