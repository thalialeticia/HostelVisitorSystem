package com.example.hostelvisitorsystem.ejb;

import com.example.hostelvisitorsystem.model.VisitRequest;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.List;

@Stateless
public class VisitRequestFacade {

    @PersistenceContext(unitName = "hostelAPU") // Make sure this matches your persistence.xml unit name
    private EntityManager entityManager;

    /**
     * Create a new visit request
     */
    public void create(VisitRequest visitRequest) {
        entityManager.persist(visitRequest);
    }

    /**
     * Find visit request by ID
     */
    public VisitRequest find(String id) {
        return entityManager.find(VisitRequest.class, id);
    }

    /**
     * Find all visit requests
     */
    public List<VisitRequest> findAll() {
        return entityManager.createQuery("SELECT v FROM VisitRequest v ORDER BY v.requestDate DESC", VisitRequest.class)
                .getResultList();
    }

    /**
     * Update an existing visit request
     */
    public void update(VisitRequest visitRequest) {
        entityManager.merge(visitRequest);
    }

    /**
     * Delete a visit request (if needed)
     */
    public void delete(String id) {
        VisitRequest visitRequest = find(id);
        if (visitRequest != null) {
            entityManager.remove(visitRequest);
        }
    }

    /**
     * Fetch all visit requests for a specific resident by their ID.
     */
    public List<VisitRequest> findByResidentID(String residentId) {
        return entityManager.createQuery("SELECT v FROM VisitRequest v WHERE v.resident.id = :residentId ORDER BY v.requestDate DESC", VisitRequest.class)
                .setParameter("residentId", residentId)
                .getResultList();
    }

    public Long getUniqueVisitorCount() {
        return entityManager.createQuery(
                        "SELECT COUNT(DISTINCT v.visitorIc) FROM VisitRequest v WHERE v.visitorIc IS NOT NULL", Long.class)
                .getSingleResult();
    }


    /**
     * Find visit request by verification code where status is APPROVED.
     */
    public VisitRequest findActiveByVerificationCodeAndIC(String code, String visitorIc) {
        TypedQuery<VisitRequest> query = entityManager.createQuery(
                "SELECT v FROM VisitRequest v WHERE v.verificationCode = :code AND v.visitorIc = :visitorIc " +
                        "AND v.status = :status AND (v.expiredAt IS NULL OR v.expiredAt > :now)", VisitRequest.class);

        query.setParameter("code", code);
        query.setParameter("visitorIc", visitorIc);
        query.setParameter("status", VisitRequest.Status.APPROVED);
        query.setParameter("now", LocalDateTime.now()); // Current timestamp

        List<VisitRequest> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    public boolean existsByVerificationCode(String code) {
        TypedQuery<Long> query = entityManager.createQuery(
                "SELECT COUNT(v) FROM VisitRequest v WHERE v.verificationCode = :code AND (v.expiredAt IS NULL OR v.expiredAt > :now)",
                Long.class);

        query.setParameter("code", code);
        query.setParameter("now", LocalDateTime.now());

        return query.getSingleResult() > 0;
    }

}
