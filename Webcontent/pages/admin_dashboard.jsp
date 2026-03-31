<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String adminUser = (String) session.getAttribute("username");
	if (adminUser == null) {
    	response.sendRedirect("index.jsp");
    	return;
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Radhakrishnan Bhawan</title>
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
            background: rgba(11, 28, 74, 0.75); /* Deep blue tint */
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
            background: #ffebee;
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
        }

        .logout-btn:hover {
            background: #d32f2f;
            color: white;
            box-shadow: 0 4px 10px rgba(211, 47, 47, 0.3);
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
        }

        .welcome-header h2 {
            font-size: 32px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .welcome-header p {
            font-size: 16px;
            opacity: 0.8;
            font-weight: 300;
        }

        /* --- Action Cards Grid --- */
        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
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
            background: linear-gradient(90deg, var(--primary-blue), var(--accent-teal));
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .action-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            border-color: rgba(41, 118, 138, 0.4);
        }

        .action-card:hover::before {
            opacity: 1;
        }

        .card-icon {
            width: 60px;
            height: 60px;
            background: rgba(41, 118, 138, 0.1);
            color: var(--accent-teal);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .action-card:hover .card-icon {
            background: var(--accent-teal);
            color: white;
            transform: scale(1.05);
        }

        .action-card h3 {
            font-size: 18px;
            font-weight: 600;
            color: var(--primary-blue);
            margin-bottom: 10px;
        }

        .action-card p {
            font-size: 14px;
            color: var(--text-muted);
            line-height: 1.5;
            margin-bottom: 15px;
            flex-grow: 1; /* Pushes the arrow to the bottom */
        }

        .card-footer {
            display: flex;
            align-items: center;
            color: var(--accent-teal);
            font-size: 14px;
            font-weight: 600;
        }

        .card-footer i {
            margin-left: 8px;
            transition: margin-left 0.3s ease;
        }

        .action-card:hover .card-footer i {
            margin-left: 12px; /* Arrow slides right on hover */
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
                <h1>Admin Control Panel</h1>
                <span>Radhakrishnan Bhawan</span>
            </div>
        </div>
        <a href="index.jsp" class="logout-btn">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    </nav>

    <div class="dashboard-container">
        
        <div class="welcome-header">
            <h2>Welcome back, Administrator</h2>
            <p>Manage hostel operations, boarders, and financial records from your dashboard.</p>
        </div>

        <div class="action-grid">
            
            <a href="manage_notices.jsp" class="action-card">
                <div class="card-icon" style="color: #d32f2f; background: rgba(211, 47, 47, 0.1);"><i class="fa-solid fa-bullhorn"></i></div>
                <h3>Declare Notice</h3>
                <p>Broadcast, edit, or delete important announcements displayed on the student homescreen.</p>
                <div class="card-footer" style="color: #d32f2f;">Manage <i class="fa-solid fa-arrow-right"></i></div>
            </a>

            <a href="update_meal_charge.jsp" class="action-card">
                <div class="card-icon"><i class="fa-solid fa-file-invoice-dollar"></i></div>
                <h3>Update Due List</h3>
                <p>Manage pending fines, fees, and outstanding dues for students.</p>
                <div class="card-footer">Manage Dues <i class="fa-solid fa-arrow-right"></i></div>
            </a>

            <a href="boarder_meal_charge.jsp" class="action-card">
                <div class="card-icon"><i class="fa-solid fa-utensils"></i></div>
                <h3>Update Meal Charges</h3>
                <p>Calculate and update the monthly mess and meal charges for boarders.</p>
                <div class="card-footer">Update Meals <i class="fa-solid fa-arrow-right"></i></div>
            </a>

            <a href="approve_students.jsp" class="action-card">
                <div class="card-icon"><i class="fa-solid fa-user-check"></i></div>
                <h3>Approve Boarders</h3>
                <p>Review new student registrations and approve room allocations.</p>
                <div class="card-footer">Review Applications <i class="fa-solid fa-arrow-right"></i></div>
            </a>

            <a href="approve_committee.jsp" class="action-card">
                <div class="card-icon"><i class="fa-solid fa-users-gear"></i></div>
                <h3>Approve Committee</h3>
                <p>Assign and approve roles like Mess Prefect, Auditor, or Manager.</p>
                <div class="card-footer">Manage Roles <i class="fa-solid fa-arrow-right"></i></div>
            </a>

            <a href="view_students.jsp" class="action-card">
                <div class="card-icon"><i class="fa-solid fa-address-book"></i></div>
                <h3>View All Boarders</h3>
                <p>Access the complete directory of current hostel residents and their details.</p>
                <div class="card-footer">Open Directory <i class="fa-solid fa-arrow-right"></i></div>
            </a>

            </div>
    </div>

</body>
</html>