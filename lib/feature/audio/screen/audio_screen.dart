import 'package:cached_network_image/cached_network_image.dart';
import 'package:edwardsrt/feature/home/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
  YoutubePlayerController? _ytController;
  final SingleAudioApiController controller = Get.put(SingleAudioApiController());
  bool _isControllerReady = false;

  @override
  void initState() {
    super.initState();
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

      debugPrint("Loading YouTube URL: $url");

      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId == null) {
        _showError("Invalid YouTube URL: $url");
        return;
      }

      debugPrint("Extracted Video ID: $videoId");

      // Dispose previous controller if exists
      _ytController?.removeListener(_youtubeListener);
      _ytController?.dispose();

      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: false,
          showLiveFullscreenButton: false,
          controlsVisibleAtStart: false,
          hideControls: true,
          loop: false,
        ),
      );

      _ytController!.addListener(_youtubeListener);
      
      // Wait a bit for controller to initialize
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() {
          _isControllerReady = true;
        });
      }
    } catch (e) {
      debugPrint("Load Audio Error: $e");
      _showError("Failed to load audio: $e");
    }
  }

  void _youtubeListener() {
    if (!mounted || _ytController == null) return;

    final value = _ytController!.value;

    // Update ready state
    if (value.isReady && !_isControllerReady) {
      setState(() {
        _isControllerReady = true;
      });
    }

    // Auto-play fix
    if (value.isReady && !value.isPlaying && value.position.inMilliseconds == 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _ytController != null && _ytController!.value.isReady) {
          try {
            _ytController!.play();
          } catch (e) {
            debugPrint("Play error: $e");
            _showError("Failed to play audio: $e");
          }
        }
      });
    }

    // On End
    if (value.playerState == PlayerState.ended) {
      final audioItem = controller.topPlayList[0];
      final session = Session(
        image: audioItem.thumbnail,
        title: audioItem.title,
        subtitle: audioItem.afterText,
        duration: Duration(seconds: value.metaData.duration.inSeconds),
        audioPath: audioItem.file,
      );
      Get.off(() => AudioWinerWidget(session: session));
    }

    // Check for unplayable state (error indicator)
    if (value.playerState == PlayerState.unknown) {
      debugPrint("YouTube Player State: Unknown - may indicate error");
    }
  }

  void _handlePlayPause() {
    if (_ytController == null) return;
    _ytController!.value.isPlaying ? _ytController!.pause() : _ytController!.play();
  }

  void _handleSeek(Duration position) {
    _ytController?.seekTo(position);
  }

  void _showError(String msg) {
    if (mounted) controller.errorMessage.value = msg;
  }

  @override
  void dispose() {
    _ytController?.removeListener(_youtubeListener);
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
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
            // Background
            Image.asset("assets/images/21. Home - V2-3.png", fit: BoxFit.cover),

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
                      _ytController?.pause();
                      Get.back();
                    },
                  ),
                ),
              ),
            ),

            // Thumbnail (100% Safe)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  imageUrl: audioItem.thumbnail,
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 180,
                    height: 180,
                    color: Colors.grey[700],
                    child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                  ),
                  errorWidget: (_, url, error) {
                    debugPrint("Image load failed: $url → $error");
                    return Container(
                      width: 180,
                      height: 180,
                      color: Colors.grey[700],
                      child: const Icon(Icons.music_note, size: 60, color: Colors.white),
                    );
                  },
                ),
              ),
            ),

            // Hidden YouTube Player (Audio Only)
            if (_ytController != null && _ytController!.initialVideoId.isNotEmpty)
              Positioned(
                top: -9999, // Off-screen
                left: 0,
                child: SizedBox(
                  width: 1,
                  height: 1,
                  child: Opacity(
                    opacity: 0,
                    child: YoutubePlayer(
                      controller: _ytController!,
                      showVideoProgressIndicator: false,
                      onReady: () {
                        debugPrint("YouTube Player Ready");
                        if (mounted) {
                          setState(() {
                            _isControllerReady = true;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),

            // Custom Progress Bar
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: _ytController == null || !_isControllerReady
                  ? const SizedBox()
                  : ValueListenableBuilder<YoutubePlayerValue>(
                valueListenable: _ytController!,
                builder: (context, value, child) {
                  // Skip if not ready or in unknown state
                  if (!value.isReady || value.playerState == PlayerState.unknown) {
                    return const SizedBox();
                  }
                  
                  final position = Duration(seconds: value.position.inSeconds);
                  final duration = value.metaData.duration.inSeconds > 0
                      ? Duration(seconds: value.metaData.duration.inSeconds)
                      : Duration.zero;

                  return CustomLinerProgressIndicatorWidget(
                    startTime: position,
                    endTime: duration,
                    isPlaying: value.isPlaying,
                    onPlayPause: _handlePlayPause,
                    onSeek: _handleSeek,
                    onPrevious: null,
                    onNext: null,
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