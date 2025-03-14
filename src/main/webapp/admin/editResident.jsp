<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 06/03/25
  Time: 4.13 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.User" %>
<%@ page import="com.example.hostelvisitorsystem.model.ManagingStaff" %>

<%
    String id = request.getParameter("id");
    User resident = (User) request.getAttribute("resident");
    User currentUser = (User) session.getAttribute("loggedUser");

    if (resident == null) {
        response.sendRedirect("manageResident.jsp?error=ResidentNotFound");
        return;
    }

    // Extract country code from phone number
    String fullPhone = resident.getPhone();
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
%>

<html>
<head>
    <title>Edit Resident</title>
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

        /* Error Messages */
        .error-message {
            color: red;
            font-size: 12px;
            display: none;
            text-align: left;
            margin-bottom: 5px;
        }

        /* Error Message Styling */
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

    </style>
</head>
<body>

<div class="container">
    <h2>Edit Resident</h2>

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


    <form action="${pageContext.request.contextPath}/admin/manageResident?action=update" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="id" value="<%= id %>">

        <!-- Username (Editable) -->
        <input type="text" name="username" value="<%= resident.getUsername() %>" placeholder="Username" required>

        <!-- Password Field (Optional) -->
        <input type="password" id="password" name="password" placeholder="New Password (Leave blank to keep current)" disabled>
        <p class="error-message" id="passwordError">Password must be at least 5 characters long and contain at least 1 number.</p>

        <input type="text" name="name" value="<%= resident.getName() %>" placeholder="Full Name" required>

        <!-- Gender Selection -->
        <select name="gender">
            <option value="MALE" <%= resident.getGender().equals("MALE") ? "selected" : "" %>>Male</option>
            <option value="FEMALE" <%= resident.getGender().equals("FEMALE") ? "selected" : "" %>>Female</option>
        </select>

        <!-- Phone Number with Country Code -->
        <div class="phone-container">
            <select id="countryCode" name="countryCode">
                <option value="+60" <%= resident.getPhone().startsWith("+60") ? "selected" : "" %>>🇲🇾 +60</option>
                <option value="+65" <%= resident.getPhone().startsWith("+65") ? "selected" : "" %>>🇸🇬 +65</option>
                <option value="+1" <%= resident.getPhone().startsWith("+1") ? "selected" : "" %>>🇺🇸 +1</option>
                <option value="+44" <%= resident.getPhone().startsWith("+44") ? "selected" : "" %>>🇬🇧 +44</option>
                <option value="+91" <%= resident.getPhone().startsWith("+91") ? "selected" : "" %>>🇮🇳 +91</option>
            </select>
            <input type="text" id="phone" name="phone" value="<%= resident.getPhone().substring(3) %>" placeholder="Phone Number" required onkeyup="validatePhone()">
        </div>
        <p class="error-message" id="phoneError">Enter a valid phone number.</p>

        <input type="text" id="ic" name="IC" value="<%= resident.getIC() %>" placeholder="Malaysian IC Number" required onkeyup="validateIC()">
        <p class="error-message" id="icError">IC number must be exactly 12 digits (e.g. 010203041234).</p>

        <input type="email" name="email" value="<%= resident.getEmail() %>" placeholder="Email" required>

        <button type="submit" class="submit-btn">Update Resident</button>
    </form>

    <div class="back-btn-container">
        <a href="${pageContext.request.contextPath}/admin/manageResident" class="back-btn">← Back to Manage Resident</a>
    </div>

</div>

<script>
    function validatePassword() {
        let password = document.getElementById("password").value;
        let passwordError = document.getElementById("passwordError");
        let regex = /^(?=.*\d).{5,}$/; // Must contain at least 1 number and be 5+ characters

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
        let regex = /^[0-9]{7,12}$/; // Phone number must be 7 to 12 digits long

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
        let regex = /^[0-9]{12}$/; // Must be exactly 12 digits

        if (!regex.test(ic)) {
            icError.style.display = "block";
            return false;
        } else {
            icError.style.display = "none";
            return true;
        }
    }

    function validateForm() {
        let password = document.getElementById("password").value.trim();

        if (password.length > 0) {
            if (!validatePassword()) {
                return false;
            }
        }

        return validatePhone() && validateIC();
    }

</script>

</body>
</html>

