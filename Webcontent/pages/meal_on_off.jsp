<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    // Security check
    if (username == null || role == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Map role to dashboard page
    String dashboardPage = "student_dashboard.jsp"; // default
    switch (role.toLowerCase()) {
        case "manager": dashboardPage = "manager_dashboard.jsp"; break;
        case "mess prefect": dashboardPage = "mess_prefect_dashboard.jsp"; break;
        case "maintenance": dashboardPage = "maintenance_dashboard.jsp"; break;
        case "technician": dashboardPage = "librarian_dashboard.jsp"; break;
        case "gardener": dashboardPage = "gardener_game_dashboard.jsp"; break;
        case "auditor": dashboardPage = "auditor_dashboard.jsp"; break;
    }

    // --- FETCH CURRENT MEAL STATUS ---
    String currentStatus = "Unknown";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");
        String sql = "SELECT meal_status FROM student WHERE username = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            currentStatus = rs.getString("meal_status");
            if (currentStatus == null) currentStatus = "off"; // Default fallback
        }
        
        rs.close(); ps.close(); conn.close();
    } catch (Exception e) {
        currentStatus = "Error";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meal Preference - Radhakrishnan Bhawan</title>
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
            --success-green: #059669;
            --danger-red: #dc2626;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body { display: flex; min-height: 100vh; overflow: hidden; background-color: var(--bg-color); }

        /* --- Left Side: Branding --- */
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

        /* Solid White Form Card */
        .form-card {
            background: #fff; 
            border: 1px solid var(--border-color); 
            border-radius: 16px; 
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03); 
            animation: fadeIn 0.5s ease;
            max-width: 600px;
        }

        /* --- Current Status Indicator --- */
        .status-banner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #f8fafc;
            border: 1px solid var(--border-color);
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .status-banner p { font-size: 14px; font-weight: 600; color: var(--text-muted); margin: 0; }
        
        .status-badge {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .badge-on { background: #ecfdf5; color: var(--success-green); border: 1px solid #a7f3d0; }
        .badge-off { background: #fef2f2; color: var(--danger-red); border: 1px solid #fecaca; }

        /* --- Alert Messages --- */
        .alert {
            padding: 14px 20px; border-radius: 10px; margin-bottom: 25px;
            display: flex; align-items: center; gap: 10px; font-size: 14px;
            font-weight: 500; animation: slideDown 0.3s ease;
        }

        .alert-success { background: #ecfdf5; color: var(--success-green); border: 1px solid #a7f3d0; }
        .alert-error { background: #fef2f2; color: var(--danger-red); border: 1px solid #fecaca; }

        /* --- Interactive Radio Toggles --- */
        .toggle-container { display: flex; gap: 15px; margin-bottom: 30px; }
        .toggle-container input[type="radio"] { display: none; }

        .toggle-label {
            flex: 1; display: flex; flex-direction: column; align-items: center;
            justify-content: center; padding: 30px 15px; background: #f8fafc;
            border: 2px solid var(--border-color); border-radius: 12px;
            cursor: pointer; transition: all 0.3s ease; color: var(--text-muted);
        }

        .toggle-label i { font-size: 32px; margin-bottom: 12px; transition: transform 0.3s ease; }
        .toggle-label span { font-size: 16px; font-weight: 600; letter-spacing: 0.5px; }
        .toggle-label:hover { background: #f1f5f9; transform: translateY(-2px); }

        /* Checked Status: ON */
        #mealOn:checked + .label-on {
            background: #ecfdf5; border-color: var(--success-green); color: var(--success-green);
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.1);
        }
        #mealOn:checked + .label-on i { transform: scale(1.1); }

        /* Checked Status: OFF */
        #mealOff:checked + .label-off {
            background: #fef2f2; border-color: var(--danger-red); color: var(--danger-red);
            box-shadow: 0 4px 15px rgba(220, 38, 38, 0.1);
        }
        #mealOff:checked + .label-off i { transform: scale(1.1); }

        /* --- Action Button --- */
        .btn-submit {
            width: 100%; background: var(--primary-blue); color: white; border: none;
            padding: 16px; border-radius: 10px; font-size: 16px; font-weight: 600;
            cursor: pointer; transition: all 0.3s ease; display: flex;
            justify-content: center; align-items: center; gap: 10px;
        }

        .btn-submit:hover {
            background: #163072; transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(11, 28, 74, 0.2);
        }

        /* Animations */
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        /* Responsive */
        @media (max-width: 960px) { 
            body { flex-direction: column; overflow: auto; } 
            .left-panel { flex: none; padding: 40px 20px; } 
            .right-panel { padding: 30px 25px; border-left: none; } 
            .toggle-container { flex-direction: column; }
            .status-banner { flex-direction: column; gap: 10px; text-align: center; }
        }
    </style>
</head>
<body>

    <div class="left-panel">
        <div class="branding-content">
            <img src="../images/bt_logo.png" alt="University Logo">
            <h1>RADHAKRISHNAN BHAWAN</h1>
            <h2>(B.T. MENS' HALL)</h2>
            <p>Student Services Portal</p>
        </div>
    </div>

    <div class="right-panel">
        
        <div class="top-bar">
            <a href="<%= dashboardPage %>" class="back-btn">
                <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <div class="header-section">
            <div class="header-icon"><i class="fa-solid fa-bell-concierge"></i></div>
            <div class="header-text">
                <h2>Meal Configuration</h2>
                <p>Update your daily mess attendance status. This helps the mess committee estimate the daily required food quantities.</p>
            </div>
        </div>

        <div class="form-card">
            
            <div class="status-banner">
                <p>Your Current Meal Status:</p>
                <% if ("on".equalsIgnoreCase(currentStatus)) { %>
                    <span class="status-badge badge-on"><i class="fa-solid fa-circle-check"></i> ON</span>
                <% } else { %>
                    <span class="status-badge badge-off"><i class="fa-solid fa-power-off"></i> OFF</span>
                <% } %>
            </div>

            <%
                String msg = request.getParameter("msg");
                if ("success".equals(msg)) {
            %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i> Your meal preference was successfully saved!
                </div>
            <% } else if ("error".equals(msg)) { %>
                <div class="alert alert-error">
                    <i class="fa-solid fa-circle-xmark"></i> Failed to update meal status. Please try again.
                </div>
            <% } %>

            <form action="../MealOnOffServlet" method="post">
                
                <div class="toggle-container">
                    <input type="radio" name="meal_on_off" id="mealOn" value="on" required <%= "on".equalsIgnoreCase(currentStatus) ? "checked" : "" %>>
                    <label for="mealOn" class="toggle-label label-on">
                        <i class="fa-solid fa-utensils"></i>
                        <span>MEAL ON</span>
                    </label>

                    <input type="radio" name="meal_on_off" id="mealOff" value="off" required <%= !"on".equalsIgnoreCase(currentStatus) ? "checked" : "" %>>
                    <label for="mealOff" class="toggle-label label-off">
                        <i class="fa-solid fa-power-off"></i>
                        <span>MEAL OFF</span>
                    </label>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fa-solid fa-floppy-disk"></i> Save New Preference
                </button>
            </form>
            
        </div>

    </div>

</body>
</html>