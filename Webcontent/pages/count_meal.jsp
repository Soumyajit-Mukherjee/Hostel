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
    <title>Count Meal - Radhakrishnan Bhawan</title>
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
            --morning-color: #f59e0b; 
            --night-color: #3b82f6; 
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
        .header-section { display: flex; align-items: flex-start; gap: 20px; margin-bottom: 40px; }
        .header-icon { 
            width: 55px; height: 55px; background: #e0f2fe; color: #0284c7; 
            border-radius: 14px; display: flex; align-items: center; justify-content: center; 
            font-size: 24px; flex-shrink: 0;
        }
        .header-text h2 { font-size: 28px; font-weight: 700; color: var(--primary-blue); margin-bottom: 6px; }
        .header-text p { font-size: 15px; color: var(--text-muted); line-height: 1.5; }

        /* Alerts */
        .alert { 
            padding: 16px 20px; border-radius: 10px; margin-bottom: 30px; 
            display: flex; align-items: center; gap: 10px; font-weight: 500; font-size: 14px; 
            animation: slideDown 0.3s ease; 
        }
        .alert-success { background: #ecfdf5; color: var(--success-green); border: 1px solid #a7f3d0; }
        .alert-error { background: #fef2f2; color: var(--danger-red); border: 1px solid #fecaca; }

        /* --- Form Card --- */
        .form-card {
            background: #fff; 
            border: 1px solid var(--border-color); 
            border-radius: 16px; 
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03); 
            animation: fadeIn 0.5s ease;
            max-width: 550px;
        }

        .input-group { margin-bottom: 25px; text-align: left; }
        .input-group label { display: block; font-size: 14px; font-weight: 600; color: var(--text-dark); margin-bottom: 10px; }

        /* Date Input */
        .date-wrapper { position: relative; }
        .date-wrapper i { position: absolute; left: 18px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 16px; }
        .date-wrapper input {
            width: 100%; padding: 16px 16px 16px 45px; border: 2px solid var(--border-color); 
            border-radius: 12px; font-size: 15px; outline: none; color: var(--text-dark); 
            transition: all 0.3s ease; background: #f8fafc;
        }
        .date-wrapper input:focus { border-color: var(--primary-blue); background: #fff; box-shadow: 0 0 0 4px rgba(11, 28, 74, 0.05); }

        /* Custom Interactive Radio Buttons */
        .toggle-container { display: flex; gap: 15px; }
        .toggle-container input[type="radio"] { display: none; }
        .toggle-label {
            flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center;
            padding: 20px 10px; background: #f8fafc; border: 2px solid var(--border-color);
            border-radius: 12px; cursor: pointer; transition: all 0.3s ease; color: var(--text-muted);
        }
        .toggle-label i { font-size: 28px; margin-bottom: 8px; transition: transform 0.3s ease; }
        .toggle-label span { font-size: 14px; font-weight: 600; }
        .toggle-label:hover { background: #f1f5f9; transform: translateY(-2px); }

        /* Checked Status */
        #mealMorning:checked + .label-morning { background: #fffbeb; border-color: var(--morning-color); color: var(--morning-color); }
        #mealMorning:checked + .label-morning i { transform: scale(1.1); }
        #mealNight:checked + .label-night { background: #eff6ff; border-color: var(--night-color); color: var(--night-color); }
        #mealNight:checked + .label-night i { transform: scale(1.1); }

        /* Action Buttons */
        .btn-submit {
            width: 100%; background: var(--primary-blue); color: white; border: none; 
            padding: 16px; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; 
            transition: all 0.3s ease; display: flex; justify-content: center; align-items: center; gap: 10px;
            margin-bottom: 15px;
        }
        .btn-submit:hover { background: #163072; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(11, 28, 74, 0.2); }

        .btn-secondary {
            display: flex; justify-content: center; align-items: center; gap: 8px; width: 100%; 
            background: transparent; color: var(--text-muted); border: 2px solid var(--border-color); 
            padding: 14px; border-radius: 10px; font-size: 15px; font-weight: 600; text-decoration: none; 
            transition: all 0.3s ease;
        }
        .btn-secondary:hover { background: #f8fafc; color: var(--primary-blue); border-color: #cbd5e1; }

        /* Animations & Responsive */
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

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
            <div class="header-icon"><i class="fa-solid fa-calculator"></i></div>
            <div class="header-text">
                <h2>Count Meal Session</h2>
                <p>Calculate and record the total number of active boarders for a specific date and meal shift.</p>
            </div>
        </div>

        <%
            String msg = request.getParameter("msg");
            if ("success".equals(msg)) {
        %>
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check"></i> Meals have been counted and recorded successfully!
            </div>
        <% } else if ("error".equals(msg)) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-circle-xmark"></i> Failed to count meals. Please verify the system data.
            </div>
        <% } else if ("exception".equals(msg)) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-triangle-exclamation"></i> System error. Try again after some time.
            </div>
        <% } %>

        <div class="form-card">
            <form action="../MealCountServlet" method="post">
                
                <div class="input-group">
                    <label for="meal_date">Select Date</label>
                    <div class="date-wrapper">
                        <i class="fa-regular fa-calendar-days"></i>
                        <input type="date" id="meal_date" name="meal_date" required>
                    </div>
                </div>

                <div class="input-group">
                    <label>Select Meal Shift</label>
                    <div class="toggle-container">
                        <input type="radio" name="meal_type" id="mealMorning" value="morning" checked required>
                        <label for="mealMorning" class="toggle-label label-morning">
                            <i class="fa-solid fa-sun"></i>
                            <span>Morning Shift</span>
                        </label>

                        <input type="radio" name="meal_type" id="mealNight" value="night" required>
                        <label for="mealNight" class="toggle-label label-night">
                            <i class="fa-solid fa-moon"></i>
                            <span>Night Shift</span>
                        </label>
                    </div>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fa-solid fa-bolt"></i> Execute Meal Count
                </button>

                <a href="view_meal_count.jsp" class="btn-secondary">
                    <i class="fa-solid fa-chart-simple"></i> View The Total Count
                </a>
            </form>
        </div>

    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var dateInput = document.getElementById('meal_date');
            if(!dateInput.value) {
                var today = new Date();
                var yyyy = today.getFullYear();
                var mm = String(today.getMonth() + 1).padStart(2, '0');
                var dd = String(today.getDate()).padStart(2, '0');
                dateInput.value = yyyy + '-' + mm + '-' + dd;
            }
        });
    </script>
</body>
</html>