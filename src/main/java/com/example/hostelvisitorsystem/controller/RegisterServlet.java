package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.UserFacade;
import com.example.hostelvisitorsystem.model.Resident;
import com.example.hostelvisitorsystem.model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Inject
    private UserFacade userFacade;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String IC = request.getParameter("IC");
        String email = request.getParameter("email");

        // ✅ Check if username, email, phone, or IC already exists
        if (userFacade.existsByUsername(username)) {
            request.setAttribute("error", "Username already taken.");
            request.getRequestDispatcher("resident/register.jsp").forward(request, response);
            return;
        }

        if (userFacade.existsByEmail(email)) {
            request.setAttribute("error", "Email already registered.");
            request.getRequestDispatcher("resident/register.jsp").forward(request, response);
            return;
        }

        if (userFacade.existsByPhone(phone)) {
            request.setAttribute("error", "Phone number already in use.");
            request.getRequestDispatcher("resident/register.jsp").forward(request, response);
            return;
        }

        if (userFacade.existsByIC(IC)) {
            request.setAttribute("error", "IC number already registered.");
            request.getRequestDispatcher("resident/register.jsp").forward(request, response);
            return;
        }

        // ✅ Create resident object
        Resident newResident = new Resident();
        newResident.setUsername(username);
        newResident.setPassword(password);
        newResident.setName(name);
        newResident.setGender(gender);
        newResident.setPhone(phone);
        newResident.setIC(IC);
        newResident.setEmail(email);
        newResident.setRole(User.Role.RESIDENT);

        // ✅ Save to database
        userFacade.create(newResident);

        // ✅ Redirect to login page upon success
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
