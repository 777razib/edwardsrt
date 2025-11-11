import 'package:flutter/cupertino.dart';
import 'package:get/Get.dart';

import '../../../core/network_caller/network_config.dart';
import '../../../core/network_path/natwork_path.dart';
import '../../home/model/top_play_list_model.dart';

class SingleAudioApiController extends GetxController{
  final RxList<TopPlayListModel> topPlayList = <TopPlayListModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  Future<void> singleAudioApiMethod(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await NetworkCall.getRequest(url: Urls.treatmentsSingleId(id));

      debugPrint("AllTreatments API: ${Urls.treatmentsSingleId(id)}");
      debugPrint("Status: ${response.isSuccess} | Data: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData!['data'];
        if (data is List) {
          topPlayList.assignAll(
            data.map((e) => TopPlayListModel.fromJson(e)).toList(),
          );
        } else {
          errorMessage.value = "Invalid data format";
        }
      } else {
        errorMessage.value = response.errorMessage ?? "Failed to load";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      debugPrint("AllTreatments Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}