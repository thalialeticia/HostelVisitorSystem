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
        String action = request.getParameter("action");

        if ("view-report".equals(action)) {
            System.out.println("Generating Reports...");

            Map<String, Object> reports = userFacade.getAllReports();

            // ✅ Store reports in request attributes
            request.setAttribute("genderReport", reports.get("genderReport"));
            request.setAttribute("purposeReport", reports.get("purposeReport"));
            request.setAttribute("ageReport", reports.get("ageReport"));
            request.setAttribute("checkInTrends", reports.get("checkInTrends"));
            request.setAttribute("locationReport", reports.get("locationReport"));
            request.setAttribute("visitDurationReport", reports.get("visitDurationReport"));

            // ✅ Forward to JSP
            request.getRequestDispatcher("/admin/viewReport.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession(false);
            User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

            if (loggedUser == null || !loggedUser.getRole().toString().equals("MANAGING_STAFF")) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
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
}
