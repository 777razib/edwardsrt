// lib/features/home/widget/audio_play_widget.dart
import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/services_class/shared_preferences_helper.dart';
import '../controller/audio_controller.dart';

class AudioPlayWidget extends StatefulWidget {
  const AudioPlayWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.audioUrl,
  });

  final String image;
  final String title;
  final String subTitle;
  final String audioUrl;

  @override
  State<AudioPlayWidget> createState() => _AudioPlayWidgetState();
}

class _AudioPlayWidgetState extends State<AudioPlayWidget> {
  YoutubePlayerController? _ytController;
  final GlobalAudioController _globalController = Get.put(GlobalAudioController());
  bool _isInitialized = false;
  bool _isPlayerReady = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initYouTubePlayer();
  }

  String _fixLocalhost(String url) {
    if (url.contains('127.0.0.1') || url.contains('localhost')) {
      return url.replaceAll('127.0.0.1', '10.0.2.2').replaceAll('localhost', '10.0.2.2');
    }
    return url;
  }

  Future<void> _initYouTubePlayer() async {
    try {
      final fixedUrl = _fixLocalhost(widget.audioUrl);
      final videoId = YoutubePlayer.convertUrlToId(fixedUrl);

      if (videoId == null) throw "Invalid YouTube URL";

      debugPrint("Initializing YouTube Player: $videoId");

      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false,
          showLiveFullscreenButton: false,
          controlsVisibleAtStart: false,
          hideControls: true,
        ),
      );

      // Add listener to track ready state
      _ytController!.addListener(_youtubeListener);

      _globalController.registerYouTubePlayer(_ytController!);

      setState(() {
        _isInitialized = true;
        _error = null;
      });
    } catch (e) {
      debugPrint("YouTube init error: $e");
      setState(() {
        _error = "Failed to load: $e";
        _isInitialized = true;
      });
    }
  }

  void _youtubeListener() {
    if (!mounted || _ytController == null) return;

    final value = _ytController!.value;

    // Update ready state
    if (value.isReady && !_isPlayerReady) {
      setState(() {
        _isPlayerReady = true;
      });
    }
  }

  Future<void> _togglePlayPause() async {
    if (_ytController == null || !_isInitialized) return;

    try {
      await _globalController.stopAllExceptYouTube(_ytController!);

      if (_ytController!.value.isPlaying) {
        _ytController!.pause();
      } else {
        _ytController!.play();
      }
    } catch (e) {
      debugPrint("Play error: $e");
    }
  }

  @override
  void dispose() {
    _ytController?.removeListener(_youtubeListener);
    _globalController.unregisterYouTubePlayer(_ytController);
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main UI
        Container(
          height: 84,
          width: 327,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.image,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note, color: Colors.grey),
                  ),
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
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
                      widget.title,
                      style: globalTextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.blackColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subTitle,
                      style: globalTextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: AppColors.blackColor.withOpacity(0.8)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Play/Pause Button
              _ytController == null || !_isInitialized
                  ? const SizedBox(
                width: 48,
                height: 48,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
              )
                  : _error != null
                  ? GestureDetector(
                onTap: _initYouTubePlayer,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.refresh, color: Colors.red),
                ),
              )
                  : ValueListenableBuilder<YoutubePlayerValue>(
                valueListenable: _ytController!,
                builder: (context, value, child) {
                  final isPlaying = value.isPlaying;
                  // Only show loading if player is truly not ready (not just unknown state)
                  // Unknown state can happen even when player is functional
                  final isLoading = !_isPlayerReady && !value.isReady;

                  if (isLoading) {
                    return const SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                    );
                  }

                  return GestureDetector(
                    onTap: _togglePlayPause,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Hidden YouTube Player (MUST BE IN WIDGET TREE)
        // YouTube requires minimum size for IFrame to initialize properly
        if (_ytController != null && _isInitialized)
          Positioned(
            top: MediaQuery.of(context).size.height + 100, // Off-screen but in viewport
            left: 0,
            child: IgnorePointer(
              ignoring: true,
              child: SizedBox(
                width: 320, // Minimum size for YouTube IFrame
                height: 180, // Minimum size for YouTube IFrame
                child: Opacity(
                  opacity: 0.01, // Very low but not 0
                  child: YoutubePlayer(
                    controller: _ytController!,
                    showVideoProgressIndicator: false,
                    onReady: () {
                      debugPrint("YouTube Player Ready: ${_ytController!.initialVideoId}");
                      if (mounted) {
                        setState(() {
                          _isPlayerReady = true;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}