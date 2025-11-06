import 'package:edwardsrt/feature/auth/login/screen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/style/text_style.dart';
import '../controller/onboarding_controller.dart';

// ... [আগের import গুলো একই থাকবে]

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  final List<String> pageTexts = [
    "Sometimes cravings and stress feel too heavy.",
    "Sometimes cravings and stress feel too heavy.",
    "One sound helps you feel lighter, calmer, stronger.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen PageView
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: [
              OnboardingPage(image: "assets/images/Onboarding 13.png", text: pageTexts[0]),
              OnboardingPage(image: "assets/images/Onboarding 14.png", text: pageTexts[1]),
              OnboardingPage(image: "assets/images/Onboarding 15.png", text: pageTexts[2]),
            ],
          ),

          // Skip Button (Top-right)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 20),
              child: GestureDetector(
                onTap: () => Get.to(() => SignInScreen()),
                child: Text(
                  "Skip",
                  style: globalTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Section: Indicators + Get Started (only on last page)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Obx(() {
                final currentPage = controller.currentPage.value;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Page Indicators (Perfectly Round)
                    Row(
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? Colors.amber
                                : Colors.white.withOpacity(0.4),
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            boxShadow: currentPage == index
                                ? [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              )
                            ]
                                : null,
                          ),
                        );
                      }),
                    ),

                    // Only show "Get Started" on 3rd page
                    if (currentPage == 2) ...[
                      SizedBox(width: 50),
                      ElevatedButton(
                        onPressed: () => Get.to(() => SignInScreen()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 5,
                          shadowColor: Colors.amber.withOpacity(0.6),
                        ),
                        child: Text(
                          "Get Started",
                          style: globalTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// OnboardingPage remains same
class OnboardingPage extends StatelessWidget {
  final String image;
  final String text;

  const OnboardingPage({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned(
          bottom: 140,
          left: 30,
          right: 30,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: globalTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ).copyWith(height: 1.3),
          ),
        ),
      ],
    );
  }
}