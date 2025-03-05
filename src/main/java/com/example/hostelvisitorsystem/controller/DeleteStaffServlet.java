package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.UserFacade;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/deleteStaff")
public class DeleteStaffServlet extends HttpServlet {

    @Inject
    private UserFacade userFacade;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");

        if (id != null && !id.isEmpty()) {
            userFacade.delete(id);
            request.getSession().setAttribute("success", "Staff member deleted successfully.");
        } else {
            request.getSession().setAttribute("error", "Invalid staff ID.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manageStaff");
    }
}

