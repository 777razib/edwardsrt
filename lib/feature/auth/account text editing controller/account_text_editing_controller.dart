import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountTextEditingController extends GetxController {
  static void initialize() {
    Get.put(AccountTextEditingController(), permanent: true);
  }

  static const int otpLength = 4;

  // Text Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final rollController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();

  // OTP Controllers & Focus Nodes
  final List<TextEditingController> otpControllersList =
  List.generate(otpLength, (index) => TextEditingController());
  final List<FocusNode> focusNodes =
  List.generate(otpLength, (index) => FocusNode());

  final agreeController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final fcmTokenController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Reactive Variables
  final RxBool obscurePassword = true.obs;
  final RxBool hasPasswordError = false.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool isEmailValid = false.obs;
  final RxBool isPhoneValid = false.obs;
  final RxString enteredOtp = ''.obs;

  // Safe access to OTP controllers
  TextEditingController operator [](int index) => otpControllersList[index];

  // Get concatenated OTP string (only digits, trimmed, no empty)
  String getOtpString() {
    return otpControllersList
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .join();
  }

  @override
  void onInit() {
    super.onInit();

    emailController.addListener(() {
      final isValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
          .hasMatch(emailController.text.trim());
      isEmailValid.value = isValid;
    });

    phoneController.addListener(() {
      final isValid = RegExp(r"^\d{6,}$").hasMatch(phoneController.text.trim());
      isPhoneValid.value = isValid;
    });
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    rollController.dispose();
    passwordController.dispose();
    newPasswordController.dispose();

    for (var controller in otpControllersList) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }

    agreeController.dispose();
    dateOfBirthController.dispose();
    fcmTokenController.dispose();

    super.onClose();
  }

  void clearAll() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    rollController.clear();
    passwordController.clear();
    newPasswordController.clear();
    for (var controller in otpControllersList) {
      controller.clear();
    }
  }
}