import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

import '../../../../core/network_path/natwork_path.dart';

// --- Model ---
class AudioModel {
  final int id;
  final String title;
  final String audio;
  final String description;
  final String thumbnail;

  AudioModel({
    required this.id,
    required this.title,
    required this.audio,
    required this.description,
    required this.thumbnail,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      audio: json['audio'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}

// --- Controller ---
class AudioPlayApiController extends GetxController {
  // API State
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var audio = Rx<AudioModel?>(null);

  // Player State
  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxBool isPlaying = false.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToPlayerState();
  }

  @override
  void onClose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _audioPlayer.dispose();
    super.onClose();
  }

  void _listenToPlayerState() {
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
    _positionSubscription = _audioPlayer.positionStream.listen((pos) {
      position.value = pos;
    });
    _durationSubscription = _audioPlayer.durationStream.listen((dur) {
      duration.value = dur ?? Duration.zero;
    });
  }

  // --- Public Methods ---
  Future<void> fetchAndPlayAudio(int id) async {
    isLoading(true);
    errorMessage(null);
    await _audioPlayer.stop(); // Stop previous audio

    try {
      final response = await http.get(Uri.parse('${Urls.singleAudio}/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        audio.value = AudioModel.fromJson(data);
        if (audio.value != null && audio.value!.audio.isNotEmpty) {
          await _audioPlayer.setUrl(audio.value!.audio);
          _audioPlayer.play();
        }
      } else {
        errorMessage.value = "Failed to load audio. Status: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading(false);
    }
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void seekTo(Duration position) {
    _audioPlayer.seek(position);
  }
  
  String format(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
