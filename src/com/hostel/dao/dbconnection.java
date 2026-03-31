package com.hostel.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class dbconnection {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 1. Attempt to fetch credentials from Render Environment Variables
            String url = System.getenv("DB_URL");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASS");

            // 2. Fallback logic: If Environment Variables are missing, use Localhost
            if (url == null || url.isEmpty()) {
                System.out.println("No cloud environment variables found. Connecting to Localhost...");
                url = "jdbc:mysql://localhost:3306/hostel_management";
                user = "root";
                pass = "Soumyajit@123";
            } else {
                System.out.println("Cloud environment detected. Connecting to Aiven MySQL...");
            }

            // 3. Establish connection
            conn = DriverManager.getConnection(url, user, pass);
            System.out.println("Success: Connected to MySQL Database!");

        } catch (Exception e) {
            System.out.println("Database Connection Error!");
            e.printStackTrace();
        }
        return conn;
    }
}
