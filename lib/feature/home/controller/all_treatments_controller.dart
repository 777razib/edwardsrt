// lib/features/home/controller/all_treatments_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network_caller/network_config.dart';
import '../../../core/network_path/natwork_path.dart';
import '../model/top_play_list_model.dart';

class AllTreatmentsController extends GetxController {
  final RxList<TopPlayListModel> topPlayList = <TopPlayListModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  Future<void> allTreatmentsApiMethod() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await NetworkCall.getRequest(url: Urls.treatmentsAll);

      debugPrint("AllTreatments API: ${Urls.treatmentsAll}");
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

  @override
  void onInit() {
    allTreatmentsApiMethod();
    super.onInit();
  }
}