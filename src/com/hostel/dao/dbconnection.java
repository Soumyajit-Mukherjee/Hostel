package com.hostel.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class dbconnection {
	public static Connection getConnection() {
		Connection conn = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");

			// Updated for Railway Cloud
			String url = "jdbc:mysql://localhost:3306/hostel_management";
			String user = "root";
			String pass = "Soumyajit@123";

			conn = DriverManager.getConnection(url, user, pass);
			System.out.println("Success: Connected to MySQL!");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
}