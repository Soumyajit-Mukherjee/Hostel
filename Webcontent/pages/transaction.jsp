<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction History - Radhakrishnan Bhawan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* --- CSS Variables --- */
        :root {
            --primary-blue: #0b1c4a;
            --accent-teal: #29768a;
            --bg-color: #f0f4f8;
            --text-dark: #333;
            --text-muted: #666;
            --glass-bg: rgba(255, 255, 255, 0.9);
            --glass-border: rgba(255, 255, 255, 0.5);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            min-height: 100vh;
            background: url('../images/hostel.png') center/cover no-repeat fixed;
            background-color: var(--primary-blue);
            display: flex;
            flex-direction: column;
        }

        /* Dark Overlay for the background image */
        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(11, 28, 74, 0.85); /* Darker tint to make the table pop */
            z-index: -1;
        }

        /* --- Top Navigation Bar --- */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 15px;
            color: var(--primary-blue);
        }

        .nav-brand img {
            height: 45px;
        }

        .nav-brand h1 {
            font-size: 20px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .nav-brand span {
            font-size: 13px;
            font-weight: 400;
            color: var(--text-muted);
            display: block;
        }

        .back-btn {
            background: var(--bg-color);
            color: var(--primary-blue);
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #d1d9e0;
        }

        .back-btn:hover {
            background: var(--primary-blue);
            color: white;
            box-shadow: 0 4px 12px rgba(11, 28, 74, 0.2);
            border-color: var(--primary-blue);
        }

        /* --- Main Content Container --- */
        .dashboard-container {
            max-width: 1000px; /* Slightly narrower for a clean table view */
            margin: 40px auto;
            padding: 0 20px;
            flex: 1;
            width: 100%;
            animation: fadeInUp 0.6s ease;
        }

        .header-section {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
            color: white;
        }

        .header-icon {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #fff;
            backdrop-filter: blur(5px);
        }

        .header-text h2 {
            font-size: 28px;
            font-weight: 600;
        }

        .header-text p {
            font-size: 15px;
            opacity: 0.8;
            font-weight: 300;
        }

        /* --- Glass Table Container --- */
        .table-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            overflow: hidden;
        }

        .table-wrapper {
            max-height: 500px; /* Makes the table scrollable if there are many rows */
            overflow-y: auto;
            border-radius: 10px;
            border: 1px solid #e0e6ed;
        }

        /* --- Modern Data Table Styles --- */
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            background: #ffffff;
        }

        thead {
            position: sticky;
            top: 0;
            background: var(--primary-blue);
            color: white;
            z-index: 10;
        }

        th {
            padding: 16px 20px;
            font-weight: 600;
            font-size: 14px;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        td {
            padding: 16px 20px;
            font-size: 15px;
            color: var(--text-dark);
            border-bottom: 1px solid #f0f4f8;
            transition: background 0.2s ease;
        }

        tbody tr:hover td {
            background-color: #f8fafc;
        }

        /* Formatting specific columns */
        .col-user {
            font-weight: 600;
            color: var(--primary-blue);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .col-user i {
            color: var(--accent-teal);
            font-size: 18px;
        }

        .col-amount {
            font-weight: 600;
            color: #2e7d32; /* Green for money/payment */
        }

        .col-date {
            color: var(--text-muted);
            font-size: 14px;
        }

        /* Scrollbar Styling for the Table Wrapper */
        .table-wrapper::-webkit-scrollbar {
            width: 8px;
        }
        .table-wrapper::-webkit-scrollbar-track {
            background: #f1f1f1; 
        }
        .table-wrapper::-webkit-scrollbar-thumb {
            background: #c1c1c1; 
            border-radius: 4px;
        }
        .table-wrapper::-webkit-scrollbar-thumb:hover {
            background: var(--accent-teal); 
        }

        /* Animations */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .navbar { padding: 15px 20px; }
            .nav-brand h1 { font-size: 18px; }
            .nav-brand span { display: none; }
            .table-card { padding: 15px; }
            th, td { padding: 12px 15px; font-size: 13px; }
            .header-text h2 { font-size: 22px; }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-brand">
            <img src="../images/bt_logo.png" alt="Hostel Logo">
            <div>
                <h1>Admin Control Panel</h1>
                <span>Radhakrishnan Bhawan</span>
            </div>
        </div>
        
        <a href="admin_dashboard.jsp" class="back-btn">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
    </nav>

    <div class="dashboard-container">
        
        <div class="header-section">
            <div class="header-icon"><i class="fa-solid fa-money-check-dollar"></i></div>
            <div class="header-text">
                <h2>Transaction Ledger</h2>
                <p>Comprehensive history of meal charges and dues paid by boarders.</p>
            </div>
        </div>

        <div class="table-card">
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th><i class="fa-solid fa-user-tag" style="margin-right: 5px;"></i> Boarder Username</th>
                            <th><i class="fa-solid fa-indian-rupee-sign" style="margin-right: 5px;"></i> Amount Paid</th>
                            <th><i class="fa-solid fa-calendar-check" style="margin-right: 5px;"></i> Date & Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection con = DriverManager.getConnection(
                                    "jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");
                                String sql = "SELECT * FROM boarder_meal_charge ORDER BY date_time DESC";
                                PreparedStatement ps = con.prepareStatement(sql);
                                ResultSet rs = ps.executeQuery();
                                
                                while (rs.next()) {
                        %>
                                    <tr>
                                        <td class="col-user">
                                            <i class="fa-solid fa-circle-user"></i> 
                                            <%= rs.getString("username") %>
                                        </td>
                                        <td class="col-amount">
                                            ₹ <%= rs.getDouble("amount") %>
                                        </td>
                                        <td class="col-date">
                                            <%= rs.getTimestamp("date_time") %>
                                        </td>
                                    </tr>
                        <%
                                }
                                rs.close();
                                ps.close();
                                con.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                        %>
                                <tr>
                                    <td colspan="3" style="text-align: center; color: red; padding: 30px;">
                                        <i class="fa-solid fa-triangle-exclamation" style="font-size: 24px; margin-bottom: 10px; display: block;"></i>
                                        Failed to load transaction data. Please check your database connection.
                                    </td>
                                </tr>
                        <%
                            }
                        %>
                        </tbody>
                </table>
            </div>
        </div>

    </div>

</body>
</html>