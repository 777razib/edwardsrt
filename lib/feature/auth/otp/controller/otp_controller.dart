import 'package:edwardsrt/core/services_class/shared_preferences_data_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network_caller/network_config.dart';
import '../../../../core/network_path/natwork_path.dart';
import '../../account text editing controller/account_text_editing_controller.dart';

class OtpController extends GetxController {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final AccountTextEditingController accountTextEditingController = Get.find();

  Future<bool> otpApiCallMethod() async {
    bool isSuccess = false;
    final email = accountTextEditingController.emailController.text.trim();

    // Build OTP directly from list
    final String otpText = accountTextEditingController.otpControllersList
        .map((controller) => controller.text.trim())
        .join('');

    debugPrint("Email: $email");
    debugPrint("OTP: '$otpText' (Length: ${otpText.length})");

    // Validation
    if (email.isEmpty) {
      _errorMessage = "Email is missing.";
      update();
      return false;
    }

    if (otpText.isEmpty || otpText.length != 4 || !RegExp(r'^\d{4}$').hasMatch(otpText)) {
      Get.snackbar("Error", "Please enter a valid 4-digit OTP");
      return false;
    }

    try {
      Map<String, dynamic> mapBody = {
        "email": email,
        "otp": int.parse(otpText),
      };

      debugPrint("Sending request to ${Urls.authFVerifyOtp}");
      debugPrint("Payload: $mapBody");

      final NetworkResponse response = await NetworkCall.postRequest(
        url: Urls.authFVerifyOtp,
        body: mapBody,
      );

      debugPrint("RESPONSE Status: ${response.statusCode}");
      debugPrint("RESPONSE Body: ${response.responseData}");

      if (response.isSuccess) {

        isSuccess = true;
        _errorMessage = null;
        // TODO: Re-enable when AuthController is ready
        // await SharedPreferencesHelper.saveAccessToken(token);
         await AuthController.getUserData();
      } else {
        final detail = response.responseData?['detail'];
        if (detail is String) {
          _errorMessage = detail;
        } else if (detail is List) {
          _errorMessage = detail.map((e) => e['msg'] as String? ?? '').join('\n');
        } else {
          _errorMessage = "Invalid OTP or email";
        }
      }
    } catch (e) {
      _errorMessage = "Something went wrong: $e";
      debugPrint("OTP Exception: $e");
    }

    update();
    return isSuccess;
  }
}