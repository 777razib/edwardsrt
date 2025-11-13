import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../audio/screen/audio_screen.dart';
import '../../home/controller/all_treatments_controller.dart';

/// Reusable Controller with Tag
class SessionController extends GetxController {
  final RxInt selectedIndex = (-1).obs;

  void select(int index) => selectedIndex.value = index;
  void reset() => selectedIndex.value = -1;
}

class SessionGuideWidget extends StatelessWidget {
  SessionGuideWidget({super.key});

  // Unique tag for controller
  final String _controllerTag =
      'session_guide_${DateTime.now().millisecondsSinceEpoch}';

  @override
  Widget build(BuildContext context) {
    // Initialize tagged controller
    final ctrl = Get.put(SessionController(), tag: _controllerTag);

    return Container(
      width: 304.6,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Session List ----------
          SizedBox(
            height: 340,
            child: GetBuilder<AllTreatmentsController>(
              builder: (controller) {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (controller.topPlayList.isEmpty) {
                  return Center(
                    child: Text(
                      "No treatments available",
                      style: globalTextStyle(
                        fontSize: 14,
                        color: AppColors.blackColor.withOpacity(0.6),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.topPlayList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final treatment = controller.topPlayList[index];
                    final isSelected = ctrl.selectedIndex.value == index;

                    return _NewWidget(
                      title: treatment.title,
                      subtitle: treatment.howToStart.isNotEmpty
                          ? (treatment.howToStart[0].subtitle ?? "No subtitle")
                          : "No subtitle",
                      image: treatment.thumbnail,
                      isSelected: isSelected,
                      onTap: () => ctrl.select(index),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ---------- Note ----------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 49.19,
                  width: 42.6,
                  child: Image.asset(
                    "assets/icons/cute-mascot-blue-paper 1.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: globalTextStyle(
                        fontSize: 14,
                        color: AppColors.blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: 'Note: ',
                          style: globalTextStyle(fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(
                          text:
                          'You may feel slightly tired after the session — rest for a few minutes if needed.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ---------- Start Button ----------
          Obx(() {
            final selectedIdx = ctrl.selectedIndex.value;
            final canStart = selectedIdx != -1;
            //final _controllerTag=treatment.id ;
            return GestureDetector(

              onTap: canStart
                  ? () {
                final allTreatmentsCtrl =
                Get.find<AllTreatmentsController>();
                final treatment =
                allTreatmentsCtrl.topPlayList[selectedIdx];

                Get.back(); // Close dialog

                // Navigate to AudioScreen with real treatment ID
                Get.to(() => AudioScreen(id: treatment.id));
              }
                  : null,
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: canStart
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Start Session",
                  style: globalTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Reusable Widget (Network Image + Selection)
class _NewWidget extends StatelessWidget {
  const _NewWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.music_note, color: Colors.grey),
                  ),
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : const Center(
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: globalTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: globalTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isSelected
                          ? AppColors.whiteColor.withOpacity(0.9)
                          : AppColors.blackColor.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}