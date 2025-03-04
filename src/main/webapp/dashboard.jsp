<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 12.46 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.User" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Check if user is logged in
    HttpSession sessionObj = request.getSession(false);
    User loggedUser = (sessionObj != null) ? (User) sessionObj.getAttribute("loggedUser") : null;

    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get user role
    String userRole = loggedUser.getRole().toString();
%>

<html>
<head>
    <title>Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #e3f2fd;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 400px;
        }

        h2 {
            color: #1565c0;
        }

        .role-info {
            font-size: 16px;
            color: #424242;
            margin-bottom: 20px;
        }

        .button {
            background-color: #1e88e5;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            margin: 5px;
            width: 100%;
            display: block;
            text-decoration: none;
            text-align: center;
        }

        .button:hover {
            background-color: #1565c0;
        }

        .disabled {
            background-color: #b0bec5;
            cursor: not-allowed;
        }

        .logout-btn {
            background-color: #e53935;
        }

        .logout-btn:hover {
            background-color: #b71c1c;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Welcome, <%= loggedUser.getUsername() %>!</h2>
    <p class="role-info">Role: <strong><%= userRole %></strong></p>

    <!-- Managing Staff Buttons -->
    <a href="manageUsers.jsp" class="button <%= userRole.equals("MANAGING_STAFF") ? "" : "disabled" %>">Manage Users</a>
    <a href="viewReports.jsp" class="button <%= userRole.equals("MANAGING_STAFF") ? "" : "disabled" %>">View Reports</a>
    <a href="approveVisitors.jsp" class="button <%= userRole.equals("MANAGING_STAFF") ? "" : "disabled" %>">Approve Visitor Requests</a>

    <!-- Resident Buttons -->
    <a href="requestVisit.jsp" class="button <%= userRole.equals("RESIDENT") ? "" : "disabled" %>">Request a Visit</a>
    <a href="viewHistory.jsp" class="button <%= userRole.equals("RESIDENT") ? "" : "disabled" %>">View Visit History</a>

    <!-- Security Staff Buttons -->
    <a href="verifyVisitors.jsp" class="button <%= userRole.equals("SECURITY_STAFF") ? "" : "disabled" %>">Verify Visitors</a>
    <a href="monitorSecurity.jsp" class="button <%= userRole.equals("SECURITY_STAFF") ? "" : "disabled" %>">Monitor Security Logs</a>

    <!-- Logout Button -->
    <a href="LogoutServlet" class="button logout-btn">Logout</a>
</div>

</body>
</html>
