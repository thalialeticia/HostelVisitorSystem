package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.UserFacade;
import com.example.hostelvisitorsystem.model.ManagingStaff;
import com.example.hostelvisitorsystem.model.SecurityStaff;
import com.example.hostelvisitorsystem.model.User;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/manageStaff")
public class ManageStaffServlet extends HttpServlet {
    @Inject
    private UserFacade userFacade;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> staffList = userFacade.getAllStaff();
        request.setAttribute("staffList", staffList);

        // ✅ Ensure `isSuperAdmin` is checked correctly
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        boolean isSuperAdmin = false;
        if (currentUser instanceof ManagingStaff) {
            isSuperAdmin = ((ManagingStaff) currentUser).isSuperAdmin();
        }

        request.setAttribute("isSuperAdmin", isSuperAdmin);
        request.getRequestDispatcher("/admin/manageStaff.jsp").forward(request, response);
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("loggedUser"); // ✅ FIXED: Use `loggedUser`

        if (currentUser == null || !(currentUser instanceof ManagingStaff)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // ✅ FIXED: Ensure `isSuperAdmin()` can be accessed
        boolean isSuperAdmin = ((ManagingStaff) currentUser).isSuperAdmin();

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String countryCode = request.getParameter("countryCode");
        String phone = request.getParameter("phone");
        String fullPhone = countryCode + phone;
        String IC = request.getParameter("IC");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        boolean newSuperAdmin = "on".equals(request.getParameter("superAdmin"));

        // ✅ FIXED: Only a Super Admin can create Managing Staff
        if (!isSuperAdmin && role.equals("MANAGING_STAFF")) {
            request.setAttribute("error", "Only a super admin can create managing staff.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        // ✅ Unique field validation
        if (userFacade.existsByUsername(username)) {
            request.setAttribute("error", "Username already taken.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        if (userFacade.existsByEmail(email)) {
            request.setAttribute("error", "Email already registered.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        if (userFacade.existsByPhone(fullPhone)) {
            request.setAttribute("error", "Phone number already in use.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        if (userFacade.existsByIC(IC)) {
            request.setAttribute("error", "IC number already registered.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        // ✅ FIXED: Creating different roles dynamically
        User newUser;
        if (role.equals("MANAGING_STAFF")) {
            ManagingStaff staff = new ManagingStaff();
            staff.setSuperAdmin(newSuperAdmin);
            newUser = staff;
        } else if (role.equals("SECURITY_STAFF")) {
            newUser = new SecurityStaff();
        } else {
            request.setAttribute("error", "Invalid role selection.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        // ✅ Set user attributes
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setName(name);
        newUser.setGender(gender);
        newUser.setPhone(fullPhone);
        newUser.setIC(IC);
        newUser.setEmail(email);
        newUser.setRole(User.Role.valueOf(role));

        userFacade.create(newUser);
        response.sendRedirect(request.getContextPath() + "/admin/manageStaff");
    }
}
