package com.example.hostelvisitorsystem.controller;

import com.example.hostelvisitorsystem.ejb.UserFacade;
import com.example.hostelvisitorsystem.model.User;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Inject
    private UserFacade userFacade;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null || !loggedUser.getRole().toString().equals("MANAGING_STAFF")) {
            switch (loggedUser.getRole()) {
                case MANAGING_STAFF:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
                case RESIDENT:
                    response.sendRedirect(request.getContextPath() + "/resident/dashboardResident");
                    break;
                case SECURITY_STAFF:
                    response.sendRedirect("security/dashboardSecurity.jsp");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        }

        // Fetch analytics data from UserFacade
        Map<String, Long> analyticsData = userFacade.countAnalytics();

        // Store analytics data in request attributes
        request.setAttribute("totalStaff", analyticsData.get("staff"));
        request.setAttribute("totalResidents", analyticsData.get("residents"));
        request.setAttribute("totalVisitors", analyticsData.get("visitors"));

        // ✅ Fix: Forward to the correct JSP file
        request.getRequestDispatcher("/admin/dashboardAdmin.jsp").forward(request, response);
    }
}
