package com.hostel.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class dbconnection {
	public static Connection getConnection() {
		Connection conn = null;
		try {
			// 1. Load the Driver
			Class.forName("com.mysql.cj.jdbc.Driver");

			// 2. Fetch Cloud Credentials (from Environment Variables)
			String dbUrl = System.getenv("DB_URL"); 
			String dbUser = System.getenv("DB_USER");
			String dbPass = System.getenv("DB_PASS");

			// 3. Fallback for Localhost (if cloud variables aren't found)
			if (url == null || url.isEmpty()) {
				// System.out.println("Connecting to Localhost...");
				url = "jdbc:mysql://localhost:3306/hostel_management";
				user = "root";
				pass = "Soumyajit@123";
			} else {
				// System.out.println("Connecting to Cloud Database...");
			}

			// 4. Establish the Connection
			conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
			// System.out.println("Success: Connected to MySQL!");

		} catch (Exception e) {
			System.out.println("Database Connection Error!");
			e.printStackTrace();
		}
		return conn;
	}
}
