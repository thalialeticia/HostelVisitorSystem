<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 1.45 AM
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

    if (loggedUser == null || !loggedUser.getRole().toString().equals("SECURITY_STAFF")) {
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
    <title>Security Staff Dashboard</title>

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

        .reach-btn {
            background-color: #4caf50; /* Green to indicate arrival */
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

        .reach-btn:hover {
            background-color: #388e3c; /* Darker green for hover */
            transform: scale(1.05);
        }

        .checkout-btn {
            background-color: #f44336; /* Red to indicate checkout */
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

        .checkout-btn:hover {
            background-color: #d32f2f; /* Darker red for hover */
            transform: scale(1.05);
        }

        /* Icons inside buttons */
        .view-btn i, .reach-btn .checkout-btn i {
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

        /* Row for labels and inputs */
        .verification-row {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px; /* Adjust spacing between inputs */
            width: 100%;
        }

        /* Style the input fields */
        .verification-input {
            padding: 10px;
            font-size: 16px;
            width: 200px; /* Set input width */
            border: 2px solid #90caf9;
            border-radius: 8px;
            text-align: center;
            outline: none;
            transition: border 0.3s ease-in-out;
        }

        .verification-input:focus {
            border-color: #1e88e5;
            box-shadow: 0 0 8px rgba(30, 136, 229, 0.3);
        }

        /* Style labels to align properly */
        .verification-label {
            font-size: 16px;
            color: #0d47a1;
            font-weight: bold;
            text-align: left;
            width: 150px; /* Set width to align labels */
        }

        .verification-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 10px;
        }

        #verificationCode {
            padding: 12px;
            font-size: 18px;
            width: 180px;
            border: 2px solid #90caf9;
            border-radius: 8px;
            text-align: center;
            outline: none;
            transition: border 0.3s ease-in-out;
        }

        #verificationCode:focus {
            border-color: #1e88e5;
            box-shadow: 0 0 8px rgba(30, 136, 229, 0.3);
        }

        .verification-btn-container {
            margin-top: 10px;
            display: flex;
            justify-content: center;
        }

        .verify-btn {
            background-color: #1e88e5;
            color: white;
            padding: 12px 18px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s ease, transform 0.2s ease;
            border: none;
            width: 150px;
        }

        .verify-btn:hover {
            background-color: #1565c0;
            transform: scale(1.05);
        }

        .verify-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }

        .verification-result {
            margin-top: 15px;
            padding: 12px;
            background: #e3f2fd;
            border-radius: 8px;
            font-size: 14px;
            color: #0d47a1;
            text-align: center;
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
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            margin-bottom: 5px;
        }

        .search-container input {
            flex-grow: 1;
            max-width: 400px;
            padding: 10px 15px;
            border: 1px solid #90caf9;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            transition: border 0.3s ease-in-out;
        }

        h3 {
            margin-top: 0px;
            margin-bottom: 0px;
        }

        .search-container input:focus {
            border-color: #1e88e5;
            box-shadow: 0px 0px 8px rgba(30, 136, 229, 0.4);
        }

        .search-container .search-icon {
            font-size: 18px;
            color: #1e88e5;
            cursor: pointer;
            position: relative;
            left: -40px;
        }

        /* Adjust container spacing */
        .container {
            padding: 20px;
            width: 85%;
            max-width: 850px;
        }

        /* Improve spacing between elements */
        h2, h3 {
            margin-bottom: 8px;
        }

        .request-table {
            margin-top: 0px;
        }

        /* Reduce space around buttons */
        .action-buttons {
            gap: 6px;
        }

        /* Top-right icons container */
        .top-right-icons {
            position: absolute;
            top: 15px;
            right: 20px;
            display: flex;
            gap: 12px; /* Space between icons */
        }

        /* Style for both icons */
        .icon-button {
            font-size: 20px;
            color: #1e88e5;
            text-decoration: none;
            transition: color 0.3s ease, transform 0.2s ease;
        }

        .icon-button:hover {
            color: #1565c0;
            transform: scale(1.1);
        }

        /* Logout icon specific styling */
        .logout-icon {
            color: #e53935; /* Red for logout */
        }

        .logout-icon:hover {
            color: #c62828; /* Darker red on hover */
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

    <div class="top-right-icons">
        <a href="../editProfile.jsp" class="icon-button" title="Edit Profile">
            <i class="fa-solid fa-user-pen"></i>
        </a>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="icon-button logout-icon" title="Logout">
            <i class="fa-solid fa-right-from-bracket"></i>
        </a>
    </div>

    <h2>Welcome, <%= loggedUser.getUsername() %>!</h2>
    <p>Role: <strong>Security Staff</strong></p>

    <div class="dashboard-options">
        <!-- Visitor Verification Section -->
        <form id="verifyVisitorForm" action="${pageContext.request.contextPath}/security/dashboardSecurity" method="post">
            <div class="verification-container">

                <!-- Row for Labels & Inputs -->
                <div class="verification-row">
                    <label for="verificationCode" class="verification-label">Enter 6-Digit Code:</label>
                    <input type="text" id="verificationCode" name="verificationCode" maxlength="6" required
                           pattern="[A-Z0-9]{6}" title="Enter a valid 6-character code (letters & numbers)"
                           class="verification-input" oninput="validateCode()" style="text-transform: uppercase;">
                </div>

                <div class="verification-row">
                    <label for="visitorIc" class="verification-label">Enter 12-Digit IC:</label>
                    <input type="text" id="visitorIc" name="visitorIc" maxlength="12" required
                           pattern="[0-9]{12}" title="Enter a valid 12-digit IC number"
                           class="verification-input" oninput="validateIC()">
                </div>

                <!-- Centered Verify Button -->
                <div class="verification-btn-container">
                    <button type="submit" class="verify-btn" id="verifyButton" disabled>
                        <i class="fa-solid fa-check"></i> Verify
                    </button>
                </div>

            </div>
        </form>

        <!-- Display Verification Result -->
        <% String verificationMessage = (String) session.getAttribute("verificationMessage"); %>
        <% if (verificationMessage != null) { %>
        <div class="verification-result">
            <p><%= verificationMessage %></p>
        </div>
        <% session.removeAttribute("verificationMessage"); %> <%-- Clear after displaying --%>
        <% } %>

        <!-- Search Bar - Now directly under "Check & Update Status" -->
        <h3 style="margin-bottom: 0px; color: #0d47a1;">Check & Update Status</h3>
        <div class="search-container">
            <input type="text" id="searchInput" placeholder="Search by Name or Status..." onkeyup="searchRequest()">
            <i class="fa-solid fa-search search-icon"></i>
        </div>

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
                        <% if (visitReq.getStatus() == VisitRequest.Status.APPROVED) { %>
                        <button class="reach-btn" onclick="reachRequest('<%= visitReq.getId() %>')">
                            <i class="fa-solid fa-map-marker-alt"></i> Reach
                        </button>
                        <% } else if (visitReq.getStatus() == VisitRequest.Status.REACHED) { %>
                        <button class="checkout-btn" onclick="checkOutRequest('<%= visitReq.getId() %>')">
                            <i class="fa-solid fa-sign-out-alt"></i> Checkout
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
    </div>
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
        window.location.href = "${pageContext.request.contextPath}/security/dashboardSecurity?action=view&id=" + requestId;
    }

    function  checkOutRequest(requestId) {
        window.location.href = "${pageContext.request.contextPath}/security/dashboardSecurity?action=checkout&id=" + requestId;
    }

    function reachRequest(requestId) {
        let verificationCode = prompt("Enter the 6-digit verification code:");

        if (verificationCode && /^[A-Z0-9]{6}$/i.test(verificationCode)) {

            window.location.href = "${pageContext.request.contextPath}/security/dashboardSecurity?action=reach&id=" + requestId + "&verificationCode=" + verificationCode;
        } else if (verificationCode !== null) {
            alert("Invalid code! Please enter a valid 6-digit verification code.");
        }
    }

    function validateCode() {
        let codeInput = document.getElementById("verificationCode");
        let icInput = document.getElementById("visitorIc");
        let verifyButton = document.getElementById("verifyButton");

        codeInput.value = codeInput.value.toUpperCase();

        if (/^[A-Z0-9]{6}$/.test(codeInput.value) && /^[0-9]{12}$/.test(icInput.value)) {
            verifyButton.disabled = false;
        } else {
            verifyButton.disabled = true;
        }
    }

    function validateIC() {
        validateCode();
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
