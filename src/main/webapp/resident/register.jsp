<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 04/03/25
  Time: 11.00 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Resident Registration</title>
    <style>
        /* General Styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #e3f2fd; /* Light Blue Background */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        /* Form Container */
        .container {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            width: 350px;
            text-align: center;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeIn 1s ease-out forwards;
        }

        @keyframes fadeIn {
            0% {
                opacity: 0;
                transform: translateY(20px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        h2 {
            color: #1565c0; /* Dark Blue */
            margin-bottom: 20px;
        }

        /* Input Fields */
        input, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #90caf9;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
        }

        select {
            background-color: #f8f9fa;
        }

        /* Submit Button */
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
            transition: background 0.3s ease;
        }

        .submit-btn:hover {
            background-color: #1565c0;
        }

        /* Messages */
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

        /* Navigation Links */
        .nav-links {
            margin-top: 15px;
            font-size: 14px;
        }

        .nav-links a {
            color: #1565c0;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .nav-links a:hover {
            color: #0d47a1;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Resident Registration</h2>
    <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <input type="text" name="name" placeholder="Full Name" required>

        <select name="gender">
            <option value="MALE">Male</option>
            <option value="FEMALE">Female</option>
        </select>

        <input type="text" name="phone" placeholder="Phone Number" required>
        <input type="text" name="IC" placeholder="IC Number" required>
        <input type="email" name="email" placeholder="Email" required>

        <button type="submit" class="submit-btn">Register</button>
    </form>

    <c:if test="${not empty error}">
        <p class="message error">${error}</p>
    </c:if>
    <c:if test="${not empty success}">
        <p class="message success">${success}</p>
    </c:if>

    <!-- Navigation Links -->
    <p class="nav-links">
        Already have an account? <a href="../login.jsp">Login here</a>.<br>
        <a href="../index.jsp">← Back to Home</a>
    </p>
</div>

</body>
</html>

