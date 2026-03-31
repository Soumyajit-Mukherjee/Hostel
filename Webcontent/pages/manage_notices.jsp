<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%
    // 1. Grab the current logged-in user and role
    String currentUser = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role");
    
    // 2. Security Kick-out if not logged in at all
    if (currentUser == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    // 3. Dynamic Dashboard Routing Logic
    // Since the Admin login does NOT set a "role" attribute, we default to the Admin dashboard.
    // If a role IS found, we route them to their specific dashboard.
    String dashboardLink = "admin_dashboard.jsp"; 
    
    if (userRole != null) {
        if (userRole.equalsIgnoreCase("auditor")) {
            dashboardLink = "auditor_dashboard.jsp";
        } else if (userRole.equalsIgnoreCase("mess prefect")) {
            dashboardLink = "mess_prefect_dashboard.jsp";
        } else if (userRole.equalsIgnoreCase("manager")) {
            dashboardLink = "manager_dashboard.jsp";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Notices - Radhakrishnan Bhawan</title>
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
            
            /* Action Colors */
            --edit-bg: #e8f0fe; --edit-text: #1a73e8;
            --delete-bg: #fce8e6; --delete-text: #d93025;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body { display: flex; min-height: 100vh; overflow: hidden; background-color: var(--bg-color); }

        /* --- Left Side: Branding --- */
        .left-panel {
            flex: 1; background: url('../images/hostel.png') center/cover no-repeat;
            position: relative; display: flex; flex-direction: column; justify-content: center;
            align-items: center; color: white; text-align: center; padding: 50px;
        }

        .left-panel::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, rgba(11, 28, 74, 0.9) 0%, rgba(41, 118, 138, 0.8) 100%); z-index: 1;
        }

        .branding-content { position: relative; z-index: 2; animation: fadeIn 0.8s ease-out; }
        .branding-content img { width: 100px; margin-bottom: 25px; background: white; padding: 5px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.3); }
        .branding-content h1 { font-size: 32px; font-weight: 700; margin-bottom: 5px; }
        .branding-content h2 { font-size: 18px; font-weight: 300; opacity: 0.9; }

        /* --- Right Side: Interface --- */
        .right-panel {
            flex: 1.5; background: var(--glass-bg); backdrop-filter: blur(20px); border-left: 1px solid var(--glass-border);
            display: flex; flex-direction: column; padding: 40px 60px; overflow-y: auto; position: relative;
        }

        .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .back-btn { color: var(--text-muted); text-decoration: none; font-size: 14px; font-weight: 500; display: flex; align-items: center; gap: 8px; transition: color 0.3s; }
        .back-btn:hover { color: var(--primary-blue); }

        .header-section { display: flex; align-items: center; gap: 15px; margin-bottom: 30px; color: var(--primary-blue); }
        .header-icon { width: 55px; height: 55px; background: rgba(41, 118, 138, 0.1); color: var(--accent-teal); border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 26px; }
        .header-text h2 { font-size: 28px; font-weight: 700; }
        .header-text p { font-size: 15px; color: var(--text-muted); }

        /* --- Alerts --- */
        .alert { padding: 15px 20px; border-radius: 10px; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; font-weight: 500; font-size: 14px; animation: slideDown 0.3s ease; }
        .alert-success { background: #eafaf1; color: #27ae60; border: 1px solid #c3f0d5; }
        .alert-error { background: #fdedec; color: #c0392b; border: 1px solid #f5b7b1; }

        /* --- Notice Form Card --- */
        .form-card {
            background: #fff; border: 1px solid #e0e6ed; border-radius: 16px; padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05); margin-bottom: 30px; animation: fadeIn 0.5s ease;
        }

        .form-card label { display: block; font-size: 14px; font-weight: 600; color: var(--text-dark); margin-bottom: 10px; }
        
        .textarea-wrapper { position: relative; margin-bottom: 20px; }
        .textarea-wrapper i { position: absolute; left: 18px; top: 18px; color: #b0bec5; font-size: 18px; transition: color 0.3s; }
        
        textarea {
            width: 100%; padding: 16px 20px 16px 50px; border: 1px solid #e0e6ed; border-radius: 10px;
            font-size: 15px; outline: none; background: #fafafa; color: var(--text-dark);
            transition: all 0.3s; resize: vertical; min-height: 100px;
        }

        textarea:focus { border-color: var(--accent-teal); background: #fff; box-shadow: 0 0 0 4px rgba(41, 118, 138, 0.1); }
        textarea:focus + i { color: var(--accent-teal); }

        .btn-submit {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--accent-teal) 100%);
            color: white; border: none; padding: 14px 25px; border-radius: 8px; font-size: 15px;
            font-weight: 600; cursor: pointer; transition: all 0.3s; box-shadow: 0 5px 15px rgba(41, 118, 138, 0.2);
            display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(41, 118, 138, 0.3); }
        
        #cancelEditBtn {
            background: #f1f3f4; color: #5f6368; border: none; padding: 14px 25px; border-radius: 8px; font-size: 15px;
            font-weight: 600; cursor: pointer; transition: all 0.3s; display: none; margin-left: 10px;
        }
        #cancelEditBtn:hover { background: #e8eaed; color: #202124; }

        /* --- Table Container --- */
        .table-card {
            background: #fff; border: 1px solid #e0e6ed; border-radius: 16px; padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05); overflow: hidden; animation: fadeIn 0.5s ease;
        }

        .table-wrapper { max-height: 400px; overflow-y: auto; border-radius: 10px; border: 1px solid #f0f4f8; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        thead { position: sticky; top: 0; background: var(--primary-blue); color: white; z-index: 10; }
        th { padding: 16px 20px; font-weight: 600; font-size: 13px; letter-spacing: 0.5px; text-transform: uppercase; }
        td { padding: 16px 20px; font-size: 14px; color: var(--text-dark); border-bottom: 1px solid #f0f4f8; vertical-align: middle; }
        tbody tr:hover td { background-color: #f8fafc; }

        .col-notice { font-weight: 500; color: var(--primary-blue); line-height: 1.5; }
        .col-date { color: var(--text-muted); font-size: 13px; white-space: nowrap; }
        .notice-author { color: #888; font-size: 12px; margin-top: 5px; display: inline-block; font-weight: 400; }

        /* --- Action Buttons --- */
        .action-cell { display: flex; gap: 8px; justify-content: center; }
        .btn-action { text-decoration: none; border: none; padding: 8px 12px; border-radius: 6px; font-size: 13px; font-weight: 600; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s ease; }
        
        .edit-btn { background-color: var(--edit-bg); color: var(--edit-text); border: 1px solid #bbdefb; }
        .edit-btn:hover { background-color: var(--edit-text); color: white; transform: translateY(-2px); }
        
        .delete-btn { background-color: var(--delete-bg); color: var(--delete-text); border: 1px solid #ffcdd2; }
        .delete-btn:hover { background-color: var(--delete-text); color: white; transform: translateY(-2px); }

        .locked-status { color: #aaa; font-size: 13px; font-weight: 500; display: inline-flex; align-items: center; gap: 5px; padding: 8px; }

        .empty-state { text-align: center; padding: 40px 20px; color: var(--text-muted); }
        .empty-state i { font-size: 40px; color: var(--accent-teal); margin-bottom: 15px; opacity: 0.4; }
        
        .table-wrapper::-webkit-scrollbar { width: 8px; }
        .table-wrapper::-webkit-scrollbar-track { background: #f1f1f1; border-radius: 4px; }
        .table-wrapper::-webkit-scrollbar-thumb { background: #b0bec5; border-radius: 4px; }

        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        @media (max-width: 960px) { body { flex-direction: column; overflow: auto; } .left-panel { flex: none; padding: 40px 20px; } .right-panel { padding: 30px 25px; border-left: none; } }
    </style>
</head>
<body>

    <div class="left-panel">
        <div class="branding-content">
            <img src="../images/bt_logo.png" alt="University Logo">
            <h1>RADHAKRISHNAN BHAWAN</h1>
            <h2>(B.T. MENS' HALL)</h2>
            <br>
            <p style="opacity: 0.8; font-size: 15px;">Notice Board Administration</p>
        </div>
    </div>

    <div class="right-panel">
        
        <div class="top-bar">
            <a href="<%= dashboardLink %>" class="back-btn">
                <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <div class="header-section">
            <div class="header-icon"><i class="fa-solid fa-bullhorn"></i></div>
            <div class="header-text">
                <h2>Manage Notices</h2>
                <p>Broadcast important announcements to the student homescreen instantly.</p>
            </div>
        </div>

        <%
            String msg = request.getParameter("msg");
            if ("added".equals(msg)) {
        %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Notice broadcasted successfully!</div>
        <% } else if ("updated".equals(msg)) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Notice updated successfully!</div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-success"><i class="fa-solid fa-trash-can"></i> Notice deleted permanently.</div>
        <% } else if ("error".equals(msg)) { %>
            <div class="alert alert-error"><i class="fa-solid fa-circle-xmark"></i> Failed to process request or permission denied.</div>
        <% } %>

        <div class="form-card">
            <form id="noticeForm" method="post" action="../NoticeServlet">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="notice_id" id="noticeId" value="">
                
                <label id="formLabel">Create a New Notice:</label>
                <div class="textarea-wrapper">
                    <i class="fa-solid fa-pen-to-square"></i>
                    <textarea name="notice_text" id="noticeText" placeholder="Type your important announcement here..." required></textarea>
                </div>
                
                <button type="submit" class="btn-submit" id="submitBtn">
                    <i class="fa-solid fa-paper-plane"></i> Publish Notice
                </button>
                <button type="button" id="cancelEditBtn" onclick="cancelEdit()">
                    Cancel Edit
                </button>
            </form>
        </div>

        <div class="table-card">
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th style="width: 60%;"><i class="fa-solid fa-message" style="margin-right: 5px;"></i> Announcement</th>
                            <th><i class="fa-solid fa-calendar-day" style="margin-right: 5px;"></i> Posted On</th>
                            <th style="text-align: center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            boolean hasNotices = false;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel_management", "root", "Soumyajit@123");

                                String sql = "SELECT * FROM notices ORDER BY created_at DESC";
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery(sql);
                                
                                while (rs.next()) {
                                    hasNotices = true;
                                    int id = rs.getInt("id");
                                    String text = rs.getString("notice_text").replace("'", "\\'"); 
                                    String author = rs.getString("posted_by");
                        %>
                                <tr>
                                    <td class="col-notice">
                                        <%= rs.getString("notice_text") %>
                                        <br>
                                        <span class="notice-author">
                                            <i class="fa-solid fa-user-pen"></i> Posted by: @<%= author != null ? author : "Admin" %>
                                        </span>
                                    </td>
                                    <td class="col-date">
                                        <%= rs.getTimestamp("created_at").toString().substring(0, 16) %>
                                    </td>
                                    <td class="action-cell">
                                        
                                        <%-- AUTHORIZATION CHECK: Only show buttons if the current user matches the author --%>
                                        <% if (currentUser != null && currentUser.equals(author)) { %>
                                            <button type="button" class="btn-action edit-btn" onclick="startEdit(<%= id %>, '<%= text %>')">
                                                <i class="fa-solid fa-pen"></i> Edit
                                            </button>
                                            
                                            <form method="post" action="../NoticeServlet" style="margin: 0;" onsubmit="return confirm('Are you sure you want to delete this notice?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="notice_id" value="<%= id %>">
                                                <button type="submit" class="btn-action delete-btn">
                                                    <i class="fa-solid fa-trash"></i> Delete
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <span class="locked-status" title="Only the author can edit this notice.">
                                                <i class="fa-solid fa-lock"></i> Locked
                                            </span>
                                        <% } %>

                                    </td>
                                </tr>
                        <%
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                                
                                if (!hasNotices) {
                        %>
                                <tr>
                                    <td colspan="3">
                                        <div class="empty-state">
                                            <i class="fa-regular fa-bell-slash"></i>
                                            <h3>No Active Notices</h3>
                                            <p>Use the form above to broadcast an announcement to the homescreen.</p>
                                        </div>
                                    </td>
                                </tr>
                        <%
                                }
                            } catch (Exception e) {
                        %>
                                <tr>
                                    <td colspan="3" style="text-align: center; color: #d93025; padding: 30px;">
                                        <i class="fa-solid fa-triangle-exclamation"></i> Error loading notices. Please check database configuration.
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

    <script>
        function startEdit(id, text) {
            document.getElementById('noticeId').value = id;
            document.getElementById('noticeText').value = text;
            document.getElementById('formAction').value = 'update';
            
            document.getElementById('formLabel').innerHTML = '<span style="color: #1a73e8;"><i class="fa-solid fa-pen"></i> Editing Existing Notice:</span>';
            
            let submitBtn = document.getElementById('submitBtn');
            submitBtn.innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Save Changes';
            submitBtn.style.background = 'linear-gradient(135deg, #1a73e8 0%, #4ba3b8 100%)'; 
            
            document.getElementById('cancelEditBtn').style.display = 'inline-block';
            document.querySelector('.right-panel').scrollTo({ top: 0, behavior: 'smooth' });
            document.getElementById('noticeText').focus();
        }

        function cancelEdit() {
            document.getElementById('noticeId').value = '';
            document.getElementById('noticeText').value = '';
            document.getElementById('formAction').value = 'add';
            
            document.getElementById('formLabel').innerHTML = 'Create a New Notice:';
            
            let submitBtn = document.getElementById('submitBtn');
            submitBtn.innerHTML = '<i class="fa-solid fa-paper-plane"></i> Publish Notice';
            submitBtn.style.background = 'linear-gradient(135deg, var(--primary-blue) 0%, var(--accent-teal) 100%)';
            
            document.getElementById('cancelEditBtn').style.display = 'none';
        }
    </script>
</body>
</html>