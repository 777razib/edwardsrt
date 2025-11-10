// lib/features/home/screen/home_screen.dart
import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
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

  void _showPlaySessionDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child:  PlayDialogBoxWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            const SliverToBoxAdapter(
              child: HomeAppBar(
                profileImage: 'assets/images/WhatsApp Image 2025-11-08 at 10.06.03_1d0d3929.jpg',
                title: "Hey John",
                subtitle: "What do you want to hear today?",
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Purchase Button
                  PurchaseNowButtonWidget(
                    title: "One purchase.",
                    subTitle: "Endless relaxation",
                    buttonText: "Purchase now",
                    onTap: () => Get.to(() => PurchaseOneTimeScreen()),
                  ),
                  const SizedBox(height: 24),

                  // Treatments Section
                  Text("Treatments", style: globalTextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
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
                        return const Center(child: Text("No treatments"));
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
                            buttonText: "How to start",
                            onTap: _showPlaySessionDialog,
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Top Playlists Section
                  Text("Top Playlists", style: globalTextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
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
                      return const Center(child: Text("No playlists"));
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