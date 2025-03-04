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
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Resident Dashboard</title>
</head>
<body>
<h2>Welcome, <%= loggedUser.getUsername() %>!</h2>
<p>Role: <strong>Resident</strong></p>

<a href="requestVisit.jsp">Request a Visit</a>
<a href="viewHistory.jsp">View Visit History</a>

<a href="${pageContext.request.contextPath}/LogoutServlet" class="button logout-btn">Logout</a>

</body>
</html>

