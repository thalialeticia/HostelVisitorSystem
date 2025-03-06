<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 4.05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.User" %>
<%@ page import="com.example.hostelvisitorsystem.model.ManagingStaff" %>

<%
    String id = request.getParameter("id");
    User staff = (User) request.getAttribute("staff");
    User currentUser = (User) session.getAttribute("loggedUser");

    if (staff == null) {
        response.sendRedirect("manageStaff.jsp?error=StaffNotFound");
        return;
    }

    // Extract country code from phone number
    String fullPhone = staff.getPhone();
    String countryCode = "+60"; // Default Malaysia
    String phoneNumber = fullPhone;

    if (fullPhone.startsWith("+65")) {
        countryCode = "+65";
        phoneNumber = fullPhone.substring(3);
    } else if (fullPhone.startsWith("+1")) {
        countryCode = "+1";
        phoneNumber = fullPhone.substring(2);
    } else if (fullPhone.startsWith("+44")) {
        countryCode = "+44";
        phoneNumber = fullPhone.substring(3);
    } else if (fullPhone.startsWith("+91")) {
        countryCode = "+91";
        phoneNumber = fullPhone.substring(3);
    } else if (fullPhone.startsWith("+60")) {
        phoneNumber = fullPhone.substring(3);
    }

    // Check if the user is a Managing Staff & Super Admin
    boolean isCurrentUserSuperAdmin = (currentUser instanceof ManagingStaff) && ((ManagingStaff) currentUser).isSuperAdmin();
    boolean isEditingSuperAdmin = (staff instanceof ManagingStaff) && ((ManagingStaff) staff).isSuperAdmin();
%>

<html>
<head>
    <title>Edit Staff</title>
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
            width: 400px;
            text-align: center;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeIn 0.7s ease-out forwards;
        }

        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        h2 {
            color: #0d47a1;
            font-size: 22px;
            margin-bottom: 15px;
        }

        /* Hide Error Box if No Error */
        .error-box {
            background-color: #ffebee;
            color: #d32f2f;
            padding: 10px;
            border-radius: 6px;
            font-size: 14px;
            text-align: center;
            margin-bottom: 15px;
            display: ${not empty error ? "block" : "none"};
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #90caf9;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
        }

        input[readonly], select[disabled] {
            background-color: #e0e0e0;
            cursor: not-allowed;
        }

        /* Submit & Back Button */
        .submit-btn, .back-btn {
            background-color: #1e88e5;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 15px;
            width: 100%;
            display: inline-block;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .submit-btn:hover { background-color: #1565c0; transform: scale(1.03); }
        .back-btn { background-color: #757575; }
        .back-btn:hover { background-color: #616161; transform: scale(1.03); }

        /* Phone Number Layout */
        .phone-container {
            display: flex;
            gap: 5px;
        }

        .phone-container select {
            width: 30%;
        }

        .phone-container input {
            width: 70%;
        }

        /* Super Admin Checkbox */
        .checkbox-container {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 10px;
        }

        .checkbox-container input {
            width: 16px;
            height: 16px;
            cursor: not-allowed;
        }

        .checkbox-container label {
            font-size: 14px;
            color: #0d47a1;
            font-weight: bold;
            cursor: not-allowed;
        }

        .disabled-field {
            background-color: #e0e0e0;
            cursor: not-allowed;
            color: #757575; /* Make disabled text look inactive */
        }

    </style>
</head>
<body>

<div class="container">
    <h2>Edit Staff</h2>

    <!-- Error Message -->
    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
    <div class="error-box" id="errorMessage">
        <p><%= error %></p>
    </div>
    <% } %>

    <!-- JavaScript to Remove Error Message After 3 Seconds -->
    <script>
        setTimeout(function () {
            let errorBox = document.getElementById('errorMessage');
            if (errorBox) {
                errorBox.style.display = 'none';
            }

            // Clear error sessloggedInUserion variable via AJAX
            fetch('${pageContext.request.contextPath}/ClearMessagesServlet', { method: 'POST' })
                .then(response => response.text())
                .then(data => console.log('Error message cleared:', data))
                .catch(error => console.error('Error clearing session message:', error));

        }, 3000);
    </script>


    <form action="${pageContext.request.contextPath}/admin/manageStaff?action=update" method="post">
        <input type="hidden" name="id" value="<%= id %>">

        <!-- Username (Editable) -->
        <input type="text" name="username" value="<%= staff.getUsername() %>" required>

        <!-- Password Field (Optional) -->
        <input type="password" id="password" name="password" placeholder="New Password (Leave blank to keep current)">

        <input type="text" name="name" value="<%= staff.getName() %>" required>

        <!-- Gender Selection -->
        <select name="gender">
            <option value="MALE" <%= staff.getGender().equals("MALE") ? "selected" : "" %>>Male</option>
            <option value="FEMALE" <%= staff.getGender().equals("FEMALE") ? "selected" : "" %>>Female</option>
        </select>

        <!-- Phone Number with Country Code -->
        <div class="phone-container">
            <select id="countryCode" name="countryCode">
                <option value="+60" <%= staff.getPhone().startsWith("+60") ? "selected" : "" %>>🇲🇾 +60</option>
                <option value="+65" <%= staff.getPhone().startsWith("+65") ? "selected" : "" %>>🇸🇬 +65</option>
                <option value="+1" <%= staff.getPhone().startsWith("+1") ? "selected" : "" %>>🇺🇸 +1</option>
                <option value="+44" <%= staff.getPhone().startsWith("+44") ? "selected" : "" %>>🇬🇧 +44</option>
                <option value="+91" <%= staff.getPhone().startsWith("+91") ? "selected" : "" %>>🇮🇳 +91</option>
            </select>
            <input type="text" id="phone" name="phone" value="<%= staff.getPhone().substring(3) %>" required>
        </div>

        <!-- IC Field (Editable) -->
        <input type="text" id="ic" name="IC" value="<%= staff.getIC() %>" required>

        <input type="email" name="email" value="<%= staff.getEmail() %>" required>

        <!-- Role Selection (Only Super Admin Can Edit) -->
        <select name="role" id="roleSelect" <%= isCurrentUserSuperAdmin ? "" : "disabled class='disabled-field'" %>>
            <option value="SECURITY_STAFF" <%= staff.getRole().name().equals("SECURITY_STAFF") ? "selected" : "" %>>Security Staff</option>
            <option value="MANAGING_STAFF" <%= staff.getRole().name().equals("MANAGING_STAFF") ? "selected" : "" %>>Managing Staff</option>
        </select>

        <!-- Super Admin Checkbox (Only Super Admin Can Edit) -->
        <div class="checkbox-container" id="superAdminContainer">
            <input type="checkbox" id="superAdmin" name="superAdmin"
                <%= isEditingSuperAdmin ? "checked" : "" %>
                <%= isCurrentUserSuperAdmin ? "" : "disabled class='disabled-field'" %>>
            <label for="superAdmin" style="color: #757575;">Make Super Admin</label>
        </div>

        <button type="submit" class="submit-btn">Update Staff</button>
    </form>

    <a href="${pageContext.request.contextPath}/admin/manageStaff" class="back-btn">← Back to Manage Staff</a>
</div>

</body>
</html>
