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

        // Hash password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        // Create resident object
        Resident newResident = new Resident();
        newResident.setUsername(username);
        newResident.setPassword(hashedPassword);
        newResident.setName(name);
        newResident.setGender(gender);
        newResident.setPhone(phone);
        newResident.setIC(IC);
        newResident.setEmail(email);
        newResident.setRole(User.Role.RESIDENT);

        // Save to database
        userFacade.create(newResident);

        request.setAttribute("success", "Registration successful!");
        request.getRequestDispatcher("resident/register.jsp").forward(request, response);
    }
}
