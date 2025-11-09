// lib/feature/guide/widget/app_guide_widget.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';

class AppGuideWidget extends StatelessWidget {
  const AppGuideWidget({super.key});

  // Reusable clickable link
  Widget _buildLink(String text, String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Text(
        text,
        style: globalTextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ).copyWith(decoration: TextDecoration.underline),
      ),
    );
  }

  // Reusable bullet point row
  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: globalTextStyle(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: globalTextStyle(
                color: AppColors.blackColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable section with icon + title + description
  Widget _buildSection({
    required String iconPath,
    required String title,
    required String description,
    List<Widget>? children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: Image.asset(iconPath, fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: globalTextStyle(
                color: AppColors.blackColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 44), // align with title
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: globalTextStyle(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              if (children != null) ...[
                const SizedBox(height: 8),
                ...children,
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Welcome Header ===
            Row(
              children: [
                SizedBox(
                  height: 71,
                  width: 86.55,
                  child: Image.asset("assets/icons/Mask group.png"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to Mind Cleanser",
                        style: globalTextStyle(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '''Your personal sound therapy
for peace and balance.''',
                        style: globalTextStyle(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // === About the App ===
            _buildSection(
              iconPath: "assets/icons/information-circle.png",
              title: "About the App",
              description: '''Mind Cleanser uses therapeutic
sound frequencies to help you relax,
refocus, and restore mental calm.''',
            ),

            // === Sessions ===
            _buildSection(
              iconPath: "assets/icons/headphones.png",
              title: "Sessions",
              description: '',
              children: [
                _buildBullet("Quick Reset (5 min)"),
                _buildBullet("Deep Clean (20 min)"),
                _buildBullet("Night Soothe (Continuous Play)"),
              ],
            ),

            // === Affirmations ===
            _buildSection(
              iconPath: "assets/icons/message-02.png",
              title: "Affirmations",
              description: '''Positive messages appear during
and after sessions. You can
revisit them anytime for motivation.''',
            ),

            // === Purchase Info ===
            _buildSection(
              iconPath: "assets/icons/briefcase-dollar.png",
              title: "Purchase Info",
              description: '''One-time payment with local
currency. Lifetime access
and offline availability.''',
            ),

            // === Website Link ===
            Row(
              children: [
                const Icon(Icons.link, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                _buildLink(
                  "Visit our website for help or updates.",
                  "https://www.mindcleanser.com",
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
