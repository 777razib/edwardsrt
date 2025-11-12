import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final SplashScreenController splashScreenController = Get.put(SplashScreenController());

  @override
  void initState() {
    super.initState();

    // 1. Initialize Animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // 2. Start login check via controller
    splashScreenController.checkIsLogin();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF3),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              children: [
                const SizedBox(height: 300),
                Container(
                  height: 105,
                  width:128 ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Image.asset(
                    "assets/icons/Mask group.png",
                    width: 180,
                    height: 180,
                  ),
                ),
                const SizedBox(height: 20),
                Text("Mind Cleanser".tr, style: globalTextStyle(fontSize:36,color: AppColors.primary)),
                const SizedBox(height: 10),
                Text("Trauma. Crisis. Cravings.".tr, style: globalTextStyle(fontSize:20,color: AppColors.primary)),
                const SizedBox(height: 20),
                Text("One Sound. No more Fear.".tr, style: globalTextStyle(fontSize:16,color: AppColors.blackColor)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}