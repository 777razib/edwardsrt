import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:edwardsrt/feature/home/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import '../../nav bar/screen/custom_bottom_nav_bar.dart';
import '../widget/audio_app_bar_widget.dart';


class AudioWinerWidget extends StatelessWidget {
  /// The session that was selected in the dialog
  final Session session;

  const AudioWinerWidget({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    // You can replace this with real playback logic later.
    // For now we just use 0 as the current progress.
    final Duration currentProgress = Duration.zero;

    return Scaffold(
      // No background colour – the image fills the whole screen
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // -------------------------------------------------
          // 1. Background image (full-screen)
          // -------------------------------------------------
          Image.asset(
            "assets/images/21. Home - V2-4.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: AudioAppBarWidget(
                  title: session.title,               // <-- session title
                  onBackPressed: () => Get.to(CustomBottomNavBar()),
                ),
              ),
            ),
          ),

          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Text("“The heart heals, not by forgetting, but by forgiving and moving forward”",style: globalTextStyle(fontWeight: FontWeight.w600,color: AppColors.whiteColor,fontSize: 18),),
            ),
          ),



        ],
      ),
    );
  }
}
