<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Hostel Visitor System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        /* General Styling */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to bottom, #e3f2fd, #bbdefb);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        /* Title Animation */
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
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 450px;
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 1s ease-out, transform 1s ease-out;
        }

        h1 {
            font-size: 22px;
            font-weight: bold;
            color: #0d47a1;
            margin-bottom: 10px;
        }

        h2 {
            font-size: 18px;
            color: #1565c0;
            font-weight: 600;
            margin-bottom: 20px;
        }

        /* Navigation Menu */
        .nav-menu {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-top: 20px;
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 1s ease-out, transform 1s ease-out;
        }

        .nav-menu a {
            text-decoration: none;
            background: #1e88e5;
            color: white;
            padding: 12px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            transition: background 0.3s ease, transform 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            position: relative;
            overflow: hidden;
            box-shadow: 0px 3px 6px rgba(0, 0, 0, 0.1);
        }

        .nav-menu a:hover {
            background: #1565c0;
            transform: scale(1.05);
        }

        /* Footer */
        .footer {
            margin-top: 20px;
            font-size: 12px;
            color: #666;
            opacity: 0;
            transition: opacity 1s ease-out 1s;
        }

        /* Icon Styling */
        .nav-menu a i {
            font-size: 18px;
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
    <h1>Welcome to the Hostel Visitor System</h1>
    <h2>Choose Your Action</h2>

    <div class="nav-menu" id="navMenu">
        <a href="resident/register.jsp"><i class="fa-solid fa-user-plus"></i> Register as a Resident</a>
        <a href="login.jsp"><i class="fa-solid fa-sign-in-alt"></i> Login to Your Account</a>
        <a href="about.jsp"><i class="fa-solid fa-circle-info"></i> Learn More About Us</a>
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
