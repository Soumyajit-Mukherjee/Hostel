<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.hostel.dao.studentDAO, com.hostel.model.student" %>
<%
    String adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    String searchUsername = request.getParameter("searchUsername");
    student student = null;
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");

    if (searchUsername != null && !searchUsername.isEmpty()) {
        studentDAO dao = new studentDAO(conn);
        student = dao.getStudentByUsername(searchUsername);
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
        /* --- CSS Variables & Reset --- */
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

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            display: flex;
            min-height: 100vh;
            overflow: hidden;
            background-color: var(--bg-color);
        }

        /* --- Left Side: Rich Gradient Branding --- */
        .left-panel {
            flex: 1;
            background: url('../images/hostel.png') center/cover no-repeat;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            text-align: center;
            padding: 50px;
        }

        .left-panel::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, rgba(11, 28, 74, 0.9) 0%, rgba(41, 118, 138, 0.8) 100%);
            z-index: 1;
        }

        .branding-content {
            position: relative;
            z-index: 2;
            animation: fadeIn 0.8s ease-out;
        }

        .branding-content img {
            width: 100px;
            margin-bottom: 25px;
            background: white;
            padding: 5px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }

        .branding-content h1 { font-size: 32px; font-weight: 700; margin-bottom: 5px; }
        .branding-content h2 { font-size: 18px; font-weight: 300; opacity: 0.9; }

        /* --- Right Side: Tool Interface --- */
        .right-panel {
            flex: 1.2;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border-left: 1px solid var(--glass-border);
            display: flex;
            flex-direction: column;
            padding: 40px 60px;
            overflow-y: auto;
            position: relative;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
        }

        .back-btn {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: color 0.3s;
        }

        .back-btn:hover { color: var(--primary-blue); }

        .form-header { margin-bottom: 30px; color: var(--primary-blue); }
        .form-header h2 { font-size: 28px; font-weight: 700; margin-bottom: 5px; }
        .form-header p { color: var(--text-muted); font-size: 15px; }

        /* --- Search Bar --- */
        .search-container {
            background: #fff;
            border: 1px solid #e0e6ed;
            border-radius: 12px;
            display: flex;
            align-items: center;
            padding: 5px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }

        .search-container:focus-within {
            border-color: var(--accent-teal);
            box-shadow: 0 4px 20px rgba(41, 118, 138, 0.15);
        }

        .search-container i {
            color: var(--text-muted);
            padding: 0 15px;
            font-size: 18px;
        }

        .search-container input {
            flex: 1;
            border: none;
            outline: none;
            padding: 15px 0;
            font-size: 16px;
            background: transparent;
        }

        .btn-search {
            background: var(--primary-blue);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-search:hover { background: var(--accent-teal); }

        /* --- Alerts --- */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
            font-size: 14px;
            animation: slideDown 0.3s ease;
        }

        .alert-success { background: #eafaf1; color: #27ae60; border: 1px solid #c3f0d5; }
        .alert-error { background: #fdedec; color: #c0392b; border: 1px solid #f5b7b1; }

        /* --- Student Profile Card --- */
        .profile-card {
            background: #fff;
            border: 1px solid #e0e6ed;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            animation: fadeIn 0.5s ease;
            margin-bottom: 30px;
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #f0f4f8;
        }

        .profile-avatar {
            width: 70px;
            height: 70px;
            background: rgba(41, 118, 138, 0.1);
            color: var(--accent-teal);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
        }

        .profile-info h3 { font-size: 22px; color: var(--primary-blue); font-weight: 600; margin-bottom: 3px; }
        .profile-info p { font-size: 14px; color: var(--text-muted); display: flex; align-items: center; gap: 8px; }
        
        .current-role {
            background: #f0f4f8;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            color: var(--primary-blue);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
            margin-top: 5px;
        }

        /* --- Assignment Form --- */
        .assign-form label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 10px;
        }

        .select-wrapper { position: relative; margin-bottom: 20px; }
        .select-wrapper select {
            width: 100%;
            padding: 16px 20px;
            border: 1px solid #e0e6ed;
            border-radius: 10px;
            font-size: 15px;
            outline: none;
            appearance: none;
            background: #fafafa;
            color: var(--text-dark);
            transition: all 0.3s;
            cursor: pointer;
        }

        .select-wrapper select:focus { border-color: var(--accent-teal); background: #fff; box-shadow: 0 0 0 4px rgba(41, 118, 138, 0.1); }
        .select-wrapper::after {
            content: '\f0d7';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #888;
            pointer-events: none;
        }

        .btn-assign {
            width: 100%;
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--accent-teal) 100%);
            color: white;
            border: none;
            padding: 16px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(41, 118, 138, 0.2);
        }

        .btn-assign:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(41, 118, 138, 0.3);
        }

        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        /* Responsive */
        @media (max-width: 960px) {
            body { flex-direction: column; overflow: auto; }
            .left-panel { flex: none; padding: 40px 20px; }
            .right-panel { padding: 30px 25px; border-left: none; }
        }
    </style>
</head>
<body>

    <div class="left-panel">
        <div class="branding-content">
            <img src="../images/bt_logo.png" alt="University Logo">
            <h1>RADHAKRISHNAN BHAWAN</h1>
            <h2>(B.T. MENS' HALL)</h2>
            <br>
            <p style="opacity: 0.8; font-size: 15px;">Administrative Control Panel</p>
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

        <% if (success != null) { %>
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check"></i> <%= success %>
            </div>
        <% } else if (error != null) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-triangle-exclamation"></i> <%= error %>
            </div>
        <% } %>

        <form method="get" action="approve_committee.jsp">
            <div class="search-container">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" name="searchUsername" placeholder="Enter boarder username..." required 
                       value="<%= searchUsername != null ? searchUsername : "" %>">
                <button type="submit" class="btn-search">Search</button>
            </div>
        </form>

        <% if (student != null) { %>
            
            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="fa-solid fa-user-tie"></i>
                    </div>
                    <div class="profile-info">
                        <h3>@<%= student.getUsername() %></h3>
                        <p><i class="fa-solid fa-phone"></i> <%= student.getPhone() %></p>
                        <div class="current-role">Current: <%= student.getRole() != null ? student.getRole() : "Boarder" %></div>
                    </div>
                </div>

                <form method="post" action="../approveCommitteeServlet" class="assign-form">
                    <input type="hidden" name="username" value="<%= student.getUsername() %>">
                    
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
                    
                    <button type="submit" class="btn-assign">
                        <i class="fa-solid fa-user-plus" style="margin-right: 8px;"></i> Update Role
                    </button>
                </form>
            </div>

        <% } else if (searchUsername != null && !searchUsername.isEmpty()) { %>
            <div class="alert alert-error" style="background: transparent; border: 2px dashed #f5b7b1; justify-content: center; padding: 30px; flex-direction: column;">
                <i class="fa-solid fa-user-xmark" style="font-size: 32px; color: #e74c3c;"></i>
                <span>No boarder found with the username "<strong><%= searchUsername %></strong>".</span>
            </div>
        <% } %>

    </div>

</body>
</html>