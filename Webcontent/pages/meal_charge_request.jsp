<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Map role to dashboard page
    String dashboardPage = "student_dashboard.jsp"; // default
    switch (role) {
        case "manager": dashboardPage = "manager_dashboard.jsp"; break;
        case "mess prefect": dashboardPage = "mess_prefect_dashboard.jsp"; break;
        case "maintenance": dashboardPage = "maintenance_dashboard.jsp"; break;
        case "librarian": dashboardPage = "librarian_dashboard.jsp"; break;
        case "gardener/game prefect": dashboardPage = "gardener_game_dashboard.jsp"; break;
        case "auditor": dashboardPage = "auditor_dashboard.jsp"; break;
        case "boarder": default: dashboardPage = "student_dashboard.jsp";
    }

    // Fetch current meal charge from DB
    double mealCharge = 0.0;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");

        PreparedStatement ps = conn.prepareStatement("SELECT meal_charge FROM student WHERE username = ?");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            mealCharge = rs.getDouble("meal_charge");
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Give Meal Charge</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .form-container {
            margin-top: 20px;
            text-align: center;
        }
        .form-container input, .form-container textarea {
            margin: 10px 0;
        }
        .form-container label {
            font-weight: bold;
        }
        .message {
            margin-top: 20px;
            text-align: center;
            color: green;
            font-weight: bold;
            font-size: 16px;
        }
    </style>
</head>
<body class="centered-bg">
    <div class="overlay"></div>
    <div class="login-box">
        <h2>Give Meal Charge</h2>

        <p style="font-weight: bold; font-size: 16px; color: black;">
            Your Current Meal Charge: <%= mealCharge %>
        </p>

        <form class="form-container">
            <input type="hidden" name="username" value="<%= username %>">

        </form>

        <% if (request.getParameter("message") != null) { %>
            <p class="message"><%= request.getParameter("message") %></p>
        <% } %>

        <form action="<%= dashboardPage %>" method="get">
            <button type="submit" class="btn">Back to Dashboard</button>
        </form>
    </div>
</body>
</html>
