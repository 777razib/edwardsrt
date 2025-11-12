// lib/feature/home/widget/play_dialog_box_widget.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:edwardsrt/feature/home/model/session_model.dart';
import 'package:edwardsrt/feature/home/model/top_play_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../audio/screen/audio_screen.dart';

/// Controller for managing selected session
class SessionController extends GetxController {
  final RxInt selectedIndex = (-1).obs;

  void select(int index) => selectedIndex.value = index;
  void reset() => selectedIndex.value = -1;
}

/// Main Dialog Widget
class PlayDialogBoxWidget extends StatelessWidget {
  final TopPlayListModel treatment;

  PlayDialogBoxWidget({super.key, required this.treatment});

  late final String _controllerTag = '${treatment.id}';
  late final SessionController ctrl;

  @override
  Widget build(BuildContext context) {
    // Initialize controller with unique tag
    ctrl = Get.put(SessionController(), tag: _controllerTag);

    // Convert howToStart → Session list
    final List<Session> sessions = treatment.howToStart.map((howTo) {
      // debugPrint removed in production
      return Session(
        image: howTo.image,
        title: howTo.title,
        subtitle: howTo.subtitle,
        duration: const Duration(minutes: 5),
        audioPath: treatment.file,
      );
    }).toList();

    // Auto cleanup when dialog closes
    ever(ctrl.selectedIndex, (_) {});
    Get.find<SessionController>(tag: _controllerTag).onClose();

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
            height: 240,
            child: sessions.isEmpty
                ? Center(
              child: Text(
                "No sessions available",
                style: globalTextStyle(
                  fontSize: 14,
                  color: AppColors.blackColor.withOpacity(0.6),
                ),
              ),
            )
                : ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: sessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Obx(() {
                  final session = sessions[index];
                  final isSelected = ctrl.selectedIndex.value == index;

                  return NewWidget(
                    session: session,
                    isSelected: isSelected,
                    onTap: () => ctrl.select(index),
                  );
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // ---------- Note ----------
          RichText(
            text: TextSpan(
              style: globalTextStyle(fontSize: 14, color: AppColors.blackColor),
              children: [
                TextSpan(
                  text: 'Note: ',
                  style: globalTextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: treatment.afterText.isNotEmpty
                      ? treatment.afterText
                      : 'You may feel slightly tired after the session — rest for a few minutes if needed.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ---------- Start Button ----------
          Obx(() {
            final canStart = ctrl.selectedIndex.value != -1 && sessions.isNotEmpty;
            return GestureDetector(
              onTap: canStart
                  ? () {
                final selectedSession = sessions[ctrl.selectedIndex.value];
                Get.back(); // Close dialog
                Get.to(() => AudioScreen(id: _controllerTag));
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

/// Reusable Session Item Widget with CachedNetworkImage
class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.session,
    required this.isSelected,
    required this.onTap,
  });

  final Session session;
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
            // Fixed: Use CachedNetworkImage
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: CachedNetworkImage(
                  imageUrl: session.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: globalTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    session.subtitle,
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