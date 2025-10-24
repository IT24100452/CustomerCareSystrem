package lk.smartlanka.ccs.test;

import lk.smartlanka.ccs.service.AuthService;
import lk.smartlanka.ccs.model.User;

public class PasswordTest {
    public static void main(String[] args) {
        try {
            // Test password hashing
            AuthService authService = new AuthService();
            
            // Test the hashPassword method using reflection
            java.lang.reflect.Method hashMethod = AuthService.class.getDeclaredMethod("hashPassword", String.class);
            hashMethod.setAccessible(true);
            String hashedPassword = (String) hashMethod.invoke(authService, "manager123");
            
            System.out.println("Input password: manager123");
            System.out.println("Generated hash: " + hashedPassword);
            System.out.println("Expected hash:   866485796CFA8D7C0CF7111640205B83076433547577511D81F8030AE99ECEA5");
            System.out.println("Match: " + hashedPassword.equals("866485796CFA8D7C0CF7111640205B83076433547577511D81F8030AE99ECEA5"));
            
            // Test user retrieval
            User user = authService.findByEmail("manager1@smartlanka.lk");
            if (user != null) {
                System.out.println("\nRetrieved user:");
                System.out.println("Email: " + user.getEmail());
                System.out.println("Password hash from DB: " + user.getPassword());
                System.out.println("Password match: " + hashedPassword.equals(user.getPassword()));
            } else {
                System.out.println("User not found!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
