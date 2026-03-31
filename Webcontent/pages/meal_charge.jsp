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
        if (userRole.equalsIgnoreCase("auditor")) {
            dashboardLink = "auditor_dashboard.jsp";
        } else if (userRole.equalsIgnoreCase("manager")) {
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
    <title>Declare Meal Charge - Radhakrishnan Bhawan</title>
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
            /* Deep blue to teal gradient */
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
            animation: slideDown 0.3s ease; background: #ecfdf5; color: var(--success-green); border: 1px solid #a7f3d0; 
        }

        /* Form Card */
        .form-card {
            background: #fff; 
            border: 1px solid var(--border-color); 
            border-radius: 16px; 
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03); 
            animation: fadeIn 0.5s ease;
            max-width: 600px;
        }

        .form-card label { display: block; font-size: 14px; font-weight: 600; color: var(--text-dark); margin-bottom: 12px; }
        
        .amount-wrapper { position: relative; margin-bottom: 30px; }
        .amount-wrapper i { 
            position: absolute; left: 20px; top: 50%; transform: translateY(-50%); 
            color: var(--primary-blue); font-size: 24px; font-weight: bold; 
        }
        
        .amount-wrapper input {
            width: 100%; padding: 20px 20px 20px 55px; border: 2px solid var(--border-color); 
            border-radius: 12px; font-size: 28px; font-weight: 700; color: var(--primary-blue); 
            outline: none; transition: all 0.3s ease; background: #f8fafc; letter-spacing: 1px;
        }

        .amount-wrapper input:focus { border-color: var(--primary-blue); background: #fff; box-shadow: 0 0 0 4px rgba(11, 28, 74, 0.05); }

        /* Hide up/down arrows on number inputs */
        .amount-wrapper input::-webkit-outer-spin-button, .amount-wrapper input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
        .amount-wrapper input[type=number] { -moz-appearance: textfield; }

        .btn-submit {
            width: 100%; background: var(--primary-blue); color: white; border: none; 
            padding: 16px; border-radius: 10px; font-size: 16px; font-weight: 600; 
            cursor: pointer; transition: all 0.3s ease; display: flex; justify-content: center; 
            align-items: center; gap: 10px;
        }
        .btn-submit:hover { background: #163072; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(11, 28, 74, 0.2); }

        /* Dynamic Date Badge */
        .billing-cycle {
            display: inline-flex; align-items: center; gap: 6px; background: #f1f5f9; 
            color: var(--text-muted); padding: 6px 14px; border-radius: 20px; 
            font-size: 13px; font-weight: 600; margin-top: 15px; border: 1px solid var(--border-color);
        }

        /* Animations */
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
            <div class="header-icon"><i class="fa-solid fa-file-invoice-dollar"></i></div>
            <div class="header-text">
                <h2>Declare Meal Charge</h2>
                <p>Calculate and submit the final rate per meal for the current billing cycle. This action will update the ledger for all active boarders.</p>
                <div class="billing-cycle" id="currentMonthText">
                    <i class="fa-regular fa-calendar"></i> Billing Cycle: Loading...
                </div>
            </div>
        </div>

        <% 
            String msg = request.getParameter("message");
            if (msg != null && !msg.trim().isEmpty()) { 
        %>
            <div class="alert">
                <i class="fa-solid fa-circle-check"></i> <%= msg %>
            </div>
        <% } %>

        <div class="form-card">
            <form action="../MealChargeServlet" method="post" onsubmit="return confirm('Are you sure you want to finalize and publish this meal charge?');">
                
                <input type="hidden" name="username" value="<%= currentUser %>">

                <label for="amount">Final Charge Per Meal</label>
                <div class="amount-wrapper">
                    <i class="fa-solid fa-indian-rupee-sign"></i>
                    <input type="number" id="amount" name="amount" step="0.01" min="0" placeholder="0.00" required autofocus>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fa-solid fa-check-double"></i> Publish Meal Charge
                </button>
            </form>
        </div>

    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const date = new Date();
            const monthNames = ["January", "February", "March", "April", "May", "June",
                                "July", "August", "September", "October", "November", "December"];
            const currentMonth = monthNames[date.getMonth()];
            const currentYear = date.getFullYear();
            
            document.getElementById('currentMonthText').innerHTML = 
                `<i class="fa-regular fa-calendar"></i> Billing Cycle: ${currentMonth} ${currentYear}`;
        });
    </script>

</body>
</html>