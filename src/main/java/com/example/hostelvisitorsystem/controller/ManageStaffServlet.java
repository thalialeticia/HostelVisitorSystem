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

@WebServlet("/admin/manageStaff")
public class ManageStaffServlet extends HttpServlet {

    @Inject
    private UserFacade userFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            handleEditForm(request, response);
        } else if ("delete".equals(action)) {
            handleDelete(request, response);
        } else {
            populateManageStaffPage(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            handleAdd(request, response);
        } else if ("update".equals(action)) {
            handleUpdate(request, response);
        } else {
            populateManageStaffPage(request, response);
        }
    }

    private void handleEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            request.getSession().setAttribute("error", "Staff not found.");
            response.sendRedirect("manageStaff");
            return;
        }

        User staff = userFacade.find(id);
        if (staff == null) {
            request.getSession().setAttribute("error", "Staff not found.");
            response.sendRedirect("manageStaff");
            return;
        }

        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/admin/editStaff.jsp").forward(request, response);
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("loggedUser");

        if (currentUser == null || !(currentUser instanceof ManagingStaff)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

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

        if (!isSuperAdmin && role.equals("MANAGING_STAFF")) {
            request.setAttribute("error", "Only a super admin can create managing staff.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        if (userFacade.existsByUsername(username)) {
            request.setAttribute("error", "Username already in use.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        if (userFacade.existsByEmail(email)) {
            request.setAttribute("error", "Email already in use.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        if (userFacade.existsByPhone(fullPhone)) {
            request.setAttribute("error", "Phone number already in use.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        if (userFacade.existsByIC(IC)) {
            request.setAttribute("error", "IC already in use.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        User newUser;
        if (role.equals("MANAGING_STAFF")) {
            ManagingStaff staff = new ManagingStaff();
            staff.setSuperAdmin(newSuperAdmin);
            newUser = staff;
        } else if (role.equals("SECURITY_STAFF")) {
            newUser = new SecurityStaff();
        } else {
            request.getSession().setAttribute("error", "Invalid role selection.");
            request.getRequestDispatcher("/admin/addStaff.jsp").forward(request, response);
            return;
        }

        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setName(name);
        newUser.setGender(gender);
        newUser.setPhone(fullPhone);
        newUser.setIC(IC);
        newUser.setEmail(email);
        newUser.setRole(User.Role.valueOf(role));

        userFacade.create(newUser);
        request.getSession().setAttribute("success", "Staff member added successfully.");
        response.sendRedirect("manageStaff");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("loggedUser");

        if (currentUser == null || !(currentUser instanceof ManagingStaff)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        boolean isCurrentUserSuperAdmin = ((ManagingStaff) currentUser).isSuperAdmin();

        String id = request.getParameter("id");
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

        boolean isSuperAdminChecked = "on".equals(request.getParameter("superAdmin"));

        User staff = userFacade.find(id);
        if (staff == null) {
            request.setAttribute("error", "Staff not found.");
            request.getRequestDispatcher("/admin/editStaff.jsp").forward(request, response);
            return;
        }

        // Prevent duplicate validation errors when updating the same user
        if (!staff.getUsername().equals(username) && userFacade.existsByUsername(username)) {
            request.setAttribute("error", "Username already in use.");
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/admin/editStaff.jsp").forward(request, response);
            return;
        }

        if (!staff.getEmail().equals(email) && userFacade.existsByEmail(email)) {
            request.setAttribute("error", "Email already in use.");
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/admin/editStaff.jsp").forward(request, response);
            return;
        }

        if (!staff.getPhone().equals(fullPhone) && userFacade.existsByPhone(fullPhone)) {
            request.setAttribute("error", "Phone number already in use.");
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/admin/editStaff.jsp").forward(request, response);
            return;
        }

        if (!staff.getIC().equals(IC) && userFacade.existsByIC(IC)) {
            request.setAttribute("error", "IC already in use.");
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/admin/editStaff.jsp").forward(request, response);
            return;
        }

        // Update user details
        staff.setUsername(username);
        staff.setName(name);
        staff.setGender(gender);
        staff.setPhone(fullPhone);
        staff.setIC(IC);
        staff.setEmail(email);

        if (password != null && !password.trim().isEmpty()) {
            staff.setPassword(password);
        }

        if (staff instanceof ManagingStaff) {
            if (isCurrentUserSuperAdmin) {
                ((ManagingStaff) staff).setSuperAdmin(isSuperAdminChecked);
                staff.setRole(User.Role.valueOf(role));
            }
        }

        userFacade.update(staff);

        // Store success message in session
        session.setAttribute("success", "Staff member updated successfully.");

        // Redirect to avoid form resubmission issues
        response.sendRedirect(request.getContextPath() + "/admin/manageStaff");
    }


    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        boolean isSuperAdmin = ((ManagingStaff) currentUser).isSuperAdmin();
        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            request.getSession().setAttribute("error", "Invalid staff ID.");
            response.sendRedirect("manageStaff");
            return;
        }

        User staffToDelete = userFacade.find(id);

        if (staffToDelete instanceof ManagingStaff && ((ManagingStaff) staffToDelete).isSuperAdmin() && !isSuperAdmin) {
            request.setAttribute("error", "You cannot delete a super admin.");
            response.sendRedirect("manageStaff");
            return;
        }

        userFacade.delete(id);
        request.setAttribute("success", "Staff member deleted successfully.");
        response.sendRedirect("manageStaff");
    }


    private void populateManageStaffPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> staffList = userFacade.getAllStaff();
        request.setAttribute("staffList", staffList);

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        boolean isSuperAdmin = false;
        if (currentUser instanceof ManagingStaff) {
            isSuperAdmin = ((ManagingStaff) currentUser).isSuperAdmin();
        }

        // Pass success message from session to request and clear it
        String successMessage = (String) session.getAttribute("success");
        if (successMessage != null) {
            request.setAttribute("success", successMessage);
            session.removeAttribute("success"); // Prevent message from persisting after refresh
        }

        request.setAttribute("isSuperAdmin", isSuperAdmin);
        request.getRequestDispatcher("/admin/manageStaff.jsp").forward(request, response);
    }

}
