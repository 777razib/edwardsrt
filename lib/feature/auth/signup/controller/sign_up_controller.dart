import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/network_caller/network_config.dart';
import '../../../../core/network_path/natwork_path.dart';
import '../../account text editing controller/account_text_editing_controller.dart';
import '../../model/user_model.dart';

class SignUpApiController extends GetxController {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final AccountTextEditingController accountTextEditingController = Get.put(AccountTextEditingController());

  UserModel? userModel;

  Future<bool> signUpApiMethod() async {
    bool isSuccess = false;

    try {
      debugPrint("Starting signUpApiMethod...");


      Map<String, dynamic> mapBody = {
        "first_name": accountTextEditingController.firstNameController.text.trim(),
        "last_name": accountTextEditingController.lastNameController.text.trim(),
        "email": accountTextEditingController.emailController.text.trim(),
        "password": accountTextEditingController.passwordController.text.trim(),
        "confirm_password": accountTextEditingController.confirmPasswordController.text.trim(),
        // Only send the FCM token to your backend
      };

      debugPrint("Signup Request Body: $mapBody");
      debugPrint("Signup URL: ${Urls.authSignUp}");

      NetworkResponse response = await NetworkCall.postRequest(
        url: Urls.authSignUp,
        body: mapBody,
      );

      debugPrint("Signup Status: ${response.statusCode}");
      debugPrint("Signup Response: ${response.responseData}");

      if (response.isSuccess) {
       /* var token = response.responseData!["data"]["token"];
        userModel = UserModel.fromJson(response.responseData!["data"]["newUser"]);

        await AuthController.setUserData(token, userModel!);
        await AuthController.getUserData();*/

        _errorMessage = null;
        isSuccess = true;
      } else {
        _errorMessage = response.responseData?["message"] ?? "Unknown error occurred";
      }
    } catch (e, stack) {
      _errorMessage = "Something went wrong: $e";
      debugPrint("Signup Exception: $e");
      debugPrint("Stack: $stack");
    }
    return isSuccess;
  }
}
