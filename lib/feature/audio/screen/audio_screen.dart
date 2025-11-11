// lib/feature/audio/screen/audio_screen.dart

import 'dart:async';
import 'package:edwardsrt/feature/home/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:just_audio/just_audio.dart';
import '../controller/single_audio_api_controller.dart';
import '../widget/audio_app_bar_widget.dart';
import '../widget/audio_winer_widger.dart';
import '../widget/custom_liner_progress_indicator_widget.dart';

class AudioScreen extends StatefulWidget {
  final String id;

  const AudioScreen({
    super.key,
    required this.id,
  });

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late final AudioPlayer _audioPlayer;
  final SingleAudioApiController controller = Get.put(SingleAudioApiController());

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      await controller.singleAudioApiMethod(widget.id);
      if (controller.topPlayList.isNotEmpty && mounted) {
        final audioUrl = controller.topPlayList[0].file;
        await _audioPlayer.setUrl(audioUrl);
        _audioPlayer.play();
      }
    } catch (e) {
      debugPrint("Audio Load Error: $e");
      if (mounted) Get.snackbar("Error", "Failed to load audio.");
    }
  }

  void _handlePlayPause() {
    _audioPlayer.playing ? _audioPlayer.pause() : _audioPlayer.play();
  }

  void _handleSeek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        // Loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        // Empty
        if (controller.topPlayList.isEmpty) {
          return const Center(
            child: Text(
              "Audio not found.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final audioItem = controller.topPlayList[0];

        return Stack(
          fit: StackFit.expand,
          children: [
            // Background
            Image.asset(
              "assets/images/21. Home - V2-3.png",
              fit: BoxFit.cover,
            ),

            // App Bar
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

            // Thumbnail
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
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note, size: 60),
                  ),
                ),
              ),
            ),

            // Progress + Controls
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

                  // On Complete → Go to Winner
                  if (processingState == ProcessingState.completed) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;

                      final session = Session(
                        image: audioItem.thumbnail,
                        title: audioItem.title,
                        subtitle: "Your session is complete. Well done!",
                        duration: _audioPlayer.duration ?? Duration.zero,
                        audioPath: audioItem.file,
                      );

                      Get.off(() => AudioWinerWidget(session: session));
                    });
                  }

                  return StreamBuilder<Duration>(
                    stream: _audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;

                      // Use player duration, NOT API
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
