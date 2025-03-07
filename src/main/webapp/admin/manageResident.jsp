<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 11.27 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.example.hostelvisitorsystem.model.Resident" %>

<%
    List<User> residentList = (List<User>) request.getAttribute("residentList");
    if (residentList == null) {
        residentList = new ArrayList<>();
    }
%>

<html>
<head>
    <title>Manage Resident Accounts</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        /* General body styling */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #e3f2fd, #bbdefb);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        /* Container styling */
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
        }

        /* Fade-in animation */
        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        /* Header title */
        h2 {
            color: #0d47a1;
            font-size: 24px;
            margin-bottom: 15px;
        }

        /* Search bar container */
        .search-container {
            margin-bottom: 15px;
        }

        input[type="text"] {
            padding: 10px;
            width: 80%;
            border: 1px solid #90caf9;
            border-radius: 6px;
            font-size: 14px;
        }

        /* Table styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            border: 1px solid #90caf9;
            padding: 10px;
            text-align: center;
            font-size: 14px;
        }

        th {
            background-color: #1e88e5;
            color: white;
        }

        /* Buttons: Edit, Delete, Approve, Reject */
        .action-buttons, .status-buttons {
            display: flex;
            justify-content: center;
            gap: 8px; /* Adds spacing between buttons */
        }

        /* General button styling */
        .action-btn, .approve-btn, .reject-btn {
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

        /* Edit button */
        .edit-btn {
            background-color: #fbc02d; /* Yellow */
        }

        .edit-btn:hover {
            background-color: #f9a825; /* Darker Yellow */
            transform: scale(1.05);
        }

        /* Delete button */
        .delete-btn {
            background-color: #e53935; /* Red */
        }

        .delete-btn:hover {
            background-color: #c62828; /* Darker Red */
            transform: scale(1.05);
        }

        /* Approve button */
        .approve-btn {
            background-color: #28a745; /* Green */
        }

        .approve-btn:hover {
            background-color: #218838; /* Darker Green */
            transform: scale(1.05);
        }

        /* Reject button */
        .reject-btn {
            background-color: #dc3545; /* Red */
        }

        .reject-btn:hover {
            background-color: #c82333; /* Darker Red */
            transform: scale(1.05);
        }

        /* Icons inside buttons */
        .action-btn i, .approve-btn i, .reject-btn i {
            font-size: 16px;
        }

        /* Button container for navigation */
        .button-container {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
            width: 100%;
            text-align: center;
        }

        /* General buttons for navigation */
        .button {
            display: inline-block;
            padding: 12px 20px;
            border-radius: 8px;
            background-color: #1e88e5;
            color: white;
            text-decoration: none;
            font-size: 16px;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .button:hover {
            background-color: #1565c0;
            transform: scale(1.05);
        }

        /* Success and error message boxes */
        .success-box, .error-box {
            text-align: center;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 6px;
            font-size: 14px;
            display: none; /* Initially hidden */
        }

        .success-box {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .error-box {
            background-color: #ffebee;
            color: #d32f2f;
        }

        /* Responsive adjustments */
        @media screen and (max-width: 768px) {
            .container {
                width: 95%;
                padding: 20px;
            }

            input[type="text"] {
                width: 100%;
            }

            .action-buttons, .status-buttons {
                flex-direction: column;
                gap: 5px;
            }

            table {
                font-size: 12px;
            }
        }

    </style>
</head>
<body>

<div class="container">
    <!-- Success Message (Hidden by Default) -->
    <c:if test="${not empty success}">
        <div class="success-box">
            <p>${success}</p>
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <!-- Error Message (Hidden by Default) -->
    <c:if test="${not empty error}">
        <div class="error-box">
            <p>${error}</p>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <h2>Manage Resident Accounts</h2>

    <!-- Search Bar -->
    <div class="search-container">
        <input type="text" id="searchInput" placeholder="Search by Name or Email..." onkeyup="searchResident()">
    </div>

    <!-- Resident Table -->
    <table>
        <thead>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody id="residentTable">
        <% if (residentList != null && !residentList.isEmpty()) {
            for (User resident : residentList) {
                if (resident instanceof Resident) {
                    Resident res = (Resident) resident; // Cast User to Resident once
        %>
        <tr>
            <td><%= res.getName() %></td>
            <td><%= res.getEmail() %></td>
            <td><%= res.getPhone() %></td>
            <td>
                <% if (res.getStatus() == Resident.Status.PENDING) { %>
                <div class="status-buttons">
                    <button class="approve-btn" onclick="approveResident('<%= res.getId() %>')">
                        <i class="fas fa-check"></i> Approve
                    </button>
                    <button class="reject-btn" onclick="rejectResident('<%= res.getId() %>')">
                        <i class="fas fa-times"></i> Reject
                    </button>
                </div>

                <% } else { %>
                <%= res.getStatus() %>
                <% } %>
            </td>

            <td>
                <div class="action-buttons">
                    <button class="action-btn edit-btn" onclick="editResident('<%= res.getId() %>')">
                        <i class="fas fa-edit"></i> Edit
                    </button>
                    <button class="action-btn delete-btn" onclick="deleteResident('<%= res.getId() %>')">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </div>
            </td>


        </tr>
        <% } }
        } else { %>
        <tr>
            <td colspan="5">No residents found.</td> <!-- Updated colspan to 5 -->
        </tr>
        <% } %>
        </tbody>
    </table>

</div>

<!-- Buttons Below Container -->
<div class="button-container">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="button back-btn">Back to Dashboard</a>
</div>

<script>
    function searchResident() {
        let input = document.getElementById("searchInput").value.toLowerCase();
        let rows = document.querySelectorAll("#residentTable tr");

        rows.forEach(row => {
            let name = row.cells[0].textContent.toLowerCase();
            let email = row.cells[1].textContent.toLowerCase();
            row.style.display = (name.includes(input) || email.includes(input)) ? "" : "none";
        });
    }

    function editResident(id) {
        window.location.href = "${pageContext.request.contextPath}/admin/manageResident?action=edit&id=" + id;
    }

    function deleteResident(id) {
        if (confirm("Are you sure you want to delete this resident?")) {
            window.location.href = "${pageContext.request.contextPath}/admin/manageResident?action=delete&id=" + id;
        }
    }

    function approveResident(id) {
        if (confirm("Are you sure you want to approve this resident?")) {
            window.location.href = "${pageContext.request.contextPath}/admin/manageResident?action=approve&id=" + id;
        }
    }

    function rejectResident(id) {
        if (confirm("Are you sure you want to reject this resident?")) {
            window.location.href = "${pageContext.request.contextPath}/admin/manageResident?action=reject&id=" + id;
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        let successBox = document.querySelector(".success-box");
        let errorBox = document.querySelector(".error-box");

        // ✅ Show only if content exists
        if (successBox && successBox.textContent.trim() !== "") {
            successBox.style.display = "block";
        }

        if (errorBox && errorBox.textContent.trim() !== "") {
            errorBox.style.display = "block";
        }
    });
</script>

</body>
</html>

