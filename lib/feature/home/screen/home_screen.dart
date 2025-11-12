// lib/features/home/screen/home_screen.dart
import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../purchase/screen/purchase_one_time_screen.dart';
import '../controller/all_treatments_controller.dart';
import '../controller/top_play_list_controller.dart';
import '../widget/app_bar.dart';
import '../widget/audio_play_widget.dart';
import '../widget/play_dialog_box_widget.dart';
import '../widget/purchase_now_button_widget.dart';
import '../widget/treatments_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TopPlayListController topPlayListController = Get.put(TopPlayListController());
  final AllTreatmentsController allTreatmentsController = Get.put(AllTreatmentsController());
  final ProfileApiController profileApiController = Get.put(ProfileApiController());

  @override
  void initState() {
    // TODO: implement initState
    profileApiController.getProfile();
    super.initState();
  }

  void _showPlaySessionDialog(int treatmentIndex) {
    final controller = Get.find<AllTreatmentsController>();

    // Loading state check
    if (controller.isLoading.value) {
      Get.snackbar("Loading", "Please wait, treatments are loading...");
      return;
    }

    if (controller.topPlayList.isEmpty) {
      Get.snackbar("Empty", "No treatments available.");
      return;
    }

    if (treatmentIndex >= controller.topPlayList.length) {
      Get.snackbar("Error", "Invalid treatment selected.");
      return;
    }

    final treatment = controller.topPlayList[treatmentIndex];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: PlayDialogBoxWidget(treatment: treatment),
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final item=profileApiController.userProfile.value;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
             SliverToBoxAdapter(
              child: HomeAppBar(
                profileImage: '${item.profileImage}',
                title: "${item.firstName} ${item.lastName}",
                subtitle: "What do you want to hear today?",
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Purchase Button
                  PurchaseNowButtonWidget(
                    title: "One purchase.".tr,
                    subTitle: "Endless relaxation".tr,
                    buttonText: "Purchase now".tr,
                    onTap: () => Get.to(() => PurchaseOneTimeScreen()),
                  ),
                  const SizedBox(height: 24),

                  // Treatments Section
                  Text("Treatments".tr, style: globalTextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 12),

                  // Horizontal List (Treatments)
                  SizedBox(
                    height: 220,
                    child: Obx(() {
                      if (allTreatmentsController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (allTreatmentsController.errorMessage.isNotEmpty) {
                        return _buildErrorWidget(
                          allTreatmentsController.errorMessage.value,
                          allTreatmentsController.allTreatmentsApiMethod,
                        );
                      }
                      if (allTreatmentsController.topPlayList.isEmpty) {
                        return  Center(child: Text("No treatments".tr));
                      }

                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: allTreatmentsController.topPlayList.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final item = allTreatmentsController.topPlayList[index];
                          return TreatmentsWidget(
                            image: item.thumbnail,
                            title: item.title,
                            buttonText: "How to start".tr,
                            onTap: () => _showPlaySessionDialog(index),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Top Playlists Section
                  Text("Top Playlists".tr, style: globalTextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 12),

                  // Vertical List (AudioPlayWidget)
                  Obx(() {
                    if (topPlayListController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (topPlayListController.errorMessage.isNotEmpty) {
                      return _buildErrorWidget(
                        topPlayListController.errorMessage.value,
                        topPlayListController.topPlayListApiMethod,
                      );
                    }
                    if (topPlayListController.topPlayList.isEmpty) {
                      return  Center(child: Text("No playlists".tr));
                    }

                    return Column(
                      children: topPlayListController.topPlayList.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AudioPlayWidget(
                            image: item.thumbnail,
                            title: item.title,
                            subTitle: item.howToStart.isNotEmpty ? item.howToStart[0].subtitle : "Relax",
                            audioUrl: item.file,
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message, VoidCallback onRetry) {
    return Center(
      child: Column(
        children: [
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
