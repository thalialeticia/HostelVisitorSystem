<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 08/03/25
  Time: 4.23 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.VisitRequest" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    VisitRequest visitRequest = (VisitRequest) request.getAttribute("visitRequest");

    if (visitRequest == null) {
        response.sendRedirect("dashboardSecurity.jsp");
        return;
    }

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a");
%>

<html>
<head>
    <title>View Visitor Request</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        /* General Styling */
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
            width: 500px;
            text-align: center;
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
            font-weight: bold;
        }

        .info-container {
            text-align: left;
            font-size: 16px;
            margin-top: 20px;
        }

        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
            padding: 10px;
            border-radius: 8px;
            background: #f5f5f5;
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
        }

        .info-item i {
            font-size: 18px;
            color: #1e88e5;
            margin-right: 10px;
        }

        .info-item span {
            font-weight: bold;
            color: #333;
        }

        .button-container {
            display: flex;
            justify-content: center; /* Centers the button */
            margin-top: 20px;
        }

        .back-btn {
            background-color: #1e88e5;
            color: white;
            padding: 12px 24px; /* Better padding */
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s ease, transform 0.2s ease;
            text-decoration: none;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px; /* Space between icon and text */
            width: auto; /* Prevents full width */
            min-width: 220px; /* Ensures good button size */
        }

        .back-btn:hover {
            background-color: #1565c0;
            transform: scale(1.05);
        }


        .back-btn:hover {
            background-color: #1565c0;
            transform: scale(1.05);
        }

        /* Check-in and Check-out Time Container */
        .check-time-container {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            background: #f8f9fa;
            padding: 12px;
            border-radius: 10px;
            border: 1px solid #dee2e6;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
            align-items: center;
        }

        /* Each Check-in/Check-out Item */
        .check-time-item {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
        }

        /* Label, Date, and Time Formatting */
        .check-time-details {
            display: flex;
            flex-direction: column; /* Makes the date appear above the time */
            font-size: 14px;
        }

        .check-time-label {
            font-weight: bold;
            color: #555;
        }

        .check-time-date {
            font-size: 16px;
            font-weight: bold;
            color: #222;
        }

        .check-time-clock {
            font-size: 14px;
            color: #444;
        }

        /* Icons */
        .check-in-icon {
            color: #28a745; /* Green for Check-in */
            font-size: 18px;
        }

        .check-out-icon {
            color: #dc3545; /* Red for Check-out */
            font-size: 18px;
        }

    </style>
</head>

<body>

<div class="container">
    <h2><i class="fa-solid fa-user-check"></i> Visitor Request Details</h2>

    <div class="info-container">
        <div class="info-item"><i class="fa-solid fa-user"></i> <span>Visitor Name: </span>&nbsp; <%= visitRequest.getVisitorName() %></div>
        <div class="info-item"><i class="fa-solid fa-phone"></i> <span>Visitor Phone: </span>&nbsp; <%= visitRequest.getVisitorPhone() %></div>
        <div class="info-item"><i class="fa-solid fa-id-card"></i> <span>Visitor IC: </span>&nbsp; <%= visitRequest.getVisitorIc() %></div>
        <div class="info-item"><i class="fa-solid fa-envelope"></i> <span>Visitor Email: </span>&nbsp; <%= visitRequest.getVisitorEmail() %></div>
        <div class="info-item"><i class="fa-solid fa-map-marker-alt"></i> <span>Visitor Address: </span>&nbsp; <%= visitRequest.getVisitorAddress() %></div>
        <div class="info-item"><i class="fa-solid fa-calendar"></i> <span>Visit Date: </span>&nbsp; <%= visitRequest.getVisitDate().format(dateFormatter) %></div>
        <div class="info-item"><i class="fa-solid fa-clock"></i> <span>Visit Time: </span>&nbsp; <%= visitRequest.getVisitTime().format(timeFormatter) %></div>
        <div class="info-item"><i class="fa-solid fa-clipboard-list"></i> <span>Purpose: </span>&nbsp; <%= visitRequest.getPurpose() %></div>

        <!-- Check-in & Check-out Time Section -->
        <div class="check-time-container" style="margin-bottom: 10px">
            <div class="check-time-item">
                <i class="fa-solid fa-sign-in-alt check-in-icon"></i>
                <div class="check-time-details">
                    <span class="check-time-label">Check-in Time:</span>
                    <span class="check-time-date">
                <%= (visitRequest.getCheckInTime() != null) ? visitRequest.getCheckInTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "-" %>
            </span>
                    <span class="check-time-clock">
                <%= (visitRequest.getCheckInTime() != null) ? visitRequest.getCheckInTime().format(DateTimeFormatter.ofPattern("hh:mm a")) : "" %>
            </span>
                </div>
            </div>
            <div class="check-time-item">
                <i class="fa-solid fa-sign-out-alt check-out-icon"></i>
                <div class="check-time-details">
                    <span class="check-time-label">Check-out Time:</span>
                    <span class="check-time-date">
                <%= (visitRequest.getCheckOutTime() != null) ? visitRequest.getCheckOutTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "-" %>
            </span>
                    <span class="check-time-clock">
                <%= (visitRequest.getCheckOutTime() != null) ? visitRequest.getCheckOutTime().format(DateTimeFormatter.ofPattern("hh:mm a")) : "" %>
            </span>
                </div>
            </div>
        </div>

        <!-- Status (Plain Text Without Color) -->
        <div class="info-item">
            <i class="fa-solid fa-circle-check"></i> <span>Status: </span>&nbsp;
            <%= visitRequest.getStatus() %>
        </div>
    </div>

    <!-- Back Button -->
    <div class="button-container">
        <a href="${pageContext.request.contextPath}/security/dashboardSecurity" class="back-btn">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

</div>

</body>
</html>
