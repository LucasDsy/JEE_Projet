package dao;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import utils.HibernateUtil;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.util.List;


// Pour des requêtes spécifiques, il faudra étendre cette classe
public abstract class DAO<T> {

    protected Session session;
    final protected Class<T> typeParameterClass;

    public DAO(Class<T> typeParameterClass){
        this.typeParameterClass = typeParameterClass;
    }

    /**
     * Persist the enitity in the database
     * @param entity the entity to create
     */
    public void persist(T entity) {
        try {
            session.beginTransaction();
            session.persist(entity);
            session.getTransaction().commit();
        } catch (HibernateException e) {
            e.printStackTrace();
            session.getTransaction().rollback();
        }
    }

    /**
     * Persist all the entities given in parameter, in the database
     * @param entities List of entities to persist
     */
    public void persistAll(List<T> entities) {
        try {
            session.beginTransaction();
            entities.forEach(session::persist);
            session.getTransaction().commit();
        } catch (HibernateException e) {
            e.printStackTrace();
            session.getTransaction().rollback();
        }
    }

    /**
     * Update the entity in the database. If the entity does not exists, then the entity gets persisted
     * @param entity The entity to merge
     */
    public void merge(T entity) {
        try {
            session.beginTransaction();
            session.merge(entity);
            session.getTransaction().commit();
        } catch (HibernateException e) {
            e.printStackTrace();
            session.getTransaction().rollback();
        }
    }

    /**
     * Update all the entities given in paramaeter, in the database. If an entity does not exists, then the entity gets persisted
     * @param entities The entities to merge
     */
    public void mergeAll(List<T> entities) {
        try {
            session.beginTransaction();
            entities.forEach(session::merge);
            session.getTransaction().commit();
        } catch (HibernateException e) {
            e.printStackTrace();
            session.getTransaction().rollback();
        }
    }

    /**
     * Find the entity of type T with the given id
     * @param id Id of the entity
     */
    public T findById(Integer id) {
        T res = session.get(typeParameterClass, id);
        return res;
    }

    /**
     * Find all the entities of type T
     * @return List of entities
     */
    public List<T> findAll() {
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<T> cq = cb.createQuery(typeParameterClass);
        Root<T> rootEntry = cq.from(typeParameterClass);
        CriteriaQuery<T> all = cq.select(rootEntry);

        TypedQuery<T> allQuery = session.createQuery(all);
        return allQuery.getResultList();
    }

    /**
     * Remove an entity from databse
     * @param entity The entity to be removed
     * @return true if the entity is successfully deleted
     */
    public boolean delete(T entity) {
        try {
            session.beginTransaction();
            session.remove(entity);
            session.getTransaction().commit();
        } catch (HibernateException e) {
            e.printStackTrace();
            session.getTransaction().rollback();
            return false;
        }
        return true;
    }

    /**
     * Remove all entities of type T given in parameters, from database
     * @param entities The entities to delete
     * @return The number of entities deleted
     */
    public boolean deleteAll(List<T> entities) {
        try {
            session.beginTransaction();
            entities.forEach(session::remove);
            session.getTransaction().commit();
        } catch (HibernateException e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    /**
     * Remove all entities of type T from database
     * @return The number of entities deleted
     */
    public boolean deleteAll() {
        return deleteAll(findAll());
    }

    public void startSession() {
        this.session = HibernateUtil.getSession();
    }

    public void closeSession() {
        this.session.close();
    }

}
