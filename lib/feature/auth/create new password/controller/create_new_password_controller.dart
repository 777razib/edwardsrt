import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/network_caller/network_config.dart';
import '../../../../core/network_path/natwork_path.dart';
import '../../account text editing controller/account_text_editing_controller.dart';

class AddNewPassword extends GetxController {
  String? _errorMessage;
  String? _successMessage;  // ✅ Add success message
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  final AccountTextEditingController accountTextEditingController = Get.find<AccountTextEditingController>();

  Future<bool> addNewPasswordApiCallMethod() async {
    bool isSuccess = false;
    _errorMessage = null;
    _successMessage = null;

    final email = accountTextEditingController.emailController.text.trim();
    final newPassword = accountTextEditingController.newPasswordController.text;
    final confirmPassword = accountTextEditingController.confirmPasswordController.text;

    // Validation
    if (email.isEmpty) {
      _errorMessage = "Email is missing.";
      update();
      return false;
    }

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _errorMessage = "Please fill both password fields.";
      update();
      return false;
    }

    if (newPassword != confirmPassword) {
      _errorMessage = "Passwords do not match.";
      update();
      return false;
    }

    if (newPassword.length < 8) {
      _errorMessage = "Password must be at least 8 characters.";
      update();
      return false;
    }

    try {
      Map<String, dynamic> mapBody = {
        "email": email,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      };

      final NetworkResponse response = await NetworkCall.postRequest(
        url: Urls.authForgetResetPassword,
        body: mapBody,
      );

      if (response.isSuccess) {
        _successMessage = response.responseData?['message'] ?? "Password reset successful.";
        isSuccess = true;
      } else {
        _errorMessage = response.responseData?['message'] ??
            response.responseData?['detail'] ??
            "Failed to reset password.";
      }
    } catch (e) {
      _errorMessage = "Network error: $e";
      debugPrint("❌ Reset Exception: $e");
    }

    update();
    return isSuccess;
  }
}