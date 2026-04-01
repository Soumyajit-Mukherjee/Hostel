<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Radhakrishnan Bhawan Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-blue: #0b1c4a;
            --admin-btn-bg: #102142;
            --user-btn-bg: #29768a;
            --text-light: #f4f4f4;
            --glass-bg: rgba(255, 255, 255, 0.45);
            --glass-border: rgba(255, 255, 255, 0.6);
            --notice-bg: #d32f2f;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body { display: flex; flex-direction: column; min-height: 100vh; }

        /* Header */
        header { background-color: #ffffff; display: flex; align-items: center; justify-content: center; padding: 15px 30px; position: relative; z-index: 10; }
        .header-logo-container { position: absolute; left: 50px; }
        .uni-logo { width: 130px; height: auto; }
        .header-text { text-align: center; color: var(--primary-blue); font-family: 'Georgia', serif; }
        .header-text h1 { font-size: 28px; letter-spacing: 1px; }

        /* Notice Bar */
        .notice-bar-container { background: linear-gradient(90deg, #5e35b1, #7e57c2); color: white; height: 45px; display: flex; align-items: center; overflow: hidden; position: relative; box-shadow: 0 4px 10px rgba(0,0,0,0.2); border-bottom: 2px solid #4527a0; }
        .notice-label { background-color: #4527a0; padding: 0 25px; font-weight: bold; display: flex; align-items: center; gap: 10px; position: absolute; left: 0; z-index: 2; height: 100%; font-size: 14px; }
        .notice-label::after { content: ''; position: absolute; right: -15px; top: 0; border-top: 22.5px solid transparent; border-bottom: 22.5px solid transparent; border-left: 15px solid #4527a0; }
        .notice-content { display: flex; white-space: nowrap; animation: slideNotice 25s linear infinite; padding-left: 100%; }
        .notice-item { margin-right: 60px; font-size: 15px; font-weight: 500; display: flex; align-items: center; gap: 8px; }
        .notice-item i { color: #ffd54f; }
        @keyframes slideNotice { 0% { transform: translateX(0); } 100% { transform: translateX(-100%); } }

        /* Main Hero */
        main { flex-grow: 1; background: url('../images/hostel.png') center/cover no-repeat; display: flex; align-items: center; justify-content: center; padding: 40px 20px; position: relative; }
        main::before { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.2); }
        .glass-card { background: var(--glass-bg); backdrop-filter: blur(12px); border: 1px solid var(--glass-border); border-radius: 20px; padding: 40px; width: 100%; max-width: 850px; position: relative; z-index: 2; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2); }
        .card-top { display: flex; align-items: center; margin-bottom: 40px; gap: 20px; }
        .bt-logo { width: 110px; border-radius: 8px; }
        .welcome-text { color: var(--primary-blue); }

        /* Buttons */
        .login-buttons { display: flex; gap: 30px; margin-bottom: 30px; }
        .login-btn { flex: 1; border-radius: 15px; padding: 40px 20px 20px; text-align: center; text-decoration: none; color: white; position: relative; transition: 0.2s; cursor: pointer; }
        .login-btn:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.3); }
        .btn-admin { background-color: var(--admin-btn-bg); }
        .btn-user { background-color: var(--user-btn-bg); }
        .icon-wrapper { position: absolute; top: -25px; left: 50%; transform: translateX(-50%); width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 2px solid white; }

        /* Footer */
        footer { background-color: rgba(0, 0, 0, 0.85); color: var(--text-light); display: flex; justify-content: space-between; align-items: center; padding: 20px 50px; font-size: 13px; }
        .footer-logo { width: 50px; background: white; padding: 2px; border-radius: 4px; }

        /* Modal */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0, 0, 0, 0.6); backdrop-filter: blur(5px); z-index: 1000; align-items: center; justify-content: center; opacity: 0; transition: 0.3s; }
        .modal-overlay.active { display: flex; opacity: 1; }
        .modal-box { background: white; border-radius: 20px; padding: 40px; width: 100%; max-width: 400px; position: relative; }
        .input-group { position: relative; margin-bottom: 20px; }
        .input-group i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #666; }
        .input-group input, .input-group select { width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #ccc; border-radius: 10px; }
        .submit-btn { width: 100%; padding: 12px; background: var(--primary-blue); color: white; border: none; border-radius: 10px; font-weight: bold; cursor: pointer; }

        @media (max-width: 900px) { .login-buttons { flex-direction: column; } .header-logo-container { position: static; } .notice-label { display: none; } }
    </style>
</head>

<body>

    <header>
        <div class="header-logo-container">
            <img src="../images/kalyani_logo.png" alt="University Logo" class="uni-logo">
        </div>
        <div class="header-text">
            <h1>UNIVERSITY OF KALYANI</h1>
            <h1>RADHAKRISHNAN BHAWAN</h1>
            <h2><b>(B. T. MENS' HALL)</b></h2>
        </div>
    </header>

    <div class="notice-bar-container">
        <div class="notice-label"><i class="fa-solid fa-bullhorn"></i> NOTICES</div>
        <div class="notice-content">
            <%
                boolean hasNotices = false;
                // Fetching from Render Env Vars
                String host = System.getenv("DB_HOST");
                String port = System.getenv("DB_PORT");
                String dbName = System.getenv("DB_NAME");
                String user = System.getenv("DB_USER");
                String pass = System.getenv("DB_PASS");
                String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?sslmode=REQUIRED";

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    try (Connection conn = DriverManager.getConnection(url, user, pass);
                         Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT notice_text FROM notices ORDER BY created_at DESC")) {
                        
                        while(rs.next()) {
                            hasNotices = true;
            %>
                            <span class="notice-item">
                                <i class="fa-solid fa-circle-exclamation"></i> 
                                <%= rs.getString("notice_text") %>
                            </span>
            <%
                        }
                    }
                } catch(Exception e) {
                    // Fallback handled below
                }

                if(!hasNotices) {
            %>
                    <span class="notice-item"><i class="fa-solid fa-info-circle"></i> Welcome to the Radhakrishnan Bhawan digital portal!</span>
            <%
                }
            %>
        </div>
    </div>

    <main>
        <div class="glass-card">
            <div class="card-top">
                <img src="../images/bt_logo.png" alt="Hostel Logo" class="bt-logo">
                <div class="welcome-text">
                    <h2>Welcome to</h2>
                    <h1>Radhakrishnan Bhawan</h1>
                    <p>Amra kara? B. T. Mens'!</p>
                </div>
            </div>

            <div class="login-buttons">
                <a onclick="openModal('Admin')" class="login-btn btn-admin">
                    <div class="icon-wrapper"><i class="fa-solid fa-user-tie"></i></div>
                    <h3>ADMINISTRATIVE LOGIN</h3>
                    <p>Steward | Provost</p>
                </a>
                <a onclick="openModal('User')" class="login-btn btn-user">
                    <div class="icon-wrapper"><i class="fa-solid fa-address-card"></i></div>
                    <h3>USER LOGIN</h3>
                    <p>Boarders | Mess</p>
                </a>
            </div>

            <div class="card-footer">
                <p>A Digital Portal for Efficient Hostel Administration</p>
            </div>
        </div>
    </main>

    <footer>
        <div class="footer-left">
            <img src="../images/kalyani_logo.png" alt="Uni Logo" class="footer-logo">
            <p>&copy; 1960 University of Kalyani</p>
        </div>
        <div class="social-icons">
            <a href="#"><i class="fa-brands fa-facebook"></i></a>
            <a href="#"><i class="fa-brands fa-youtube"></i></a>
        </div>
    </footer>

    <div id="loginModal" class="modal-overlay">
        <div class="modal-box">
            <span class="close-btn" style="cursor:pointer; float:right; font-size:24px;" onclick="closeModal()">&times;</span>
            <div class="modal-header" style="text-align:center; margin-bottom:20px;">
                <i id="modalIcon" style="font-size:40px; color:var(--primary-blue);"></i>
                <h2 id="modalTitle">Login</h2>
            </div>
            <form id="loginForm" method="POST">
                <div class="input-group">
                    <i class="fa-solid fa-user"></i>
                    <input type="text" name="username" placeholder="Username" required>
                </div>
                <div class="input-group">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" name="password" placeholder="Password" required>
                </div>
                <div class="input-group" id="roleGroup">
                    <i class="fa-solid fa-id-badge"></i>
                    <select id="role" name="role">
                        <option value="" disabled selected>Select Role</option>
                        <option value="boarder">Boarder</option>
                        <option value="mess_prefect">Mess Prefect</option>
                    </select>
                </div>
                <button type="submit" class="submit-btn">Login</button>
                <div id="signupContainer" style="text-align:center; margin-top:15px;">
                    New here? <a href="student_register.jsp">Sign up</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        const modal = document.getElementById('loginModal');
        function openModal(type) {
            document.getElementById('modalTitle').innerText = type + " Login";
            document.getElementById('modalIcon').className = (type === 'Admin') ? "fa-solid fa-user-tie" : "fa-solid fa-address-card";
            document.getElementById('loginForm').action = (type === 'Admin') ? "../adminLoginServlet" : "../studentLoginServlet";
            document.getElementById('roleGroup').style.display = (type === 'Admin') ? "none" : "block";
            document.getElementById('signupContainer').style.display = (type === 'Admin') ? "none" : "block";
            modal.classList.add('active');
        }
        function closeModal() { modal.classList.remove('active'); }
    </script>
</body>
</html>
