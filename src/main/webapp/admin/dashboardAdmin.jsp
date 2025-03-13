<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 1.43 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.User" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession sessionObj = request.getSession(false);
    User loggedUser = (sessionObj != null) ? (User) sessionObj.getAttribute("loggedUser") : null;

    if (loggedUser == null || !loggedUser.getRole().toString().equals("MANAGING_STAFF")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Retrieve analytics data passed from AdminDashboardServlet
    Long totalStaff = (Long) request.getAttribute("totalStaff");
    Long totalResidents = (Long) request.getAttribute("totalResidents");
    Long totalVisitors = (Long) request.getAttribute("totalVisitors");

    // Ensure default values are set if attributes are missing
    int staffCount = (totalStaff != null) ? totalStaff.intValue() : 0;
    int residentCount = (totalResidents != null) ? totalResidents.intValue() : 0;
    int visitorCount = (totalVisitors != null) ? totalVisitors.intValue() : 0;
%>
<html>
<head>
    <title>Admin Dashboard</title>

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
            width: 500px;
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
            margin-bottom: 10px;
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

        .edit-profile i {
            color: #1e88e5 !important; /* Force blue color */
            display: inline-block !important; /* Ensure it's visible */
            font-size: 24px; /* Ensure the icon is large enough */
        }

        .dashboard-stats {
            display: flex;
            justify-content: space-between;
            margin: 20px 0;
        }

        .stat-box {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            flex: 1;
            margin: 0 5px;
            text-align: center;
            font-size: 14px;
        }

        .stat-box i {
            font-size: 24px;
            color: #1e88e5;
            margin-bottom: 5px;
        }

        .stat-number {
            font-size: 20px;
            font-weight: bold;
        }

        .button {
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #1e88e5;
            color: white;
            padding: 12px;
            border-radius: 8px;
            margin: 10px 0;
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
    <!-- Edit Profile Icon -->
    <a href="../editProfile.jsp" class="edit-profile" title="Edit Profile">
        <i class="fa-solid fa-user-pen"></i>
    </a>
    <h2>Welcome, <%= loggedUser.getUsername() %>!</h2>
    <p>Role: <strong>Admin (Managing Staff)</strong></p>

    <!-- Dashboard Analytics -->
    <div class="dashboard-stats">
        <div class="stat-box">
            <i class="fas fa-user-shield"></i>
            <p>Staff</p>
            <p class="stat-number"><%= totalStaff %></p>
        </div>
        <div class="stat-box">
            <i class="fas fa-users"></i>
            <p>Residents</p>
            <p class="stat-number"><%= totalResidents %></p>
        </div>
        <div class="stat-box">
            <i class="fas fa-user-check"></i>
            <p>Visitors</p>
            <p class="stat-number"><%= totalVisitors %></p>
        </div>
    </div>

    <!-- Functional Buttons -->
    <a href="${pageContext.request.contextPath}/admin/manageStaff" class="button">
        <i class="fas fa-user-cog"></i> Manage Staff
    </a>
    <a href="${pageContext.request.contextPath}/admin/manageResident" class="button">
        <i class="fas fa-user-cog"></i> Manage Resident
    </a>
    <a href="${pageContext.request.contextPath}/admin/manageVisitRequests" class="button">
        <i class="fas fa-user-cog"></i> Manage Visitors
    </a>
    <a href="${pageContext.request.contextPath}/admin/dashboard?action=view-report" class="button">
        <i class="fas fa-chart-bar"></i> View Reports
    </a>

    <!-- Logout Button -->
    <a href="${pageContext.request.contextPath}/LogoutServlet" class="button logout-btn">
        <i class="fas fa-sign-out-alt"></i> Logout
    </a>
</div>
</body>
</html>
