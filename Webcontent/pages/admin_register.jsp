<!-- WebContent/pages/admin_register.jsp -->
<!DOCTYPE html>
<html>
<head>
    <title>Admin Account Creation</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body class="centered-bg">
    <div class="overlay"></div>
    <div class="login-box">
        <h2 class="login-title" style="color: black;">Admin Registration</h2>
        <form action="../adminRegisterServlet" method="post">
        	<input type="text" name="full_name" placeholder="Full Name" required /><br/>
            <input type="text" name="username" placeholder="Username" required /><br/>
            <input type="text" name="email" placeholder="Email" required /><br/>
            <input type="text" name="phone" placeholder="Phone" required /><br/>
            <input type="password" name="password" placeholder="Password" required /><br/>
            <input type="password" name="confirm_password" placeholder="Confirm Password" required /><br/>
            <input type="submit" value="Register" class="btn" />
        </form>
        <p style="margin-top: 10px; color: black;">
            Already registered? <a href="index.jsp" style="color: blue;">Login</a>
        </p>
    </div>
</body>
</html>
