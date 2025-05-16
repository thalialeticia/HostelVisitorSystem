<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 1.20 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.example.hostelvisitorsystem.model.ManagingStaff" %>

<html>
<head>
    <title>Add New Staff</title>
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

        /* Form Container */
        .container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.2);
            width: 400px;
            text-align: center;
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
            font-size: 22px;
            margin-bottom: 15px;
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
            transition: 0.3s ease;
        }

        input:focus, select:focus {
            border-color: #1e88e5;
            outline: none;
            box-shadow: 0 0 5px rgba(30, 136, 229, 0.5);
        }

        /* Error Messages */
        .error-message {
            color: red;
            font-size: 12px;
            text-align: left;
            display: none;
            margin-bottom: 5px;
        }

        /* Pop-up Error Box */
        .error-box {
            background-color: #ffebee;
            color: #d32f2f;
            padding: 10px;
            border-radius: 6px;
            font-size: 14px;
            text-align: center;
            margin-bottom: 15px;
            display: block;
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

        /* Back Button Container */
        .back-btn-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        /* Back Button */
        .back-btn {
            background-color: #757575;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            width: 50%; /* Adjust width as needed */
            text-align: center;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .back-btn:hover {
            background-color: #616161;
            transform: scale(1.03);
        }

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
            cursor: pointer;
        }

        .checkbox-container label {
            font-size: 14px;
            color: #0d47a1;
            font-weight: bold;
            cursor: pointer;
        }

        .shift-container {
            display: none; /* Hidden by default */
            margin-top: 10px;
        }

    </style>
</head>
<body>

<div class="container">
    <h2>Add New Staff</h2>

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

            // Clear error session variable via AJAX
            fetch('${pageContext.request.contextPath}/ClearMessagesServlet', { method: 'POST' })
                .then(response => response.text())
                .then(data => console.log('Error message cleared:', data))
                .catch(error => console.error('Error clearing session message:', error));

        }, 3000);
    </script>

    <form action="${pageContext.request.contextPath}/admin/manageStaff?action=add" method="post" onsubmit="return validateForm()">
        <input type="text" name="username" placeholder="Username" required>

        <!-- Password Field with Validation -->
        <input type="password" id="password" name="password" placeholder="Password" required onkeyup="validatePassword()">
        <p class="error-message" id="passwordError">Password must be at least 5 characters long and contain at least 1 number.</p>

        <input type="text" name="name" placeholder="Full Name" required>

        <!-- Gender Selection -->
        <select name="gender">
            <option value="MALE">Male</option>
            <option value="FEMALE">Female</option>
        </select>

        <!-- Phone Number with Country Code -->
        <div class="phone-container">
            <select id="countryCode">
                <option value="+60">🇲🇾 +60</option>
                <option value="+65">🇸🇬 +65</option>
                <option value="+1">🇺🇸 +1</option>
                <option value="+44">🇬🇧 +44</option>
                <option value="+91">🇮🇳 +91</option>
            </select>
            <input type="text" id="phone" name="phone" placeholder="Phone Number" required onkeyup="validatePhone()">
        </div>
        <p class="error-message" id="phoneError">Enter a valid phone number.</p>

        <input type="text" id="ic" name="IC" placeholder="IC Number" required onkeyup="validateIC()">
        <p class="error-message" id="icError">IC number must be exactly 12 digits.</p>

        <input type="email" name="email" placeholder="Email" required>

        <!-- Role Selection -->
        <select name="role" id="roleSelect" onchange="toggleFields()">
            <option value="SECURITY_STAFF">Security Staff</option>
            <option value="MANAGING_STAFF">Managing Staff</option>
        </select>

        <!-- Shift Selection (Only for Security Staff) -->
        <div class="shift-container" id="shiftContainer">
            <label for="shift">Assign Shift:</label>
            <select name="shift" id="shift">
                <option value="MORNING">Morning (6 AM - 2 PM)</option>
                <option value="EVENING">Evening (2 PM - 10 PM)</option>
                <option value="NIGHT">Night (10 PM - 6 AM)</option>
            </select>
        </div>

        <!-- Super Admin Checkbox (Hidden by Default) -->
        <div class="checkbox-container" id="superAdminContainer" style="display: none;">
            <input type="checkbox" id="superAdmin" name="superAdmin">
            <label for="superAdmin">Make Super Admin</label>
        </div>

        <button type="submit" class="submit-btn">Add Staff</button>
    </form>

    <!-- Back Button -->
    <div class="back-btn-container">
        <a href="${pageContext.request.contextPath}/admin/manageStaff" class="back-btn">← Back to Manage Staff</a>
    </div>

</div>

<script>
    function validatePassword() {
        let password = document.getElementById("password").value;
        let passwordError = document.getElementById("passwordError");
        let regex = /^(?=.*\d).{5,}$/;

        if (!regex.test(password)) {
            passwordError.style.display = "block";
            return false;
        } else {
            passwordError.style.display = "none";
            return true;
        }
    }

    function validatePhone() {
        let phone = document.getElementById("phone").value;
        let phoneError = document.getElementById("phoneError");
        let regex = /^[0-9]{7,12}$/;

        if (!regex.test(phone)) {
            phoneError.style.display = "block";
            return false;
        } else {
            phoneError.style.display = "none";
            return true;
        }
    }

    function validateIC() {
        let ic = document.getElementById("ic").value;
        let icError = document.getElementById("icError");
        let regex = /^[0-9]{12}$/;

        if (!regex.test(ic)) {
            icError.style.display = "block";
            return false;
        } else {
            icError.style.display = "none";
            return true;
        }
    }

    function validateForm() {
        return validatePassword() && validatePhone() && validateIC();
    }

    function toggleFields() {
        let role = document.getElementById("roleSelect").value;
        let shiftContainer = document.getElementById("shiftContainer");
        let superAdminContainer = document.getElementById("superAdminContainer");

        let isLoggedInSuperAdmin = <%= (session.getAttribute("loggedUser") instanceof ManagingStaff) && ((ManagingStaff) session.getAttribute("loggedUser")).isSuperAdmin() %>;

        shiftContainer.style.display = (role === "SECURITY_STAFF") ? "block" : "none";
        superAdminContainer.style.display = (role === "MANAGING_STAFF" && isLoggedInSuperAdmin) ? "flex" : "none";
    }

    window.onload = toggleFields;
</script>

</body>
</html>
