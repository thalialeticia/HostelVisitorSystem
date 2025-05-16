<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 04/03/25
  Time: 11.00 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Resident Registration</title>
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

        /* Submit Button */
        .submit-btn {
            background-color: #1e88e5;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
            width: 100%;
            transition: background 0.3s ease;
        }

        .submit-btn:hover { background-color: #1565c0; }

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
            display: block;
        }

        /* Navigation Links */
        .nav-links {
            margin-top: 15px;
            font-size: 14px;
        }

        .nav-links a {
            color: #1565c0;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .nav-links a:hover { color: #0d47a1; }
    </style>
</head>
<body>

<div class="container">
    <h2>Resident Registration</h2>

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

    <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" onsubmit="return validateForm()">
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
        <div style="display: flex; gap: 5px;">
            <select id="countryCode">
                <option value="+60">🇲🇾 +60 (Malaysia)</option>
                <option value="+65">🇸🇬 +65 (Singapore)</option>
                <option value="+1">🇺🇸 +1 (USA)</option>
                <option value="+44">🇬🇧 +44 (UK)</option>
                <option value="+91">🇮🇳 +91 (India)</option>
            </select>
            <input type="text" id="phone" name="phone" placeholder="Phone Number" required onkeyup="validatePhone()">
        </div>
        <p class="error-message" id="phoneError">Enter a valid phone number.</p>

        <input type="text" id="ic" name="IC" placeholder="Malaysian IC Number" required onkeyup="validateIC()">
        <p class="error-message" id="icError">IC number must be exactly 12 digits (e.g. 010203041234).</p>

        <input type="email" name="email" placeholder="Email" required>

        <button type="submit" class="submit-btn">Register</button>
    </form>

    <!-- Navigation Links -->
    <p class="nav-links">
        Already have an account? <a href="../login.jsp">Login here</a>.<br>
        <a href="../index.jsp">← Back to Home</a>
    </p>
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
        return validatePassword() && validatePhone() && validateIC();
    }
</script>

</body>
</html>
