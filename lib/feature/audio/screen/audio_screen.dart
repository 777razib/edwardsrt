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
  Duration _cachedDuration = Duration.zero;

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

      // Reset cached duration for new audio
      _cachedDuration = Duration.zero;

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
      
      // Wait for controller to initialize and metadata to load
      // Try multiple times to get duration
      for (int i = 0; i < 5; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted && _ytController != null) {
          final durationSeconds = _ytController!.value.metaData.duration.inSeconds;
          if (durationSeconds > 30) {
            _cachedDuration = Duration(seconds: durationSeconds);
            debugPrint("Duration loaded during init (attempt ${i + 1}): ${_cachedDuration.inHours}h ${_cachedDuration.inMinutes.remainder(60)}m ${_cachedDuration.inSeconds.remainder(60)}s");
            break;
          }
        }
      }
      
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

    // Cache duration when it becomes available
    // Only update if duration is reasonable (more than 30 seconds) to avoid initial wrong values
    final durationSeconds = value.metaData.duration.inSeconds;
    if (durationSeconds > 30 && _cachedDuration.inSeconds != durationSeconds) {
      _cachedDuration = Duration(seconds: durationSeconds);
      debugPrint("Duration updated: ${_cachedDuration.inHours}h ${_cachedDuration.inMinutes.remainder(60)}m ${_cachedDuration.inSeconds.remainder(60)}s (${durationSeconds}s total)");
      if (mounted) {
        setState(() {}); // Trigger rebuild to update UI
      }
    } else if (durationSeconds > 0 && durationSeconds <= 30 && _cachedDuration.inSeconds == 0) {
      // Log but don't cache short durations (likely initial wrong value)
      debugPrint("Ignoring initial duration: ${durationSeconds}s (too short, likely wrong)");
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

    // Check if audio has ended - multiple ways to detect
    final duration = _cachedDuration.inSeconds > 0 ? _cachedDuration.inSeconds : durationSeconds;
    final position = value.position.inSeconds;
    
    // Method 1: Check player state
    if (value.playerState == PlayerState.ended) {
      _handleAudioEnd();
      return;
    }

    // Method 2: Check if position reached duration (with small tolerance)
    if (duration > 0 && position > 0 && position >= duration - 1) {
      _handleAudioEnd();
      return;
    }

    // Check for unplayable state (error indicator)
    if (value.playerState == PlayerState.unknown) {
      debugPrint("YouTube Player State: Unknown - may indicate error");
    }
  }

  void _handleAudioEnd() {
    if (!mounted || controller.topPlayList.isEmpty) return;
    
    // Prevent multiple calls
    _ytController?.removeListener(_youtubeListener);
    
    final audioItem = controller.topPlayList[0];
    final session = Session(
      image: audioItem.thumbnail,
      title: audioItem.title,
      subtitle: audioItem.afterText,
      duration: Duration(seconds: _ytController?.value.metaData.duration.inSeconds ?? 0),
      audioPath: audioItem.file,
    );
    
    // Small delay to ensure UI updates
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Get.off(() => AudioWinerWidget(session: session));
      }
    });
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
                        // Wait for metadata to load properly
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          if (mounted && _ytController != null) {
                            final durationSeconds = _ytController!.value.metaData.duration.inSeconds;
                            // Only cache if duration is reasonable (more than 30 seconds)
                            if (durationSeconds > 30) {
                              _cachedDuration = Duration(seconds: durationSeconds);
                              debugPrint("Duration loaded in onReady: ${_cachedDuration.inHours}h ${_cachedDuration.inMinutes.remainder(60)}m ${_cachedDuration.inSeconds.remainder(60)}s (${durationSeconds}s total)");
                            } else if (durationSeconds > 0) {
                              debugPrint("Duration in onReady too short (${durationSeconds}s), waiting for update...");
                            }
                            setState(() {
                              _isControllerReady = true;
                            });
                          }
                        });
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
                  
                  // Use cached duration if available and valid, otherwise try metadata (but ignore short durations)
                  final metaDurationSeconds = value.metaData.duration.inSeconds;
                  final durationSeconds = _cachedDuration.inSeconds > 0 
                      ? _cachedDuration.inSeconds 
                      : (metaDurationSeconds > 30 ? metaDurationSeconds : 0);
                  
                  final duration = durationSeconds > 0
                      ? Duration(seconds: durationSeconds)
                      : Duration.zero;

                  // Only show progress bar if we have valid duration (more than 30 seconds)
                  if (duration.inSeconds == 0 || duration.inSeconds <= 30) {
                    return const SizedBox(); // Hide until valid duration is loaded
                  }

                  // Debug log periodically
                  if (position.inSeconds % 10 == 0 && position.inSeconds > 0) {
                    debugPrint("Progress: ${position.inSeconds}s / ${duration.inSeconds}s");
                  }

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