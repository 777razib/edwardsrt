import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class AudioImageWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? date;
  final String? episodes;          // kept for old code – can be removed later
  final int? durationSec;          // <-- NEW
  final String imageUrl;
  final VoidCallback onTap;

  const AudioImageWidget({
    super.key,
    this.title,
    this.subTitle,
    this.date,
    this.episodes,
    this.durationSec,
    required this.imageUrl,
    required this.onTap,
  });

  // --------------------------------------------------------------
  // Helper: 123 sec → "2m 3s"
  // --------------------------------------------------------------
  String _formatDuration(int? sec) {
    if (sec == null || sec <= 0) return '';
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    // Responsive width (same as before)
    final screenWidth = MediaQuery.of(context).size.width;
    final widgetWidth = screenWidth > 400 ? 327.0 : (screenWidth - 48) / 2;
    final imageHeight = widgetWidth * (144 / 327);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: widgetWidth,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------- IMAGE -------------------
              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: imageHeight,
                      placeholder: (_, __) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.music_note,
                            size: 40, color: Colors.grey),
                      ),
                    ),
                    // Play icon (uncomment if you want it)
                    /*
                    const Positioned.fill(
                      child: Center(
                        child: Icon(Icons.play_circle_filled,
                            size: 40, color: Colors.white),
                      ),
                    ),
                    */
                  ],
                ),
              ),

              // ------------------- TEXT SECTION -------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    if (title != null && title!.isNotEmpty)
                      Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 2),

                    // Subtitle
                    if (subTitle != null && subTitle!.isNotEmpty)
                      Text(
                        subTitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),

                    // ----- DATE + DURATION (right-aligned) -----
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Episodes (old field – optional)
                        if (episodes != null && episodes!.isNotEmpty)
                          Text(
                            episodes!,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          )
                        else
                          const SizedBox.shrink(),

                        // Date + Duration
                        Row(
                          children: [
                            // Duration (new)
                            if (durationSec != null && durationSec! > 0)
                              Text(
                                _formatDuration(durationSec),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            if (durationSec != null && durationSec! > 0 && date != null && date!.isNotEmpty)
                              const SizedBox(width: 8),

                            // Date
                            if (date != null && date!.isNotEmpty)
                              Text(
                                date!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ],
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