<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Sign Up - Radhakrishnan Bhawan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* --- CSS Variables & Reset --- */
        :root {
            --primary-blue: #0b1c4a;
            --accent-teal: #29768a;
            --bg-color: #f0f4f8;
            --text-dark: #333;
            --text-muted: #777;
            --error-red: #ef5350;
            --success-green: #66bb6a;
            --glass-bg: rgba(255, 255, 255, 0.8);
            --glass-border: rgba(255, 255, 255, 0.4);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body { display: flex; min-height: 100vh; overflow: hidden; background-color: var(--bg-color); }

        .left-panel {
            flex: 1.1; background: url('../images/hostel.png') center/cover no-repeat;
            position: relative; display: flex; flex-direction: column; justify-content: center;
            align-items: center; color: white; text-align: center; padding: 50px;
        }

        .left-panel::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, rgba(11, 28, 74, 0.95) 0%, rgba(41, 118, 138, 0.7) 100%);
            z-index: 1;
        }

        .branding-content { position: relative; z-index: 2; animation: brandingEntry 0.8s ease-out; }
        @keyframes brandingEntry { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }

        .branding-content img { width: 100px; margin-bottom: 25px; background: white; padding: 5px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.3); }
        .branding-content h1 { font-size: 32px; letter-spacing: 1px; font-weight: 700; margin-bottom: 5px; }
        .branding-content h2 { font-size: 18px; font-weight: 300; opacity: 0.9; }

        .right-panel {
            flex: 1; background: var(--glass-bg); backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px); border-left: 1px solid var(--glass-border);
            display: flex; flex-direction: column; justify-content: flex-start;
            padding: 40px 60px; overflow-y: auto; z-index: 5;
        }

        .form-header { margin-top: auto; margin-bottom: 35px; color: var(--primary-blue); }
        .form-header h2 { font-size: 32px; font-weight: 700; margin-bottom: 5px; }
        .form-header p { color: var(--text-muted); font-size: 16px; }

        #signupForm { margin-bottom: auto; padding-bottom: 20px; }

        /* Server Error Box Styles */
        .server-error {
            background-color: #fff1f0; border: 1px solid #ffa39e; color: #cf1322;
            padding: 15px; border-radius: 10px; margin-bottom: 25px;
            display: flex; align-items: center; gap: 10px; font-size: 14px; font-weight: 500;
            animation: tabSlideIn 0.3s ease;
        }

        .progress-container { display: flex; justify-content: space-between; position: relative; margin-bottom: 45px; }
        .progress-container::before { content: ''; background-color: #e0e6ed; position: absolute; top: 50%; left: 0; transform: translateY(-50%); height: 4px; width: 100%; z-index: 1; border-radius: 4px; }
        .progress-bar { background: linear-gradient(90deg, var(--primary-blue), var(--accent-teal)); position: absolute; top: 50%; left: 0; transform: translateY(-50%); height: 4px; width: 0%; z-index: 2; transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1); border-radius: 4px; }
        .step-circle { background-color: #fff; color: #b0bec5; border: 3px solid #e0e6ed; border-radius: 50%; width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; font-weight: 600; transition: all 0.3s ease; z-index: 3; font-size: 16px; position: relative; }
        .step-circle.active { border-color: var(--accent-teal); color: var(--accent-teal); box-shadow: 0 0 15px rgba(41, 118, 138, 0.4); transform: scale(1.05); }
        .step-circle.completed { background-color: var(--accent-teal); border-color: var(--accent-teal); color: #fff; }

        .tab { display: none; animation: tabSlideIn 0.5s ease; }
        @keyframes tabSlideIn { from { opacity: 0; transform: translateX(20px); } to { opacity: 1; transform: translateX(0); } }
        .tab-title { color: var(--text-dark); margin-bottom: 25px; font-size: 18px; font-weight: 600; }

        .input-group { position: relative; margin-bottom: 22px; }
        .input-group i { position: absolute; left: 18px; top: 50%; transform: translateY(-50%); color: #b0bec5; font-size: 16px; transition: color 0.3s; }
        .input-group input, .input-group textarea { width: 100%; padding: 18px 18px 18px 55px; border: 1px solid transparent; border-radius: 12px; font-size: 15px; outline: none; background: #fff; transition: all 0.3s; box-shadow: 0 5px 10px rgba(0,0,0,0.03); }
        .input-group textarea { resize: vertical; min-height: 110px; padding-top: 18px; }
        input[type="date"] { color: #888; cursor: pointer; }
        
        .input-group input:focus, .input-group textarea:focus { border-color: var(--glass-border); box-shadow: 0 8px 20px rgba(41, 118, 138, 0.1), 0 0 0 2px rgba(41, 118, 138, 0.05); background: #fff; }
        .input-group input:focus + i, .input-group textarea:focus + i { color: var(--accent-teal); }
        .input-group input.invalid, .input-group textarea.invalid { border-color: var(--error-red); background-color: #fff8f8; box-shadow: 0 0 0 2px rgba(239, 83, 80, 0.1); }

        .btn-container { display: flex; justify-content: space-between; margin-top: 35px; gap: 15px; }
        .btn { padding: 16px 25px; border: none; border-radius: 10px; font-size: 15px; font-weight: 600; cursor: pointer; transition: all 0.2s ease; flex: 1; letter-spacing: 0.5px; }
        .btn:active { transform: scale(0.97); }
        .btn:disabled { opacity: 0.7; cursor: not-allowed; }
        .btn-prev { background-color: #fff; color: var(--text-dark); border: 1px solid #e0e6ed; }
        .btn-prev:hover:not(:disabled) { background-color: #f8f9fa; border-color: #d1d9e0; }
        .btn-next { background-color: var(--accent-teal); color: white; }
        .btn-next:hover:not(:disabled) { background-color: #246a7d; box-shadow: 0 5px 20px rgba(41,118,138,0.3); }
        .btn-submit { background: linear-gradient(135deg, #1e3c72 0%, #1a73e8 100%); color: white; display: none; }
        .btn-submit:hover:not(:disabled) { background: linear-gradient(135deg, #1557b0 0%, #0056b3 100%); box-shadow: 0 5px 20px rgba(26,115,232,0.3); }

        .login-link { text-align: center; margin-top: 30px; padding-bottom: 20px; font-size: 14px; color: var(--text-muted); }
        .login-link a { color: var(--primary-blue); font-weight: 600; text-decoration: none; }
        .login-link a:hover { text-decoration: underline; color: var(--accent-teal); }
        .password-match-msg { font-size: 13px; color: var(--error-red); display: none; margin-top: -12px; margin-bottom: 18px; margin-left: 5px; font-weight: 500;}

        @media (max-width: 1100px) { .right-panel { padding: 40px 40px; } }
        @media (max-width: 960px) {
            body { flex-direction: column; overflow: auto; }
            .left-panel { flex: none; padding: 60px 20px; }
            .right-panel { max-width: 100%; padding: 40px 25px; border-radius: 20px 20px 0 0; margin-top: -20px; border-left: none; }
            .branding-content h1 { font-size: 28px; }
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
            <p style="opacity: 0.7; font-size: 15px; font-weight: 300;">Official Registration Portal</p>
        </div>
    </div>

    <div class="right-panel">
        
        <div class="form-header">
            <h2>Sign Up</h2>
            <p>Fill out the steps below to join us.</p>
        </div>

        <% 
            String errorMsg = (String) request.getAttribute("error"); 
            if (errorMsg != null && !errorMsg.trim().isEmpty()) { 
        %>
            <div class="server-error">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <%= errorMsg %>
            </div>
        <% } %>

        <div class="progress-container">
            <div class="progress-bar" id="progress"></div>
            <div class="step-circle active"><i class="fa-solid fa-user"></i></div>
            <div class="step-circle"><i class="fa-solid fa-address-book"></i></div>
            <div class="step-circle"><i class="fa-solid fa-graduation-cap"></i></div>
            <div class="step-circle"><i class="fa-solid fa-shield-halved"></i></div>
        </div>

        <form id="signupForm" action="../studentRegisterServlet" method="POST" onsubmit="event.preventDefault();">
            
            <input type="hidden" name="role" value="boarder">

            <div class="tab">
                <h3 class="tab-title">Tell us about yourself</h3>
                <div class="input-group">
                    <i class="fa-solid fa-id-card"></i>
                    <input type="text" name="full_name" placeholder="Full Name" oninput="this.className = ''">
                </div>
                <div class="input-group">
                    <i class="fa-solid fa-at"></i>
                    <input type="text" name="username" placeholder="Choose a Username" oninput="this.className = ''">
                </div>
                <div class="input-group">
                    <i class="fa-solid fa-calendar-days"></i>
                    <input type="date" name="dob" title="Date of Birth" oninput="this.className = ''">
                </div>
            </div>

            <div class="tab">
                <h3 class="tab-title">Contact Information</h3>
                <div class="input-group">
                    <i class="fa-solid fa-phone"></i>
                    <input type="tel" name="phone" placeholder="Mobile Number (+91)" oninput="this.className = ''">
                </div>
                <div class="input-group">
                    <i class="fa-solid fa-envelope"></i>
                    <input type="email" name="email" placeholder="Email ID" oninput="this.className = ''">
                </div>
                <div class="input-group">
                    <i class="fa-solid fa-house"></i>
                    <textarea name="address" placeholder="Permanent Address" oninput="this.className = ''"></textarea>
                </div>
            </div>

            <div class="tab">
                <h3 class="tab-title">Academic Details</h3>
                <div class="input-group">
                    <i class="fa-solid fa-building-columns"></i>
                    <input type="text" name="department" placeholder="Department (e.g., Computer Science)" oninput="this.className = ''">
                </div>
                <div class="input-group">
                    <i class="fa-solid fa-book-open"></i>
                    <input type="text" name="course" placeholder="Course (e.g., B.Tech, M.Sc)" oninput="this.className = ''">
                </div>
            </div>

            <div class="tab">
                <h3 class="tab-title">Secure your account</h3>
                <div class="input-group">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" id="pass1" name="password" placeholder="Set Password" oninput="this.className = ''">
                </div>
                <div class="input-group">
                    <i class="fa-solid fa-circle-check"></i>
                    <input type="password" id="pass2" name="confirm_password" placeholder="Confirm Password" oninput="this.className = ''">
                </div>
                <div id="passwordError" class="password-match-msg">Passwords do not match!</div>
            </div>

            <div class="btn-container">
                <button type="button" class="btn btn-prev" id="prevBtn" onclick="nextPrev(-1)">Back</button>
                <button type="button" class="btn btn-next" id="nextBtn" onclick="nextPrev(1)">Continue</button>
                <button type="button" class="btn btn-submit" id="submitBtn" onclick="submitForm()">Create Account</button>
            </div>

            <div class="login-link">
                Already have an account? <a href="index.jsp">Sign In here</a>
            </div>

        </form>
    </div>

    <script>
        let currentTab = 0; 
        showTab(currentTab); 

        function showTab(n) {
            const tabs = document.getElementsByClassName("tab");
            tabs[n].style.display = "block";
            
            if (n == 0) {
                document.getElementById("prevBtn").style.display = "none";
            } else {
                document.getElementById("prevBtn").style.display = "inline-block";
            }
            
            if (n == (tabs.length - 1)) {
                document.getElementById("nextBtn").style.display = "none";
                document.getElementById("submitBtn").style.display = "inline-block";
            } else {
                document.getElementById("nextBtn").style.display = "inline-block";
                document.getElementById("submitBtn").style.display = "none";
            }
            
            updateProgressIndicator(n);
        }

        function nextPrev(n) {
            const tabs = document.getElementsByClassName("tab");
            if (n == 1 && !validateForm()) return false;
            
            tabs[currentTab].style.display = "none";
            currentTab = currentTab + n;
            showTab(currentTab);
        }

        function validateForm() {
            let valid = true;
            const tabs = document.getElementsByClassName("tab");
            const inputs = tabs[currentTab].getElementsByTagName("input");
            const textareas = tabs[currentTab].getElementsByTagName("textarea");
            const fieldsToCheck = [...inputs, ...textareas];
            
            for (let i = 0; i < fieldsToCheck.length; i++) {
                // Ignore hidden inputs
                if(fieldsToCheck[i].type === 'hidden') continue;

                if (fieldsToCheck[i].value == "") {
                    fieldsToCheck[i].className += " invalid";
                    valid = false;
                }
            }
            
            if (valid) {
                document.getElementsByClassName("step-circle")[currentTab].classList.add("completed");
            }
            return valid;
        }

        function submitForm() {
            const pass1 = document.getElementById("pass1").value;
            const pass2 = document.getElementById("pass2").value;
            const errorMsg = document.getElementById("passwordError");

            if (!validateForm()) return false;

            if (pass1 !== pass2) {
                document.getElementById("pass2").className += " invalid";
                errorMsg.style.display = "block";
                return false;
            } else {
                errorMsg.style.display = "none";
                const btn = document.getElementById("submitBtn");
                btn.innerText = "Creating...";
                btn.disabled = true;
                
                // Submit the form
                document.getElementById("signupForm").submit();
            }
        }

        function updateProgressIndicator(n) {
            const circles = document.getElementsByClassName("step-circle");
            const progressBar = document.getElementById("progress");
            
            for (let i = 0; i < circles.length; i++) {
                circles[i].classList.remove("active");
            }
            circles[n].classList.add("active");
            
            const progressPercentage = (n / (circles.length - 1)) * 100;
            progressBar.style.width = progressPercentage + "%";
        }
    </script>
</body>
</html>