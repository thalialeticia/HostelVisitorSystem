package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.UserFacade;
import com.example.hostelvisitorsystem.model.ManagingStaff;
import com.example.hostelvisitorsystem.model.User;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Inject
    private UserFacade userFacade;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Retrieve user from database
        User user = userFacade.findByUsername(username);

        if (user != null && user.checkPassword(password)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loggedUser", user);

            // ✅ Add isSuperAdmin attribute for Managing Staff users
            if (user instanceof ManagingStaff) {
                ManagingStaff staff = (ManagingStaff) user;
                session.setAttribute("isSuperAdmin", staff.isSuperAdmin());
            } else {
                session.setAttribute("isSuperAdmin", false);
            }

            // Redirect based on user role
            switch (user.getRole()) {
                case MANAGING_STAFF:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
                case RESIDENT:
                    response.sendRedirect("resident/dashboardResident.jsp");
                    break;
                case SECURITY_STAFF:
                    response.sendRedirect("security/dashboardSecurity.jsp");
                    break;
                default:
                    response.sendRedirect("login.jsp?error=UnknownRole");
            }
        } else {
            // ❌ Invalid credentials
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}

