package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.UserFacade;
import com.example.hostelvisitorsystem.model.User;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/AddStaffServlet")
public class AddStaffServlet extends HttpServlet {

    @Inject
    private UserFacade userFacade;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password =request.getParameter("password");

//        User newStaff = new User(UUID.randomUUID().toString(), "SECURITY_STAFF", name, phone, email, password);
//        userFacade.create(newStaff);

        response.sendRedirect("manageStaff.jsp");
    }
}
