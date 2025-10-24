package lk.smartlanka.ccs.service;

import lk.smartlanka.ccs.dao.UserDao;
import lk.smartlanka.ccs.model.User;

import java.util.List;

public class UserService {
    private UserDao userDao = new UserDao();

    public User getById(int id) {
        return userDao.findById(id);
    }

    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }

    public List<User> getAllUsers() {
        return userDao.getAll();
    }

    public int getTotalUsers() {
        return getAllUsers().size();
    }

    public int getActiveUsers() {
        return (int) getAllUsers().stream()
                .filter(User::isActive)
                .count();
    }

    public void create(User user) {
        userDao.create(user);
    }

    public void update(User user) {
        userDao.update(user);
    }

    public void delete(int id) {
        userDao.delete(id);
    }
}