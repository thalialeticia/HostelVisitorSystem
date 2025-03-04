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
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Security Staff Dashboard</title>
</head>
<body>
<h2>Welcome, <%= loggedUser.getUsername() %>!</h2>
<p>Role: <strong>Security Staff</strong></p>

<a href="verifyVisitors.jsp">Verify Visitors</a>
<a href="monitorSecurity.jsp">Monitor Security Logs</a>

<a href="${pageContext.request.contextPath}/LogoutServlet" class="button logout-btn">Logout</a>

</body>
</html>

