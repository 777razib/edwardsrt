import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/style/text_style.dart';
import '../../../audio/widget/audio_app_bar_widget.dart';
import '../../../audio/widget/custom_liner_progress_indicator_widget.dart';
import '../controller/audio_paly_api_controller.dart';

class AudioPlayScreen extends StatefulWidget {
  final int audioId;

  const AudioPlayScreen({super.key, required this.audioId});

  @override
  State<AudioPlayScreen> createState() => _AudioPlayScreenState();
}

class _AudioPlayScreenState extends State<AudioPlayScreen> {
  final AudioPlayApiController audioController = Get.put(AudioPlayApiController());

  @override
  void initState() {
    super.initState();
    audioController.fetchAndPlayAudio(widget.audioId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: AudioAppBarWidget(
            title: 'Now Playing',
            onBackPressed: () => Get.back(),
          ),
        ),
      ),
      body: Obx(() {
        if (audioController.isLoading.value && audioController.audio.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (audioController.errorMessage.value != null) {
          return Center(
            child: Text(audioController.errorMessage.value!),
          );
        }

        if (audioController.audio.value == null) {
          return const Center(child: Text('Audio not found.'));
        }

        final audio = audioController.audio.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  audio.thumbnail,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.music_note, size: 100, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              Text(audio.title, style: globalTextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(audio.description, style: globalTextStyle(fontSize: 16, color: Colors.grey.shade700), textAlign: TextAlign.center),
              const SizedBox(height: 40),
              CustomLinerProgressIndicatorWidget(
                startTime: audioController.position.value,
                endTime: audioController.duration.value,
                isPlaying: audioController.isPlaying.value,
                onPlayPause: audioController.togglePlayPause,
                onSeek: audioController.seekTo,
              ),
              const SizedBox(height: 40),
              // Additional UI elements can go here
            ],
          ),
        );
      }),
    );
  }
}
