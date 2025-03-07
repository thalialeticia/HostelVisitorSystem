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
            margin-top: 20px;
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

        .view-btn {
            background-color: #ffa000; /* Orange */
            border: none;
            color: white;
            font-size: 14px;
            font-weight: bold;
            padding: 8px 16px;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.2s ease;
            text-decoration: none;
        }

        .view-btn:hover {
            background-color: #ff8f00; /* Darker Orange */
            transform: scale(1.05);
        }

        .cancel-btn {
            background-color: #dc3545; /* Red */
            border: none;
            color: white;
            font-size: 14px;
            font-weight: bold;
            padding: 8px 16px;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.2s ease;
            text-decoration: none;
        }

        .cancel-btn:hover {
            background-color: #c82333; /* Darker Red */
            transform: scale(1.05);
        }

        /* Icons inside buttons */
        .view-btn i, .cancel-btn i {
            font-size: 16px;
        }

        .pagination-container {
            display: flex;
            justify-content: flex-end;
            margin-top: 15px;
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
            display: none;
        }

        .success-box {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .error-box {
            background-color: #ffebee;
            color: #d32f2f;
        }

        /* Search bar */
        .search-container {
            display: flex;
            justify-content: center; /* Centers the search bar */
            align-items: center;
            margin-bottom: 15px;
            position: relative;
            width: 100%;
            margin-top: 15px;
        }

        .search-container input {
            width: 100%;
            max-width: 400px; /* Restricts width */
            padding: 12px 40px 12px 15px; /* Space for icon */
            border: 1px solid #90caf9;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            transition: all 0.3s ease-in-out;
        }

        .search-container input:focus {
            border-color: #1e88e5;
            box-shadow: 0px 0px 8px rgba(30, 136, 229, 0.4);
        }

        .search-icon {
            position: absolute;
            right: 15px;
            font-size: 16px;
            color: #1e88e5;
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

    <a href="../editProfile.jsp" class="edit-profile" title="Edit Profile">
        <i class="fa-solid fa-user-pen"></i>
    </a>

    <h2>Welcome, <%= loggedUser.getUsername() %>!</h2>
    <p>Role: <strong>Resident</strong></p>

    <!-- Request Visit Button -->
    <div class="dashboard-options">
        <a href="addRequestVisit.jsp" class="button"><i class="fa-solid fa-calendar-check"></i> Request a Visit</a>
    </div>

    <!-- Search Bar -->
    <div class="search-container">
        <input type="text" id="searchInput" placeholder="🔍 Search by Name or Status..." onkeyup="searchRequest()">
        <i class="fa-solid fa-search search-icon"></i>
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
        <tbody id="table-body">
        <%
            if (!visitRequests.isEmpty()) {
                for (VisitRequest visitReq : visitRequests) {
        %>
        <tr>
            <td><%= visitReq.getVisitorName() %></td>
            <td><%= visitReq.getVisitDate().format(dateFormatter) %></td>
            <td><%= visitReq.getVisitTime().format(timeFormatter) %></td>
            <td><%= visitReq.getPurpose() %></td>
            <td><%= visitReq.getStatus() %></td>
            <td>
                <div class="action-buttons">
                    <button class="view-btn" onclick="viewRequest('<%= visitReq.getId() %>')">
                        <i class="fa-solid fa-eye"></i> View
                    </button>
                    <% if (visitReq.getStatus() == VisitRequest.Status.PENDING) { %>
                    <button class="cancel-btn" onclick="cancelRequest('<%= visitReq.getId() %>')">
                        <i class="fa-solid fa-ban"></i> Cancel
                    </button>
                    <% } %>
                </div>
            </td>
        </tr>
        <%
            }
        } else { // If there are no records, show a message
        %>
        <tr>
            <td colspan="6" style="text-align: center; font-style: italic; color: #757575;">
                No visit requests found.
            </td>
        </tr>
        <%
            }
        %>
        </tbody>

    </table>

    <!-- Pagination Controls -->
    <div class="pagination-container">
        <button id="prevBtn" class="pagination-btn" disabled>← Previous</button>
        <button id="nextBtn" class="pagination-btn">Next →</button>
    </div>

    <!-- Logout Button -->
    <a href="${pageContext.request.contextPath}/LogoutServlet" class="button logout-btn">
        <i class="fa-solid fa-right-from-bracket"></i> Logout
    </a>

</div>

<script>
    function searchRequest() {
        let input = document.getElementById("searchInput").value.toLowerCase();
        let rows = document.querySelectorAll("#table-body tr");

        rows.forEach(row => {
            let name = row.cells[0].textContent.toLowerCase();
            let status = row.cells[4].textContent.toLowerCase();
            row.style.display = (name.includes(input) || status.includes(input)) ? "" : "none";
        });
    }

    function viewRequest(requestId) {
        window.location.href = "${pageContext.request.contextPath}/resident/dashboardResident?action=view&id=" + requestId;
    }

    function cancelRequest(requestId) {
        if (confirm("Are you sure you want to cancel this visit request?")) {
            window.location.href = "${pageContext.request.contextPath}/resident/dashboardResident?action=cancel&id=" + requestId;
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        let currentPage = 1;
        const rowsPerPage = 5;
        const tableRows = document.querySelectorAll("#table-body tr");
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
