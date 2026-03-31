<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    // 1. Grab the current logged-in user and role
    String currentUser = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role");

    // 2. Security Kick-out if not logged in
    if (currentUser == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    // 3. Dynamic Dashboard Routing Logic
    String dashboardLink = "admin_dashboard.jsp"; 
    
    if ("admin".equalsIgnoreCase(currentUser)) {
        dashboardLink = "admin_dashboard.jsp";
    } else if (userRole != null) {
        if (userRole.equalsIgnoreCase("manager")) {
            dashboardLink = "manager_dashboard.jsp";
        } else if (userRole.equalsIgnoreCase("mess prefect")) {
            dashboardLink = "mess_prefect_dashboard.jsp";
        } else if (userRole.equalsIgnoreCase("auditor")) {
            dashboardLink = "auditor_dashboard.jsp";
        } else {
            dashboardLink = "student_dashboard.jsp";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meal History - Radhakrishnan Bhawan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* --- CSS Variables --- */
        :root {
            --primary-blue: #0b1c4a;
            --accent-teal: #29768a;
            --morning-color: #f59e0b; /* Amber */
            --night-color: #3b82f6; /* Blue */
            --bg-color: #f0f4f8;
            --text-dark: #333;
            --text-muted: #666;
            --glass-bg: rgba(255, 255, 255, 0.92);
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
            display: flex;
            align-items: center;
            justify-content: center;
            background: url('../images/hostel.png') center/cover no-repeat fixed;
            position: relative;
            padding: 40px 20px;
        }

        /* Frosted Glass Overlay */
        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(11, 28, 74, 0.7); 
            backdrop-filter: blur(8px); 
            -webkit-backdrop-filter: blur(8px);
            z-index: 1;
        }

        /* --- Main Container --- */
        .history-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            width: 100%;
            max-width: 900px;
            position: relative;
            z-index: 2;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.4);
            overflow: hidden;
            animation: slideUp 0.6s ease;
        }

        /* --- Header Section --- */
        .card-header {
            background: linear-gradient(135deg, rgba(11, 28, 74, 0.05) 0%, rgba(41, 118, 138, 0.1) 100%);
            padding: 30px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }

        .header-title { display: flex; align-items: center; gap: 15px; }
        
        .header-icon {
            width: 50px; height: 50px;
            background: var(--primary-blue);
            color: white;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 24px;
            box-shadow: 0 4px 15px rgba(11, 28, 74, 0.3);
        }

        .header-title h2 { color: var(--primary-blue); font-size: 24px; font-weight: 700; }
        .header-title p { color: var(--text-muted); font-size: 14px; margin-top: 2px; }

        .btn-back {
            background: #f1f5f9;
            color: var(--text-muted);
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            border: 1px solid #e2e8f0;
        }

        .btn-back:hover {
            background: var(--primary-blue);
            color: white;
            border-color: var(--primary-blue);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(11, 28, 74, 0.2);
        }

        /* --- Table Styling --- */
        .table-container {
            padding: 30px 40px;
            max-height: 500px;
            overflow-y: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        thead {
            position: sticky;
            top: 0;
            background: #f8fafc;
            z-index: 10;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        th {
            padding: 15px 20px;
            font-weight: 600;
            font-size: 13px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e2e8f0;
        }

        td {
            padding: 16px 20px;
            font-size: 15px;
            color: var(--text-dark);
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
            transition: background 0.2s ease;
        }

        tbody tr:hover td { background-color: #f8fafc; }

        .col-date { font-weight: 600; color: var(--primary-blue); }
        
        .col-count { 
            font-weight: 700; 
            color: var(--primary-blue); 
            font-size: 18px !important;
        }

        /* Custom Badges for Meal Type */
        .badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .badge-morning { background: #fffbeb; color: var(--morning-color); border: 1px solid #fef3c7; }
        .badge-night { background: #eff6ff; color: var(--night-color); border: 1px solid #dbeafe; }

        .error-msg { text-align: center; color: #d93025; padding: 20px; font-weight: 500; }

        /* Scrollbar Styling */
        .table-container::-webkit-scrollbar { width: 8px; }
        .table-container::-webkit-scrollbar-track { background: #f1f1f1; border-radius: 4px; }
        .table-container::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }
        .table-container::-webkit-scrollbar-thumb:hover { background: var(--accent-teal); }

        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

        @media (max-width: 768px) {
            .card-header { flex-direction: column; gap: 20px; align-items: flex-start; }
            .table-container { padding: 20px; }
            th, td { padding: 12px 15px; }
        }
    </style>
</head>
<body>

    <div class="history-card">
        
        <div class="card-header">
            <div class="header-title">
                <div class="header-icon"><i class="fa-solid fa-chart-line"></i></div>
                <div>
                    <h2>Meal Count History</h2>
                    <p>Log of all active boarder headcounts calculated by @<%= currentUser %>.</p>
                </div>
            </div>
            
            <a href="<%= dashboardLink %>" class="btn-back">
                <i class="fa-solid fa-arrow-left"></i> Back
            </a>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th><i class="fa-solid fa-calendar-day" style="margin-right: 5px; color: var(--accent-teal);"></i> Record Date</th>
                        <th><i class="fa-solid fa-clock" style="margin-right: 5px; color: var(--accent-teal);"></i> Meal Session</th>
                        <th style="text-align: right;"><i class="fa-solid fa-users" style="margin-right: 5px; color: var(--accent-teal);"></i> Total Headcount</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");

                            String sql = "SELECT * FROM meal_count WHERE manager_username = ? ORDER BY meal_date DESC";
                            ps = conn.prepareStatement(sql);
                            ps.setString(1, currentUser);
                            rs = ps.executeQuery();

                            boolean hasData = false;
                            while (rs.next()) {
                                hasData = true;
                                String type = rs.getString("meal_type");
                    %>
                                <tr>
                                    <td class="col-date"><%= rs.getDate("meal_date") %></td>
                                    <td>
                                        <% if ("morning".equalsIgnoreCase(type)) { %>
                                            <span class="badge badge-morning"><i class="fa-solid fa-sun"></i> Morning</span>
                                        <% } else if ("night".equalsIgnoreCase(type)) { %>
                                            <span class="badge badge-night"><i class="fa-solid fa-moon"></i> Night</span>
                                        <% } else { %>
                                            <span class="badge" style="background:#f1f5f9; color:#666;"><%= type %></span>
                                        <% } %>
                                    </td>
                                    <td style="text-align: right;" class="col-count"><%= rs.getInt("total_meals") %></td>
                                </tr>
                    <%
                            }

                            if (!hasData) {
                    %>
                                <tr>
                                    <td colspan="3" style="text-align: center; padding: 40px; color: #666;">
                                        <i class="fa-regular fa-folder-open" style="font-size: 40px; color: #cbd5e1; margin-bottom: 10px; display: block;"></i>
                                        You have not recorded any meal counts yet.
                                    </td>
                                </tr>
                    <%
                            }
                        } catch (Exception e) {
                    %>
                            <tr>
                                <td colspan="3" class="error-msg">
                                    <i class="fa-solid fa-triangle-exclamation"></i> Error loading records: <%= e.getMessage() %>
                                </td>
                            </tr>
                    <%
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (ps != null) ps.close();
                                if (conn != null) conn.close();
                            } catch (SQLException se) {
                                out.println("<tr><td colspan='3' class='error-msg'>Connection Close Error</td></tr>");
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

    </div>

</body>
</html>