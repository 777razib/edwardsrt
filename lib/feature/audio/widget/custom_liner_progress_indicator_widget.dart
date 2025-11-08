import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:flutter/material.dart';

class CustomLinerProgressIndicatorWidget extends StatelessWidget {
  const CustomLinerProgressIndicatorWidget({
    super.key,
    this.startTime = const Duration(minutes: 0),
    this.endTime = const Duration(minutes: 10),
    this.onPrevious,
    this.onNext,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onSeek,
  });

  final Duration startTime;
  final Duration endTime;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final void Function(Duration) onSeek;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final double progress = endTime.inSeconds > 0 ? startTime.inSeconds / endTime.inSeconds : 0.0;

    return Column(
      children: [
        // === Horizontal Progress Bar ===
        GestureDetector(
          onTapDown: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final Offset localOffset = box.globalToLocal(details.globalPosition);
            final double newProgress = localOffset.dx / box.size.width;
            final Duration newPosition = endTime * newProgress;
            onSeek(newPosition);
          },
          onHorizontalDragUpdate: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final Offset localOffset = box.globalToLocal(details.globalPosition);
            final double newProgress = (localOffset.dx / box.size.width).clamp(0.0, 1.0);
            final Duration newPosition = endTime * newProgress;
            onSeek(newPosition);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Background Track
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Progress Fill
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xff2399F6), // Blue progress
                      borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ),

                // Thumb (White Circle)
                FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Align(
                    alignment: Alignment(progress * 2 - 1, 0), // -1 to 1
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // === Time Labels ===
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(startTime),
                style: globalTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.whiteColor,
                ),
              ),
              Text(
                _formatDuration(endTime),
                style: globalTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.whiteColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // === Control Buttons ===
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
            ),

            const SizedBox(width: 30),

            // Play/Pause Button
            GestureDetector(
              onTap: onPlayPause,
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff2399F6), Color(0xff1E88E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 30),

            // Next
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
            ),
          ],
        ),
      ],
    );
  }
}
