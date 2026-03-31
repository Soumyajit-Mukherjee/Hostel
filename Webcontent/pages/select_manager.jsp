<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.hostel.dao.studentDAO, com.hostel.model.student" %>
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
        if (userRole.equalsIgnoreCase("mess prefect")) {
            dashboardLink = "mess_prefect_dashboard.jsp";
        } else if (userRole.equalsIgnoreCase("auditor")) {
            dashboardLink = "auditor_dashboard.jsp";
        } else {
            dashboardLink = "student_dashboard.jsp";
        }
    }

    // 4. Search Logic
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
    <title>Manager Selection - Radhakrishnan Bhawan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* --- CSS Variables & Reset --- */
        :root {
            --primary-blue: #0b1c4a;
            --accent-teal: #29768a;
            --bg-color: #f8fafc;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --success-green: #0f766e;
            --danger-red: #dc2626;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body { display: flex; min-height: 100vh; overflow: hidden; background-color: var(--bg-color); }

        /* --- Left Side: Branding (Matches Screenshot) --- */
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
            background: linear-gradient(135deg, rgba(11, 28, 74, 0.92) 0%, rgba(41, 118, 138, 0.85) 100%); 
            z-index: 1;
        }

        .branding-content { position: relative; z-index: 2; animation: fadeIn 0.8s ease-out; }
        .branding-content img { width: 140px; margin-bottom: 25px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.3); }
        .branding-content h1 { font-size: 36px; font-weight: 700; margin-bottom: 5px; letter-spacing: 1px; }
        .branding-content h2 { font-size: 20px; font-weight: 400; opacity: 0.9; margin-bottom: 30px; }
        .branding-content p { font-size: 15px; opacity: 0.8; font-weight: 300; }

        /* --- Right Side: Interface --- */
        .right-panel {
            flex: 1.5; 
            background: var(--bg-color); 
            display: flex; 
            flex-direction: column; 
            padding: 50px 80px; 
            overflow-y: auto; 
            position: relative;
        }

        /* Top Back Button */
        .top-bar { margin-bottom: 40px; }
        .back-btn { 
            color: var(--text-muted); text-decoration: none; font-size: 14px; 
            font-weight: 500; display: inline-flex; align-items: center; gap: 8px; 
            transition: color 0.3s; 
        }
        .back-btn:hover { color: var(--primary-blue); }

        /* Header Section */
        .header-section { display: flex; align-items: flex-start; gap: 20px; margin-bottom: 30px; }
        .header-icon { 
            width: 55px; height: 55px; background: #e0f2fe; color: #0284c7; 
            border-radius: 14px; display: flex; align-items: center; justify-content: center; 
            font-size: 24px; flex-shrink: 0;
        }
        .header-text h2 { font-size: 26px; font-weight: 700; color: var(--primary-blue); margin-bottom: 4px; }
        .header-text p { font-size: 14px; color: var(--text-muted); line-height: 1.5; }

        /* Alerts */
        .alert { 
            padding: 14px 20px; border-radius: 10px; margin-bottom: 25px; 
            display: flex; align-items: center; gap: 10px; font-weight: 500; font-size: 14px; 
            animation: slideDown 0.3s ease; 
        }
        .alert-success { background: #ecfdf5; color: var(--success-green); border: 1px solid #a7f3d0; }
        .alert-error { background: #fef2f2; color: var(--danger-red); border: 1px solid #fecaca; }

        /* Form Content Card (White Box from Screenshot) */
        .content-card {
            background: #fff; 
            border: 1px solid var(--border-color); 
            border-radius: 16px; 
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03); 
            animation: fadeIn 0.5s ease;
            width: 100%;
            max-width: 650px;
        }

        /* Modern Search Input */
        .search-form { display: flex; gap: 15px; margin-bottom: 10px; }
        .search-wrapper { position: relative; flex: 1; }
        .search-wrapper i {
            position: absolute; left: 15px; top: 50%; transform: translateY(-50%);
            color: var(--text-muted); font-size: 16px;
        }
        .search-wrapper input {
            width: 100%; padding: 14px 15px 14px 45px; border: 2px solid var(--border-color);
            border-radius: 10px; font-size: 15px; outline: none; transition: border-color 0.3s;
            color: var(--text-dark); background: #f8fafc;
        }
        .search-wrapper input:focus { border-color: var(--primary-blue); background: #fff; }
        
        .btn-search {
            background: var(--primary-blue); color: white; border: none; padding: 0 25px;
            border-radius: 10px; font-size: 15px; font-weight: 600; cursor: pointer;
            transition: all 0.3s;
        }
        .btn-search:hover { background: #163072; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(11,28,74,0.2); }

        /* User Result Box */
        .result-box {
            margin-top: 30px;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            background: #f8fafc;
            overflow: hidden;
            animation: slideDown 0.4s ease;
        }

        .result-header {
            background: var(--primary-blue);
            color: white;
            padding: 15px 20px;
            font-size: 15px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .result-body { padding: 25px; }
        .result-row { display: flex; justify-content: space-between; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid var(--border-color); }
        .result-row:last-child { margin-bottom: 0; padding-bottom: 0; border-bottom: none; }
        
        .result-label { color: var(--text-muted); font-size: 13px; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }
        .result-value { color: var(--text-dark); font-weight: 600; font-size: 15px; }
        .role-badge { background: #e0f2fe; color: #0284c7; padding: 4px 12px; border-radius: 20px; font-size: 12px; text-transform: uppercase; }

        /* Role Update Form */
        .update-form {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-top: 25px;
            background: white;
            padding: 15px;
            border-radius: 10px;
            border: 1px solid var(--border-color);
        }

        .update-form select {
            flex: 1; padding: 10px 15px; border: 1px solid var(--border-color); border-radius: 8px;
            font-size: 14px; outline: none; background: #f8fafc;
        }
        
        .btn-update {
            background: var(--success-green); color: white; border: none; padding: 10px 20px;
            border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.3s;
        }
        .btn-update:hover { background: #115e59; transform: translateY(-2px); }

        /* Empty State */
        .empty-state { text-align: center; padding: 30px; color: var(--text-muted); }
        .empty-state i { font-size: 40px; color: #cbd5e1; margin-bottom: 15px; }

        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        /* Responsive */
        @media (max-width: 960px) { 
            body { flex-direction: column; overflow: auto; } 
            .left-panel { flex: none; padding: 40px 20px; } 
            .right-panel { padding: 30px 25px; } 
            .search-form { flex-direction: column; }
            .btn-search { padding: 14px; }
        }
    </style>
</head>
<body>

    <div class="left-panel">
        <div class="branding-content">
            <img src="../images/bt_logo.png" alt="University Logo">
            <h1>RADHAKRISHNAN BHAWAN</h1>
            <h2>(B.T. MENS' HALL)</h2>
            <p>Administrative Control Panel</p>
        </div>
    </div>

    <div class="right-panel">
        
        <div class="top-bar">
            <a href="<%= dashboardLink %>" class="back-btn">
                <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <div class="header-section">
            <div class="header-icon"><i class="fa-solid fa-user-gear"></i></div>
            <div class="header-text">
                <h2>Manager Selection</h2>
                <p>Search the boarder directory by username and elevate permissions to manager status.</p>
            </div>
        </div>

        <% if (success != null) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <%= success %></div>
        <% } else if (error != null) { %>
            <div class="alert alert-error"><i class="fa-solid fa-circle-xmark"></i> <%= error %></div>
        <% } %>

        <div class="content-card">
            
            <form method="get" action="select_manager.jsp" class="search-form">
                <div class="search-wrapper">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" name="searchUsername" placeholder="Enter boarder username (e.g., anup)" required value="<%= (searchUsername != null) ? searchUsername : "" %>">
                </div>
                <button type="submit" class="btn-search">Search</button>
            </form>

            <% if (student != null) { %>
                
                <div class="result-box">
                    <div class="result-header">
                        <i class="fa-solid fa-user"></i> Boarder Profile Found
                    </div>
                    <div class="result-body">
                        <div class="result-row">
                            <span class="result-label">Username</span>
                            <span class="result-value">@<%= student.getUsername() %></span>
                        </div>
                        <div class="result-row">
                            <span class="result-label">Contact No.</span>
                            <span class="result-value">+91 <%= student.getPhone() %></span>
                        </div>
                        <div class="result-row">
                            <span class="result-label">Current Role</span>
                            <span class="role-badge"><%= student.getRole() %></span>
                        </div>

                        <form method="post" action="../SelectManagerServlet" class="update-form">
                            <input type="hidden" name="username" value="<%= student.getUsername() %>">
                            <span class="result-label" style="margin-right: 10px;">Assign New Role:</span>
                            <select name="role" required>
                                <option value="" disabled selected>Select Role</option>
                                <option value="manager">Manager</option>
                                <option value="boarder">Boarder</option>
                            </select>
                            <button type="submit" class="btn-update">Update Access</button>
                        </form>
                    </div>
                </div>

            <% } else if (searchUsername != null) { %>
                
                <div class="empty-state">
                    <i class="fa-solid fa-user-slash"></i>
                    <p style="font-weight: 500; color: var(--text-dark);">No boarder found with username "@<%= searchUsername %>".</p>
                    <p style="font-size: 13px;">Please check the spelling and try again.</p>
                </div>
                
            <% } %>

        </div>

    </div>

</body>
</html>