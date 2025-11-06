// widget/choose_interest_widget.dart
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class ChooseInterestWidget extends StatelessWidget {
  const ChooseInterestWidget({
    super.key,
    required this.image,
    required this.text,
    required this.isSelect,
    required this.onTap,
  });

  final String image;
  final String text;
  final bool isSelect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Image + Overlay + Border
          Container(
            height: 142,
            width: 183.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isSelect
                  ? Border.all(color: AppColors.primary, width: 2.0)
                  : Border.all(color: Colors.transparent, width: 2.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.image, color: Colors.grey, size: 40));
                    },
                  ),
                  // Overlay when selected
                  if (isSelect)
                    Container(
                      color: AppColors.primary.withOpacity(0.6),
                    ),
                ],
              ),
            ),
          ),

          // Text at bottom-right
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            top: 8,
            child: Center(
              child: Text(
                text,
                style:  TextStyle(
                  color: Color(0xFFFFFFF3),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
              ),
            ),
          ),


          // Optional: Check icon when selected
          if (isSelect)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.check_circle, color: Colors.white, size: 24),
            ),
        ],
      ),
    );
  }
}