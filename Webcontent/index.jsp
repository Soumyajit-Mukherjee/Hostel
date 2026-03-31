<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Radhakrishnan Bhawan Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS Variables for Colors */
        :root {
            --primary-blue: #0b1c4a;
            --admin-btn-bg: #102142;
            --user-btn-bg: #29768a;
            --text-light: #f4f4f4;
            --glass-bg: rgba(255, 255, 255, 0.45);
            --glass-border: rgba(255, 255, 255, 0.6);
            --notice-bg: #d32f2f; /* Deep Red for attention */
        }

        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* --- Header Section --- */
        header {
            background-color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px 30px;
            position: relative;
            z-index: 10;
        }

        .header-logo-container {
            position: absolute;
            left: 50px;
        }

        .uni-logo {
            width: 130px;
            height: auto;
            display: block;
        }

        .header-text {
            text-align: center;
            color: var(--primary-blue);
            font-family: 'Georgia', serif;
        }

        .header-text h1 { font-size: 28px; letter-spacing: 1px; margin-bottom: 5px; }
        .header-text h2 { font-size: 18px; font-weight: normal; margin-bottom: 5px; }
        .header-text h3 { font-size: 16px; font-weight: bold; }

        /* --- Sliding Notice Bar --- */
       /* --- Sliding Notice Bar (Premium Indigo) --- */
        .notice-bar-container {
            /* Changed to an Indigo/Purple gradient */
            background: linear-gradient(90deg, #5e35b1, #7e57c2); 
            color: white;
            height: 45px;
            display: flex;
            align-items: center;
            overflow: hidden;
            position: relative;
            z-index: 9;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            /* Darker Indigo border */
            border-bottom: 2px solid #4527a0; 
        }

        .notice-label {
            /* Darker Indigo for the label box */
            background-color: #4527a0; 
            color: white;
            padding: 0 25px;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 10px;
            position: absolute;
            left: 0;
            z-index: 2;
            height: 100%;
            font-size: 14px;
            letter-spacing: 1px;
            box-shadow: 5px 0 15px rgba(0,0,0,0.3);
        }

        .notice-label::after {
            content: '';
            position: absolute;
            right: -15px;
            top: 0;
            border-top: 22.5px solid transparent;
            border-bottom: 22.5px solid transparent;
            /* This MUST match the notice-label background color to form the arrow */
            border-left: 15px solid #4527a0; 
        }

        .notice-content {
            display: flex;
            white-space: nowrap;
            animation: slideNotice 25s linear infinite;
            padding-left: 100%; 
        }

        .notice-bar-container:hover .notice-content {
            animation-play-state: paused;
            cursor: pointer;
        }

        .notice-item {
            margin-right: 60px;
            font-size: 15px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .notice-item i {
            /* Soft gold icon to match the purple */
            color: #ffd54f; 
        }

        @keyframes slideNotice {
            0% { transform: translateX(0); }
            100% { transform: translateX(-100%); }
        }
        /* --- Main Hero Section --- */
        main {
            flex-grow: 1;
            background: url('../images/hostel.png') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            position: relative;
        }

        main::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0, 0, 0, 0.2);
        }

        /* --- Glassmorphism Card --- */
        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 850px;
            position: relative;
            z-index: 2;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }

        .card-top { display: flex; align-items: center; margin-bottom: 40px; gap: 20px; }
        .bt-logo-container { width: 110px; flex-shrink: 0; }
        .bt-logo { width: 100%; height: auto; display: block; border-radius: 8px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3); }

        .welcome-text { color: var(--primary-blue); }
        .welcome-text h2 { font-size: 24px; font-weight: normal; }
        .welcome-text h1 { font-size: 32px; margin: 5px 0 10px 0; }
        .welcome-text p { font-size: 16px; font-weight: 500; }

        /* --- Login Buttons Container --- */
        .login-buttons { display: flex; gap: 30px; margin-bottom: 30px; }

        .login-btn {
            flex: 1; border-radius: 15px; padding: 40px 20px 20px; text-align: center;
            text-decoration: none; color: white; position: relative;
            transition: transform 0.2s, box-shadow 0.2s; border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: inset 0 0 20px rgba(0, 0, 0, 0.2); cursor: pointer;
        }

        .login-btn:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3), inset 0 0 20px rgba(0, 0, 0, 0.2);
        }

        .btn-admin { background-color: var(--admin-btn-bg); }
        .btn-user { background-color: var(--user-btn-bg); }

        .icon-wrapper {
            position: absolute; top: -25px; left: 50%; transform: translateX(-50%);
            width: 50px; height: 50px; border-radius: 50%; display: flex;
            align-items: center; justify-content: center; font-size: 20px;
            color: white; border: 2px solid rgba(255, 255, 255, 0.8);
        }

        .btn-admin .icon-wrapper { background-color: var(--admin-btn-bg); }
        .btn-user .icon-wrapper { background-color: var(--user-btn-bg); }

        .login-btn h3 { font-size: 18px; margin-bottom: 10px; letter-spacing: 1px; }
        .login-btn p { font-size: 13px; margin-bottom: 15px; opacity: 0.9; }
        .login-btn .sub-links {
            font-size: 12px; opacity: 0.7; border-top: 1px solid rgba(255, 255, 255, 0.2);
            padding-top: 10px; display: inline-block;
        }

        .card-footer { text-align: center; color: var(--primary-blue); }
        .card-footer h4 { font-size: 16px; margin-bottom: 5px; }
        .card-footer p { font-size: 14px; }

        /* --- Footer Section --- */
        footer {
            background-color: rgba(0, 0, 0, 0.85); color: var(--text-light);
            display: flex; justify-content: space-between; align-items: center;
            padding: 20px 50px; font-size: 13px; z-index: 10;
        }

        .footer-left { display: flex; align-items: center; gap: 15px; }
        .footer-logo { width: 50px; height: auto; display: block; background-color: white; padding: 2px; border-radius: 4px; }
        .footer-center { text-align: center; line-height: 1.6; }
        .footer-right { text-align: right; }
        .footer-links { margin-bottom: 10px; }
        .footer-links a, .social-icons a { color: white; text-decoration: none; margin-left: 10px; }
        .social-icons a { font-size: 18px; margin-left: 15px; }

        /* =========================================
           MODAL (POPUP) STYLES
           ========================================= */
        .modal-overlay {
            display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0, 0, 0, 0.6); backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px); z-index: 1000; align-items: center;
            justify-content: center; opacity: 0; transition: opacity 0.3s ease;
        }

        .modal-overlay.active { display: flex; opacity: 1; }

        .modal-box {
            background: rgba(255, 255, 255, 0.95); border-radius: 20px; padding: 40px;
            width: 100%; max-width: 400px; position: relative;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4); transform: translateY(-30px);
            transition: transform 0.3s ease;
        }

        .modal-overlay.active .modal-box { transform: translateY(0); }

        .close-btn {
            position: absolute; top: 15px; right: 20px; font-size: 28px;
            color: #666; cursor: pointer; transition: color 0.2s;
        }

        .close-btn:hover { color: #000; }

        .modal-header { text-align: center; margin-bottom: 30px; color: var(--primary-blue); }
        .modal-header i { font-size: 40px; margin-bottom: 10px; color: var(--user-btn-bg); }
        .modal-header h2 { font-size: 24px; }

        /* Form Inputs */
        .input-group { position: relative; margin-bottom: 20px; }
        .input-group i {
            position: absolute; left: 15px; top: 50%; transform: translateY(-50%);
            color: #666; font-size: 16px;
        }

        .input-group input, .input-group select {
            width: 100%; padding: 15px 15px 15px 45px; border: 1px solid #ccc;
            border-radius: 10px; font-size: 15px; outline: none; background: #fff;
            appearance: none; transition: border-color 0.3s;
        }

        .select-wrapper::after {
            content: '\f0d7'; font-family: 'Font Awesome 6 Free'; font-weight: 900;
            position: absolute; right: 15px; top: 50%; transform: translateY(-50%);
            color: #666; pointer-events: none;
        }

        .input-group input:focus, .input-group select:focus { border-color: var(--user-btn-bg); }

        .submit-btn {
            width: 100%; padding: 15px; background-color: var(--primary-blue);
            color: white; border: none; border-radius: 10px; font-size: 16px;
            font-weight: bold; cursor: pointer; transition: background-color 0.3s;
            margin-top: 10px;
        }

        .submit-btn:hover { background-color: var(--user-btn-bg); }

        .auth-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #444;
        }

        .auth-link a {
            color: var(--primary-blue);
            font-weight: bold;
            text-decoration: none;
            transition: color 0.3s;
        }

        .auth-link a:hover {
            color: var(--user-btn-bg);
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .header-logo-container { position: static; margin-right: 20px; }
            .header-text h1 { font-size: 20px; }
            .login-buttons { flex-direction: column; }
            footer { flex-direction: column; gap: 20px; text-align: center; }
            .footer-right { text-align: center; }
            .notice-label { display: none; /* Hide label on mobile to save space */ }
        }
    </style>
