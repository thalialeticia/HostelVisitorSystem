package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.UserFacade;
import com.example.hostelvisitorsystem.model.User;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/manageStaff")
public class ManageStaffServlet extends HttpServlet {
    @Inject
    private UserFacade userFacade;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> staffList = userFacade.getAllStaff();
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("/admin/manageStaff.jsp").forward(request, response);
    }

}
