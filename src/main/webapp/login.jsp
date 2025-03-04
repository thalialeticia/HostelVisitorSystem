<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 12.35 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Login</title>
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
            width: 350px;
            text-align: center;
        }

        h2 {
            color: #1565c0;
            margin-bottom: 20px;
        }

        input {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #90caf9;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
        }

        .submit-btn {
            background-color: #1e88e5;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
            width: 100%;
        }

        .submit-btn:hover {
            background-color: #1565c0;
        }

        .message {
            font-size: 14px;
            margin-top: 10px;
            padding: 8px;
            border-radius: 6px;
        }

        .error {
            background-color: #ffcdd2;
            color: #c62828;
        }

        .success {
            background-color: #c8e6c9;
            color: #2e7d32;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Login</h2>
    <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit" class="submit-btn">Login</button>
    </form>

    <c:if test="${not empty error}">
        <p class="message error">${error}</p>
    </c:if>

    <p style="margin-top: 15px; font-size: 14px;">
        Don't have an account? <a href="resident/register.jsp" style="color: #1565c0;">Register here</a>.
    </p>
</div>

</body>
</html>

