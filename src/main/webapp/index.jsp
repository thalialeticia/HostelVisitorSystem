<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Hostel Visitor Verification System</title>
    <style>
        /* General Styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #e3f2fd; /* Light Blue Background */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        /* Animated Title */
        .title-container {
            font-size: 50px;
            font-weight: bold;
            color: #1565c0;
            position: absolute;
            top: 40%;
            display: flex;
            justify-content: center;
            gap: 5px;
            opacity: 1;
            transition: opacity 1s ease-out, transform 1s ease-out;
        }

        .title-letter {
            opacity: 0;
            transform: translateY(30px);
            font-size: 60px;
            animation: letterAppear 0.5s ease forwards;
        }

        @keyframes letterAppear {
            0% {
                opacity: 0;
                transform: translateY(30px) scale(1.5);
            }
            100% {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Main Content */
        .container {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: center;
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 1s ease-out, transform 1s ease-out;
        }

        /* Navigation Menu */
        .nav-menu {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 20px;
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 1s ease-out, transform 1s ease-out;
        }

        .nav-menu a {
            text-decoration: none;
            background-color: #1e88e5;
            color: white;
            padding: 12px;
            border-radius: 6px;
            font-size: 16px;
            transition: background 0.3s ease, transform 0.2s ease;
            display: block;
            position: relative;
            overflow: hidden;
        }

        .nav-menu a:hover {
            background-color: #1565c0;
            transform: scale(1.05);
        }

        /* Hover Effect */
        .nav-menu a::before {
            content: "";
            position: absolute;
            left: 0;
            width: 100%;
            height: 3px;
            bottom: 0;
            background: white;
            transform: scaleX(0);
            transition: transform 0.3s ease-in-out;
        }

        .nav-menu a:hover::before {
            transform: scaleX(1);
        }

        /* Footer */
        .footer {
            margin-top: 15px;
            font-size: 12px;
            color: #666;
            opacity: 0;
            transition: opacity 1s ease-out 1s;
        }
    </style>
</head>
<body>

<!-- Floating Letter-by-Letter Animation -->
<div class="title-container" id="floatingTitle">
    <span class="title-letter" style="animation-delay: 0s;">H</span>
    <span class="title-letter" style="animation-delay: 0.1s;">o</span>
    <span class="title-letter" style="animation-delay: 0.2s;">s</span>
    <span class="title-letter" style="animation-delay: 0.3s;">t</span>
    <span class="title-letter" style="animation-delay: 0.4s;">e</span>
    <span class="title-letter" style="animation-delay: 0.5s;">l</span>
    &nbsp;
    <span class="title-letter" style="animation-delay: 0.6s;">V</span>
    <span class="title-letter" style="animation-delay: 0.7s;">i</span>
    <span class="title-letter" style="animation-delay: 0.8s;">s</span>
    <span class="title-letter" style="animation-delay: 0.9s;">i</span>
    <span class="title-letter" style="animation-delay: 1s;">t</span>
    <span class="title-letter" style="animation-delay: 1.1s;">o</span>
    <span class="title-letter" style="animation-delay: 1.2s;">r</span>
</div>

<!-- Main Content -->
<div class="container" id="mainContent">
    <h1>Welcome to the Hostel Visitor Verification System</h1>
    <h2>Navigation</h2>

    <div class="nav-menu" id="navMenu">
        <a href="resident/register.jsp">Resident Registration</a>
        <a href="login.jsp">Login</a>
        <a href="about.jsp">About Us</a>
    </div>

    <p class="footer" id="footer">© 2025 Hostel Management. All rights reserved.</p>
</div>

<script>
    // Delay animations
    window.onload = function() {
        setTimeout(() => {
            document.getElementById("floatingTitle").style.transition = "transform 1s ease, opacity 1s ease";
            document.getElementById("floatingTitle").style.transform = "scale(0.8) translateY(-20px)";
        }, 1500);

        setTimeout(() => {
            document.getElementById("floatingTitle").style.opacity = "0";
            setTimeout(() => {
                document.getElementById("floatingTitle").style.display = "none";
                document.getElementById("mainContent").style.opacity = "1";
                document.getElementById("mainContent").style.transform = "translateY(0)";
                document.getElementById("navMenu").style.opacity = "1";
                document.getElementById("navMenu").style.transform = "translateY(0)";
                document.getElementById("footer").style.opacity = "1";
            }, 500);
        }, 2500);
    };
</script>

</body>
</html>
