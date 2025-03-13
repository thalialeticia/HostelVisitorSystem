package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.UserFacade;
import com.example.hostelvisitorsystem.ejb.VisitRequestFacade;
import com.example.hostelvisitorsystem.model.Resident;
import com.example.hostelvisitorsystem.model.SecurityStaff;
import com.example.hostelvisitorsystem.model.User;
import com.example.hostelvisitorsystem.model.VisitRequest;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/security/dashboardSecurity")
public class SecurityDashboardServlet extends HttpServlet {
    @Inject
    private UserFacade userFacade;

    @Inject
    private VisitRequestFacade visitRequestFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("reach".equals(action)) {
            handleReach(request, response);
        } else if ("view".equals(action)) {
            handleViewRequest(request, response);
        } else if ("checkout".equals(action)) {
            handleCheckout(request, response);
        } else {
            populateSecurityDashboardPage(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        // Check if the user is a Security Staff
        if (loggedUser == null || !loggedUser.getRole().toString().equals("SECURITY_STAFF")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String verificationCode = request.getParameter("verificationCode");
        String visitorIc = request.getParameter("visitorIc"); // Get IC from form input

        if (verificationCode == null || verificationCode.trim().isEmpty() || verificationCode.length() != 6 ||
                visitorIc == null || visitorIc.trim().isEmpty() || visitorIc.length() != 12) {
            session.setAttribute("verificationMessage", "Invalid input. Please enter a 6-digit code and a 12-digit IC number.");

            request.getRequestDispatcher("/security/dashboardSecurity.jsp").forward(request, response);
            return;
        }

        // Find an approved visit request with the entered verification code and IC that hasn't expired
        VisitRequest visitRequest = visitRequestFacade.findActiveByVerificationCodeAndIC(verificationCode, visitorIc);

        if (visitRequest != null && visitRequest.getStatus() == VisitRequest.Status.APPROVED) {
            SecurityStaff securityStaff = (SecurityStaff) userFacade.find(loggedUser.getId());

            if (securityStaff == null) {
                session.setAttribute("verificationMessage", "Security Staff record not found.");
                request.getRequestDispatcher("/security/dashboardSecurity.jsp").forward(request, response);
                return;
            }

            visitRequest.setStatus(VisitRequest.Status.REACHED);
            visitRequest.setSecurityStaff(securityStaff);
            visitRequest.setCheckInTime(LocalDateTime.now()); // Set Check-in Time
            visitRequestFacade.update(visitRequest);

            session.setAttribute("verificationMessage", "Visitor verified successfully!");
        } else {
            session.setAttribute("verificationMessage", "Verification failed. Code and IC do not match, or request expired.");
        }

        response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
    }


    private void populateSecurityDashboardPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null || !(loggedUser instanceof SecurityStaff)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<VisitRequest> visitRequests = visitRequestFacade.findAll();

        if (visitRequests == null) {
            visitRequests = new ArrayList<>();
        }

        request.setAttribute("visitRequests", visitRequests);

        request.getRequestDispatcher("/security/dashboardSecurity.jsp").forward(request, response);
    }

    private void handleReach(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null || !loggedUser.getRole().toString().equals("SECURITY_STAFF")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            session.setAttribute("error", "Invalid visitor request ID.");
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
            return;
        }

        String verificationCode = request.getParameter("verificationCode");

        if (verificationCode == null || verificationCode.trim().isEmpty() || verificationCode.length() != 6) {
            session.setAttribute("error", "Invalid code. Please enter a 6-digit code.");
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
            return;
        }

        VisitRequest visitRequest = visitRequestFacade.find(id);
        if (visitRequest == null) {
            session.setAttribute("error", "Visit Request not found.");
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
        }

        LocalDateTime now = LocalDateTime.now();

        if (visitRequest.getExpiredAt() != null && visitRequest.getExpiredAt().isBefore(now)) {
            visitRequest.setStatus(VisitRequest.Status.CANCELLED);
            visitRequestFacade.update(visitRequest);
            session.setAttribute("error", "This visit request has already expired and has been automatically cancelled.");
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
            return;
        }

        // Check if the request is approved
        if (visitRequest.getStatus() != VisitRequest.Status.APPROVED) {
            session.setAttribute("error", "Only approved requests can be marked as reached.");
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
            return;
        }

        if(visitRequest.getVerificationCode().equals(verificationCode)) {
            SecurityStaff securityStaff = (SecurityStaff) userFacade.find(loggedUser.getId());

            if (securityStaff == null) {
                session.setAttribute("error", "Security Staff record not found.");
                response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
                return;
            }

            visitRequest.setStatus(VisitRequest.Status.REACHED);
            visitRequest.setSecurityStaff(securityStaff);
            visitRequest.setCheckInTime(LocalDateTime.now());
            visitRequestFacade.update(visitRequest);

            session.setAttribute("success", "Visit request has been successfully marked as reached.");
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
        } else {
            visitRequest.setVerificationCodeCount(visitRequest.getVerificationCodeCount() + 1);
            if(visitRequest.getVerificationCodeCount() == 3) {
                visitRequest.setStatus(VisitRequest.Status.CANCELLED);
            }
            visitRequestFacade.update(visitRequest);

            if (visitRequest.getStatus() == VisitRequest.Status.CANCELLED) {
                session.setAttribute("error", "Invalid visitor verification code. Request cancelled. Please contact the administrator.");
            } else {
                session.setAttribute("error", "Invalid visitor verification code. Attempts left " + (3 - visitRequest.getVerificationCodeCount()) + ".");
            }
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
        }
    }

    private void handleCheckout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null || !loggedUser.getRole().toString().equals("SECURITY_STAFF")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            session.setAttribute("error", "Invalid visitor request ID.");
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
            return;
        }

        VisitRequest visitRequest = visitRequestFacade.find(id);
        if (visitRequest == null) {
            session.setAttribute("error", "Visit Request not found.");
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
        }

        // Check if the request is approved
        if (visitRequest.getStatus() != VisitRequest.Status.REACHED) {
            session.setAttribute("error", "Only reached requests can be marked as checked out.");
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
            return;
        }

        visitRequest.setStatus(VisitRequest.Status.CHECKED_OUT);
        visitRequest.setCheckOutTime(LocalDateTime.now());
        visitRequestFacade.update(visitRequest);

        session.setAttribute("success", "Visit request has been successfully marked as checked out.");
        response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
    }

    private void handleViewRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null || !(loggedUser instanceof SecurityStaff)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            session.setAttribute("error", "Invalid visitor request ID.");
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
            return;
        }

        VisitRequest visitRequest = visitRequestFacade.find(id);

        if (visitRequest == null) {
            session.setAttribute("error", "Visit request not found.");
            response.sendRedirect(request.getContextPath() + "/security/dashboardSecurity");
            return;
        }


        request.setAttribute("visitRequest", visitRequest);
        request.getRequestDispatcher("/security/viewRequestVisit.jsp").forward(request, response);
    }

}
