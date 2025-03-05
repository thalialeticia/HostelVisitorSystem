<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 4.41 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.User" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession sessionObj = request.getSession(false);
    User loggedUser = (sessionObj != null) ? (User) sessionObj.getAttribute("loggedUser") : null;

    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Extract Country Code and Phone Number
    String fullPhone = loggedUser.getPhone();
    String countryCode = "+60"; // Default country code
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
    } else {
        if (fullPhone.startsWith("+60")) {
            phoneNumber = fullPhone.substring(3);
        }
    }
%>

<html>
<head>
    <title>Edit Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #e3f2fd;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
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

        h2 { color: #1565c0; margin-bottom: 20px; }

        input, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #90caf9;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
        }

        input[readonly] {
            background-color: #e0e0e0;
            cursor: not-allowed;
        }

        .button {
            background-color: #1e88e5;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            margin-top: 10px;
            transition: background 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .button:hover { background-color: #1565c0; }

        .back-btn {
            background-color: #757575;
        }

        .back-btn:hover {
            background-color: #616161;
        }

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

        .error-message {
            color: red;
            font-size: 12px;
            display: none; /* Hide error messages initially */
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Edit Profile</h2>

    <form action="${pageContext.request.contextPath}/EditProfileServlet" method="post" onsubmit="return validateForm()">
        <input type="text" name="username" value="<%= loggedUser.getUsername() %>" readonly>

        <input type="password" id="password" name="password" placeholder="New Password (Leave blank to keep current)" onkeyup="validatePassword()">
        <p class="error-message" id="passwordError">Password must be at least 5 characters long and contain at least 1 number.</p>

        <input type="text" name="name" placeholder="Full Name" value="<%= loggedUser.getName() %>" required>

        <select name="gender">
            <option value="MALE" <%= loggedUser.getGender().equals("MALE") ? "selected" : "" %>>Male</option>
            <option value="FEMALE" <%= loggedUser.getGender().equals("FEMALE") ? "selected" : "" %>>Female</option>
        </select>

        <div class="phone-container">
            <select id="countryCode" name="countryCode">
                <option value="+60" <%= countryCode.equals("+60") ? "selected" : "" %>>🇲🇾 +60</option>
                <option value="+65" <%= countryCode.equals("+65") ? "selected" : "" %>>🇸🇬 +65</option>
                <option value="+1" <%= countryCode.equals("+1") ? "selected" : "" %>>🇺🇸 +1</option>
                <option value="+44" <%= countryCode.equals("+44") ? "selected" : "" %>>🇬🇧 +44</option>
                <option value="+91" <%= countryCode.equals("+91") ? "selected" : "" %>>🇮🇳 +91</option>
            </select>
            <input type="text" id="phone" name="phone" placeholder="Phone Number" value="<%= phoneNumber %>" required onkeyup="validatePhone()">
        </div>
        <p class="error-message" id="phoneError">Enter a valid phone number.</p>

        <input type="text" id="ic" name="ic" placeholder="Malaysian IC Number" value="<%= loggedUser.getIC() %>" required onkeyup="validateIC()">
        <p class="error-message" id="icError">IC number must be exactly 12 digits.</p>

        <input type="email" name="email" placeholder="Email" value="<%= loggedUser.getEmail() %>" required>

        <button type="submit" class="button">Update Profile</button>
    </form>

    <a href="${pageContext.request.contextPath}/admin/dashboard" class="button back-btn">Back to Dashboard</a>
</div>

<script>
    function validatePassword() {
        let password = document.getElementById("password").value;
        let passwordError = document.getElementById("passwordError");
        let regex = /^(?=.*\d).{5,}$/;

        if (password.length > 0 && !regex.test(password)) {
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
</script>

</body>
</html>
