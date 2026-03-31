<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String User = (String) session.getAttribute("username");
	if (User == null) {
    	response.sendRedirect("index.jsp");
    	return;
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - Radhakrishnan Bhawan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* --- CSS Variables --- */
        :root {
            --primary-blue: #0b1c4a;
            --accent-teal: #29768a;
            --accent-manager: #27ae60; /* Emerald Green to distinguish the Manager role */
            --bg-color: #f0f4f8;
            --text-dark: #333;
            --text-muted: #666;
            --glass-bg: rgba(255, 255, 255, 0.85);
            --glass-border: rgba(255, 255, 255, 0.4);
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
            background: rgba(11, 28, 74, 0.78); /* Deep blue tint for focus */
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

        .logout-btn {
            background: #fff0f0;
            color: #d32f2f;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #ffcdd2;
        }

        .logout-btn:hover {
            background: #d32f2f;
            color: white;
            box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
            border-color: #d32f2f;
        }

        /* --- Main Dashboard Content --- */
        .dashboard-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
            flex: 1;
            width: 100%;
        }

        .welcome-header {
            color: white;
            margin-bottom: 40px;
            animation: fadeInDown 0.6s ease;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            flex-wrap: wrap;
            gap: 15px;
        }

        .welcome-text h2 {
            font-size: 32px;
            font-weight: 600;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .role-badge {
            background: rgba(39, 174, 96, 0.2);
            color: #4ade80;
            border: 1px solid rgba(39, 174, 96, 0.5);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .welcome-text p {
            font-size: 16px;
            opacity: 0.85;
            font-weight: 300;
        }

        /* --- Action Cards Grid --- */
        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            animation: fadeInUp 0.8s ease;
        }

        .action-card {
            background: var(--glass-bg);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 30px 25px;
            text-decoration: none;
            color: var(--text-dark);
            display: flex;
            flex-direction: column;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }

        /* Decorative top accent line */
        .action-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-teal), var(--primary-blue));
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        /* Highlight the Manager specific cards with green */
        .manager-task::before {
            background: linear-gradient(90deg, var(--accent-manager), #2ecc71);
            opacity: 1; /* Always visible for priority tasks */
        }

        .action-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.25);
            border-color: rgba(41, 118, 138, 0.4);
        }

        .manager-task:hover {
            border-color: rgba(39, 174, 96, 0.5);
        }

        .action-card:hover::before {
            opacity: 1;
        }

        .card-icon {
            width: 65px;
            height: 65px;
            background: rgba(41, 118, 138, 0.08);
            color: var(--accent-teal);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .manager-task .card-icon {
            background: rgba(39, 174, 96, 0.1);
            color: var(--accent-manager);
        }

        .action-card:hover .card-icon {
            background: var(--accent-teal);
            color: white;
            transform: scale(1.05) rotate(2deg);
            box-shadow: 0 8px 20px rgba(41, 118, 138, 0.3);
        }

        .manager-task:hover .card-icon {
            background: var(--accent-manager);
            box-shadow: 0 8px 20px rgba(39, 174, 96, 0.3);
        }

        .action-card h3 {
            font-size: 19px;
            font-weight: 600;
            color: var(--primary-blue);
            margin-bottom: 10px;
        }

        .action-card p {
            font-size: 14px;
            color: var(--text-muted);
            line-height: 1.5;
            margin-bottom: 20px;
            flex-grow: 1;
        }

        .card-footer {
            display: flex;
            align-items: center;
            color: var(--accent-teal);
            font-size: 14px;
            font-weight: 600;
            margin-top: auto;
        }

        .manager-task .card-footer {
            color: var(--accent-manager);
        }

        .card-footer i {
            margin-left: 8px;
            transition: margin-left 0.3s ease;
        }

        .action-card:hover .card-footer i {
            margin-left: 12px;
        }

        /* Animations */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .navbar { padding: 15px 20px; }
            .nav-brand h1 { font-size: 18px; }
            .nav-brand span { display: none; }
            .action-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-brand">
            <img src="../images/bt_logo.png" alt="Hostel Logo">
            <div>
                <h1>Manager Portal</h1>
                <span>Radhakrishnan Bhawan</span>
            </div>
        </div>
        
        <a href="index.jsp" class="logout-btn">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    </nav>

    <div class="dashboard-container">
        
        <div class="welcome-header">
            <div class="welcome-text">
                <h2>Welcome back, Boarder <span class="role-badge"><i class="fa-solid fa-clipboard-check"></i> Manager</span></h2>
                <p>Manage hostel operations, track meals, and access your personal boarder services.</p>
            </div>
        </div>

        <div class="action-grid">
            
            <a href="count_meal.jsp" class="action-card manager-task">
                <div class="card-icon"><i class="fa-solid fa-clipboard-check"></i></div>
                <h3>Count Total Meal</h3>
                <p>Calculate and tally the total daily meals consumed by all boarders for operational records.</p>
                <div class="card-footer">Tally Meals <i class="fa-solid fa-arrow-right"></i></div>
            </a>

            <a href="view_boarders.jsp" class="action-card manager-task">
                <div class="card-icon"><i class="fa-solid fa-users"></i></div>
                <h3>View Total Boarders</h3>
                <p>Access the directory to see information and status of all current hostel residents.</p>
                <div class="card-footer">Open Directory <i class="fa-solid fa-arrow-right"></i></div>
            </a>

            <a href="meal_on_off.jsp" class="action-card">
                <div class="card-icon"><i class="fa-solid fa-utensils"></i></div>
                <h3>Meal On/Off</h3>
                <p>Manage your personal daily meal preferences and toggle your mess status.</p>
                <div class="card-footer">Manage Meals <i class="fa-solid fa-arrow-right"></i></div>
            </a>

            <a href="meal_charge_request.jsp" class="action-card">
                <div class="card-icon"><i class="fa-solid fa-file-invoice-dollar"></i></div>
                <h3>Give Meal Charge</h3>
                <p>Submit and record your own personal monthly mess and meal charge payments.</p>
                <div class="card-footer">Submit Payment <i class="fa-solid fa-arrow-right"></i></div>
            </a>

            <!--<a href="room_change.jsp" class="action-card">
                <div class="card-icon"><i class="fa-solid fa-bed"></i></div>
                <h3>Room Change Request</h3>
                <p>Submit an official application to transfer to a different room or wing.</p>
                <div class="card-footer">Apply Now <i class="fa-solid fa-arrow-right"></i></div>
            </a>-->

            <!--<a href="clearance.jsp" class="action-card">
                <div class="card-icon"><i class="fa-solid fa-file-circle-check"></i></div>
                <h3>Apply for Clearance</h3>
                <p>Request an official hostel clearance certificate for semester end or leaving.</p>
                <div class="card-footer">Request Clearance <i class="fa-solid fa-arrow-right"></i></div>
            </a>-->

        </div>
    </div>

</body>
</html>