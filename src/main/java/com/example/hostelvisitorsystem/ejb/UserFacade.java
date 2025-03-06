package com.example.hostelvisitorsystem.ejb;

import com.example.hostelvisitorsystem.model.Resident;
import com.example.hostelvisitorsystem.model.User;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Stateless
public class UserFacade {

    @PersistenceContext(unitName = "hostelAPU")
    private EntityManager em;

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

    // ✅ Check if email exists
    public boolean existsByEmail(String email) {
        return !em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                .setParameter("email", email)
                .getResultList()
                .isEmpty();
    }

    // ✅ Check if phone exists
    public boolean existsByPhone(String phone) {
        return !em.createQuery("SELECT u FROM User u WHERE u.phone = :phone", User.class)
                .setParameter("phone", phone)
                .getResultList()
                .isEmpty();
    }

    // ✅ Check if IC exists
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
        Long visitorCount = em.createQuery("SELECT COUNT(v) FROM Visitor v", Long.class)
                .getSingleResult();
        counts.put("visitors", visitorCount);

        return counts;
    }

}
