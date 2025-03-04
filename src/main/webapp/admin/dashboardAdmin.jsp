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
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #e3f2fd; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .container { background: white; padding: 30px; border-radius: 12px; box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); text-align: center; width: 400px; }
        h2 { color: #1565c0; }
        .button { display: block; background-color: #1e88e5; color: white; padding: 10px; border-radius: 6px; margin: 5px 0; text-decoration: none; }
        .button:hover { background-color: #1565c0; }
        .logout-btn { background-color: #e53935; }
    </style>
</head>
<body>
<div class="container">
    <h2>Welcome, <%= loggedUser.getUsername() %>!</h2>
    <p>Role: <strong>Admin (Managing Staff)</strong></p>

    <a href="manageUsers.jsp" class="button">Manage Users</a>
    <a href="viewReports.jsp" class="button">View Reports</a>
    <a href="approveVisitors.jsp" class="button">Approve Visitor Requests</a>

    <a href="${pageContext.request.contextPath}/LogoutServlet" class="button logout-btn">Logout</a>

</div>
</body>
</html>
