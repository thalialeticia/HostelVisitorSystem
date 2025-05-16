<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 14/03/25
  Time: 1.03 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>

<%
    // Retrieve Reports
    Map<String, Object> genderReport = (Map<String, Object>) request.getAttribute("genderReport");
    Map<String, Object> purposeReport = (Map<String, Object>) request.getAttribute("purposeReport");
    Map<String, Object> ageReport = (Map<String, Object>) request.getAttribute("ageReport");
    Map<String, Object> checkInTrends = (Map<String, Object>) request.getAttribute("checkInTrends");
    Map<String, Object> locationReport = (Map<String, Object>) request.getAttribute("locationReport");
    Map<String, Object> visitDurationReport = (Map<String, Object>) request.getAttribute("visitDurationReport");
%>

<html>
<head>
    <title>Visitor Reports</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> <!-- Chart.js Library -->

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #e3f2fd, #bbdefb);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            flex-direction: column;
        }

        .container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.2);
            width: 90%;
            max-width: 1100px;
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
            font-size: 26px;
            margin-bottom: 20px;
            text-align: center;
        }

        .report-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .report-card {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .report-card h3 {
            color: #1565c0;
            font-size: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .report-card h3 i {
            margin-right: 10px;
            font-size: 22px;
            color: #0d47a1;
        }

        canvas {
            width: 100% !important;
            height: auto !important;
        }

        .back-button {
            background: #1e88e5;
            color: white;
            padding: 12px 15px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 25px;
            transition: background 0.3s ease, transform 0.2s ease;
            width: fit-content;
            margin-left: auto;
            margin-right: auto;
        }

        .back-button:hover {
            background: #1565c0;
            transform: scale(1.05);
        }

        .back-button i {
            margin-right: 8px;
            font-size: 18px;
        }

    </style>
</head>
<body>

<div class="container">
    <h2><i class="fas fa-chart-bar"></i> Visitor Reports</h2>

    <div class="report-grid">
        <!-- Gender Distribution (Pie Chart) -->
        <div class="report-card">
            <h3><i class="fas fa-venus-mars"></i> Gender Distribution</h3>
            <canvas id="genderChart"></canvas>
        </div>

        <!-- Check-In Trends (Bar Chart) -->
        <div class="report-card">
            <h3><i class="fas fa-calendar-check"></i> Check-In Trends</h3>
            <canvas id="checkInChart"></canvas>
        </div>

        <!-- Visitor Age Distribution (Bar Chart) -->
        <div class="report-card">
            <h3><i class="fas fa-user-clock"></i> Visitor Age Distribution</h3>
            <canvas id="ageChart"></canvas>
        </div>

        <!-- Visit Purpose (Bar Chart) -->
        <div class="report-card">
            <h3><i class="fas fa-briefcase"></i> Visit Purposes</h3>
            <canvas id="purposeChart"></canvas>
        </div>

        <!-- Visitor Locations (Bar Chart) -->
        <div class="report-card">
            <h3><i class="fas fa-map-marker-alt"></i> Visitor Locations</h3>
            <canvas id="locationChart"></canvas>
        </div>

    <!-- Visit Duration (New Bar Chart) -->
    <div class="report-card">
        <h3><i class="fas fa-hourglass-half"></i> Visit Duration</h3>
        <canvas id="visitDurationChart"></canvas>
    </div>
</div>

    <!-- Back Button -->
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-button">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
</div>

<script>
    // Gender Chart Data
    new Chart(document.getElementById('genderChart'), {
        type: 'pie',
        data: {
            labels: [<% for (Map.Entry<?, ?> entry : genderReport.entrySet()) { %>"<%= entry.getKey().toString() %>", <% } %>],
            datasets: [{
                label: 'Visitors by Gender',
                data: [<% for (Map.Entry<?, ?> entry : genderReport.entrySet()) { %><%= entry.getValue() %>, <% } %>],
                backgroundColor: ['#42A5F5', '#FF6384']
            }]
        }
    });

    // Check-In Trends Data
    new Chart(document.getElementById('checkInChart'), {
        type: 'bar',
        data: {
            labels: [<% for (Map.Entry<?, ?> entry : checkInTrends.entrySet()) { %>"Hour <%= entry.getKey().toString() %>", <% } %>],
            datasets: [{
                label: 'Number of Check-Ins',
                data: [<% for (Map.Entry<?, ?> entry : checkInTrends.entrySet()) { %><%= entry.getValue() %>, <% } %>],
                backgroundColor: '#42A5F5'
            }]
        }
    });

    // Age Distribution Data
    new Chart(document.getElementById('ageChart'), {
        type: 'bar',
        data: {
            labels: [<% for (Map.Entry<?, ?> entry : ageReport.entrySet()) { %>"<%= entry.getKey().toString() %>", <% } %>],
            datasets: [{
                label: 'Visitors by Age',
                data: [<% for (Map.Entry<?, ?> entry : ageReport.entrySet()) { %><%= entry.getValue() %>, <% } %>],
                backgroundColor: '#66BB6A'
            }]
        }
    });

    // Visit Purpose Chart
    new Chart(document.getElementById('purposeChart'), {
        type: 'bar',
        data: {
            labels: [<% for (Map.Entry<?, ?> entry : purposeReport.entrySet()) { %>"<%= entry.getKey().toString() %>", <% } %>],
            datasets: [{
                label: 'Number of Visits',
                data: [<% for (Map.Entry<?, ?> entry : purposeReport.entrySet()) { %><%= entry.getValue() %>, <% } %>],
                backgroundColor: '#FFA726'
            }]
        }
    });

    // Visitor Location Chart
    new Chart(document.getElementById('locationChart'), {
        type: 'bar',
        data: {
            labels: [<% for (Map.Entry<?, ?> entry : locationReport.entrySet()) { %>"<%= entry.getKey().toString() %>", <% } %>],
            datasets: [{
                label: 'Number of Visitors',
                data: [<% for (Map.Entry<?, ?> entry : locationReport.entrySet()) { %><%= entry.getValue() %>, <% } %>],
                backgroundColor: '#AB47BC'
            }]
        }
    });

    // Visit Duration Chart
    new Chart(document.getElementById('visitDurationChart'), {
        type: 'bar',
        data: {
            labels: [<% for (Map.Entry<?, ?> entry : visitDurationReport.entrySet()) { %>"<%= entry.getKey().toString() %>", <% } %>],
            datasets: [{
                label: 'Number of Visitors',
                data: [<% for (Map.Entry<?, ?> entry : visitDurationReport.entrySet()) { %><%= entry.getValue() %>, <% } %>],
                backgroundColor: '#FFB300'
            }]
        }
    });

</script>

</body>
</html>