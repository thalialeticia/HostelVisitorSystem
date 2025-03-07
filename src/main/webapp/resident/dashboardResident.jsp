<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 1.44 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.User" %>
<%@ page import="com.example.hostelvisitorsystem.model.VisitRequest" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    HttpSession sessionObj = request.getSession(false);
    User loggedUser = (sessionObj != null) ? (User) sessionObj.getAttribute("loggedUser") : null;

    if (loggedUser == null || !loggedUser.getRole().toString().equals("RESIDENT")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    List<VisitRequest> visitRequests = (List<VisitRequest>) request.getAttribute("visitRequests");
    if (visitRequests == null) {
        visitRequests = new ArrayList<>();
    }

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
%>

<html>
<head>
    <title>Resident Dashboard</title>

    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #e3f2fd, #bbdefb);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }

        .container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 90%;
            max-width: 900px;
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
            gap: 15px;
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

        .logout-btn:hover {
            background-color: #c62828;
        }

        /* Table Styling */
        .request-table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }

        .request-table th, .request-table td {
            border: 1px solid #90caf9;
            padding: 10px;
            text-align: center;
            font-size: 14px;
        }

        .request-table th {
            background-color: #1e88e5;
            color: white;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 8px;
        }

        .approve-btn, .reject-btn, .view-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            color: white;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s ease, transform 0.2s ease;
            text-decoration: none;
        }

        .view-btn {
            background-color: #ffa000;
        }

        .view-btn:hover {
            background-color: #ff8f00;
            transform: scale(1.05);
        }

        .cancel-btn {
            background-color: #dc3545;
        }

        .cancel-btn:hover {
            background-color: #c82333;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
<div class="container">
    <a href="../editProfile.jsp" class="edit-profile" title="Edit Profile">
        <i class="fa-solid fa-user-pen"></i>
    </a>

    <h2>Welcome, <%= loggedUser.getUsername() %>!</h2>
    <p>Role: <strong>Resident</strong></p>

    <!-- Request Visit Button -->
    <div class="dashboard-options">
        <a href="requestVisit.jsp" class="button"><i class="fa-solid fa-calendar-check"></i> Request a Visit</a>
    </div>

    <!-- Check & Update Status Table -->
    <h3 style="margin-top: 20px; color: #0d47a1;">Check & Update Status</h3>
    <table class="request-table">
        <thead>
        <tr>
            <th>Visitor Name</th>
            <th>Visit Date</th>
            <th>Time</th>
            <th>Purpose</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (!visitRequests.isEmpty()) {
            for (VisitRequest visitReq : visitRequests) { %>
        <tr>
            <td><%= visitReq.getVisitorName() %></td>
            <td><%= visitReq.getVisitDate().format(dateFormatter) %></td>
            <td><%= visitReq.getVisitTime().format(timeFormatter) %></td>
            <td><%= visitReq.getPurpose() %></td>
            <td><%= visitReq.getStatus() %></td>
            <td>
                <div class="action-buttons">
                    <a href="viewRequest.jsp?id=<%= visitReq.getId() %>" class="view-btn">
                        <i class="fa-solid fa-eye"></i> View
                    </a>
                    <% if (visitReq.getStatus() == VisitRequest.Status.PENDING) { %>
                    <a href="cancelVisit.jsp?id=<%= visitReq.getId() %>" class="cancel-btn">
                        <i class="fa-solid fa-ban"></i> Cancel
                    </a>
                    <% } %>
                </div>
            </td>
        </tr>
        <% } } else { %>
        <tr>
            <td colspan="6">No visit requests found.</td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <!-- Logout Button -->
    <a href="${pageContext.request.contextPath}/LogoutServlet" class="button logout-btn">
        <i class="fa-solid fa-right-from-bracket"></i> Logout
    </a>
</div>
</body>
</html>
