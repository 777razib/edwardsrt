import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../core/network_path/natwork_path.dart';

// Model for audio summary
class AudioSummaryModel {
  final int id;
  final String title;
  final String thumbnail;

  AudioSummaryModel({
    required this.id,
    required this.title,
    required this.thumbnail,
  });

  factory AudioSummaryModel.fromJson(Map<String, dynamic> json) {
    return AudioSummaryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}

// Controller to fetch audio summary
class AudioSummaryApiController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var audioSummary = Rx<AudioSummaryModel?>(null);

  Future<void> fetchAudioSummary(int id) async {
    isLoading(true);
    errorMessage(null);

    try {
      final response = await http.get(Uri.parse('${Urls.audioSummary}/$id')); // Corrected

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        audioSummary.value = AudioSummaryModel.fromJson(data); // Assuming the response is the summary object
      } else {
        errorMessage.value = "Failed to load summary. Status: ${response.statusCode}";
        debugPrint(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      debugPrint("Exception: $e");
    } finally {
      isLoading(false);
    }
  }
}
