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
import java.io.IOException;

@WebServlet("/admin/editStaff")
public class EditStaffServlet extends HttpServlet {

    @Inject
    private UserFacade userFacade;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            response.sendRedirect("manageStaff.jsp?error=StaffNotFound");
            return;
        }

        User staff = userFacade.find(id);
        if (staff == null) {
            response.sendRedirect("manageStaff.jsp?error=StaffNotFound");
            return;
        }

        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/admin/editStaff.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        boolean isSuperAdmin = "on".equals(request.getParameter("superAdmin"));

        User staff = userFacade.find(id);
        if (staff == null) {
            response.sendRedirect("manageStaff.jsp?error=StaffNotFound");
            return;
        }

        // ✅ Check if fields are unique before updating
        if (!userFacade.isFieldUnique("email", email, id)) {
            request.setAttribute("error", "Email is already in use.");
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/admin/editStaff.jsp").forward(request, response);
            return;
        }

        if (!userFacade.isFieldUnique("phone", phone, id)) {
            request.setAttribute("error", "Phone number is already in use.");
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/admin/editStaff.jsp").forward(request, response);
            return;
        }

        // ✅ Update staff details
        staff.setName(name);
        staff.setGender(gender);
        staff.setPhone(phone);
        staff.setEmail(email);

        // ✅ Only update password if a new one is provided
        if (password != null && !password.trim().isEmpty()) {
            staff.setPassword(password);
        }

        // ✅ Set Super Admin status (only for Managing Staff)
        if (staff instanceof ManagingStaff) {
            ((ManagingStaff) staff).setSuperAdmin(isSuperAdmin);
        }

        userFacade.update(staff);
        response.sendRedirect("manageStaff.jsp?success=StaffUpdated");
    }
}
