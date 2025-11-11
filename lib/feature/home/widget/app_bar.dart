import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    this.profileImage,
    this.title,
    this.subtitle,
  });

  final String? profileImage;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 126, // Rounded for simplicity
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Profile Image
              ClipOval(
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.grey[300], // Placeholder background
                  child: profileImage != null
                      ? Image.network(
                    profileImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Colors.grey);
                    },
                  )
                      : const Icon(Icons.person, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),

              // Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title ?? 'User',
                      style: globalTextStyle(
                        fontSize: 16,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle ?? 'Subtitle',
                      style: globalTextStyle(
                        fontSize: 14,
                        color: AppColors.blackColor.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}