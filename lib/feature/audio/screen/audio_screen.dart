// lib/feature/audio/screen/audio_screen.dart
import 'dart:async';
import 'package:edwardsrt/feature/home/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;
import '../controller/single_audio_api_controller.dart';
import '../widget/audio_app_bar_widget.dart';
import '../widget/audio_winer_widger.dart';
import '../widget/custom_liner_progress_indicator_widget.dart';

class AudioScreen extends StatefulWidget {
  final String id;
  const AudioScreen({super.key, required this.id});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late final AudioPlayer _audioPlayer;
  final SingleAudioApiController controller = Get.put(SingleAudioApiController());
  final yt.YoutubeExplode _yt = yt.YoutubeExplode();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      if (controller.topPlayList.isEmpty) {
        await controller.singleAudioApiMethod(widget.id);
      }
      if (!mounted || controller.topPlayList.isEmpty) return;

      final audioItem = controller.topPlayList[0];
      final url = audioItem.file.trim();

      if (url.isEmpty) {
        _showError("Audio URL is empty");
        return;
      }

      if (url.contains('youtube.com') || url.contains('youtu.be')) {
        await _loadYouTubeAudio(url);
      } else {
        await _audioPlayer.setUrl(url);
        if (mounted) _audioPlayer.play();
      }
    } catch (e) {
      _showError("Failed to load audio: $e");
    }
  }

  Future<void> _loadYouTubeAudio(String url) async {
    try {
      final videoId = yt.VideoId(url);
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      
      // Corrected: Simply get the highest bitrate audio-only stream
      final streamInfo = manifest.audioOnly.withHighestBitrate();

      await _audioPlayer.setUrl(streamInfo.url.toString());
      if (mounted) _audioPlayer.play();

    } catch (e) {
      debugPrint("YouTube Error: $e");
      if (mounted) {
        Get.snackbar(
          "YouTube Error",
          "Cannot play YouTube audio.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        controller.errorMessage.value = "YouTube playback failed";
      }
    }
  }

  void _handlePlayPause() {
    _audioPlayer.playing ? _audioPlayer.pause() : _audioPlayer.play();
  }

  void _handleSeek(Duration position) {
    _audioPlayer.seek(position);
  }

  void _showError(String msg) {
    if (mounted) {
      controller.errorMessage.value = msg;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        if (controller.isLoading.value && controller.topPlayList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (controller.topPlayList.isEmpty) {
          return Center(
            child: Text("Audio not found.".tr, style: const TextStyle(color: Colors.white)),
          );
        }

        final audioItem = controller.topPlayList[0];

        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/images/21. Home - V2-3.png", fit: BoxFit.cover),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: AudioAppBarWidget(
                    title: audioItem.title,
                    onBackPressed: () {
                      _audioPlayer.stop();
                      Get.back();
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  audioItem.thumbnail,
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 180,
                    height: 180,
                    color: Colors.grey[700],
                    child: const Icon(Icons.music_note, size: 60, color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: StreamBuilder<PlayerState>(
                stream: _audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final isPlaying = playerState?.playing ?? false;
                  final processingState = playerState?.processingState;

                  if (processingState == ProcessingState.completed) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;

                      final session = Session(
                        image: audioItem.thumbnail,
                        title: audioItem.title,
                        subtitle: audioItem.afterText,
                        duration: _audioPlayer.duration ?? Duration.zero,
                        audioPath: audioItem.file,
                      );

                      _audioPlayer.stop();
                      Get.off(() => AudioWinerWidget(session: session));
                    });
                  }

                  return StreamBuilder<Duration>(
                    stream: _audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = _audioPlayer.duration ?? const Duration(seconds: 30);

                      return CustomLinerProgressIndicatorWidget(
                        startTime: position,
                        endTime: duration,
                        isPlaying: isPlaying,
                        onPlayPause: _handlePlayPause,
                        onSeek: _handleSeek,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
