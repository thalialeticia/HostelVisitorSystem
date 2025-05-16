package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.UserFacade;
import com.example.hostelvisitorsystem.model.ManagingStaff;
import com.example.hostelvisitorsystem.model.Resident;
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

@WebServlet("/admin/manageResident")
public class ManageResidentServlet extends HttpServlet {
    @Inject
    private UserFacade userFacade;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            handleEditForm(request, response);
        } else if ("delete".equals(action)) {
            handleDelete(request, response);
        } else if ("approve".equals(action)) {
            handleApprove(request, response);
        } else if ("reject".equals(action)) {
            handleReject(request, response);
        } else {
            populateManageResidentPage(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if  ("update".equals(action)) {
            handleUpdate(request, response);
        } else {
            populateManageResidentPage(request, response);
        }
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            request.getSession().setAttribute("error", "Invalid resident ID.");
            response.sendRedirect("manageResident");
            return;
        }

        User user = userFacade.find(id);
        if (!(user instanceof Resident)) {
            request.getSession().setAttribute("error", "Resident not found.");
            response.sendRedirect("manageResident");
            return;
        }

        Resident resident = (Resident) user;
        resident.setStatus(Resident.Status.APPROVED);
        userFacade.update(resident);

        request.getSession().setAttribute("success", "Resident approved successfully.");
        response.sendRedirect("manageResident");
    }

    private void handleReject(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            request.getSession().setAttribute("error", "Invalid resident ID.");
            response.sendRedirect("manageResident");
            return;
        }

        User user = userFacade.find(id);
        if (!(user instanceof Resident)) {
            request.getSession().setAttribute("error", "Resident not found.");
            response.sendRedirect("manageResident");
            return;
        }

        Resident resident = (Resident) user;
        resident.setStatus(Resident.Status.REJECTED);
        userFacade.update(resident);

        request.getSession().setAttribute("success", "Resident rejected successfully.");
        response.sendRedirect("manageResident");
    }

    private void handleEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            request.getSession().setAttribute("error", "Resident not found.");
            response.sendRedirect("manageResident");
            return;
        }

        User resident = userFacade.find(id);
        if (resident == null) {
            request.getSession().setAttribute("error", "Resident not found.");
            response.sendRedirect("manageResident");
            return;
        }

        request.setAttribute("resident", resident);
        request.getRequestDispatcher("/admin/editResident.jsp").forward(request, response);
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            request.getSession().setAttribute("error", "Invalid resident ID.");
            response.sendRedirect("manageResident");
            return;
        }

        User residentToDelete = userFacade.find(id);
        if (residentToDelete == null) {
            request.getSession().setAttribute("error", "Resident not found.");
            response.sendRedirect("manageResident");
            return;
        }

        userFacade.delete(id);

        request.getSession().setAttribute("success", "Resident member deleted successfully.");
        response.sendRedirect("manageResident");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("loggedUser");

        if (currentUser == null || !(currentUser instanceof ManagingStaff)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

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

        User resident = userFacade.find(id);
        if (resident == null) {
            request.setAttribute("error", "Resident not found.");
            request.getRequestDispatcher("/admin/editResident.jsp").forward(request, response);
            return;
        }

        // Prevent duplicate validation errors when updating the same user
        if (!resident.getUsername().equals(username) && userFacade.existsByUsername(username)) {
            request.setAttribute("error", "Username already in use.");
            request.setAttribute("resident", resident);
            request.getRequestDispatcher("/admin/editResident.jsp").forward(request, response);
            return;
        }

        if (!resident.getEmail().equals(email) && userFacade.existsByEmail(email)) {
            request.setAttribute("error", "Email already in use.");
            request.setAttribute("resident", resident);
            request.getRequestDispatcher("/admin/editResident.jsp").forward(request, response);
            return;
        }

        if (!resident.getPhone().equals(fullPhone) && userFacade.existsByPhone(fullPhone)) {
            request.setAttribute("error", "Phone number already in use.");
            request.setAttribute("resident", resident);
            request.getRequestDispatcher("/admin/editResident.jsp").forward(request, response);
            return;
        }

        if (!resident.getIC().equals(IC) && userFacade.existsByIC(IC)) {
            request.setAttribute("error", "IC already in use.");
            request.setAttribute("resident", resident);
            request.getRequestDispatcher("/admin/editResident.jsp").forward(request, response);
            return;
        }

        // Update user details
        resident.setUsername(username);
        resident.setName(name);
        resident.setGender(gender);
        resident.setPhone(fullPhone);
        resident.setIC(IC);
        resident.setEmail(email);

        if (password != null && !password.trim().isEmpty()) {
            resident.setPassword(password);
        }

        userFacade.update(resident);

        // Store success message in session
        session.setAttribute("success", "Resident member updated successfully.");

        // Redirect to avoid form resubmission issues
        response.sendRedirect(request.getContextPath() + "/admin/manageResident");
    }

    private void populateManageResidentPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> residentList = userFacade.getAllResident();
        request.setAttribute("residentList", residentList);
        request.getRequestDispatcher("/admin/manageResident.jsp").forward(request, response);
    }
}
