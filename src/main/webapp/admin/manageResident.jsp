<%--
  Created by IntelliJ IDEA.
  User: leticiathalia
  Date: 05/03/25
  Time: 11.27 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.hostelvisitorsystem.model.User" %>
<%@ page import="com.example.hostelvisitorsystem.ejb.UserFacade" %>
<%@ page import="jakarta.inject.Inject" %>
<%@ page import="java.util.List" %>

<%
    HttpSession sessionObj = request.getSession(false);
    User loggedUser = (sessionObj != null) ? (User) sessionObj.getAttribute("loggedUser") : null;

    if (loggedUser == null || !loggedUser.getRole().toString().equals("MANAGING_STAFF")) {
        response.sendRedirect("../login.jsp");
        return;
    }

//    @Inject
//    UserFacade userFacade;
//    List<User> residentList = userFacade.getAllResidents();
%>

<html>
<head>
    <title>Manage Resident Accounts</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #e3f2fd, #bbdefb);
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
            padding: 20px;
        }

        .container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.2);
            width: 90%;
            max-width: 800px;
        }

        h2 {
            color: #0d47a1;
            text-align: center;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
            border: 1px solid #ddd;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        .button {
            display: inline-block;
            padding: 8px 12px;
            margin: 5px;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            background-color: #1e88e5;
        }

        .delete-btn {
            background-color: #e53935;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Manage Resident Accounts</h2>

    <input type="text" id="searchInput" placeholder="Search residents..." onkeyup="searchResidents()">

    <table>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Actions</th>
        </tr>
<%--        <% for (User resident : residentList) { %>--%>
<%--        <tr>--%>
<%--            <td><%= resident.getName() %></td>--%>
<%--            <td><%= resident.getEmail() %></td>--%>
<%--            <td><%= resident.getPhone() %></td>--%>
<%--            <td>--%>
<%--                <a href="editResident.jsp?id=<%= resident.getId() %>" class="button">Edit</a>--%>
<%--                <a href="deleteResidentServlet?id=<%= resident.getId() %>" class="button delete-btn">Delete</a>--%>
<%--            </td>--%>
<%--        </tr>--%>
<%--        <% } %>--%>
    </table>

    <a href="addResident.jsp" class="button">Add New Resident</a>
</div>

<script>
    function searchResidents() {
        let input = document.getElementById("searchInput").value.toLowerCase();
        let rows = document.querySelectorAll("table tr:not(:first-child)");

        rows.forEach(row => {
            let name = row.cells[0].innerText.toLowerCase();
            let email = row.cells[1].innerText.toLowerCase();
            row.style.display = (name.includes(input) || email.includes(input)) ? "" : "none";
        });
    }
</script>

</body>
</html>