</head>

<body>

    <header>
        <div class="header-logo-container">
            <img src="../images/kalyani_logo.png" alt="University of Kalyani Logo" class="uni-logo">
        </div>
        <div class="header-text">
        	<h1>UNIVERSITY OF KALYANI</h1>
            <h1>RADHAKRISHNAN BHAWAN</h1>
            <h2><B>(B. T. MENS' HALL)</B></h2>
        </div>
    </header>

    <div class="notice-bar-container">
        <div class="notice-label">
            <i class="fa-solid fa-bullhorn"></i> NOTICES
        </div>
        
        <div class="notice-content">
            <%
                boolean hasNotices = false;
                try {
                    // 1. Connect to the database
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");

                    // 2. Fetch all notices, newest first
                    String sql = "SELECT * FROM notices ORDER BY created_at DESC";
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    
                    // 3. Loop through the database and print each notice into the slider
                    while(rs.next()) {
                        hasNotices = true;
            %>
                        <span class="notice-item">
                            <i class="fa-solid fa-circle-exclamation"></i> 
                            <%= rs.getString("notice_text") %>
                        </span>
            <%
                    }
                    
                    rs.close();
                    stmt.close();
                    conn.close();
                    
                    // 4. Fallback if the admin deletes ALL notices (so the bar isn't empty)
                    if(!hasNotices) {
            %>
                        <span class="notice-item">
                            <i class="fa-solid fa-info-circle"></i> 
                            Welcome to the Radhakrishnan Bhawan digital portal!
                        </span>
            <%
                    }
                    
                } catch(Exception e) {
                    // Fallback just in case the database is offline
            %>
                    <span class="notice-item">
                        <i class="fa-solid fa-bell"></i> 
                        Welcome to the Radhakrishnan Bhawan digital portal!
                    </span>
            <%
                }
            %>
        </div>
    </div>

    <main>
        <div class="glass-card">
            <div class="card-top">
                <div class="bt-logo-container">
                    <img src="../images/bt_logo.png" alt="B.T. Men's Hall Logo" class="bt-logo">
                </div>
                <div class="welcome-text">
                    <h2>Welcome to</h2>
                    <h1>Radhakrishnan Bhawan<br>(B. T. Mens' Hall)</h1>
                    <p> Amra kara B. T. Mens'</p>
                </div>
            </div>

            <div class="login-buttons">
                <a onclick="openModal('Admin')" class="login-btn btn-admin">
                    <div class="icon-wrapper"><i class="fa-solid fa-user-tie"></i></div>
                    <h3>ADMINISTRATIVE LOGIN</h3>
                    <p>Secure access for Admin</p>
                    <span class="sub-links">Steward | Provost</span>
                </a>

                <a onclick="openModal('User')" class="login-btn btn-user">
                    <div class="icon-wrapper"><i class="fa-solid fa-address-card"></i></div>
                    <h3>USER LOGIN</h3>
                    <p>Secure access for Boarders</p>
                    <span class="sub-links">Boarder Dashboard | Meal charge</span>
                </a>
            </div>

            <div class="card-footer">
                <h4>Manage Your Hostel Experience Seamlessly</h4>
                <p>A Digital Portal for Efficient Hostel Administration and Student Services</p>
            </div>
        </div>
    </main>

    <footer>
        <div class="footer-left">
            <img src="../images/kalyani_logo.png" alt="University of Kalyani Logo" class="footer-logo">
            <div>
                <p>&copy; 1960 University of Kalyani</p>
                <p>Radhakrishnan Bhawan | All Rights Reserved.</p>
            </div>
        </div>
        <div class="footer-center">
            <p>Contact University of Kalyani</p>
            <p>Contact: +91 92425 92425</p>
            <p>Email: radhakrishnan@kalyani.edu.in</p>
        </div>
        <div class="footer-right">
            <div class="footer-links">
                <a href="#">About Us</a> | <a href="#">Contact</a>
            </div>
            <div class="social-icons">
                <a href="https://www.facebook.com/RadhakrishananBhawan"><i class="fa-brands fa-facebook"></i></a>
                <a href="https://www.youtube.com/@b.tmenshostel3027"><i class="fa-brands fa-youtube"></i></a>
                <a href="https://t.me/+SRHygwU_iwExOTNl"><i class="fa-brands fa-telegram"></i></a>
            </div>
        </div>
    </footer>

    <div id="loginModal" class="modal-overlay">
        <div class="modal-box">
            <span class="close-btn" onclick="closeModal()">&times;</span>
            
            <div class="modal-header">
                <i class="fa-solid fa-circle-user" id="modalIcon"></i>
                <h2 id="modalTitle">Portal Login</h2>
            </div>

            <form id="loginForm" action="#" method="POST">
                
                <div class="input-group">
                    <i class="fa-solid fa-user"></i>
                    <input type="text" id="username" name="username" placeholder="Username" required>
                </div>

                <div class="input-group">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" id="password" name="password" placeholder="Password" required>
                </div>

                <div class="input-group select-wrapper" id="roleGroup">
                    <i class="fa-solid fa-id-badge"></i>
                    <select id="role" name="role" required>
                        <option value="" disabled selected>Select Your Role</option>
                        <option value="boarder">Boarder</option>
                        <option value="auditor">Auditor</option>
                        <option value="technician">Technician</option>
                        <option value="gardener">Gardener</option>
                        <option value="manager">Manager</option>
                        <option value="mess prefect">Mess Prefect</option>
                        <option value="maintenance">Maintenance</option>
                    </select>
                </div>

                <button type="submit" class="submit-btn">Login</button>
                
                <div id="signupContainer" class="auth-link">
                    Don't have an account? <a href="student_register.jsp">Sign up</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        const modal = document.getElementById('loginModal');
        const modalTitle = document.getElementById('modalTitle');
        const modalIcon = document.getElementById('modalIcon');
        const loginForm = document.getElementById('loginForm');
        const roleGroup = document.getElementById('roleGroup');
        const roleSelect = document.getElementById('role');
        const signupContainer = document.getElementById('signupContainer');

        function openModal(loginType) {
            if (loginType === 'Admin') {
                modalTitle.innerText = "Administrative Login";
                modalIcon.className = "fa-solid fa-user-tie";
                // Routes to the Admin Servlet mapped endpoint
                loginForm.action = "../adminLoginServlet";
                
                roleGroup.style.display = "none";
                roleSelect.required = false; 
                
                // Hide Sign Up for Admins
                signupContainer.style.display = "none";
                
            } else {
                modalTitle.innerText = "User Login";
                modalIcon.className = "fa-solid fa-address-card";
                // Routes to the Student/User Servlet mapped endpoint
                loginForm.action = "../studentLoginServlet";
                
                roleGroup.style.display = "block";
                roleSelect.required = true;
                
                // Show Sign Up for Users
                signupContainer.style.display = "block";
            }
            
            modal.classList.add('active');
        }

        function closeModal() {
            modal.classList.remove('active');
        }

        window.onclick = function(event) {
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>

</body>
</html>