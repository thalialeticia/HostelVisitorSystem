<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 1.45 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.User" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession sessionObj = request.getSession(false);
    User loggedUser = (sessionObj != null) ? (User) sessionObj.getAttribute("loggedUser") : null;

    if (loggedUser == null || !loggedUser.getRole().toString().equals("SECURITY_STAFF")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Security Staff Dashboard</title>

    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #e3f2fd, #bbdefb);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 450px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeIn 1s ease-out forwards;
            position: relative;
        }

        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        h2 {
            color: #0d47a1;
            font-size: 24px;
            margin-bottom: 15px;
        }

        .edit-profile {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 20px;
            color: #1e88e5;
            text-decoration: none;
            transition: color 0.3s ease, transform 0.2s ease;
        }

        .edit-profile:hover {
            color: #1565c0;
            transform: scale(1.1);
        }

        .dashboard-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 20px;
        }

        .button {
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #1e88e5;
            color: white;
            padding: 12px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 16px;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .button i {
            margin-right: 8px;
            font-size: 18px;
        }

        .button:hover {
            background-color: #1565c0;
            transform: scale(1.05);
        }

        .logout-btn {
            background-color: #e53935;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="../editProfile.jsp" class="edit-profile" title="Edit Profile">
        <i class="fa-solid fa-user-pen"></i>
    </a>

    <h2>Welcome, <%= loggedUser.getUsername() %>!</h2>
    <p>Role: <strong>Security Staff</strong></p>

    <div class="dashboard-options">
        <a href="verifyVisitors.jsp" class="button"><i class="fa-solid fa-id-card"></i> Verify Visitors</a>
        <a href="monitorSecurity.jsp" class="button"><i class="fa-solid fa-video"></i> Monitor Security Logs</a>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="button logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
    </div>
</div>
</body>
</html>
