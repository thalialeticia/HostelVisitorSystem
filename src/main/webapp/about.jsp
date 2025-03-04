<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 3.20 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>About Us - Hostel Visitor System</title>
    <style>
        /* General Styling */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #e3f2fd, #bbdefb);
            display: flex;
            justify-content: center;
            align-items: flex-start;
            height: auto;
            min-height: 100vh;
            margin: 0;
            padding: 40px 20px;
            overflow-y: auto;
        }

        /* Container */
        .about-container {
            max-width: 900px;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.2);
            text-align: center;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeIn 1s ease-out forwards;
        }

        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        /* Section Styling */
        h2 {
            color: #0d47a1;
            font-size: 24px;
            margin-top: 30px;
            text-align: left;
            border-bottom: 3px solid #90caf9;
            padding-bottom: 5px;
        }

        p {
            font-size: 16px;
            color: #333;
            line-height: 1.7;
            text-align: left;
        }

        /* List Styling */
        .animated-list {
            list-style: none;
            padding: 0;
            text-align: left;
        }

        .animated-list li {
            opacity: 0;
            transform: translateY(10px);
            animation: fadeIn 0.8s ease-out forwards;
            animation-delay: 0.3s;
            font-size: 16px;
            margin: 10px 0;
            color: #333;
            padding-left: 0;
            position: relative;
        }

        /* Footer */
        .footer {
            margin-top: 30px;
            font-size: 14px;
            color: #666;
            text-align: center;
        }

        /* Back to Home Button */
        .back-home {
            display: block;
            margin-top: 15px;
            font-size: 14px;
            text-decoration: none;
            color: #1e88e5;
            font-weight: bold;
            transition: color 0.3s ease;
            text-align: center;
        }

        .back-home:hover {
            color: #0d47a1;
        }
    </style>
</head>
<body>

<!-- Main Content -->
<div class="about-container">
    <h2>About the Hostel Visitor System</h2>
    <p>
        The <b>Hostel Visitor Verification System</b> enhances <b>visitor tracking, security, and efficiency</b>
        within hostel environments. The system provides a <b>seamless, user-friendly platform</b> for residents,
        security personnel, and administrators to <b>manage visitor requests, verify identities, and maintain accurate records</b>.
    </p>

    <h2>Key Features</h2>
    <ul class="animated-list">
        <li><b>Secure visitor request approval system.</b></li>
        <li><b>Automated visitor verification via unique codes.</b></li>
        <li><b>Digital record tracking for visitor history.</b></li>
        <li><b>Admin dashboard for comprehensive reporting.</b></li>
        <li><b>Resident profile management with visitor tracking.</b></li>
    </ul>

    <h2>Why This System is Important</h2>
    <p>The <b>current visitor tracking process</b> is <b>manual, inefficient, and lacks security measures</b>.
        This system introduces:</p>
    <ul class="animated-list">
        <li><b>Automated Visitor Approvals</b> – Reduces administrative workload.</li>
        <li><b>Enhanced Security</b> – Visitors must verify identity with unique codes.</li>
        <li><b>Accurate Digital Records</b> – Eliminates errors in manual logs.</li>
    </ul>

    <h2>Project Scope & Deliverables</h2>
    <ul class="animated-list">
        <li>📌 <b>System Design Document</b> – Architecture, UML diagrams, and ER models.</li>
        <li>📌 <b>Fully Functional Web Application</b> – JSP & Servlet-based system.</li>
        <li>📌 <b>User Manual</b> – Documentation on system functionalities.</li>
        <li>📌 <b>Reporting Module</b> – Includes at least <b>5 key analytical reports</b>.</li>
    </ul>

    <h2>Future Enhancements</h2>
    <p>
        Potential improvements include <b>AI-based visitor behavior analytics</b> and <b>real-time security alerts</b>
        for enhanced security monitoring.
    </p>

    <!-- Footer -->
    <p class="footer">© 2025 Hostel Management. All rights reserved.</p>

    <!-- Back to Home -->
    <a href="index.jsp" class="back-home">← Back to Home</a>
</div>

</body>
</html>
