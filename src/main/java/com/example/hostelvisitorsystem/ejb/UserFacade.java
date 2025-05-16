package com.example.hostelvisitorsystem.ejb;


import com.example.hostelvisitorsystem.model.User;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.ejb.EJB;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Stateless
public class UserFacade {

    @PersistenceContext(unitName = "hostelAPU")
    private EntityManager em;

    @EJB
    private VisitRequestFacade visitRequestFacade;

    public void create(User user) {
        em.persist(user);
    }

    public User find(String id) {
        return em.find(User.class, id);
    }

    public void update(User user) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }
        em.merge(user);
        em.flush();
    }


    public void delete(String id) {
        User user = find(id);
        if (user != null) {
            em.remove(em.contains(user) ? user : em.merge(user));
            em.flush();
        }
    }

    public List<User> getAllStaff() {
        List<User> staffList = em.createQuery("SELECT u FROM User u WHERE u.role IN (:role1, :role2)", User.class)
                .setParameter("role1", User.Role.SECURITY_STAFF)
                .setParameter("role2", User.Role.MANAGING_STAFF)
                .getResultList();

        return staffList;
    }

    public List<User> getAllResident() {
        List<User> residentList = em.createQuery("SELECT u FROM User u WHERE u.role IN (:role1)", User.class)
                .setParameter("role1", User.Role.RESIDENT)
                .getResultList();

        return residentList;
    }

    public boolean isFieldUnique(String field, String value, String userId) {
        String queryStr = "SELECT COUNT(u) FROM User u WHERE u." + field + " = :value AND u.id <> :userId";
        Long count = em.createQuery(queryStr, Long.class)
                .setParameter("value", value)
                .setParameter("userId", userId)
                .getSingleResult();
        return count == 0; // Returns true if no duplicate exists
    }

    public User findByUsername(String username) {
        List<User> users = em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class)
                .setParameter("username", username)
                .getResultList();
        return users.isEmpty() ? null : users.get(0);
    }

    // ✅ Check if username exists
    public boolean existsByUsername(String username) {
        return !em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class)
                .setParameter("username", username)
                .getResultList()
                .isEmpty();
    }

    public boolean existsByEmail(String email) {
        return !em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                .setParameter("email", email)
                .getResultList()
                .isEmpty();
    }

    public boolean existsByPhone(String phone) {
        return !em.createQuery("SELECT u FROM User u WHERE u.phone = :phone", User.class)
                .setParameter("phone", phone)
                .getResultList()
                .isEmpty();
    }

    public boolean existsByIC(String IC) {
        return !em.createQuery("SELECT u FROM User u WHERE u.IC = :IC", User.class)
                .setParameter("IC", IC)
                .getResultList()
                .isEmpty();
    }

    public Map<String, Long> countAnalytics() {
        Map<String, Long> counts = new HashMap<>();

        // Counting staff (Managing Staff + Security Staff)
        Long staffCount = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.role IN (:role1, :role2)", Long.class)
                .setParameter("role1", User.Role.SECURITY_STAFF)
                .setParameter("role2", User.Role.MANAGING_STAFF)
                .getSingleResult();
        counts.put("staff", staffCount);

        // Counting residents
        Long residentCount = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = :role", Long.class)
                .setParameter("role", User.Role.RESIDENT)
                .getSingleResult();
        counts.put("residents", residentCount);

        // Counting visitors
        Long visitorCount = visitRequestFacade.getUniqueVisitorCount();
        counts.put("visitors", visitorCount);

        return counts;
    }

    public Map<String, Object> getAllReports() {
        Map<String, Object> reports = new HashMap<>();

        //Gender Distribution Report
        List<Object[]> genderResults = em.createQuery(
                "SELECT u.gender, COUNT(u) FROM User u GROUP BY u.gender", Object[].class
        ).getResultList();
        Map<String, Long> genderReport = new HashMap<>();
        for (Object[] row : genderResults) {
            genderReport.put((String) row[0], (Long) row[1]);
        }
        reports.put("genderReport", genderReport);

        //Visitors by Purpose Report
        List<Object[]> purposeResults = em.createQuery(
                "SELECT v.purpose, COUNT(v) FROM VisitRequest v GROUP BY v.purpose ORDER BY COUNT(v) DESC", Object[].class
        ).getResultList();
        Map<String, Long> purposeReport = new HashMap<>();
        for (Object[] row : purposeResults) {
            purposeReport.put((String) row[0], (Long) row[1]);
        }
        reports.put("purposeReport", purposeReport);

        //Age Distribution Report (Estimated using IC)
        List<Object[]> ageResults = em.createQuery(
                "SELECT " +
                        "CASE " +
                        "WHEN SUBSTRING(u.IC, 1, 2) > '30' THEN CONCAT('19', SUBSTRING(u.IC, 1, 2)) " +
                        "ELSE CONCAT('20', SUBSTRING(u.IC, 1, 2)) " +
                        "END AS birthYear, COUNT(u) " +
                        "FROM User u WHERE u.role = 'RESIDENT' " +
                        "GROUP BY birthYear " +
                        "ORDER BY " +
                        "CASE " +
                        "WHEN SUBSTRING(u.IC, 1, 2) > '30' THEN CONCAT('19', SUBSTRING(u.IC, 1, 2)) " +
                        "ELSE CONCAT('20', SUBSTRING(u.IC, 1, 2)) " +
                        "END DESC", Object[].class
        ).getResultList();

        Map<String, Long> ageReport = new HashMap<>();
        for (Object[] row : ageResults) {
            ageReport.put((String) row[0], (Long) row[1]);
        }
        reports.put("ageReport", ageReport);

        //Visitors Check-in Trends (Hourly)
        List<Object[]> checkInResults = em.createQuery(
                "SELECT HOUR(v.checkInTime), COUNT(v) FROM VisitRequest v WHERE v.checkInTime IS NOT NULL GROUP BY HOUR(v.checkInTime) ORDER BY HOUR(v.checkInTime)", Object[].class
        ).getResultList();
        Map<Integer, Long> checkInTrends = new HashMap<>();
        for (Object[] row : checkInResults) {
            checkInTrends.put((Integer) row[0], (Long) row[1]);
        }
        reports.put("checkInTrends", checkInTrends);

        //Resident Locations Report
        List<Object[]> locationResults = em.createQuery(
                "SELECT v.visitorAddress, COUNT(v) FROM VisitRequest v GROUP BY v.visitorAddress ORDER BY COUNT(v) DESC", Object[].class
        ).getResultList();
        Map<String, Long> locationReport = new HashMap<>();
        for (Object[] row : locationResults) {
            locationReport.put((String) row[0], (Long) row[1]);
        }
        reports.put("locationReport", locationReport);

        //Visit Duration Report
        List<Object[]> visitDurationResults = em.createQuery(
                "SELECT " +
                        "CASE " +
                        "WHEN FUNCTION('TIMESTAMPDIFF', MINUTE, v.checkInTime, v.checkOutTime) BETWEEN 0 AND 30 THEN '0-30 mins' " +
                        "WHEN FUNCTION('TIMESTAMPDIFF', MINUTE, v.checkInTime, v.checkOutTime) BETWEEN 31 AND 60 THEN '30-60 mins' " +
                        "WHEN FUNCTION('TIMESTAMPDIFF', MINUTE, v.checkInTime, v.checkOutTime) BETWEEN 61 AND 90 THEN '60-90 mins' " +
                        "ELSE '90+ mins' END AS durationRange, COUNT(v) " +
                        "FROM VisitRequest v WHERE v.checkInTime IS NOT NULL AND v.checkOutTime IS NOT NULL " +
                        "GROUP BY durationRange",
                Object[].class).getResultList();
        Map<String, Long> visitDurationReport = new HashMap<>();
        for (Object[] row : visitDurationResults) {
            visitDurationReport.put((String) row[0], (Long) row[1]);
        }
        reports.put("visitDurationReport", visitDurationReport);

        return reports;
    }
}
