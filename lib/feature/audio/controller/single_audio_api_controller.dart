// lib/feature/audio/controller/single_audio_api_controller.dart
import 'package:flutter/cupertino.dart';
import 'package:get/Get.dart';
import '../../../core/network_caller/network_config.dart';
import '../../../core/network_path/natwork_path.dart';
import '../../home/model/top_play_list_model.dart';

class SingleAudioApiController extends GetxController {
  final RxList<TopPlayListModel> topPlayList = <TopPlayListModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  Future<void> singleAudioApiMethod(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      topPlayList.clear(); // Clear previous data

      final response = await NetworkCall.getRequest(url: Urls.treatmentsSingleId(id));

      debugPrint("API URL: ${Urls.treatmentsSingleId(id)}");
      debugPrint("Status: ${response.isSuccess} | Data: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData!['data'];

        // data is Map, not List
        if (data is Map<String, dynamic>) {
          final model = TopPlayListModel.fromJson(data);
          topPlayList.assignAll([model]); // Single item → wrap in list for assignAll
        } else {
          errorMessage.value = "Invalid data format";
        }
      } else {
        errorMessage.value = response.errorMessage ?? "Failed to load data";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      debugPrint("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}