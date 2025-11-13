// lib/feature/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/app_colors.dart';
import '../../auth/model/user_model.dart';
import '../controllers/profile_controller.dart';
import '../widget/about_us_widget.dart';
import '../widget/privacy_policy_widget.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileApiController controller = Get.put(ProfileApiController());

  @override
  void initState() {
    controller.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            // Profile Header
            Obx(() {
              final user = controller.userProfile.value;
              final fullName = "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
              final hasProfile = fullName.isNotEmpty;

              if (!hasProfile && !controller.isLoading.value) {
                return _buildGuestCard();
              }

              if (controller.isLoading.value) return _buildShimmer();

              return _buildProfileCard(user, fullName, controller);
            }),
            const SizedBox(height: 24),
            _buildMenuSection(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          _placeholder(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Guest User'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Login to see profile'.tr, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(UserModel user, String fullName, ProfileApiController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: user.profileImage != null
                ? Image.network(
              user.profileImage!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              cacheWidth: 200,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _placeholder();
              },
              errorBuilder: (_, __, ___) => _placeholder(),
            )
                : _placeholder(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user.email ?? '', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.primary),
            onPressed: () async {
              if (fullName.isEmpty) {
                await controller.getProfile();
              }
              Get.to(() => const EditProfilePage());
            },
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(Icons.person, size: 40, color: AppColors.primary),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(width: 80, height: 80, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Container(width: 150, height: 16, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 120, height: 14, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, ProfileApiController controller) {
    final personalItems = [
      _MenuItem('Personal Details'.tr, Icons.person_outline, () async {
        final user = controller.userProfile.value;
        final fullName = "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
        if (fullName.isEmpty) {
          await controller.getProfile();
        }
        Get.to(() => const EditProfilePage());
      }),
      _MenuItem('About Us'.tr, Icons.info_outline, () => Get.to(() => const AboutUsWidget())),
      _MenuItem('Privacy Policy'.tr, Icons.privacy_tip_outlined, () => Get.to(() => const PrivacyPolicyWidget())),
      _MenuItem('Change Language'.tr, Icons.language, () => _showLanguageDialog(context)),
    ];

    final accountItems = [
      _MenuItem('Log Out'.tr, Icons.logout, () => _showLogoutDialog(context, controller), isDanger: true),
      _MenuItem('Delete Account'.tr, Icons.delete_forever, () => _showDeleteDialog(context, controller), isDanger: true),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMenuCard("Personal Info".tr, personalItems),
        const SizedBox(height: 16),
        _buildMenuCard("Account Actions".tr, accountItems, isDanger: true),
      ],
    );
  }

  Widget _buildMenuCard(String title, List<_MenuItem> items, {bool isDanger = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDanger ? Colors.red.shade700 : Colors.grey.shade600),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: item.isDanger ? Colors.red.shade50 : Colors.grey.shade50, shape: BoxShape.circle),
                      child: Icon(item.icon, size: 20, color: item.isDanger ? Colors.red : AppColors.primary),
                    ),
                    title: Text(item.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: item.isDanger ? Colors.red : Colors.black)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
                    onTap: item.onTap,
                  ),
                  if (i < items.length - 1) const Divider(height: 1, indent: 56, thickness: 0.5),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Change Language'.tr),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption('English', const Locale('en')),
                _buildLanguageOption('বাংলা', const Locale('bn')),
                _buildLanguageOption('العربية', const Locale('ar')),
                _buildLanguageOption('हिन्दी', const Locale('hi')),
                _buildLanguageOption('中文', const Locale('zh')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('Cancel'.tr)),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, Locale locale) {
    final isSelected = Get.locale?.languageCode == locale.languageCode;
    return ListTile(
      title: Text(language),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        Get.updateLocale(locale);
        Get.back();
      },
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileApiController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Log Out'.tr),
        content: Text('Are you sure?'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel'.tr)),
          TextButton(
            onPressed: () async {
              Get.back();
              Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
              final success = await controller.logout();
              if (Get.isDialogOpen == true) Get.back();
              if (!success) {
                Get.snackbar('Error'.tr, 'Logout failed'.tr, backgroundColor: Colors.red, colorText: Colors.white);
              }
            },
            child: Text('Log Out'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showDeleteDialog(BuildContext context, ProfileApiController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Account'.tr),
        content: Text('This cannot be undone.'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel'.tr)),
          TextButton(
            onPressed: () async {
              Get.back();
              Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
              final success = await controller.deleteAccount();
              if (Get.isDialogOpen == true) Get.back();
              if (!success) {
                Get.snackbar('Error'.tr, 'Delete failed'.tr, backgroundColor: Colors.red, colorText: Colors.white);
              }
            },
            child: Text('Delete'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final bool isDanger;
  final VoidCallback onTap;
  _MenuItem(this.title, this.icon, this.onTap, {this.isDanger = false});
}