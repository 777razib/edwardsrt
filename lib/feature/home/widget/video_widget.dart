import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoWidget extends StatefulWidget {
  final String title;
  final String date;
  final String subTitle;
  final String videoUrl;

  const VideoWidget({
    super.key,
    required this.title,
    required this.date,
    required this.subTitle,
    required this.videoUrl,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.videoUrl.isEmpty) return;

    _videoController = VideoPlayerController.network(widget.videoUrl);
    try {
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: false,
        looping: false,
        aspectRatio: 16 / 9,
        allowFullScreen: true,
        // ✅ MODIFIED: Show Chewie's default controls (includes seek bar, duration, volume)
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
          handleColor: Colors.blueAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightBlue,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );

      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint("Video Error: $e");
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 144,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Video Player (Background)
            _isInitialized
                ? SizedBox(
              width: double.infinity,
              height: 144,
              child: Chewie(controller: _chewieController!),
            )
                : Container(
              height: 144,
              color: Colors.black,
              child: const Center(child: CircularProgressIndicator()),
            ),

            // ❌ REMOVED: Custom Play/Pause Overlay is removed
            // as Chewie's default controls now handle playback and display.

            // Title - Top Left (Custom Overlay)
            Positioned(
              top: 8,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF686868).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Date - Top Right (Custom Overlay)
            Positioned(
              top: 8,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF686868).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
            ),

            // Subtitle - Bottom (Custom Overlay)
            Positioned(
              bottom: 0, // Pushed to the very bottom
              left: 0,
              right: 0,
              // Note: The Chewie controls will display on top of this subtitle
              // when they appear, which is standard video player UI behavior.
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: Colors.black.withOpacity(0.6),
                child: Text(
                  widget.subTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}