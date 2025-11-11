// lib/dialog/play_dialog_box_widget.dart
import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:edwardsrt/feature/home/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../audio/screen/audio_screen.dart';

class _SessionController extends GetxController {
  final RxInt selectedIndex = (-1).obs;

  void select(int index) => selectedIndex.value = index;
}

class SessionGuideWidget extends StatelessWidget {
  SessionGuideWidget({super.key});

  final List<Session> sessions = [
    Session(
      image: 'assets/images/mehreen.jpg',
      title: 'Mehreen',
      subtitle: 'Tumi Acho Bole',
      duration: const Duration(minutes: 3),
      audioPath: 'assets/audio/MEHREEN  TUMI ACHO BOLE (তম আছ বল)  OFFICIAL VDO.mp3',
    ),
    Session(
      image: 'assets/images/session_2.png',
      title: 'Session 2: Morning Boost',
      subtitle: '5 min • Energizing',
      duration: const Duration(minutes: 5),
      audioPath: 'assets/audio/session_2.mp3',
    ),
    Session(
      image: 'assets/images/session_3.png',
      title: 'Session 3: Sleep Prep',
      subtitle: '15 min • Calming',
      duration: const Duration(minutes: 15),
      audioPath: 'assets/audio/session_3.mp3',
    ),
    Session(
      image: 'assets/images/session_4.png',
      title: 'Session 4: Focus Flow',
      subtitle: '8 min • Productive',
      duration: const Duration(minutes: 8),
      audioPath: 'assets/audio/session_4.mp3',
    ),
    Session(
      image: 'assets/images/session_5.png',
      title: 'Session 5: Stress Relief',
      subtitle: '12 min • Soothing',
      duration: const Duration(minutes: 12),
      audioPath: 'assets/audio/session_5.mp3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(_SessionController());

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
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: sessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Obx(() {
                  final session = sessions[index];
                  final isSelected = ctrl.selectedIndex.value == index;

                  return _NewWidget(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mascot Icon
                SizedBox(
                  height: 49.19,
                  width: 42.6,
                  child: Image.asset(
                    "assets/icons/cute-mascot-blue-paper 1.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),

                // Text Part - Wrap with Expanded to prevent overflow
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: globalTextStyle(fontSize: 14, color: AppColors.blackColor),
                      children: [
                        TextSpan(
                          text: 'Note: ',
                          style: globalTextStyle(fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(
                          text: 'You may feel slightly tired after the session — rest for a few minutes if needed.',
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
            final canStart = ctrl.selectedIndex.value != -1;
            return GestureDetector(
              onTap: canStart
                  ? () {
                final selected = sessions[ctrl.selectedIndex.value];
                Get.back(); // Close dialog
                Get.to(() => AudioScreen(id: "",));
              }
                  : null,
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: canStart ? AppColors.primary : AppColors.primary.withOpacity(0.4),
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


class _NewWidget extends StatelessWidget {
  const _NewWidget({
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Image.asset(
                  session.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.music_note, color: Colors.grey),
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
