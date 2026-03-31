<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    // 1. Grab the current logged-in user and role
    String currentUser = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role");

    // 2. Security Kick-out if not logged in
    if (currentUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 3. Dynamic Dashboard Routing Logic
    String dashboardLink = "admin_dashboard.jsp"; 
    
    if ("admin".equalsIgnoreCase(currentUser)) {
        dashboardLink = "admin_dashboard.jsp";
    } else if (userRole != null) {
        if (userRole.equalsIgnoreCase("manager")) {
            dashboardLink = "manager_dashboard.jsp";
        } else if (userRole.equalsIgnoreCase("auditor")) {
            dashboardLink = "auditor_dashboard.jsp";
        } else if (userRole.equalsIgnoreCase("mess prefect")) {
            dashboardLink = "mess_prefect_dashboard.jsp";
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
    <title>All Boarders - Radhakrishnan Bhawan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* --- CSS Variables --- */
        :root {
            --table-header-bg: #0e1940; 
            --id-teal: #0d9488;
            --name-dark: #0f172a;
            --text-muted: #475569;
            --border-light: #f1f5f9;
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

        /* Dark overlay for the page background */
        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(11, 28, 74, 0.7); 
            backdrop-filter: blur(8px); 
            -webkit-backdrop-filter: blur(8px);
            z-index: 1;
        }

        /* --- Solid White Main Container --- */
        .directory-card {
            background: #ffffff;
            border-radius: 16px;
            width: 100%;
            max-width: 1250px;
            position: relative;
            z-index: 2;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
            padding: 30px;
            animation: slideUp 0.6s ease;
        }

        /* --- Minimal Header --- */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding: 0 15px;
        }

        .header-title h2 { color: var(--name-dark); font-size: 22px; font-weight: 700; }
        
        .btn-back {
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: color 0.3s ease;
        }

        .btn-back:hover { color: var(--table-header-bg); }

        /* =========================================
           MINI-SCREEN SCROLLING SYSTEM
           ========================================= */
        .table-scroll-window {
            width: 100%;
            max-height: 480px; /* Sets the height of the mini-screen */
            overflow-y: auto;  /* Enables vertical scrolling */
            overflow-x: auto;  /* Enables horizontal scrolling on small screens */
            padding-right: 8px; /* Prevents scrollbar from touching the edge */
            border-bottom: 1px solid var(--border-light);
        }

        /* Custom Sleek Scrollbar */
        .table-scroll-window::-webkit-scrollbar { width: 6px; height: 6px; }
        .table-scroll-window::-webkit-scrollbar-track { background: transparent; }
        .table-scroll-window::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
        .table-scroll-window::-webkit-scrollbar-thumb:hover { background: #94a3b8; }

        /* --- Premium Table Styling --- */
        table {
            width: 100%;
            border-collapse: separate; 
            border-spacing: 0;
            text-align: left;
            min-width: 900px; /* Forces horizontal scroll on phones to protect layout */
        }

        /* The Sticky Pill-Shaped Dark Header */
        thead {
            position: sticky;
            top: 0;
            z-index: 20; /* Keeps header above the scrolling rows */
        }

        thead th {
            background-color: var(--table-header-bg);
            color: #ffffff;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 18px 25px;
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); /* Slight shadow underneath header */
        }

        /* Rounding the ends of the header row */
        thead th:first-child { border-radius: 10px 0 0 10px; }
        thead th:last-child { border-radius: 0 10px 10px 0; }

        /* Row Styling */
        tbody td {
            padding: 22px 25px;
            font-size: 14px;
            color: var(--text-muted);
            border-bottom: 1px solid var(--border-light);
            vertical-align: middle;
            transition: background 0.2s ease;
            background-color: #ffffff; /* Ensures text doesn't overlap when scrolling */
        }

        tbody tr:hover td { background-color: #f8fafc; }
        tbody tr:last-child td { border-bottom: none; } 

        /* Specific Column Typography */
        .col-id { color: var(--id-teal); font-weight: 700; font-size: 15px; }
        .col-name { color: var(--name-dark); font-weight: 600; font-size: 15px; }
        
        /* Soft Badges for Meal Status */
        .status-pill {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-on { background: #ecfdf5; color: #059669; }
        .status-off { background: #fef2f2; color: #dc2626; }

        .error-msg { text-align: center; color: #dc2626; padding: 40px; font-weight: 500; }

        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

        @media (max-width: 768px) {
            .directory-card { padding: 20px; border-radius: 12px; }
            .top-nav { flex-direction: column; align-items: flex-start; gap: 15px; }
        }
    </style>
</head>
<body>

    <div class="directory-card">
        
        <div class="top-nav">
            <div class="header-title">
                <h2>Boarder Directory</h2>
            </div>
            
            <a href="<%= dashboardLink %>" class="btn-back">
                <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <div class="table-scroll-window">
            <table>
                <thead>
                    <tr>
                        
                        <th>Full Name</th>
                        
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Room</th>
                        
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection con = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");
                            stmt = con.createStatement();
                            
                            rs = stmt.executeQuery("SELECT * FROM student ORDER BY id ASC");
                            
                            boolean hasData = false;
                            while (rs.next()) {
                                hasData = true;
                                int roomNo = rs.getInt("room_no");
                                String mealStatus = rs.getString("meal_status");
                                if(mealStatus == null) mealStatus = "off";
                    %>
                    <tr>
                        
                        <td class="col-name"><%= rs.getString("full_name") %></td>
                        
                        <td><%= rs.getString("email") %></td>
                        <td>+91 <%= rs.getString("phone") %></td>
                        <td>
                            <% if (roomNo > 0) { %>
                                <%= roomNo %>
                            <% } else { %>
                                <span style="color: #94a3b8; font-size: 13px;">Unassigned</span>
                            <% } %>
                        </td>
                        
                    </tr>
                    <%
                            }
                            
                            if (!hasData) {
                    %>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 60px; color: #94a3b8;">
                                    <i class="fa-regular fa-folder-open" style="font-size: 40px; margin-bottom: 15px; display: block;"></i>
                                    No boarders found in the database.
                                </td>
                            </tr>
                    <%
                            }
                        } catch (Exception e) {
                    %>
                            <tr>
                                <td colspan="7" class="error-msg">
                                    <i class="fa-solid fa-triangle-exclamation"></i> Database Error: <%= e.getMessage() %>
                                </td>
                            </tr>
                    <%
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (stmt != null) stmt.close();
                                if (con != null) con.close();
                            } catch (SQLException se) {
                                out.println("<tr><td colspan='7' class='error-msg'>Connection Close Error: " + se.getMessage() + "</td></tr>");
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

    </div>

</body>
</html>