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
import java.util.List;

@WebServlet("/resident/dashboardResident")
public class ResidentDashboardServlet extends HttpServlet {

    @Inject
    private VisitRequestFacade visitRequestFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null || !(loggedUser instanceof Resident)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<VisitRequest> visitRequests = visitRequestFacade.findByResidentID(loggedUser.getId());

        request.setAttribute("visitRequests", visitRequests);

        request.getRequestDispatcher("/resident/dashboardResident.jsp").forward(request, response);
    }
}
