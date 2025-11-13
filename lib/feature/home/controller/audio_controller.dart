// lib/core/controllers/global_audio_controller.dart
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GlobalAudioController extends GetxController {
  final List<AudioPlayer> _activePlayers = [];
  final List<YoutubePlayerController> _activeYouTubePlayers = [];

  void registerPlayer(AudioPlayer player) {
    if (!_activePlayers.contains(player)) {
      _activePlayers.add(player);
    }
  }

  void unregisterPlayer(AudioPlayer player) {
    _activePlayers.remove(player);
  }

  void registerYouTubePlayer(YoutubePlayerController controller) {
    if (!_activeYouTubePlayers.contains(controller)) {
      _activeYouTubePlayers.add(controller);
    }
  }

  void unregisterYouTubePlayer(YoutubePlayerController? controller) {
    if (controller != null) {
      _activeYouTubePlayers.remove(controller);
    }
  }

  Future<void> stopAllExcept(AudioPlayer current) async {
    for (final player in _activePlayers) {
      if (player != current && player.playing) {
        await player.pause();
      }
    }
  }

  Future<void> stopAllExceptYouTube(YoutubePlayerController current) async {
    // Stop all other YouTube players
    for (final controller in _activeYouTubePlayers) {
      if (controller != current && controller.value.isPlaying) {
        controller.pause();
      }
    }
    // Also stop all AudioPlayer instances
    for (final player in _activePlayers) {
      if (player.playing) {
        await player.pause();
      }
    }
  }

  @override
  void onClose() {
    for (final player in _activePlayers) {
      player.dispose();
    }
    for (final controller in _activeYouTubePlayers) {
      controller.dispose();
    }
    super.onClose();
  }
}