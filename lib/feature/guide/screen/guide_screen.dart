// lib/feature/guide/ui/guide_screen.dart
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../widget/app_guide_widget.dart';
import '../widget/session_guide_widget.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  // Track which tab is selected: 0 = Section Guide, 1 = App Guide
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF3),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          " Session Guide",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // === Toggle Buttons: Section Guide | App Guide ===
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildTabButton(
                  title: "Section Guide",
                  isSelected: selectedTab == 0,
                  onTap: () => setState(() => selectedTab = 0),
                ),
                const SizedBox(width: 12),
                _buildTabButton(
                  title: "App Guide",
                  isSelected: selectedTab == 1,
                  onTap: () => setState(() => selectedTab = 1),
                ),
              ],
            ),
          ),

          // === Content Area ===
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: selectedTab == 0
                  ?  SessionGuideWidget()
                  :  AppGuideWidget(),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Tab Button
  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary, width: 1.5),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

