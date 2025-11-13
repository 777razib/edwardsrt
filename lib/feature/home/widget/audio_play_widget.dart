// lib/features/home/widget/audio_play_widget.dart
import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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

      _ytController!.addListener(_youtubeListener);
      _globalController.registerYouTubePlayer(_ytController!);

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Failed to load: $e";
          _isInitialized = true;
        });
      }
    }
  }

  void _youtubeListener() {
    if (!mounted || _ytController == null) return;

    final value = _ytController!.value;
    if (value.isReady && !_isPlayerReady) {
      if (mounted) {
        setState(() {
          _isPlayerReady = true;
        });
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (_ytController == null || !_isInitialized || !_isPlayerReady) return;

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                  loadingBuilder: (_, child, progress) =>
                  progress == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              ),
              const SizedBox(width: 16),
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
                      style: globalTextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14, color: AppColors.blackColor.withOpacity(0.8)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildPlayPauseButton(),
            ],
          ),
        ),
        if (_ytController != null && _isInitialized)
          Offstage(
            offstage: true,
            child: YoutubePlayer(
              controller: _ytController!,
              onReady: () {
                if (mounted) {
                  setState(() {
                    _isPlayerReady = true;
                  });
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPlayPauseButton() {
    if (_ytController == null || !_isInitialized) {
      return const SizedBox(
        width: 48,
        height: 48,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
      );
    }

    if (_error != null) {
      return GestureDetector(
        onTap: _initYouTubePlayer,
        child: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(Icons.refresh, color: Colors.red),
        ),
      );
    }

    return ValueListenableBuilder<YoutubePlayerValue>(
      valueListenable: _ytController!,
      builder: (context, value, child) {
        final isPlaying = value.isPlaying;

        if (!_isPlayerReady) {
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
    );
  }
}
