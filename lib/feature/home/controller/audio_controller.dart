// lib/core/controllers/global_audio_controller.dart
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class GlobalAudioController extends GetxController {
  final List<AudioPlayer> _activePlayers = [];

  void registerPlayer(AudioPlayer player) {
    if (!_activePlayers.contains(player)) {
      _activePlayers.add(player);
    }
  }

  void unregisterPlayer(AudioPlayer player) {
    _activePlayers.remove(player);
  }

  Future<void> stopAllExcept(AudioPlayer current) async {
    for (final player in _activePlayers) {
      if (player != current && player.playing) {
        await player.pause();
      }
    }
  }

  @override
  void onClose() {
    for (final player in _activePlayers) {
      player.dispose();
    }
    super.onClose();
  }
}