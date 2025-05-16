package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.VisitRequestFacade;
import com.example.hostelvisitorsystem.model.ManagingStaff;
import com.example.hostelvisitorsystem.model.VisitRequest;
import com.example.hostelvisitorsystem.model.User;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.security.SecureRandom;

@WebServlet("/admin/manageVisitRequests")
public class ManageVisitRequestsServlet extends HttpServlet {

    @Inject
    private VisitRequestFacade visitRequestFacade;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("approve".equals(action)) {
            handleApprove(request, response);
        } else if ("reject".equals(action)) {
            handleReject(request, response);
        } else {
            populateManageResidentPage(request, response);
        }
    }

    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; // Uppercase letters and numbers
    private static final SecureRandom RANDOM = new SecureRandom();

    private String generateVerificationCode() {
        StringBuilder code = new StringBuilder(6);
        for (int i = 0; i < 6; i++) {
            code.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }
        return code.toString();
    }

    private String generateUniqueVerificationCode() {
        String code;
        int maxAttempts = 10; // Limit attempts to prevent infinite loops
        int attempts = 0;

        do {
            code = generateVerificationCode(); // Generate a new code
            attempts++;
            // Check if the generated code already exists in the database
        } while (visitRequestFacade.existsByVerificationCode(code) && attempts < maxAttempts);

        if (attempts >= maxAttempts) {
            throw new RuntimeException("Unable to generate a unique verification code after multiple attempts.");
        }

        return code;
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            request.getSession().setAttribute("error", "Invalid visit request ID.");
            response.sendRedirect("manageVisitRequests");
            return;
        }

        VisitRequest visitRequest = visitRequestFacade.find(id);
        if (visitRequest == null) {
            request.getSession().setAttribute("error", "Visit request not found.");
            response.sendRedirect("manageVisitRequests");
            return;
        }

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("loggedUser");

        if (currentUser == null || !(currentUser instanceof ManagingStaff)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        ManagingStaff managingStaff = (ManagingStaff) currentUser;

        LocalDate today = LocalDate.now();
        LocalDate visitDate = visitRequest.getVisitDate();

        // Prevent approving visit requests for past dates
        if (visitDate.isBefore(today)) {
            visitRequest.setStatus(VisitRequest.Status.CANCELLED);
            visitRequestFacade.update(visitRequest);
            request.getSession().setAttribute("error", "This visit request was due and cannot be approved. It has been updated to CANCELED.");
            response.sendRedirect("manageVisitRequests");
            return;
        }

        visitRequest.setVerificationCode(generateUniqueVerificationCode());
        visitRequest.setStatus(VisitRequest.Status.APPROVED);
        visitRequest.setManagingStaff(managingStaff);
        visitRequest.setApprovalDate(LocalDateTime.now());
        visitRequest.setExpiredAt(LocalDateTime.of(visitDate, LocalTime.of(23, 59, 59)));
        visitRequestFacade.update(visitRequest);
        request.getSession().setAttribute("success", "Visit request approved successfully.");
        response.sendRedirect("manageVisitRequests");
    }

    private void handleReject(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            request.getSession().setAttribute("error", "Invalid visit request ID.");
            response.sendRedirect("manageVisitRequests");
            return;
        }

        VisitRequest visitRequest = visitRequestFacade.find(id);
        if (visitRequest == null) {
            request.getSession().setAttribute("error", "Visit request not found.");
            response.sendRedirect("manageVisitRequests");
            return;
        }

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("loggedUser");

        if (currentUser == null || !(currentUser instanceof ManagingStaff)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        ManagingStaff managingStaff = (ManagingStaff) currentUser;

        visitRequest.setStatus(VisitRequest.Status.REJECTED);
        visitRequest.setManagingStaff(managingStaff);
        visitRequest.setApprovalDate(LocalDateTime.now());
        visitRequestFacade.update(visitRequest);
        request.getSession().setAttribute("success", "Visit request rejected successfully.");
        response.sendRedirect("manageVisitRequests");
    }

    private void populateManageResidentPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<VisitRequest> visitRequests = visitRequestFacade.findAll();
        request.setAttribute("visitRequests", visitRequests);
        request.getRequestDispatcher("/admin/manageVisitRequests.jsp").forward(request, response);
    }
}
