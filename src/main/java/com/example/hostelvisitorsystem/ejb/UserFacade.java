package com.example.hostelvisitorsystem.ejb;

import com.example.hostelvisitorsystem.model.User;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class UserFacade {

    @PersistenceContext(unitName = "hostelAPU")
    private EntityManager em;

    public void create(User user) {
        em.persist(user);
    }
    public void updateUser(User user) {
        em.merge(user);
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
}
