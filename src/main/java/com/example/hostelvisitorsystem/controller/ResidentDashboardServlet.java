package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.VisitRequestFacade;
import com.example.hostelvisitorsystem.model.Resident;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/resident/dashboardResident")
public class ResidentDashboardServlet extends HttpServlet {

    @Inject
    private VisitRequestFacade visitRequestFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("cancel".equals(action)) {
            handleCancel(request, response);
        } else {
            populateResidentDashboardPage(request, response);
        }
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null || !(loggedUser instanceof Resident)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            session.setAttribute("error", "Invalid visitor request ID.");
            response.sendRedirect(request.getContextPath() + "/resident/dashboardResident");
            return;
        }

        VisitRequest visitRequest = visitRequestFacade.find(id);

        if (visitRequest == null) {
            session.setAttribute("error", "Visit request not found.");
            response.sendRedirect(request.getContextPath() + "/resident/dashboardResident");
            return;
        }

        if (!visitRequest.getResident().getId().equals(loggedUser.getId())) {
            session.setAttribute("error", "Unauthorized action.");
            response.sendRedirect(request.getContextPath() + "/resident/dashboardResident");
            return;
        }

        if (visitRequest.getStatus() == VisitRequest.Status.PENDING) {
            visitRequest.setStatus(VisitRequest.Status.CANCELLED);
            visitRequestFacade.update(visitRequest);
            session.setAttribute("success", "Visit request cancelled successfully.");
        } else {
            session.setAttribute("error", "Only pending requests can be cancelled.");
        }

        response.sendRedirect(request.getContextPath() + "/resident/dashboardResident");
    }


    private void populateResidentDashboardPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null || !(loggedUser instanceof Resident)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<VisitRequest> visitRequests = visitRequestFacade.findByResidentID(loggedUser.getId());

        if (visitRequests == null) {
            visitRequests = new ArrayList<>();
        }

        request.setAttribute("visitRequests", visitRequests);

        request.getRequestDispatcher("/resident/dashboardResident.jsp").forward(request, response);
    }
}
