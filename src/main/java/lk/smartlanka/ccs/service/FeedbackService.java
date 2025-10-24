package lk.smartlanka.ccs.service;

import lk.smartlanka.ccs.dao.FeedbackDao;
import lk.smartlanka.ccs.model.Feedback;

import java.util.List;

public class FeedbackService {
    private FeedbackDao dao = new FeedbackDao();

    public void createFeedback(Feedback feedback) {
        // Validation: rating 1-5
        if (feedback.getRating() < 1 || feedback.getRating() > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        dao.create(feedback);
    }

    public void update(Feedback feedback) {
        dao.update(feedback);
    }

    public void delete(long id) {
        dao.delete(id);
    }

    public Feedback getById(long id) {
        return dao.getById(id);
    }

    public List<Feedback> getByComplaint(long complaintId) {
        return dao.getByComplaint(complaintId);
    }
    
    public int getTotalFeedback() {
        return getAllFeedback().size();
    }
    
    public List<Feedback> getAllFeedback() {
        return dao.getAll();
    }
    
    public List<Feedback> getRecentFeedback(int limit) {
        return getAllFeedback().stream()
                .sorted((f1, f2) -> f2.getSubmittedDate().compareTo(f1.getSubmittedDate()))
                .limit(limit)
                .toList();
    }
    
    public double getAverageRating() {
        return getAllFeedback().stream()
                .mapToDouble(Feedback::getRating)
                .average()
                .orElse(0.0);
    }
    
    public List<Feedback> getFeedbackBySentiment(String sentiment) {
        return getAllFeedback().stream()
                .filter(f -> sentiment.equals(f.getSentiment()))
                .toList();
    }
    
    public List<Feedback> getFeedbackByCustomer(Integer customerId) {
        return dao.getByCustomer(customerId);
    }
}