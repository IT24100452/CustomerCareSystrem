package lk.smartlanka.ccs.infra;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.InputStream;
import java.util.Properties;

public class Mailer {
    private static Properties props;
    private static boolean mailConfigured = false;

    static {
        try (InputStream is = Mailer.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (is != null) {
                props = new Properties();
                props.load(is);
                
                // Check if mail is properly configured
                String user = props.getProperty("mail.smtp.user");
                String password = props.getProperty("mail.smtp.password");
                
                if (user != null && !user.equals("your_email@gmail.com") && 
                    password != null && !password.equals("your_app_password_here")) {
                    mailConfigured = true;
                    System.out.println("Mail configuration loaded successfully");
                } else {
                    System.out.println("Mail configuration not properly set up - using console fallback");
                }
                
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
            } else {
                System.out.println("mail.properties not found - using console fallback");
                props = new Properties();
            }
        } catch (Exception e) {
            System.err.println("Failed to load mail config: " + e.getMessage());
            props = new Properties();
        }
    }

    public static void sendPasswordResetEmail(String to, String otp, String token) {
        if (!mailConfigured) {
            // Fallback to console output when email is not configured
            System.out.println("=".repeat(60));
            System.out.println("PASSWORD RESET EMAIL (Console Fallback)");
            System.out.println("=".repeat(60));
            System.out.println("To: " + to);
            System.out.println("Subject: Smart Lanka CCS - Password Reset");
            System.out.println();
            System.out.println("Dear User,");
            System.out.println();
            System.out.println("You have requested to reset your password for Smart Lanka Customer Care System.");
            System.out.println();
            System.out.println("Your OTP Code: " + otp);
            System.out.println("Reset Token: " + token);
            System.out.println();
            System.out.println("Please use this OTP and token to reset your password. This code will expire in 15 minutes.");
            System.out.println();
            System.out.println("If you did not request this password reset, please ignore this email.");
            System.out.println();
            System.out.println("Best regards,");
            System.out.println("Smart Lanka CCS Team");
            System.out.println("=".repeat(60));
            return;
        }

        try {
            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(props.getProperty("mail.smtp.user"), props.getProperty("mail.smtp.password"));
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(props.getProperty("mail.from")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject("Smart Lanka CCS - Password Reset");
            
            String emailBody = String.format(
                "Dear User,\n\n" +
                "You have requested to reset your password for Smart Lanka Customer Care System.\n\n" +
                "Your OTP Code: %s\n" +
                "Reset Token: %s\n\n" +
                "Please use this OTP and token to reset your password. This code will expire in 15 minutes.\n\n" +
                "If you did not request this password reset, please ignore this email.\n\n" +
                "Best regards,\n" +
                "Smart Lanka CCS Team",
                otp, token
            );
            
            message.setText(emailBody);
            Transport.send(message);
            System.out.println("Password reset email sent successfully to: " + to);
        } catch (MessagingException e) {
            System.err.println("Failed to send password reset email to " + to + ": " + e.getMessage());
            // Fallback to console output
            System.out.println("=".repeat(60));
            System.out.println("PASSWORD RESET EMAIL (Fallback due to error)");
            System.out.println("=".repeat(60));
            System.out.println("To: " + to);
            System.out.println("OTP Code: " + otp);
            System.out.println("Reset Token: " + token);
            System.out.println("=".repeat(60));
            throw new RuntimeException("Failed to send password reset email", e);
        }
    }
}