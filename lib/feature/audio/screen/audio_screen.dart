import 'dart:async';

import 'package:edwardsrt/feature/home/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../widget/audio_app_bar_widget.dart';
import '../widget/audio_winer_widger.dart';
import '../widget/custom_liner_progress_indicator_widget.dart';

class AudioScreen extends StatefulWidget {
  final Session session;

  const AudioScreen({
    super.key,
    required this.session,
  });

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      // When the audio is loaded, the duration will be available.
      await _audioPlayer.setAsset(widget.session.audioPath);
      _audioPlayer.play();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  void _handlePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/21. Home - V2-3.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: AudioAppBarWidget(
                  title: widget.session.title,
                  onBackPressed: () {
                    _audioPlayer.stop();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                widget.session.image,
                width: 180,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 180,
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.music_note, size: 60, color: Colors.grey),
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
                     Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => AudioWinerWidget(session: widget.session),
                        ),
                      );
                  });
                }

                return StreamBuilder<Duration>(
                  stream: _audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration = _audioPlayer.duration ?? widget.session.duration;
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
      ),
    );
  }
}
