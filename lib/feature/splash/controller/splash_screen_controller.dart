import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart'; // <-- Add this
import 'package:get/get.dart';
import '../../../core/services_class/shared_preferences_helper.dart';
import '../../nav bar/screen/custom_bottom_nav_bar.dart';
import '../../onboarding/view/onboarding.dart';

class SplashScreenController extends GetxController {
  Future<void> checkIsLogin() async {
    // 1. Wait for login status
    bool? isLogin = await SharedPreferencesHelper.checkLogin(); // <-- await + ()
    String? token = await SharedPreferencesHelper.getAccessToken(); // <-- await + ()

    // 2. Splash delay
    await Future.delayed(const Duration(seconds: 3));

    print("------------Is Login: $isLogin | -------Token: $token");

    // 3. Navigation logic
    if (isLogin == true && token != null && token.isNotEmpty) {
      Get.offAll(() => const CustomBottomNavBar());
    } else {
      // Either not logged in OR token expired/missing
      Get.offAll(() =>  OnboardingScreen());
      EasyLoading.showToast(
        "Your session has expired. Please log in again.",
        duration: const Duration(seconds: 3),
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkIsLogin();
  }
}