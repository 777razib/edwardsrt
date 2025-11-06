// lib/feature/auth/forget password/controller/reset_password_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network_caller/network_config.dart';
import '../../../../core/network_path/natwork_path.dart';
import '../../account text editing controller/account_text_editing_controller.dart';

class ResetPasswordController extends GetxController {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final AccountTextEditingController _acctCtrl = Get.find<AccountTextEditingController>();

  Future<bool> resetPasswordApiCallMethod() async {
    bool isSuccess = false;
    _errorMessage = null;

    try {
      // Get the actual text, not the controller
      final String email = _acctCtrl.emailController.text.trim();

      // Validate email
      if (email.isEmpty) {
        _errorMessage = "Please enter your email";
        update();
        return false;
      }

      if (!GetUtils.isEmail(email)) {
        _errorMessage = "Please enter a valid email";
        update();
        return false;
      }

      final Map<String, dynamic> mapBody = {
        "email": email, // Correct: send string, not controller
      };

      debugPrint("Sending request to ${Urls.authForgetSendOtp}");
      debugPrint("Payload: $mapBody");

      final NetworkResponse response = await NetworkCall.postRequest(
        url: Urls.authForgetSendOtp,
        body: mapBody,
      );

      debugPrint("RESPONSE Status: ${response.statusCode}");
      debugPrint("RESPONSE Body: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData!;

        // Optional: Save OTP or token if returned
        // final otp = data['otp'];
        // final message = data['message'];

        _errorMessage = null;
        isSuccess = true;
      } else {
        _errorMessage = response.responseData?['message'] ??
            response.errorMessage ??
            "Failed to send OTP. Please try again.";
      }
    } catch (e) {
      _errorMessage = "Network error: $e";
      debugPrint("Reset Password Exception: $e");
    }

    update();
    return isSuccess;
  }
}