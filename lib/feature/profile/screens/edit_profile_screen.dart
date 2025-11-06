// lib/feature/profile/ui/edit_profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import '../../../core/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController()); // ← Get.put() না!

    return Scaffold(
      appBar: CustomAppBar(title: const Text('Personal Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Image
            Obx(() {
              final path = controller.newProfileImagePath.value;
              final url = controller.profileCtrl.userProfile.value.avatar;

              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  if (path.isNotEmpty)
                    CircleAvatar(radius: 60, backgroundImage: FileImage(File(path)))
                  else if (url?.isNotEmpty == true)
                    CircleAvatar(radius: 60, backgroundImage: NetworkImage(url!))
                  else
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 60, color: AppColors.primary),
                    ),

                  GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 30),

            // Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  _buildField('First Name', controller.firstNameCtrl),
                  const SizedBox(height: 24),
                  _buildField('Last Name', controller.lastNameCtrl),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.hasChanges ? controller.updateProfile : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.hasChanges ? AppColors.primary : Colors.grey[400],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }
}