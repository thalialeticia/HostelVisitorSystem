<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 1.44 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.User" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession sessionObj = request.getSession(false);
    User loggedUser = (sessionObj != null) ? (User) sessionObj.getAttribute("loggedUser") : null;

    if (loggedUser == null || !loggedUser.getRole().toString().equals("RESIDENT")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Resident Dashboard</title>
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
            width: 400px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeIn 1s ease-out forwards;
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

        .button {
            display: block;
            background-color: #1e88e5;
            color: white;
            padding: 12px;
            border-radius: 8px;
            margin: 10px 0;
            text-decoration: none;
            font-size: 16px;
            transition: background 0.3s ease, transform 0.2s ease;
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
    <h2>Welcome, <%= loggedUser.getUsername() %>!</h2>
    <p>Role: <strong>Resident</strong></p>

    <a href="requestVisit.jsp" class="button">Request a Visit</a>
    <a href="viewHistory.jsp" class="button">View Visit History</a>
    <a href="../editProfile.jsp" class="button">Edit Profile</a>

    <a href="${pageContext.request.contextPath}/LogoutServlet" class="button logout-btn">Logout</a>

</div>
</body>
</html>

