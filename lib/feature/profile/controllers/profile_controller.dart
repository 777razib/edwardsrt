// lib/feature/profile/controllers/profile_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import '../../../core/network_caller/network_config.dart';
import '../../../core/network_path/natwork_path.dart';
import '../../../core/services_class/shared_preferences_helper.dart';
import '../../auth/login/screen/signin_screen.dart';
import '../../auth/model/user_model.dart';

class ProfileApiController extends GetxController {
  final Rx<UserModel> userProfile = UserModel().obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // getProfile(); // ← API কল হবে না
  }

  Future<void> getProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await NetworkCall.getRequest(url: Urls.getUserDataUrl);
      if (response.isSuccess) {
        final data = response.responseData?['data'] ?? response.responseData ?? {};
        userProfile.value = UserModel.fromJson(data);
      } else {
        errorMessage.value = response.errorMessage ?? 'Failed to load profile';
        if (response.statusCode == 401) Get.offAllNamed('/login');
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> editProfile({
    required String firstName,
    required String lastName,
    String? profileImagePath,
  }) async {
    isLoading.value = true;
    try {
      final Map<String, String> fields = {
        'first_name': firstName,
        'last_name': lastName,
      };

      final response = await NetworkCall.multipartRequest(
        url: Urls.editUserDataUrl,
        fields: fields,
        imageFile: profileImagePath != null ? File(profileImagePath) : null,
        imageFieldName: 'image', // ← API অনুযায়ী ফিল্ড নাম
      );

      if (response.isSuccess) {
        final updatedData = response.responseData?['data'] ?? response.responseData ?? {};
        if (updatedData.isNotEmpty) {
          userProfile.value = UserModel.fromJson(updatedData);
        } else {
          await getProfile(); // ফলব্যাক
        }
        Get.snackbar('Success', 'Profile updated', backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      } else {
        errorMessage.value = response.errorMessage ?? 'Update failed';
        if (response.statusCode == 401) Get.offAllNamed('/login');
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> logout() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // UI delay
      await SharedPreferencesHelper.clearAccessToken();

      // শেষে offAll — কোনো snackbar/dialog থাকবে না
      Get.offAll(() => const SignInScreen());
      return true;
    } catch (e) {
      // এখানে snackbar দেখাবে না — UI ইতিমধ্যে চলে গেছে
      return false;
    } finally {
      isLoading.value = false; // এটা চলবে না, কিন্তু রাখা ভালো
    }
  }

  Future<bool> deleteAccount() async {
    isLoading.value = true;
    try {
      final response = await NetworkCall.deleteRequest(url: Urls.deleteUserDataUrl);
      if (response.isSuccess) {
        await SharedPreferencesHelper.clearAccessToken();
        Get.offAll(() => const SignInScreen());
        Get.snackbar('Deleted', 'Account deleted', backgroundColor: Colors.red, colorText: Colors.white);
        return true;
      } else {
        errorMessage.value = response.errorMessage ?? 'Delete failed';
        if (response.statusCode == 401) Get.offAll(() => const SignInScreen());;
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}