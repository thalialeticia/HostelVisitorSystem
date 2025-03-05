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

<%
    List<User> residentList = (List<User>) request.getAttribute("residentList");
    if (residentList == null) {
        residentList = new ArrayList<>();
    }
%>

<html>
<head>
    <title>Manage Resident Accounts</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #e3f2fd, #bbdefb);
            display: flex;
            flex-direction: column;
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
            width: 800px;
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

        .search-container {
            margin-bottom: 15px;
        }

        input[type="text"] {
            padding: 10px;
            width: 80%;
            border: 1px solid #90caf9;
            border-radius: 6px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            border: 1px solid #90caf9;
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #1e88e5;
            color: white;
        }

        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            color: white;
            cursor: pointer;
        }

        .edit-btn { background-color: #fbc02d; }
        .delete-btn { background-color: #e53935; }

        .button-container {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
            width: 100%;
            text-align: center;
        }

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

        .success-box, .error-box {
            text-align: center;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 6px;
            font-size: 14px;
            display: none; /* ✅ Initially hidden */
        }

        .success-box {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .error-box {
            background-color: #ffebee;
            color: #d32f2f;
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
            <th>Actions</th>
        </tr>
        <tbody id="residentTable">
            <% if (residentList != null && !residentList.isEmpty()) {
            for (User resident : residentList) { %>
        <tr>
            <td><%= resident.getName() %></td>
            <td><%= resident.getEmail() %></td>
            <td><%= resident.getPhone() %></td>
            <td>
                <button class="action-btn edit-btn" onclick="editResident('<%= resident.getId() %>')">Edit</button>
                <button class="action-btn delete-btn" onclick="deleteResident('<%= resident.getId() %>')">Delete</button>
            </td>
        </tr>
        <% }
        } else { %>
        <tr>
            <td colspan="4">No staff found.</td>
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
        window.location.href = "${pageContext.request.contextPath}/admin/editResident?id=" + id;
    }

    function deleteResident(id) {
        if (confirm("Are you sure you want to delete this staff member?")) {
            window.location.href = "${pageContext.request.contextPath}/admin/deleteResident?id=" + id;
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

