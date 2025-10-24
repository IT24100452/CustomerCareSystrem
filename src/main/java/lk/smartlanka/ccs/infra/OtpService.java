package lk.smartlanka.ccs.infra;

import java.util.Random;

public class OtpService {
  public static String generateOtp() {
    return String.format("%06d", new Random().nextInt(999999));
  }

  // Store OTP in session or DB (for simplicity, use session in servlet)
}