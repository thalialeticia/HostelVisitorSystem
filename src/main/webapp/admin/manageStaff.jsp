<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 11.25 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.example.hostelvisitorsystem.model.ManagingStaff" %>


<%
    List<User> staffList = (List<User>) request.getAttribute("staffList");
    if (staffList == null) {
        staffList = new ArrayList<>();
    }
%>

<html>
<head>
    <title>Manage Staff Accounts</title>

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

        /* Search bar */
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

        /* Button styling */
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 8px; /* Adds spacing between Edit & Delete buttons */
        }

        /* General button styles */
        .action-btn {
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

        /* Icons inside buttons */
        .action-btn i {
            font-size: 16px;
        }

        /* Super Admin text styling */
        .super-admin-label {
            color: #757575;
            font-weight: bold;
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

        /* Navigation buttons */
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

        /* Responsive adjustments */
        @media screen and (max-width: 768px) {
            .container {
                width: 95%;
                padding: 20px;
            }

            input[type="text"] {
                width: 100%;
            }

            table {
                font-size: 12px;
            }
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

    <h2>Manage Staff Accounts</h2>

    <!-- Search Bar -->
    <div class="search-container">
        <input type="text" id="searchInput" placeholder="Search by Name or Email..." onkeyup="searchStaff()">
    </div>

    <!-- Staff Table -->
    <table>
        <thead>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody id="staffTable">
        <% if (staffList != null && !staffList.isEmpty()) {
            for (User staff : staffList) {
                boolean isSuperAdmin = (staff instanceof ManagingStaff) && ((ManagingStaff) staff).isSuperAdmin();
        %>
        <tr>
            <td><%= staff.getName() %></td>
            <td><%= staff.getEmail() %></td>
            <td><%= staff.getRole() %></td>
            <td>
                <% if (!isSuperAdmin) { %>  <!-- ✅ Hide buttons for Super Admins -->
                <div class="action-buttons">
                    <button class="action-btn edit-btn" onclick="editStaff('<%= staff.getId() %>')">
                        <i class="fas fa-edit"></i> Edit
                    </button>
                    <button class="action-btn delete-btn" onclick="deleteStaff('<%= staff.getId() %>')">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </div>
                <% } else { %>
                <span class="super-admin-label">Super Admin</span>
                <% } %>
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

<!-- Pagination Controls -->
<div class="pagination-container">
    <button id="prevBtn" class="pagination-btn" disabled>← Previous</button>
    <button id="nextBtn" class="pagination-btn">Next →</button>
</div>


<!-- Buttons Below Container -->
<div class="button-container">
    <a href="addStaff.jsp" class="button">Add New Staff</a>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="button back-btn">Back to Dashboard</a>
</div>

<script>
    function searchStaff() {
        let input = document.getElementById("searchInput").value.toLowerCase();
        let rows = document.querySelectorAll("#staffTable tr");

        rows.forEach(row => {
            let name = row.cells[0].textContent.toLowerCase();
            let email = row.cells[1].textContent.toLowerCase();
            row.style.display = (name.includes(input) || email.includes(input)) ? "" : "none";
        });
    }

    function editStaff(id) {
        window.location.href = "${pageContext.request.contextPath}/admin/manageStaff?action=edit&id=" + id;
    }

    function deleteStaff(id) {
        if (confirm("Are you sure you want to delete this staff member?")) {
            window.location.href = "${pageContext.request.contextPath}/admin/manageStaff?action=delete&id=" + id;
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        let currentPage = 1;
        const rowsPerPage = 7; // ✅ Set to 7 rows per page
        const tableRows = document.querySelectorAll("#staffTable tr");
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
