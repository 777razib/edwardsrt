import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/network_path/natwork_path.dart';
import '../../../core/services_class/shared_preferences_helper.dart';
import '../../nav bar/screen/custom_bottom_nav_bar.dart';

class ChooseInterestApiController extends GetxController {
  final interestList = <Map<String, dynamic>>[].obs;
  final selectedInterests = <int>[].obs;

  final isLoading = false.obs;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  @override
  void onInit() {
    super.onInit();
    fetchInterests();
  }

  void toggleInterest(int id) {
    if (selectedInterests.contains(id)) {
      selectedInterests.remove(id);
    } else {
      selectedInterests.add(id);
    }
    debugPrint("Selected IDs: $selectedInterests");
  }

  Future<void> fetchInterests() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(Urls.chooseInterest));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null) {
          final List<Map<String, dynamic>> interests = (data['results'] as List)
              .map((item) => {
            'id': item['id'] as int,
            'title': item['title'] as String,
            'thumbnail': item['thumbnail'] as String? ?? '',
          })
              .toList();
          interestList.value = interests;
          debugPrint("Fetched ${interestList.length} interests.");
        }
      } else {
        _errorMessage = "Failed to load interests: ${response.statusCode}";
        debugPrint(_errorMessage);
      }
    } catch (e) {
      _errorMessage = "Something went wrong: $e";
      debugPrint(_errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveInterests() async {
    if (selectedInterests.isEmpty) {
      Get.snackbar("No Selection", "Please select at least one interest.");
      return false;
    }

    isLoading.value = true;
    _errorMessage = null;

    final String? token = await SharedPreferencesHelper.getAccessToken();
    if (token == null) {
      _errorMessage = "Auth token not found.";
      isLoading.value = false;
      return false;
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'interests': selectedInterests,
    });

    try {
      debugPrint("Sending selected interests to the server...");
      final response = await http.post(
        Uri.parse(Urls.chooseInterest),
        headers: headers,
        body: body,
      );

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Interests saved successfully!");
        Get.offAll(() => const CustomBottomNavBar());
        return true;
      } else {
        final data = json.decode(response.body);
        _errorMessage = data['detail'] as String? ?? "Failed to save interests.";
        Get.snackbar("Error", _errorMessage!);
        return false;
      }
    } catch (e) {
      _errorMessage = "An unexpected error occurred: $e";
      Get.snackbar("Error", _errorMessage!);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
