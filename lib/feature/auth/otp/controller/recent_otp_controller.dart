/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ResendOTPController extends GetxController {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  UserModel? userModel;

  final DataHelperController dataHelperController = Get.put(DataHelperController());

  Future<bool> resendPasswordApiCallMethod() async {
    bool isSuccess = false;

    final email = userModel?.email?.trim();
    print("📧 Entered email: $email");

    // 🔒 Validation
    if (email == null || email.isEmpty) {
      _errorMessage = "Email cannot be empty.";
      update();
      return false;
    }

    try {
      Map<String, dynamic> mapBody = {
        "email": email,
      };

      final NetworkResponse response = await NetworkCall.postRequest(
        url: NetworkPath.resendOTP,
        body: mapBody,
      );

      debugPrint("📤 Sending request to ${NetworkPath.resendOTP}");
      debugPrint("📦 Payload: $mapBody");


      debugPrint("📥 RESPONSE Status: ${response.statusCode}");
      debugPrint("📥 RESPONSE Body: ${response.responseData}");

      if (response.isSuccess) {

        var data = response.responseData?['data'];
        var token = dataHelperController.accessToken??'';
        print("====$token");

        // ✅ Parse updated user from response
        final updatedUser = UserModel.fromJson(data);
        await dataHelperController.saveUserData(token, updatedUser);
        await dataHelperController.getUserData();

        isSuccess = true;
        _errorMessage = null;
      } else {
        _errorMessage = response.responseData?['message'] ?? "Unknown error";
      }
    } catch (e) {
      _errorMessage = "Something went wrong: $e";
      debugPrint("❌ Reset Password Exception: $e");
    }

    update();
    return isSuccess;
  }
}*/
