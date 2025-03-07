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
        }

        .container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.2);
            width: 400px;
            text-align: center;
            animation: fadeIn 1s ease-out forwards;
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

        .form-group {
            position: relative;
            text-align: left;
        }

        input, select {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid #90caf9;
            border-radius: 6px;
            font-size: 14px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.05);
        }

        input:focus, select:focus {
            border-color: #1e88e5;
            outline: none;
            box-shadow: 0 0 8px rgba(30, 136, 229, 0.5);
        }

        .icon {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #1e88e5;
        }

        .input-with-icon input {
            padding-left: 35px;
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

        .submit-btn {
            background-color: #1e88e5;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 15px;
            width: 100%;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .submit-btn:hover { background-color: #1565c0; transform: scale(1.03); }

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

        .back-btn:hover { background-color: #616161; transform: scale(1.03); }

        .error-message {
            color: red;
            font-size: 12px;
            text-align: left;
            display: none;
            margin-bottom: 5px;
        }

        /* Date & Time Picker */
        input[type="date"], input[type="time"] {
            position: relative;
            background: white;
            cursor: pointer;
        }

        /* Custom styling for disabled buttons */
        .disabled-btn {
            background-color: #d6d6d6 !important;
            cursor: not-allowed;
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
            <i class="fa-solid fa-user icon"></i>
            <input type="text" name="visitorName" placeholder="Visitor Name" required>
        </div>

        <!-- Phone Number Input with Country Code -->
        <div class="phone-container">
            <select id="countryCode">
                <option value="+60">🇲🇾 +60</option>
                <option value="+65">🇸🇬 +65</option>
                <option value="+1">🇺🇸 +1</option>
                <option value="+44">🇬🇧 +44</option>
                <option value="+91">🇮🇳 +91</option>
            </select>
            <input type="text" id="phone" name="visitorPhone" placeholder="Phone Number" required onkeyup="validatePhone()">
        </div>
        <p class="error-message" id="phoneError">Enter a valid phone number.</p>

        <input type="text" id="ic" name="visitorIc" placeholder="Visitor IC Number (12 digits)" required pattern="\d{12}" onkeyup="validateIC()">
        <p class="error-message" id="icError">IC number must be exactly 12 digits.</p>

        <input type="email" name="visitorEmail" placeholder="Visitor Email" required>
        <input type="text" name="visitorAddress" placeholder="Visitor Address" required>

        <label for="visitDate">Visit Date</label>
        <input type="date" name="visitDate" id="visitDate" min="<%= todayDate %>" required>

        <label for="visitTime">Visit Time</label>
        <input type="time" name="visitTime" id="visitTime" required>

        <input type="text" name="purpose" placeholder="Purpose of Visit" required>

        <button type="submit" class="submit-btn">Submit Request</button>
    </form>

    <a href="${pageContext.request.contextPath}/resident/dashboardResident" class="back-btn">← Back to Dashboard</a>
</div>

<script>
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
        return validatePhone() && validateIC();
    }
</script>

</body>
</html>

