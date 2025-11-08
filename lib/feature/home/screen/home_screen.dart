import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:flutter/material.dart';

import '../widget/app_bar.dart';
import '../widget/audio_play_widget.dart';
import '../widget/play_dialog_box_widget.dart';
import '../widget/purchase_now_button_widget.dart';
import '../widget/treatments_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample data
  final List<Map<String, String>> treatments = [
    {
      'image': 'assets/images/image (1).png',
      'title': 'Sleep Therapy',
      'buttonText': 'HOW TO',
    },
    {
      'image': 'assets/images/image (2).png',
      'title': 'Stress Relief',
      'buttonText': 'TRY NOW',
    },
    {
      'image': 'assets/images/image (3).png',
      'title': 'Mindfulness',
      'buttonText': 'START',
    },
  ];

  final List<Map<String, String>> topPlaylists = List.generate(10, (index) => {
    'image': 'assets/images/image (2).png',
    'title': 'Relax Session ${index + 1}',
    'subTitle': '${5 + (index % 3) * 5}-10 Min',
  });

  int _currentlyPlayingIndex = -1;

  void _onPlayToggle(int index, bool isPlaying) {
    setState(() {
      _currentlyPlayingIndex = isPlaying ? index : -1;
    });
    debugPrint(isPlaying ? 'Playing $index' : 'Paused');
  }

  // Correct: Defined outside build()
  void _showPlaySessionDialog() {
    showDialog(
      context: context, // `context` already available in State
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child:  PlayDialogBoxWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            const HomeAppBar(
              profileImage: 'assets/images/WhatsApp Image 2025-11-08 at 10.06.03_1d0d3929.jpg',
              title: "Hey John",
              subtitle: "What do you want to hear today?",
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Purchase Card
                    const PurchaseNowButtonWidget(
                      title: "One purchase.",
                      subTitle: "Endless relaxation",
                      buttonText: "Purchase now",
                      onTap: null,
                    ),
                    const SizedBox(height: 24),

                    // Treatments Section
                    Text(
                      "Treatments",
                      style: globalTextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Horizontal Treatments
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: treatments.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final item = treatments[index];
                          return TreatmentsWidget(
                            image: item['image']!,
                            title: item['title']!,
                            buttonText: item['buttonText']!,
                            onTap: _showPlaySessionDialog, // Correct callback
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Top Playlists Section
                    Text(
                      "Top Playlists",
                      style: globalTextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Vertical Audio List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: topPlaylists.length,
                      itemBuilder: (context, index) {
                        final item = topPlaylists[index];
                        final isPlaying = _currentlyPlayingIndex == index;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AudioPlayWidget(
                            image: item['image']!,
                            title: item['title']!,
                            subTitle: item['subTitle']!,
                            onPlayToggle: (playing) => _onPlayToggle(index, playing),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}