<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Due List - Radhakrishnan Bhawan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* --- CSS Variables & Reset --- */
        :root {
            --primary-blue: #0b1c4a;
            --accent-teal: #29768a;
            --bg-color: #f0f4f8;
            --text-dark: #333;
            --text-muted: #666;
            --glass-bg: rgba(255, 255, 255, 0.95);
            --glass-border: rgba(255, 255, 255, 0.5);
            --money-green: #2e7d32;
            
            /* Action Colors */
            --approve-bg: #e6f4ea; --approve-text: #1e8e3e; 
            --reject-bg: #fce8e6; --reject-text: #d93025; 
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            display: flex;
            min-height: 100vh;
            overflow: hidden;
            background-color: var(--bg-color);
        }

        /* --- Left Side: Rich Gradient Branding --- */
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
            background: linear-gradient(135deg, rgba(11, 28, 74, 0.9) 0%, rgba(41, 118, 138, 0.8) 100%);
            z-index: 1;
        }

        .branding-content {
            position: relative;
            z-index: 2;
            animation: fadeIn 0.8s ease-out;
        }

        .branding-content img {
            width: 100px;
            margin-bottom: 25px;
            background: white;
            padding: 5px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }

        .branding-content h1 { font-size: 32px; font-weight: 700; margin-bottom: 5px; }
        .branding-content h2 { font-size: 18px; font-weight: 300; opacity: 0.9; }

        /* --- Right Side: Tool Interface --- */
        .right-panel {
            flex: 1.5;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border-left: 1px solid var(--glass-border);
            display: flex;
            flex-direction: column;
            padding: 40px 60px;
            overflow-y: auto;
            position: relative;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .back-btn {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: color 0.3s;
        }

        .back-btn:hover { color: var(--primary-blue); }

        .header-section {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
            color: var(--primary-blue);
        }

        .header-icon {
            width: 55px;
            height: 55px;
            background: rgba(41, 118, 138, 0.1);
            color: var(--accent-teal);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
        }

        .header-text h2 { font-size: 28px; font-weight: 700; }
        .header-text p { font-size: 15px; color: var(--text-muted); }

        /* --- Alerts --- */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
            font-size: 14px;
            animation: slideDown 0.3s ease;
        }

        .alert-success { background: #eafaf1; color: #27ae60; border: 1px solid #c3f0d5; }
        .alert-error { background: #fdedec; color: #c0392b; border: 1px solid #f5b7b1; }

        /* --- Glass Table Container --- */
        .table-card {
            background: #fff;
            border: 1px solid #e0e6ed;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            overflow: hidden;
            animation: fadeIn 0.5s ease;
        }

        .table-wrapper {
            max-height: 500px;
            overflow-y: auto;
            border-radius: 10px;
            border: 1px solid #f0f4f8;
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
        }

        td {
            padding: 16px 20px;
            font-size: 14px;
            color: var(--text-dark);
            border-bottom: 1px solid #f0f4f8;
            vertical-align: middle;
            transition: background 0.2s ease;
        }

        tbody tr:hover td { background-color: #f8fafc; }

        /* Specific Columns */
        .col-user { font-weight: 600; color: var(--primary-blue); display: flex; align-items: center; gap: 10px; }
        .col-user i { color: var(--accent-teal); font-size: 18px; }
        .col-amount { font-weight: 700; color: var(--money-green); font-size: 16px; }

        /* --- Action Buttons --- */
        .action-cell { display: flex; gap: 10px; align-items: center; }

        .btn-action {
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
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
        .empty-state { text-align: center; padding: 40px 20px; color: var(--text-muted); }
        .empty-state i { font-size: 48px; color: var(--accent-teal); margin-bottom: 15px; opacity: 0.4; }
        .empty-state h3 { font-size: 20px; color: var(--primary-blue); margin-bottom: 5px; }

        /* Scrollbar Styling */
        .table-wrapper::-webkit-scrollbar { width: 8px; }
        .table-wrapper::-webkit-scrollbar-track { background: #f1f1f1; border-radius: 4px; }
        .table-wrapper::-webkit-scrollbar-thumb { background: #b0bec5; border-radius: 4px; }
        .table-wrapper::-webkit-scrollbar-thumb:hover { background: var(--accent-teal); }

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
            <br>
            <p style="opacity: 0.8; font-size: 15px;">Administrative Control Panel</p>
        </div>
    </div>

    <div class="right-panel">
        
        <div class="top-bar">
            <a href="admin_dashboard.jsp" class="back-btn">
                <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <div class="header-section">
            <div class="header-icon"><i class="fa-solid fa-file-invoice-dollar"></i></div>
            <div class="header-text">
                <h2>Pending Due List</h2>
                <p>Review and verify submitted meal charge requests before updating the ledger.</p>
            </div>
        </div>

        <%
            String msg = request.getParameter("msg");
            if ("success".equals(msg)) {
        %>
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check"></i> Status updated successfully!
            </div>
        <% } else if ("error".equals(msg)) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-circle-xmark"></i> Failed to update status. Please try again.
            </div>
        <% } else if ("exception".equals(msg)) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-triangle-exclamation"></i> A system error occurred. Please check database connectivity.
            </div>
        <% } %>

        <div class="table-card">
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th><i class="fa-solid fa-user-tag" style="margin-right: 5px;"></i> Boarder Username</th>
                            <th><i class="fa-solid fa-indian-rupee-sign" style="margin-right: 5px;"></i> Amount Pending</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                        <%
                            boolean hasPendingCharges = false;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");

                                String sql = "SELECT * FROM total_meal_charge WHERE status = 'pending'";
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery(sql);
                                
                                while (rs.next()) {
                                    hasPendingCharges = true;
                        %>
                                <tr>
                                    <td class="col-user">
                                        <i class="fa-solid fa-circle-user"></i> 
                                        @<%= rs.getString("username") %>
                                    </td>
                                    <td class="col-amount">
                                        ₹ <%= String.format("%.2f", rs.getDouble("amount")) %>
                                    </td>
                                    <td class="action-cell">
                                        <a href="../MealChargeApprovalServlet?action=approve&username=<%= rs.getString("username") %>" class="btn-action approve-btn" title="Verify & Update">
                                            <i class="fa-solid fa-check"></i> Update
                                        </a>
                                        <a href="../MealChargeApprovalServlet?action=reject&username=<%= rs.getString("username") %>" class="btn-action reject-btn" title="Reject Request">
                                            <i class="fa-solid fa-xmark"></i> Reject
                                        </a>
                                    </td>
                                </tr>
                        <%
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                                
                                // Empty State Logic
                                if (!hasPendingCharges) {
                        %>
                                <tr>
                                    <td colspan="3">
                                        <div class="empty-state">
                                            <i class="fa-solid fa-clipboard-check"></i>
                                            <h3>All Caught Up!</h3>
                                            <p>There are no pending meal charge requests in the queue.</p>
                                        </div>
                                    </td>
                                </tr>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                        %>
                                <tr>
                                    <td colspan="3" style="text-align: center; color: #d93025; padding: 30px;">
                                        <i class="fa-solid fa-triangle-exclamation" style="font-size: 24px; margin-bottom: 10px; display: block;"></i>
                                        <strong>Error connecting to database.</strong> Please check your connection.
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