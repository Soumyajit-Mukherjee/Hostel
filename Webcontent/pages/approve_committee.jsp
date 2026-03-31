<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.hostel.dao.studentDAO, com.hostel.model.student" %>
<%
    // 1. Session Check
    String adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // 2. Database & Logic Preparation
    String searchUsername = request.getParameter("searchUsername");
    student studentObj = null; // Renamed from 'student' to 'studentObj' to avoid class name conflict
    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Fetch Cloud Credentials
        String dbUrl = System.getenv("DB_URL");
        String dbUser = System.getenv("DB_USER");
        String dbPass = System.getenv("DB_PASS");

        // Fallback for Localhost
        if (dbUrl == null || dbUrl.isEmpty()) {
            dbUrl = "jdbc:mysql://localhost:3306/hostel_management";
            dbUser = "root";
            dbPass = "Soumyajit@123";
        }

        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        if (searchUsername != null && !searchUsername.isEmpty()) {
            studentDAO dao = new studentDAO(conn);
            studentObj = dao.getStudentByUsername(searchUsername);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approve Committee - Radhakrishnan Bhawan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* [YOUR EXISTING CSS STYLES HERE - Keep them exactly as they were] */
        :root {
            --primary-blue: #0b1c4a;
            --accent-teal: #29768a;
            --bg-color: #f0f4f8;
            --text-dark: #333;
            --text-muted: #666;
            --glass-bg: rgba(255, 255, 255, 0.95);
            --glass-border: rgba(255, 255, 255, 0.5);
            --success-color: #2ecc71;
            --error-color: #e74c3c;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: var(--bg-color); }
        .left-panel { flex: 1; background: url('../images/hostel.png') center/cover no-repeat; position: relative; display: flex; flex-direction: column; justify-content: center; align-items: center; color: white; text-align: center; padding: 50px; }
        .left-panel::before { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(135deg, rgba(11, 28, 74, 0.9) 0%, rgba(41, 118, 138, 0.8) 100%); z-index: 1; }
        .branding-content { position: relative; z-index: 2; }
        .branding-content img { width: 100px; margin-bottom: 25px; background: white; padding: 5px; border-radius: 12px; }
        .branding-content h1 { font-size: 32px; font-weight: 700; }
        .right-panel { flex: 1.2; background: var(--glass-bg); display: flex; flex-direction: column; padding: 40px 60px; border-left: 1px solid var(--glass-border); }
        .top-bar { display: flex; justify-content: space-between; margin-bottom: 40px; }
        .back-btn { color: var(--text-muted); text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .search-container { background: #fff; border: 1px solid #e0e6ed; border-radius: 12px; display: flex; align-items: center; padding: 5px; margin-bottom: 30px; }
        .search-container input { flex: 1; border: none; outline: none; padding: 15px; font-size: 16px; }
        .btn-search { background: var(--primary-blue); color: white; border: none; padding: 12px 25px; border-radius: 8px; cursor: pointer; }
        .alert { padding: 15px; border-radius: 10px; margin-bottom: 25px; font-size: 14px; }
        .alert-success { background: #eafaf1; color: #27ae60; }
        .alert-error { background: #fdedec; color: #c0392b; }
        .profile-card { background: #fff; border: 1px solid #e0e6ed; border-radius: 16px; padding: 30px; }
        .profile-header { display: flex; align-items: center; gap: 20px; margin-bottom: 25px; }
        .profile-avatar { width: 70px; height: 70px; background: #eee; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 30px; }
        .select-wrapper { margin-bottom: 20px; }
        .select-wrapper select { width: 100%; padding: 15px; border-radius: 10px; border: 1px solid #ccc; }
        .btn-assign { width: 100%; padding: 15px; background: var(--primary-blue); color: white; border: none; border-radius: 10px; font-weight: bold; cursor: pointer; }
    </style>
</head>
<body>

    <div class="left-panel">
        <div class="branding-content">
            <img src="../images/bt_logo.png" alt="Logo">
            <h1>RADHAKRISHNAN BHAWAN</h1>
            <h2>(B.T. MENS' HALL)</h2>
            <p>Administrative Control Panel</p>
        </div>
    </div>

    <div class="right-panel">
        <div class="top-bar">
            <a href="admin_dashboard.jsp" class="back-btn">
                <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <div class="form-header">
            <h2>Approve Committee Members</h2>
            <p>Search for a boarder to elevate their administrative role.</p>
        </div>

        <%-- Alerts --%>
        <% if (success != null) { %>
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check"></i> <%= success %>
            </div>
        <% } else if (error != null) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-triangle-exclamation"></i> <%= error %>
            </div>
        <% } %>

        <%-- Search Form --%>
        <form method="get" action="approve_committee.jsp">
            <div class="search-container">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" name="searchUsername" placeholder="Enter boarder username..." required 
                       value="<%= searchUsername != null ? searchUsername : "" %>">
                <button type="submit" class="btn-search">Search</button>
            </div>
        </form>

        <%-- Results Section --%>
        <% if (studentObj != null) { %>
            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="fa-solid fa-user-tie"></i>
                    </div>
                    <div class="profile-info">
                        <h3>@<%= studentObj.getUsername() %></h3>
                        <p><i class="fa-solid fa-phone"></i> <%= studentObj.getPhone() %></p>
                        <div class="current-role">Current: <%= studentObj.getRole() != null ? studentObj.getRole() : "Boarder" %></div>
                    </div>
                </div>

                <form method="post" action="../approveCommitteeServlet" class="assign-form">
                    <input type="hidden" name="username" value="<%= studentObj.getUsername() %>">
                    <label>Assign New Committee Role:</label>
                    <div class="select-wrapper">
                        <select name="role" required>
                            <option value="" disabled selected>-- Select Official Role --</option>
                            <option value="maintenance">Maintenance</option>
                            <option value="mess prefect">Mess Prefect</option>
                            <option value="auditor">Auditor</option>
                            <option value="technician">Technician</option>
                            <option value="gardener/game prefect">Gardener / Game Prefect</option>
                            <option value="boarder">Boarder (Standard)</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-assign">Update Role</button>
                </form>
            </div>
        <% } else if (searchUsername != null && !searchUsername.isEmpty()) { %>
            <div class="alert alert-error" style="text-align: center; border: 2px dashed #f5b7b1;">
                <i class="fa-solid fa-user-xmark" style="font-size: 32px;"></i>
                <p>No boarder found with username "<strong><%= searchUsername %></strong>".</p>
            </div>
        <% } %>
    </div>

    <%-- Clean up connection --%>
    <% if (conn != null) try { conn.close(); } catch(SQLException ignore) {} %>

</body>
</html>
