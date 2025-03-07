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
import java.time.LocalDateTime;
import java.util.List;

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

        visitRequest.setStatus(VisitRequest.Status.APPROVED);
        visitRequest.setManagingStaff(managingStaff);
        visitRequest.setApprovalDate(LocalDateTime.now());
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
