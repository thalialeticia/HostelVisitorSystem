package com.example.hostelvisitorsystem.ejb;

import com.example.hostelvisitorsystem.model.VisitRequest;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
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

}
