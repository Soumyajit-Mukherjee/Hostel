<%@ page session="true" %>
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
    case "manager":
        dashboardPage = "manager_dashboard.jsp";
        break;
    case "mess prefect":
        dashboardPage = "mess_prefect_dashboard.jsp";
        break;
    case "maintenance":
        dashboardPage = "maintenance_dashboard.jsp";
        break;
    case "librarian":
        dashboardPage = "librarian_dashboard.jsp";
        break;
    case "gardener/game prefect":
        dashboardPage = "gardener_game_dashboard.jsp";
        break;
    case "auditor":
        dashboardPage = "auditor_dashboard.jsp";
        break;
    case "boarder":
    default:
        dashboardPage = "student_dashboard.jsp";
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Clearance</title>
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
        <h2>Apply for Clearance</h2>

        <form action="../ClearanceRequestServlet" method="post" class="form-container">
            <input type="hidden" name="username" value="<%= username %>">
            <label for="purpose">Purpose:</label><br>
            <textarea id="purpose" name="purpose" rows="3" cols="30" required></textarea><br>

            <input type="submit" class="btn" value="Submit">
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
