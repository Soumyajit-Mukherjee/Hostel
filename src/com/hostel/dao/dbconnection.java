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
			String dbUrl = "jdbc:mysql://mysql-688ab9d-sommajeet-595a.a.aivencloud.com:13274/defaultdb";
            String dbUser = "avnadmin";
            String dbPass = "AVNS_LL2rbOBw-mOt8BId7a5";

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
			conn = DriverManager.getConnection(url, user, pass);
			// System.out.println("Success: Connected to MySQL!");

		} catch (Exception e) {
			System.out.println("Database Connection Error!");
			e.printStackTrace();
		}
		return conn;
	}
}
