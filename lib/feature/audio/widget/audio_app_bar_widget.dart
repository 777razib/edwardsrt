import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class AudioAppBarWidget extends StatelessWidget {
  const AudioAppBarWidget({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  final String title;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Back Button
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onBackPressed ?? () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
            padding: EdgeInsets.zero,
            splashRadius: 24,
          ),
        ),

        const SizedBox(width: 12),

        // Title
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}