// lib/core/helpers/shared_preferences_helper.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../feature/media/audio/model/audio_summay_model.dart'; // Adjust path if needed

class SharedPreferencesHelper {
  // Keys
  static const String _accessTokenKey = 'token';
  static const String _isLoginKey = 'isLogin';

  static const String _userTypeKey = 'userType';
  static const String _userIdKey = 'userId';
  static const String _userEmailKey = 'userEmail';
  static const String _userSummaryKey = 'audio_summary'; // Clear & descriptive
  static const String _pickerLocationUuidKey = 'pickerLocationUuid';

  // MARK: - Access Token
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
    await prefs.setBool(_isLoginKey, true);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // MARK: - User ID
  static Future<void> saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // MARK: - User Email
  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // MARK: - User Type
  static Future<void> saveUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTypeKey, userType);
  }

  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }

  // MARK: - Audio Summary (String version - simple & fast)
  static Future<void> saveAudioSummary(String summary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userSummaryKey, summary);
  }

  /// Async getter - Use in FutureBuilder
  static Future<String?> getAudioSummaryAsync() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userSummaryKey);
  }

  /// Sync getter (if you have a sync wrapper elsewhere)
  // static String? getAudioSummary() => SharedPrefs.instance.getString(_userSummaryKey);

  // MARK: - Optional: Save full PodcastTranscriptModel as JSON
  static Future<void> saveAudioSummaryModel(PodcastTranscriptModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    await prefs.setString(_userSummaryKey, jsonString);
  }

  static Future<PodcastTranscriptModel?> getAudioSummaryModel() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userSummaryKey);
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return PodcastTranscriptModel.fromJson(jsonMap);
    } catch (e) {
      print('Error parsing summary model: $e');
      return null;
    }
  }

  // MARK: - Picker Location
  static Future<void> savePickerLocationUuid(String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pickerLocationUuidKey, uuid);
  }

  static Future<String?> getPickerLocationUuid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pickerLocationUuidKey);
  }

  // MARK: - Login Status
  static Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoginKey) ?? false;
  }

  // MARK: - Clear Methods
  static Future<void> clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_isLoginKey);
  }

  static Future<void> clearSummary() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userSummaryKey);
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_accessTokenKey),
      prefs.remove(_userTypeKey),
      prefs.remove(_userIdKey),
      prefs.remove(_userEmailKey),
      prefs.remove(_userSummaryKey),
      prefs.remove(_isLoginKey),
      prefs.remove(_pickerLocationUuidKey),
    ]);
  }
}