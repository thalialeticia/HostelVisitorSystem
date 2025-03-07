<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 08/03/25
  Time: 12.49 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    String todayDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
%>

<html>
<head>
    <title>Request a Visitor</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #e3f2fd, #bbdefb);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .container {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0px 6px 15px rgba(0, 0, 0, 0.15);
            width: 450px;
            text-align: center;
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

        .form-group {
            text-align: left;
            margin-bottom: 12px;
            position: relative;
        }

        label {
            font-weight: bold;
            color: #1e88e5;
            margin-bottom: 5px;
            display: block;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #90caf9;
            border-radius: 6px;
            font-size: 14px;
            box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease-in-out;
        }

        input:focus, select:focus {
            border-color: #1e88e5;
            outline: none;
            box-shadow: 0 0 8px rgba(30, 136, 229, 0.5);
        }

        .input-with-icon {
            position: relative;
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

        .row {
            display: flex;
            gap: 10px;
        }

        .row .form-group {
            width: 50%;
        }

        .submit-btn {
            background-color: #1e88e5;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
            width: 100%;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .submit-btn:hover {
            background-color: #1565c0;
            transform: scale(1.03);
        }

        .back-btn {
            background-color: #757575;
            color: white;
            padding: 12px;
            border-radius: 6px;
            font-size: 16px;
            width: 100%;
            margin-top: 10px;
            display: inline-block;
            text-align: center;
            text-decoration: none;
        }

        .back-btn:hover {
            background-color: #616161;
            transform: scale(1.03);
        }

        .error-message {
            color: red;
            font-size: 12px;
            text-align: left;
            display: none;
            margin-bottom: 5px;
        }

        input[type="date"], input[type="time"] {
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Request a Visitor</h2>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
    <div class="error-box" style="color: red; background-color: #ffebee; padding: 10px; border-radius: 6px;">
        <p><%= error %></p>
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/resident/dashboardResident" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="action" value="createVisitRequest">

        <div class="form-group input-with-icon">
            <label>Visitor Name</label>
            <input type="text" name="visitorName" placeholder="John Doe" required>
        </div>

        <div class="form-group">
            <label>Visitor Phone Number</label>
            <div class="phone-container">
                <select id="countryCode">
                    <option value="+60">🇲🇾 +60</option>
                    <option value="+65">🇸🇬 +65</option>
                    <option value="+1">🇺🇸 +1</option>
                </select>
                <input type="text" id="phone" name="visitorPhone" placeholder="123456789" required onkeyup="validatePhone()">
            </div>
            <p class="error-message" id="phoneError">Enter a valid phone number.</p>
        </div>

        <div class="form-group">
            <label>Visitor IC Number</label>
            <input type="text" id="ic" name="visitorIc" placeholder="12-digit IC" required pattern="\d{12}" onkeyup="validateIC()">
            <p class="error-message" id="icError">IC number must be exactly 12 digits.</p>
        </div>

        <div class="form-group">
            <label>Visitor Email</label>
            <input type="email" name="visitorEmail" placeholder="example@email.com" required>
        </div>

        <div class="row">
            <div class="form-group">
                <label>Visit Date</label>
                <input type="date" name="visitDate" id="visitDate" min="<%= todayDate %>" required>
            </div>

            <div class="form-group">
                <label>Visit Time</label>
                <input type="time" name="visitTime" id="visitTime" required>
            </div>
        </div>

        <div class="row">
            <div class="form-group">
                <label>Visitor Address</label>
                <input type="text" name="visitorAddress" placeholder="123 Street, City" required>
            </div>

            <div class="form-group">
                <label>Purpose of Visit</label>
                <input type="text" name="purpose" placeholder="Meeting / Family / Delivery" required>
            </div>
        </div>

        <button type="submit" class="submit-btn">Submit Request</button>
    </form>

    <a href="${pageContext.request.contextPath}/resident/dashboardResident" class="back-btn">← Back to Dashboard</a>
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
