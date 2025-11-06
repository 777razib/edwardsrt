import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network_caller/network_config.dart';
import '../../../../core/network_path/natwork_path.dart';
import '../../account text editing controller/account_text_editing_controller.dart';

class OtpController extends GetxController {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  //UserModel? userModel;

  // final DataHelperController dataHelperController = Get.put(DataHelperController());
  final AccountTextEditingController accountTextEditingController = Get.put(AccountTextEditingController());

  /// ✅ Set email from previous step
  /* void setEmail(String email) {
    userModel = UserModel(email: email);
  }*/

  Future<bool> otpApiCallMethod() async {
    bool isSuccess = false;

    final email = accountTextEditingController.emailController.text.trim();
    final otpControllers = accountTextEditingController.otpControllersList;

    debugPrint("📧 Email: $email");

    // Extract OTP as a concatenated string from the list of controllers
    String otpText = otpControllers.map((controller) => controller.text.trim()).join('');
    debugPrint("🔢 OTP: $otpText");

    // Validation
    if (email.isEmpty) {
      _errorMessage = "Email is missing.";
      update();
      return false;
    }

    if (otpText.isEmpty || otpText.length != otpControllers.length) {  // Assuming one digit per controller
      Get.snackbar("Error", "Invalid OTP format");
      return false;
    }

    try {
      Map<String, dynamic> mapBody = {
        "email": email,
        "otp": otpText,  // Send as string
      };

      debugPrint("📤 Sending request to ${Urls.authFVerifyOtp}");
      debugPrint("📦 Payload: $mapBody");

      final NetworkResponse response = await NetworkCall.postRequest(
        url: Urls.authFVerifyOtp,
        body: mapBody,
      );

      debugPrint("📥 RESPONSE Status: ${response.statusCode}");
      debugPrint("📥 RESPONSE Body: ${response.responseData}");

      if (response.isSuccess) {
        final data = response.responseData?['data'];

       /* final token = response.responseData!["access_token"];
        print("====$token");

        final updatedUser = UserModel.fromJson(data);
        await AuthController.setUserData(token, updatedUser);
        await SharedPreferencesHelper.saveAccessToken(token);
        await AuthController.getUserData();*/

        isSuccess = true;
        _errorMessage = null;
      } else {
        final detail = response.responseData?['detail'];
        if (detail is String) {
          _errorMessage = detail;
        } else if (detail is List) {
          _errorMessage = detail.map((e) => e['msg'] as String).join('\n');
        } else {
          _errorMessage = "Unknown error";
        }
      }
    } catch (e) {
      _errorMessage = "Something went wrong: $e";
      debugPrint("❌ OTP Exception: $e");
    }

    update();
    return isSuccess;
  }
}