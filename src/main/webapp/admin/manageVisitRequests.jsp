<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 07/03/25
  Time: 3.13 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.VisitRequest" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.ArrayList" %>

<%
    List<VisitRequest> visitRequests = (List<VisitRequest>) request.getAttribute("visitRequests");
    if (visitRequests == null) {
        visitRequests = new ArrayList<>();
    }
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
%>

<html>
<head>
    <title>Manage Visitor Requests</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
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
            font-size: 14px;
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
            font-size: 14px;
        }

        th {
            background-color: #1e88e5;
            color: white;
        }

        .status-buttons {
            display: flex;
            justify-content: center;
            gap: 8px; /* Ensure spacing between buttons */
        }

        .status-buttons button {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 5px 10px; /* Adjust padding */
            font-size: 13px; /* Slightly reduce font size */
            border-radius: 5px;
            border: none;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        /* Ensuring buttons don't overflow in smaller screens */
        @media screen and (max-width: 768px) {
            .container {
                width: 95%;
                padding: 20px;
            }

            table {
                font-size: 12px;
            }

            .status-buttons {
                flex-direction: column; /* Stack buttons on small screens */
                gap: 4px;
            }
        }

        .approve-btn, .reject-btn {
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

        /* Fix approve button */
        .approve-btn {
            background-color: #28a745;
        }

        .approve-btn:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

        /* Fix reject button */
        .reject-btn {
            background-color: #dc3545;
        }

        .reject-btn:hover {
            background-color: #c82333;
            transform: scale(1.05);
        }

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

        .pagination-container {
            display: flex;
            justify-content: center; /* ✅ Center align */
            align-items: center; /* ✅ Ensure vertical alignment */
            margin-top: 15px;
            gap: 10px; /* ✅ Add spacing between buttons */
        }


        .pagination-btn {
            background-color: #1e88e5; /* Active Blue */
            color: white;
            border: none;
            padding: 10px 18px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            border-radius: 5px;
            transition: background 0.3s ease, transform 0.2s ease;
            margin-left: 10px;
        }

        .pagination-btn:hover:not(:disabled) {
            background-color: #1565c0;
            transform: scale(1.05);
        }

        /* Disabled button (Full Grey Effect) */
        .pagination-btn:disabled {
            background-color: #b0bec5 !important; /* Full Grey */
            color: #ffffff !important;
            cursor: not-allowed;
            box-shadow: none;
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


    </style>
</head>
<body>
<div class="container">
    <!-- Success Message (Only if there is no error) -->
    <c:if test="${not empty success and empty error}">
    <div class="success-box" id="successMessage">
        <p>${success}</p>
    </div>
    </c:if>

    <!-- Error Message -->
    <c:if test="${not empty error}">
    <div class="error-box" id="errorMessage">
        <p>${error}</p>
    </div>
    </c:if>

    <!-- JavaScript to Hide Messages and Remove from Session After 3 Seconds -->
    <script>
        setTimeout(function () {
            let successBox = document.getElementById('successMessage');
            let errorBox = document.getElementById('errorMessage');

            if (successBox) {
                successBox.style.display = 'none';
            }
            if (errorBox) {
                errorBox.style.display = 'none';
            }

            // Send AJAX request to clear session attributes
            fetch('${pageContext.request.contextPath}/ClearMessagesServlet', { method: 'POST' })
                .then(response => response.text())
                .then(data => console.log('Session messages cleared:', data))
                .catch(error => console.error('Error clearing session messages:', error));

        }, 3000); // 3 seconds
    </script>

    <div class="container">
        <h2>Manage Visitor Requests</h2>

        <!-- Search Bar -->
        <div class="search-container">
            <input type="text" id="searchInput" placeholder="Search by Resident Name or Visitor Name..." onkeyup="searchRequests()">
        </div>

        <!-- Visit Requests Table -->
        <table>
            <thead>
            <tr>
                <th>Resident Name</th>
                <th>Visitor Name</th>
                <th>Phone</th>
                <th>Visit Date</th>
                <th>Time</th>
                <th>Purpose</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody id="visitRequestsTable">
            <% if (!visitRequests.isEmpty()) {
                for (VisitRequest requestItem : visitRequests) { %>
            <tr>
                <td><%= requestItem.getResident().getName() %></td>
                <td><%= requestItem.getVisitorName() %></td>
                <td><%= requestItem.getVisitorPhone() %></td>
                <td><%= requestItem.getVisitDate().format(dateFormatter) %></td>
                <td><%= requestItem.getVisitTime().format(timeFormatter) %></td>
                <td><%= requestItem.getPurpose() %></td>
                <td>
                    <% if (requestItem.getStatus() == VisitRequest.Status.PENDING) { %>
                    <div class="status-buttons">
                        <button class="approve-btn" onclick="approveRequest('<%= requestItem.getId() %>')">
                            <i class="fas fa-check"></i> Approve
                        </button>
                        <button class="reject-btn" onclick="rejectRequest('<%= requestItem.getId() %>')">
                            <i class="fas fa-times"></i> Reject
                        </button>
                    </div>
                    <% } else { %>
                    <%= requestItem.getStatus() %>
                    <% } %>
                </td>
            </tr>
            <% } } else { %>
            <tr>
                <td colspan="7">No visitor requests found.</td> <!-- Update colspan to match new layout -->
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <!-- Pagination Controls -->
    <div class="pagination-container">
        <button id="prevBtn" class="pagination-btn" disabled>← Previous</button>
        <button id="nextBtn" class="pagination-btn">Next →</button>
    </div>

    <div class="button-container">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="button">Back to Dashboard</a>
    </div>

    <script>
        function approveRequest(id) {
            if (confirm("Are you sure you want to approve this visit request?")) {
                window.location.href = "${pageContext.request.contextPath}/admin/manageVisitRequests?action=approve&id=" + id;
            }
        }

        function rejectRequest(id) {
            if (confirm("Are you sure you want to reject this visit request?")) {
                window.location.href = "${pageContext.request.contextPath}/admin/manageVisitRequests?action=reject&id=" + id;
            }
        }

        function searchRequests() {
            let input = document.getElementById("searchInput").value.toLowerCase();
            let rows = document.querySelectorAll("#visitRequestsTable tr");

            rows.forEach(row => {
                let resident = row.cells[0].textContent.toLowerCase();
                let visitor = row.cells[1].textContent.toLowerCase();
                row.style.display = (resident.includes(input) || visitor.includes(input)) ? "" : "none";
            });
        }

        document.addEventListener("DOMContentLoaded", function () {
            let currentPage = 1;
            const rowsPerPage = 7;
            const tableRows = document.querySelectorAll("#visitRequestsTable tr");
            const totalPages = Math.ceil(tableRows.length / rowsPerPage) || 1; // Ensure at least 1 page

            function updatePaginationButtons() {
                const prevBtn = document.getElementById("prevBtn");
                const nextBtn = document.getElementById("nextBtn");

                prevBtn.disabled = (currentPage === 1);
                nextBtn.disabled = (currentPage === totalPages);

                prevBtn.style.backgroundColor = prevBtn.disabled ? "#b0bec5" : "#1e88e5"; // Grey when disabled, blue when active
                nextBtn.style.backgroundColor = nextBtn.disabled ? "#b0bec5" : "#1e88e5";
            }

            function showPage(page) {
                tableRows.forEach((row, index) => {
                    row.style.display = (index >= (page - 1) * rowsPerPage && index < page * rowsPerPage) ? "table-row" : "none";
                });

                currentPage = page;
                updatePaginationButtons();
            }

            document.getElementById("prevBtn").addEventListener("click", function () {
                if (currentPage > 1) {
                    showPage(currentPage - 1);
                }
            });

            document.getElementById("nextBtn").addEventListener("click", function () {
                if (currentPage < totalPages) {
                    showPage(currentPage + 1);
                }
            });

            showPage(currentPage);
        });

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