class Urls {
  static const String baseUrl = 'http://198.199.76.220:12021/api/v1'; // Re-check this IP and port

  // Auth URLs
  static const String login = '$baseUrl/auth/login';
  static const String authSignUp = '$baseUrl/auth/signup';
  static const String authForgetSendOtp = '$baseUrl/auth/send-otp';
  static const String authFVerifyOtp = '$baseUrl/auth/verify-otp';
  static const String authForgetResetPassword = '$baseUrl/auth/reset-password';

  // Profile URLs
  static const String getUserDataUrl = '$baseUrl/users/profile';
  static const String editUserDataUrl = '$baseUrl/users/update-profile';
  static const String logout = '$baseUrl/profile/logout';
  static const String deleteUserDataUrl = '$baseUrl/profile';

  // Treatments URLs
  static const String treatmentsAll = '$baseUrl/treatments/all';
  static const String treatmentsTopPlayList = '$baseUrl/treatments/top';
  static  String treatmentsSingleId(String id) => '$baseUrl/treatments/single/$id';

  // Other URLs
  static const String chooseInterest = '$baseUrl/interests'; // Corrected endpoint
  static const String singleAudio = '$baseUrl/audios';      // Corrected endpoint
  static const String audioSummary = '$baseUrl/audio/summary';
  static const String searchingText = '$baseUrl/search';
}
