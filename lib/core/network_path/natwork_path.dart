// lib/core/network_path/network_path.dart

class Urls {
  static const String _baseUrl = 'http://206.162.244.140:8033';

  // Keep your auth URLs
  static const String login = '$_baseUrl/auth/login';
  static const String authSignUp = '$_baseUrl/auth/signup';
  static const String authForgetSendOtp = '$_baseUrl/auth/forget/send-otp';
  static const String authFVerifyOtp = '$_baseUrl/auth/forget/verify-otp';
  static const String authForgetResetPassword = '$_baseUrl/auth/forget/reset-password';
  static const String getUserDataUrl = '$_baseUrl/user/me';
  static const String editUserDataUrl = '$_baseUrl/user/me/edit';
  static const String deleteUserDataUrl = '$_baseUrl/user/delete-my-profile';
  static   String singleAudio(String id) => '$_baseUrl/episode/$id?show_transcript=1';
  static String searchingText(String url,String text){
    final encoded=Uri.encodeComponent(url);
    return '$_baseUrl/search-any-topic?audio_url=$encoded&topic=$text';
  }
// network_path.dart
  static String audioSummary(String audioUrl) {
    final encoded = Uri.encodeComponent(audioUrl);
    return "$_baseUrl/episode/transcribe?audio_url=$encoded";
  }


  // FIXED: Direct to ListenNotes
  static String chooseInterest({
    required String interest,
    int page = 1,
    int pageSize = 10,
  }) {
    final int offset = (page - 1) * pageSize;
    final String query = Uri.encodeComponent(interest.trim());

    return '$_baseUrl/podcasts'
        '?q=$query'
        '&type=episode'
        '&language=English'
        '&len_min=5'      // ← Real episodes
        '&len_max=120'
        '&offset=$offset'
        '&limit=$pageSize';
  }
  static String getCalendar(String date, String locationUuid) =>
      '$_baseUrl/calendar?date=$date&pickup_location_uuid=$locationUuid';

  static const String googleApiKey = "AIzaSyC7AoMhe2ZP3iHflCVr6a3VeL0ju0bzYVE";
}