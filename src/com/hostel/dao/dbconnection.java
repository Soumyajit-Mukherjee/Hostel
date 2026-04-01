package com.hostel.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Locale;

public class dbconnection {

    public static void main(String[] args) throws ClassNotFoundException {
        // 1. Initialize variables from Environment Variables (Render default)
        String host = System.getenv("DB_HOST");
        String port = System.getenv("DB_PORT");
        String databaseName = System.getenv("DB_NAME");
        String userName = System.getenv("DB_USER");
        String password = System.getenv("DB_PASS");

        // 2. Allow overrides via Command Line Arguments (Format provided in your example)
        for (int i = 0; i < args.length - 1; i++) {
            switch (args[i].toLowerCase(Locale.ROOT)) {
                case "-host": host = args[++i]; break;
                case "-username": userName = args[++i]; break;
                case "-password": password = args[++i]; break;
                case "-database": databaseName = args[++i]; break;
                case "-port": port = args[++i]; break;
            }
        }

        // 3. Validation
        if (host == null || port == null || databaseName == null) {
            System.out.println("Host, port, and database information is required via Environment Variables or Args.");
            return;
        }

        // 4. Load Driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 5. Connect and Execute (Using try-with-resources for automatic closing)
        // Note: Aiven requires ?sslmode=REQUIRED (or 'require' as in your format)
        String url = "jdbc:mysql://" + host + ":" + port + "/" + databaseName + "?sslmode=REQUIRED";

        try (final Connection connection = DriverManager.getConnection(url, userName, password);
             final Statement statement = connection.createStatement();
             final ResultSet resultSet = statement.executeQuery("SELECT version() AS version")) {

            System.out.println("Successfully connected to Aiven MySQL!");
            
            while (resultSet.next()) {
                System.out.println("Database Version: " + resultSet.getString("version"));
            }

        } catch (SQLException e) {
            System.out.println("Connection failure to Aiven Cloud.");
            e.printStackTrace();
        }
    }
}
