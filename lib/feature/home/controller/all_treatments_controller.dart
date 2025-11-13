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
  
  // Safety mechanism: Auto-reset loading if stuck
  void _setupLoadingSafety() {
    Future.delayed(const Duration(seconds: 35), () {
      if (isLoading.value) {
        debugPrint("AllTreatments: Loading stuck, auto-resetting...");
        isLoading.value = false;
        if (errorMessage.value.isEmpty) {
          errorMessage.value = "Loading timeout. Please pull to refresh.";
        }
      }
    });
  }

  Future<void> allTreatmentsApiMethod() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Setup safety mechanism
      _setupLoadingSafety();

      // Add timeout to prevent infinite loading
      final response = await NetworkCall.getRequest(url: Urls.treatmentsAll)
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint("AllTreatments API timeout");
          return NetworkResponse(
            statusCode: -1,
            isSuccess: false,
            errorMessage: "Request timeout. Please try again.",
          );
        },
      );

      debugPrint("AllTreatments API: ${Urls.treatmentsAll}");
      debugPrint("Status: ${response.isSuccess} | Data: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData!['data'];
        if (data is List) {
          topPlayList.assignAll(
            data.map((e) => TopPlayListModel.fromJson(e)).toList(),
          );
          debugPrint("AllTreatments loaded: ${topPlayList.length} items");
        } else {
          errorMessage.value = "Invalid data format";
          debugPrint("AllTreatments: Invalid data format - data is not a List");
        }
      } else {
        errorMessage.value = response.errorMessage ?? "Failed to load";
        debugPrint("AllTreatments API failed: ${response.errorMessage}");
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      debugPrint("AllTreatments Exception: $e");
    } finally {
      // Always set loading to false, even if there's an error
      isLoading.value = false;
      debugPrint("AllTreatments loading state: false");
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Call API after a small delay to ensure controller is fully initialized
    Future.delayed(const Duration(milliseconds: 100), () {
      allTreatmentsApiMethod();
    });
  }
}