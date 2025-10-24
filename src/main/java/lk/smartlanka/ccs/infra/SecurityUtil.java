package lk.smartlanka.ccs.infra;

/**
 * Lightweight SecurityUtil replacement used for plaintext password comparison.
 * NOTE: storing plaintext passwords is insecure. This change removes BCrypt usage
 * and performs direct equality checks to get the app running as requested.
 */
public class SecurityUtil {
    /**
     * Verify password by simple equality check.
     * @param candidate plain text password supplied by user
     * @param stored the password string stored in DB
     * @return true if matches, false otherwise
     */
    public static boolean verifyPassword(String candidate, String stored) {
        if (candidate == null) return stored == null;
        return candidate.equals(stored);
    }
}
