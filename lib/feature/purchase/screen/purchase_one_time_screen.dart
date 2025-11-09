import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../audio/widget/audio_app_bar_widget.dart';

class PurchaseOneTimeScreen extends StatelessWidget {
  const PurchaseOneTimeScreen({super.key});

  // Clickable text widget
  Widget _buildClickableText({
    required String text,
    required String url,
    TextAlign textAlign = TextAlign.center,
  }) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar(
            "Error",
            "Could not open $url",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      },
      child: Text(
        text,
        style: globalTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AppColors.primary,
        ).copyWith(decoration: TextDecoration.underline),
        textAlign: textAlign,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive card width – 85% of screen width, max 320
    final double cardWidth = MediaQuery.of(context).size.width * 0.85;
    final double cardHeight = cardWidth * (537 / 292); // keep original ratio

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // ---------- Custom AppBar ----------
              AudioAppBarWidget(
                title: "Purchase One Time",
                onBackPressed: () => Get.back(),
              ),

              // ---------- Main Content ----------
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    children: [
                      // ---------- Product Card ----------
                      Center(
                        child: Container(
                          width: cardWidth,
                          height: cardHeight,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary, width: 1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // ---- Header (image + title) ----
                              Container(
                                height: cardHeight * (140 / 300),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  color: AppColors.primary,
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 62,
                                      width: 62,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Image.asset(
                                        "assets/icons/Mask group.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Mind Cleanser Sound Therapy",
                                      style: globalTextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '''Experience relaxation and
focus through sound.
One-time purchase.
No subscription.''',
                                      style: globalTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ---- Benefits ----
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Image.asset(
                                            "assets/icons/champion.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "What You’ll Get:",
                                            style: globalTextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '''- Unlimited lifetime access
- All therapeutic sounds
- Offline listening
- Free future updates''',
                                      style: globalTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ---------- Purchase Button ----------
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Add real in-app purchase logic
                            Get.snackbar(
                              "Purchase",
                              "Purchase flow will be implemented here",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          child: Container(
                            width: cardWidth,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Purchase Now",
                              style: globalTextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ---------- Clickable Footer Links ----------
                      Center(
                        child: Column(
                          children: [
                            _buildClickableText(
                              text: "www.mindcleanser.com",
                              url: "https://www.mindcleanser.com",
                            ),
                            const SizedBox(height: 8),
                            _buildClickableText(
                              text: "Need help? Visit our website",
                              url: "https://www.mindcleanser.com",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
