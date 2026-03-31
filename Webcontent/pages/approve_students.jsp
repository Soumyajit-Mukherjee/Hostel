<%@ page import="java.util.*,java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approve Boarders - Radhakrishnan Bhawan</title>
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
            --glass-bg: rgba(255, 255, 255, 0.95);
            --glass-border: rgba(255, 255, 255, 0.5);
            
            /* Action Colors */
            --approve-bg: #e6f4ea; --approve-text: #1e8e3e; --approve-hover: #137333;
            --reject-bg: #fce8e6; --reject-text: #d93025; --reject-hover: #c5221f;
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
            background: rgba(11, 28, 74, 0.85); 
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

        .nav-brand img { height: 45px; }
        .nav-brand h1 { font-size: 20px; font-weight: 700; letter-spacing: 0.5px; }
        .nav-brand span { font-size: 13px; font-weight: 400; color: var(--text-muted); display: block; }

        .back-btn {
            background: var(--bg-color);
            color: var(--primary-blue);
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #d1d9e0;
        }

        .back-btn:hover {
            background: var(--primary-blue);
            color: white;
            box-shadow: 0 4px 12px rgba(11, 28, 74, 0.2);
            border-color: var(--primary-blue);
        }

        /* --- Main Content Container --- */
        .dashboard-container {
            max-width: 96%; /* Ultra-wide container to accommodate columns */
            margin: 40px auto;
            padding: 0 20px;
            flex: 1;
            width: 100%;
            animation: fadeInUp 0.6s ease;
        }

        .header-section {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
            color: white;
        }

        .header-icon {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #fff;
            backdrop-filter: blur(5px);
        }

        .header-text h2 { font-size: 28px; font-weight: 600; }
        .header-text p { font-size: 15px; opacity: 0.8; font-weight: 300; }

        /* --- Glass Table Container --- */
        .table-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            overflow: hidden;
        }

        .table-wrapper {
            max-height: 65vh;
            overflow: auto;
            border-radius: 10px;
            border: 1px solid #e0e6ed;
            background: #ffffff;
        }

        /* --- Modern Data Table Styles --- */
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            white-space: nowrap; 
        }

        thead {
            position: sticky;
            top: 0;
            background: var(--primary-blue);
            color: white;
            z-index: 10;
        }

        th {
            padding: 16px 20px;
            font-weight: 600;
            font-size: 13px;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            border-right: 1px solid rgba(255,255,255,0.1);
        }

        td {
            padding: 14px 20px;
            font-size: 14px;
            color: var(--text-dark);
            border-bottom: 1px solid #f0f4f8;
            vertical-align: middle;
            transition: background 0.2s ease;
        }

        tbody tr:hover td {
            background-color: #f8fafc;
        }

        .col-id { font-weight: 700; color: var(--accent-teal); }
        .col-name { font-weight: 600; color: var(--primary-blue); }
        .col-user { color: var(--text-muted); font-size: 13px; }

        /* --- Action Buttons --- */
        .action-cell {
            display: flex;
            gap: 10px;
            align-items: center;
            justify-content: center;
        }

        .btn-action {
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }

        .approve-btn {
            background-color: var(--approve-bg);
            color: var(--approve-text);
            border: 1px solid #c8e6c9;
        }

        .approve-btn:hover {
            background-color: var(--approve-text);
            color: white;
            box-shadow: 0 4px 10px rgba(30, 142, 62, 0.2);
            transform: translateY(-2px);
        }

        .reject-btn {
            background-color: var(--reject-bg);
            color: var(--reject-text);
            border: 1px solid #ffcdd2;
        }

        .reject-btn:hover {
            background-color: var(--reject-text);
            color: white;
            box-shadow: 0 4px 10px rgba(217, 48, 37, 0.2);
            transform: translateY(-2px);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: var(--text-muted);
        }

        .empty-state i {
            font-size: 48px;
            color: var(--accent-teal);
            margin-bottom: 15px;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 20px;
            color: var(--primary-blue);
            margin-bottom: 5px;
        }

        /* Scrollbar Styling */
        .table-wrapper::-webkit-scrollbar { width: 10px; height: 10px; }
        .table-wrapper::-webkit-scrollbar-track { background: #f1f1f1; border-radius: 8px; }
        .table-wrapper::-webkit-scrollbar-thumb { background: #b0bec5; border-radius: 8px; border: 2px solid #f1f1f1; }
        .table-wrapper::-webkit-scrollbar-thumb:hover { background: var(--accent-teal); }

        /* Animations */
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
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
        
        <a href="admin_dashboard.jsp" class="back-btn">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
    </nav>

    <div class="dashboard-container">
        
        <div class="header-section">
            <div class="header-icon"><i class="fa-solid fa-user-clock"></i></div>
            <div class="header-text">
                <h2>Pending Boarder Approvals</h2>
                <p>Review and process new registration requests for hostel accommodation.</p>
            </div>
        </div>

        <div class="table-card">
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Applicant Info</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th>DOB</th>
                            <th>Role</th>
                            <th>Course</th>
                            <th>Department</th>
                            <th style="text-align: center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                        <%
                            boolean hasPendingRecords = false;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection con = DriverManager.getConnection(
                                    "jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");

                                Statement stmt = con.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT * FROM student WHERE status='pending' and role = 'boarder'");

                                while (rs.next()) {
                                    hasPendingRecords = true;
                        %>
                        <tr>
                            <td class="col-id">#<%= rs.getInt("id") %></td>
                            <td>
                                <div class="col-name"><%= rs.getString("full_name") %></div>
                                <div class="col-user">@<%= rs.getString("username") %></div>
                            </td>
                            <td><%= rs.getString("email") %></td>
                            <td><%= rs.getString("phone") %></td>
                            <td style="max-width: 180px; overflow: hidden; text-overflow: ellipsis;" title="<%= rs.getString("address") %>">
                                <%= rs.getString("address") %>
                            </td>
                            <td><%= rs.getDate("dob") %></td>
                            <td><span style="background: #e8f0fe; color: #1a73e8; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; text-transform: uppercase;"><%= rs.getString("role") %></span></td>
                            <td><%= rs.getString("course") %></td>
                            <td><%= rs.getString("department") %></td>
                            <td class="action-cell">
                                <form action="../approveStudentServlet" method="post" style="margin: 0;">
                                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                    <button type="submit" name="action" value="approve" class="btn-action approve-btn" title="Approve Request">
                                        <i class="fa-solid fa-check"></i> Approve
                                    </button>
                                </form>
                                <form action="../approveStudentServlet" method="post" style="margin: 0;">
                                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                    <button type="submit" name="action" value="reject" class="btn-action reject-btn" title="Reject Request">
                                        <i class="fa-solid fa-xmark"></i> Reject
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <%
                                }
                                con.close();
                                
                                // If the loop finishes and no records were found, show the Empty State
                                if (!hasPendingRecords) {
                        %>
                                <tr>
                                    <td colspan="10">
                                        <div class="empty-state">
                                            <i class="fa-solid fa-clipboard-check"></i>
                                            <h3>All Caught Up!</h3>
                                            <p>There are currently no pending boarder registrations to review.</p>
                                        </div>
                                    </td>
                                </tr>
                        <%
                                }
                            } catch (Exception e) {
                        %>
                                <tr>
                                    <td colspan="10" style="text-align: center; color: red; padding: 30px;">
                                        <i class="fa-solid fa-triangle-exclamation" style="font-size: 24px; margin-bottom: 10px; display: block;"></i>
                                        <strong>Error connecting to database:</strong> <%= e.getMessage() %>
                                    </td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</body>
</html>