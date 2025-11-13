import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:edwardsrt/feature/home/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../nav bar/screen/custom_bottom_nav_bar.dart';
import 'audio_app_bar_widget.dart';

class AudioWinerWidget extends StatelessWidget {
  final Session session;

  const AudioWinerWidget({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
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
                  title: session.title,
                  onBackPressed: () => Get.offAll(() => const CustomBottomNavBar()),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                session.afterText??'', // Use the subtitle from the session
                textAlign: TextAlign.center,
                style: globalTextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
