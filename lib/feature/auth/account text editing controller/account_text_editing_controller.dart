// lib/controllers/account_text_editing_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountTextEditingController extends GetxController {
  static const int otpLength = 5;

  // ✅ কন্ট্রোলারগুলো
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final rollController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  // OTP কন্ট্রোলার
  final List<TextEditingController> otpControllersList = List.generate(otpLength, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(otpLength, (index) => FocusNode());

  final agreeController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final fcmTokenController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool obscurePassword = true.obs;
  final RxBool hasPasswordError = false.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool isEmailValid = false.obs;
  final RxBool isPhoneValid = false.obs;
  final RxString enteredOtp = ''.obs;

  // ✅ Getter
  List<TextEditingController> get controllers => otpControllersList;

  // ✅ Index operator
  TextEditingController operator [](int index) => otpControllersList[index];

  // ✅ OTP স্ট্রিং
  String getOtpString() {
    return otpControllersList.map((c) => c.text).join();
  }

  @override
  void onInit() {
    super.onInit();

    // Email validation
    emailController.addListener(() {
      final isValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
          .hasMatch(emailController.text.trim());
      isEmailValid.value = isValid;
    });

    // Phone validation
    phoneController.addListener(() {
      final isValid = RegExp(r"^\d{6,}$").hasMatch(phoneController.text.trim());
      isPhoneValid.value = isValid;
    });
  }

  // এটাই ফিক্স — dispose করো
  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    rollController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    newPasswordController.dispose();

    // OTP কন্ট্রোলার
    for (var controller in otpControllersList) {
      controller.dispose();
    }

    // Focus nodes
    for (var node in focusNodes) {
      node.dispose();
    }

    agreeController.dispose();
    dateOfBirthController.dispose();
    fcmTokenController.dispose();

    super.onClose();
  }
}