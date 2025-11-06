// lib/feature/media/audio/controller/audio_paly_api_controller.dart

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/network_caller/network_config.dart';
import '../../../../core/network_path/natwork_path.dart';
import '../../../choose interest/model/choose_interest_response_model.dart';


class AudioPlayApiController extends GetxController {
  final chooseInterestItem = Rxn<ChooseInterestItem>();
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  String format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  // Player - initialize once
  final AudioPlayer player = AudioPlayer();
  final isPlaying = false.obs;
  final duration = Duration.zero.obs;
  final position = Duration.zero.obs;

  bool _initialized = false;

  @override
  void onInit() {
    super.onInit();
    _setupStreams();
  }

  void _setupStreams() {
    if (_initialized) return;
    player.positionStream.listen((p) => position.value = p);
    player.durationStream.listen((d) => duration.value = d ?? Duration.zero);
    player.playerStateStream.listen((state) => isPlaying.value = state.playing);
    _initialized = true;
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  Future<void> audioPlayApiMethod(String id) async {
    if (id.isEmpty) {
      errorMessage.value = 'Invalid ID';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;
    chooseInterestItem.value = null;

    _setupStreams(); // safe
    await player.stop();

    try {
      final response = await NetworkCall.getRequest(url: Urls.singleAudio(id));

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData! as Map<String, dynamic>;
        final item = ChooseInterestItem.fromJson(data);
        chooseInterestItem.value = item;

        final audioUrl = item.audio ?? '';
        if (audioUrl.isNotEmpty) {
          await player.setUrl(audioUrl);
          print('Audio loaded: $audioUrl');
        } else {
          errorMessage.value = 'No audio URL';
        }
      } else {
        errorMessage.value = response.errorMessage ?? 'Failed';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void togglePlayPause() => player.playing ? player.pause() : player.play();

  void seekTo(double progress) {
    final dur = duration.value;
    if (dur == Duration.zero) return;
    player.seek(Duration(seconds: (dur.inSeconds * progress).round()));
  }
}

