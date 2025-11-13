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
    getProfile();
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

  // lib/feature/profile/controllers/profile_controller.dart

  Future<bool> editProfile({
    required String firstName,
    required String lastName,
    String? profileImagePath,
   }) async {
    isLoading.value = true;
    try {
      final Map<String, String> fields = {
        'firstName': firstName,
        'lastName': lastName,
      };

      final File? imageFile = profileImagePath != null ? File(profileImagePath) : null;

      final response = await NetworkCall.multipartRequest(
        url: Urls.editUserDataUrl,     // ← /profile
        fields: fields,
        imageFile: imageFile,            // ← imageFile
        methodType: 'PUT',               // ← PUT
        imageFieldName: 'image',         // ← image
      );

      if (response.isSuccess) {
        final updatedData = response.responseData?['data'] ?? {};
        if (updatedData.isNotEmpty) {
          userProfile.value = UserModel.fromJson(updatedData);
        } else {
          await getProfile();
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
      await Future.delayed(const Duration(milliseconds: 500));
      await SharedPreferencesHelper.clearAccessToken();
      Get.offAll(() => const SignInScreen());
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteAccount() async {
    isLoading.value = true;
    try {
      final response = await NetworkCall.deleteRequest(url: Urls.deleteUserDataUrl);
      if (response.isSuccess) {
        await SharedPreferencesHelper.getAccessToken();
        await SharedPreferencesHelper.clearAccessToken();
        Get.offAll(() => const SignInScreen());
        Get.snackbar('Deleted', 'Account deleted', backgroundColor: Colors.red, colorText: Colors.white);
        return true;
      } else {
        errorMessage.value = response.errorMessage ?? 'Delete failed';
        if (response.statusCode == 401) Get.offAll(() => const SignInScreen());
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
