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
%>

<html>
<head>
    <title>Edit Profile</title>
    <style>
        /* General Styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #e3f2fd;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        /* Form Container */
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

        /* Input Fields */
        input, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #90caf9;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
        }

        /* Greyed out input field */
        input[readonly] {
            background-color: #e0e0e0;
            cursor: not-allowed;
        }

        /* Submit & Back Button */
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

        /* Error Messages (Initially Hidden) */
        .error-message {
            color: red;
            font-size: 12px;
            display: none;
            text-align: left;
            margin-bottom: 5px;
        }

        /* Error Box */
        .error-box {
            background-color: #ffebee;
            color: #d32f2f;
            padding: 10px;
            border-radius: 6px;
            font-size: 14px;
            text-align: center;
            margin-bottom: 15px;
            display: none;
        }

        /* Country Code & Phone Input Layout */
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

    </style>
</head>
<body>

<div class="container">

    <c:if test="${not empty success}">
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                alert("${success}"); // ✅ Show success popup
                <c:remove var="success" scope="session" /> // ✅ Clear success message
            });
        </script>
    </c:if>

    <!-- Hide error box if no error -->
    <c:if test="${empty error}">
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let errorBox = document.querySelector(".error-box");
                if (errorBox) errorBox.style.display = "none";
            });
        </script>
    </c:if>


    <h2>Edit Profile</h2>

    <form action="${pageContext.request.contextPath}/EditProfileServlet" method="post" onsubmit="return validateForm()">
        <!-- Username (Greyed out & uneditable) -->
        <input type="text" name="username" value="<%= loggedUser.getUsername() %>" readonly>

        <!-- Password Field (Optional) -->
        <input type="password" id="password" name="password" placeholder="New Password (Leave blank to keep current)" onkeyup="validatePassword()">
        <p class="error-message" id="passwordError">Password must be at least 5 characters long and contain at least 1 number.</p>

        <input type="text" name="name" placeholder="Full Name" value="<%= loggedUser.getName() %>" required>

        <!-- Gender Selection -->
        <select name="gender">
            <option value="MALE" <%= loggedUser.getGender().equals("MALE") ? "selected" : "" %>>Male</option>
            <option value="FEMALE" <%= loggedUser.getGender().equals("FEMALE") ? "selected" : "" %>>Female</option>
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
            <input type="text" id="phone" name="phone" placeholder="Phone Number" value="<%= loggedUser.getPhone() %>" required onkeyup="validatePhone()">
        </div>
        <p class="error-message" id="phoneError">Enter a valid phone number.</p>

        <input type="text" id="ic" name="ic" placeholder="Malaysian IC Number" value="<%= loggedUser.getIC() %>" required onkeyup="validateIC()">
        <p class="error-message" id="icError">IC number must be exactly 12 digits.</p>

        <input type="email" name="email" placeholder="Email" value="<%= loggedUser.getEmail() %>" required>

        <button type="submit" class="button">Update Profile</button>
    </form>

    <%
        String dashboardUrl = "login.jsp?error=UnknownRole"; // Default fallback

        if (loggedUser != null) {
            switch (loggedUser.getRole().name()) {
                case "MANAGING_STAFF":
                    dashboardUrl = "admin/dashboardAdmin.jsp";
                    break;
                case "RESIDENT":
                    dashboardUrl = "resident/dashboardResident.jsp";
                    break;
                case "SECURITY_STAFF":
                    dashboardUrl = "security/dashboardSecurity.jsp";
                    break;
            }
        }
    %>

    <a href="<%= dashboardUrl %>" class="button back-btn">Back to Dashboard</a>



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

