<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View All Boarders - Radhakrishnan Bhawan</title>
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
            --glass-bg: rgba(255, 255, 255, 0.92);
            --glass-border: rgba(255, 255, 255, 0.5);
            
            /* Status Colors */
            --success-bg: #e6f4ea; --success-text: #1e8e3e;
            --warning-bg: #fef7e0; --warning-text: #f29900;
            --danger-bg: #fce8e6; --danger-text: #d93025;
            --info-bg: #e8f0fe; --info-text: #1a73e8;
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
            background: rgba(11, 28, 74, 0.85); 
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

        .nav-brand img { height: 45px; }
        .nav-brand h1 { font-size: 20px; font-weight: 700; letter-spacing: 0.5px; }
        .nav-brand span { font-size: 13px; font-weight: 400; color: var(--text-muted); display: block; }

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
            max-width: 96%; /* Ultra-wide container to accommodate 15 columns */
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

        .header-text h2 { font-size: 28px; font-weight: 600; }
        .header-text p { font-size: 15px; opacity: 0.8; font-weight: 300; }

        /* --- Glass Table Container --- */
        .table-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            overflow: hidden;
        }

        .table-wrapper {
            max-height: 65vh; /* Responsive vertical scroll */
            overflow: auto; /* Horizontal and Vertical Scroll */
            border-radius: 10px;
            border: 1px solid #e0e6ed;
            background: #ffffff;
        }

        /* --- Modern Data Table Styles --- */
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            white-space: nowrap; /* Prevents text from breaking into multiple lines, forcing horizontal scroll */
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
            font-size: 13px;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            border-right: 1px solid rgba(255,255,255,0.1); /* Subtle column separators in header */
        }

        td {
            padding: 14px 20px;
            font-size: 14px;
            color: var(--text-dark);
            border-bottom: 1px solid #f0f4f8;
            transition: background 0.2s ease;
        }

        tbody tr:hover td {
            background-color: #f8fafc;
        }

        /* --- Specific Column Styling & Badges --- */
        .col-id { font-weight: 700; color: var(--accent-teal); }
        .col-name { font-weight: 600; color: var(--primary-blue); }
        .col-money { font-weight: 600; color: var(--success-text); }
        .col-date { font-size: 13px; color: var(--text-muted); }

        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }

        /* Status Badges */
        .status-active { background: var(--success-bg); color: var(--success-text); border: 1px solid #c8e6c9; }
        .status-pending { background: var(--warning-bg); color: var(--warning-text); border: 1px solid #ffe082; }
        .status-inactive { background: var(--danger-bg); color: var(--danger-text); border: 1px solid #ffcdd2; }

        /* Role Badge */
        .badge-role { background: var(--info-bg); color: var(--info-text); border: 1px solid #bbdefb; }

        /* Meal Status Indicators */
        .meal-on { color: var(--success-text); font-weight: 700; }
        .meal-off { color: var(--danger-text); font-weight: 700; }
        .meal-icon { margin-right: 5px; }

        /* Scrollbar Styling for the Table Wrapper */
        .table-wrapper::-webkit-scrollbar { width: 10px; height: 10px; }
        .table-wrapper::-webkit-scrollbar-track { background: #f1f1f1; border-radius: 8px; }
        .table-wrapper::-webkit-scrollbar-thumb { background: #b0bec5; border-radius: 8px; border: 2px solid #f1f1f1; }
        .table-wrapper::-webkit-scrollbar-thumb:hover { background: var(--accent-teal); }

        /* Animations */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive Navbar */
        @media (max-width: 768px) {
            .navbar { padding: 15px 20px; }
            .nav-brand h1 { font-size: 18px; }
            .nav-brand span { display: none; }
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
            <div class="header-icon"><i class="fa-solid fa-address-book"></i></div>
            <div class="header-text">
                <h2>Boarder Directory</h2>
                <p>Complete database of all registered students, their roles, and current statuses.</p>
            </div>
        </div>

        <div class="table-card">
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Full Name</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th>DOB</th>
                            <th>Role</th>
                            <th>Course</th>
                            <th>Department</th>
                            <th>Registered At</th>
                            <th>Status</th>
                            <th>Room No.</th>
                            <th>Meal Charge</th>
                            <th>Meal Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection con = DriverManager.getConnection(
                                    "jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");
                                
                                // Assuming table name is 'students' or 'boarders', adjust if needed
                                String sql = "SELECT * FROM student ORDER BY id ASC"; 
                                PreparedStatement ps = con.prepareStatement(sql);
                                ResultSet rs = ps.executeQuery();
                                
                                while (rs.next()) {
                                    // Extract data for logic checks
                                    String status = rs.getString("status");
                                    String mealStatus = rs.getString("meal_status");
                                    
                                    // Determine CSS classes for Status
                                    String statusClass = "status-inactive";
                                    if(status != null && status.equalsIgnoreCase("active")) statusClass = "status-active";
                                    else if(status != null && status.equalsIgnoreCase("pending")) statusClass = "status-pending";
                        %>
                                    <tr>
                                        <td class="col-id">#<%= rs.getInt("id") %></td>
                                        
                                        <td class="col-name"><%= rs.getString("full_name") %></td>
                                        <td>@<%= rs.getString("username") %></td>
                                        
                                        <td><%= rs.getString("email") %></td>
                                        <td><%= rs.getString("phone") %></td>
                                        
                                        <td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis;" title="<%= rs.getString("address") %>">
                                            <%= rs.getString("address") %>
                                        </td>
                                        
                                        <td class="col-date"><%= rs.getDate("dob") %></td>
                                        
                                        <td>
                                            <span class="badge badge-role">
                                                <%= rs.getString("role") != null ? rs.getString("role") : "-" %>
                                            </span>
                                        </td>
                                        
                                        <td><%= rs.getString("course") %></td>
                                        <td><%= rs.getString("department") %></td>
                                        <td class="col-date"><%= rs.getTimestamp("created_at") %></td>
                                        
                                        <td>
                                            <span class="badge <%= statusClass %>">
                                                <%= status != null ? status : "Unknown" %>
                                            </span>
                                        </td>
                                        
                                        <td><strong><%= rs.getDouble("room_no") %></strong></td>
                                        <td class="col-money">₹ <%= rs.getDouble("meal_charge") %></td>
                                        
                                        <td>
                                            <% if(mealStatus != null && mealStatus.equalsIgnoreCase("on")) { %>
                                                <span class="meal-on"><i class="fa-solid fa-toggle-on meal-icon"></i>ON</span>
                                            <% } else { %>
                                                <span class="meal-off"><i class="fa-solid fa-toggle-off meal-icon"></i>OFF</span>
                                            <% } %>
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
                                    <td colspan="15" style="text-align: center; color: red; padding: 40px;">
                                        <i class="fa-solid fa-triangle-exclamation" style="font-size: 28px; margin-bottom: 15px; display: block;"></i>
                                        <strong>Failed to load boarder data.</strong><br>
                                        Please check your database connection or SQL table name.
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