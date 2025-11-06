// lib/feature/media/audio/controller/audio_summary_api_controller.dart
import 'package:get/get.dart';
import '../../../../core/network_caller/network_config.dart';
import '../../../../core/network_path/natwork_path.dart';
import '../../../../core/services_class/shared_preferences_helper.dart';
import '../model/audio_summay_model.dart'; // Adjust path if needed

class AudioSummaryApiController extends GetxController {
  PodcastTranscriptModel? _podcastTranscriptModel;
  PodcastTranscriptModel? get podcastTranscriptModel => _podcastTranscriptModel;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  var isLoading = false.obs;

  Future<bool> audioSummaryApiController(String audioUrl) async {
    isLoading(true);
    // Validate URL
    if (audioUrl.isEmpty || !audioUrl.startsWith('http')) {
      _errorMessage = 'Invalid or missing audio URL';
      isLoading(false);
      update();
      return false;
    }

    isLoading(true);
    _errorMessage = null;
    _podcastTranscriptModel = null;
    bool isSuccess = false;

    try {
     /* Map<String,dynamic> body={
        "audio_url":audioUrl
      };*/
      // Use GET (your backend supports query params)
      final response = await NetworkCall.postRequest(
        url: Urls.audioSummary(audioUrl),
      );

      print("🔗 Final URL: ${Urls.audioSummary(audioUrl)}");
      print("📥 Raw Response: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData!;

        dynamic summaryData;
        if (data.containsKey('summary')) {
          summaryData = data['summary']; // Could be String or Map
        } else if (data is String) {
          summaryData = data;
        } else {
          _errorMessage = 'No summary field in response';
          update();
          return false;
        }

        try {
          _podcastTranscriptModel = PodcastTranscriptModel.fromJson(summaryData);

          final summaryText = _podcastTranscriptModel?.summary ?? '';
          if (summaryText.isNotEmpty) {
            await SharedPreferencesHelper.saveAudioSummary(summaryText);
            print("✅ Summary saved: ${summaryText.substring(0, summaryText.length.clamp(0, 100))}...");
            isSuccess = true;
          } else {
            _errorMessage = 'Summary is empty';
          }
        } catch (parseError) {
          _errorMessage = 'Failed to parse summary: $parseError';
          print("❌ Parse Error: $parseError");
        }
      } else {
        _errorMessage = response.errorMessage ?? 'Server error ${response.statusCode}';
        print("❌ API Error: ${_errorMessage}");
      }
    } catch (e) {
      _errorMessage = 'Network Exception: $e';
      print("❌ Exception: $e");
    } finally {
      isLoading(false);
    }

    update(); // Notify UI
    return isSuccess;
  }
}