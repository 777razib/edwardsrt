// lib/feature/profile/controllers/edit_profile_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:file_picker/file_picker.dart';
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  final ProfileApiController profileCtrl = Get.find<ProfileApiController>();
  final RxString newProfileImagePath = ''.obs;

  late final TextEditingController firstNameCtrl;
  late final TextEditingController lastNameCtrl;

  String _originalFirstName = '';
  String _originalLastName = '';
  String _originalImage = '';

  @override
  void onInit() {
    super.onInit();
    firstNameCtrl = TextEditingController();
    lastNameCtrl = TextEditingController();

    final user = profileCtrl.userProfile.value;
    if (user.first_name == null || user.first_name!.isEmpty) {
      profileCtrl.getProfile().then((_) {
        _loadProfile();
        update();
      });
    } else {
      _loadProfile();
      update();
    }
  }

  void _loadProfile() {
    final user = profileCtrl.userProfile.value;
    final fullName = "${user.first_name ?? ''} ${user.last_name ?? ''}".trim();
    final parts = fullName.split(' ');

    firstNameCtrl.text = parts.isNotEmpty ? parts[0] : '';
    lastNameCtrl.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    _originalFirstName = firstNameCtrl.text;
    _originalLastName = lastNameCtrl.text;
    _originalImage = user.avatar ?? '';
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result?.files.single.path != null) {
      newProfileImagePath.value = result!.files.single.path!;
      update(); // ← UI আপডেট
    }
  }

  bool get hasChanges {
    return firstNameCtrl.text.trim() != _originalFirstName ||
        lastNameCtrl.text.trim() != _originalLastName ||
        newProfileImagePath.value.isNotEmpty;
  }

  Future<void> updateProfile() async {
    final first = firstNameCtrl.text.trim();
    final last = lastNameCtrl.text.trim();

    if (first.isEmpty || last.isEmpty) {
      Get.snackbar('Error', 'Both names are required', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final success = await profileCtrl.editProfile(
      firstName: first,
      lastName: last,
      profileImagePath: newProfileImagePath.value.isNotEmpty ? newProfileImagePath.value : null,
    );

    if (success) {
      newProfileImagePath.value = '';
      Get.back(); // ← ProfileScreen এ ফিরে যাবে
    }
  }

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    super.onClose();
  }
}