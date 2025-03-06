package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.UserFacade;
import com.example.hostelvisitorsystem.model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {

    @Inject
    private UserFacade userFacade;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User loggedUser = (User) session.getAttribute("loggedUser");

        String name = request.getParameter("name");
        String password = request.getParameter("password");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String ic = request.getParameter("ic");
        String email = request.getParameter("email");

        // Validate uniqueness for phone, IC, and email
        if (!userFacade.isFieldUnique("phone", phone, loggedUser.getId())) {
            request.setAttribute("error", "Phone number is already in use.");
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
            return;
        }

        if (!userFacade.isFieldUnique("IC", ic, loggedUser.getId())) {
            request.setAttribute("error", "IC number is already registered.");
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
            return;
        }

        if (!userFacade.isFieldUnique("email", email, loggedUser.getId())) {
            request.setAttribute("error", "Email is already registered.");
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
            return;
        }

        // Update user details
        loggedUser.setName(name);
        loggedUser.setGender(gender);
        loggedUser.setPhone(phone);
        loggedUser.setIC(ic);
        loggedUser.setEmail(email);

        // If password is provided, hash and update it
        if (password != null && !password.isEmpty()) {
            loggedUser.setPassword(BCrypt.hashpw(password, BCrypt.gensalt(12)));
        }

        userFacade.update(loggedUser);
        session.setAttribute("loggedUser", loggedUser); // Update session data

        session.setAttribute("success", "Profile updated successfully!");

        switch (loggedUser.getRole()) {
            case MANAGING_STAFF:
                response.sendRedirect("admin/dashboardAdmin.jsp");
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
    }
}