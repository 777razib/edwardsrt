// lib/features/home/widget/audio_play_widget.dart
import 'package:edwardsrt/core/app_colors.dart';
import 'package:edwardsrt/core/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
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
  late final AudioPlayer _audioPlayer;
  late final GlobalAudioController _globalController=Get.put(GlobalAudioController());
  bool _isInitialized = false;
  final YoutubeExplode _yt = YoutubeExplode();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _globalController ;
    _globalController.registerPlayer(_audioPlayer);
    _initAudio();
  }

  String _fixLocalhost(String url) {
    if (url.contains('127.0.0.1') || url.contains('localhost')) {
      return url.replaceAll('127.0.0.1', '10.0.2.2').replaceAll('localhost', '10.0.2.2');
    }
    return url;
  }

  String _forceHttps(String url) {
    return url.replaceFirst('http://', 'https://');
  }

  Future<String> _getStreamUrl(String url) async {
    final fixedUrl = _fixLocalhost(url);
    debugPrint("Original URL: $url → Fixed: $fixedUrl");

    // YouTube URL?
    if (fixedUrl.contains('youtube.com') || fixedUrl.contains('youtu.be')) {
      try {
        final videoId = VideoId(fixedUrl); // Corrected

        final manifest = await _yt.videos.streams.getManifest(videoId);

        // Try HTTPS audio stream
        final audioStreams = manifest.audioOnly
            .where((s) => s.url.toString().startsWith('https'))
            .toList();

        if (audioStreams.isNotEmpty) {
          return audioStreams.withHighestBitrate().url.toString();
        }

        // Fallback: Force HTTPS
        final fallback = manifest.audioOnly.withHighestBitrate().url.toString();
        return _forceHttps(fallback);
      } catch (e) {
        debugPrint("YouTube extract failed: $e");
        rethrow;
      }
    }

    // Direct URL (MP3, HLS, etc.)
    return fixedUrl;
  }

  Future<void> _initAudio() async {
    if (_audioPlayer.processingState == ProcessingState.loading ||
        _audioPlayer.processingState == ProcessingState.buffering ||
        _audioPlayer.playing) return;

    setState(() => _isInitialized = false);

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final streamUrl = await _getStreamUrl(widget.audioUrl);

      final headers = {
        'Accept': '*/*',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(streamUrl), headers: headers),
      );

      debugPrint("Audio source loaded: $streamUrl");
      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint("Audio init error: $e");
      setState(() => _isInitialized = true);
    }
  }

  Future<void> _togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _globalController.stopAllExcept(_audioPlayer);
      if (_audioPlayer.audioSource == null) {
        await _initAudio();
        if (!_isInitialized) return;
      }
      await _audioPlayer.play();
    }
  }

  @override
  void dispose() {
    _globalController.unregisterPlayer(_audioPlayer);
    _audioPlayer.dispose();
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
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
                  style: globalTextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: AppColors.blackColor.withOpacity(0.8)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing ?? false;

              if (!_isInitialized ||
                  processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return const SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                );
              }

              if (snapshot.hasError ||
                  (processingState == ProcessingState.idle && _audioPlayer.audioSource == null)) {
                return GestureDetector(
                  onTap: _initAudio,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.refresh, color: Colors.red),
                  ),
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
                    playing ? Icons.pause : Icons.play_arrow,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
