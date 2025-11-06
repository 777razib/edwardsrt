
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../../../core/widgets/custom_appbar.dart';
import '../controller/audio_paly_api_controller.dart';
import '../controller/audio_summary_api_controller.dart';
import 'description_screen.dart';

const kTeal = Color(0xFF39CCCC);

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({
    super.key,
    this.episodeIds,
    this.currentId,
    this.Id,
  });

  final List<String>? episodeIds;
  final String? currentId;
  final String? Id;

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late final AudioPlayApiController audioPlayApiController;
  final AudioSummaryApiController audioSummaryApiController = Get.put(AudioSummaryApiController());

  String currentEpisodeId = '';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    audioPlayApiController = Get.isRegistered<AudioPlayApiController>()
        ? Get.find<AudioPlayApiController>()
        : Get.put(AudioPlayApiController());

    String id = widget.Id ?? widget.currentId ?? widget.episodeIds?.firstOrNull ?? '';
    if (id.isEmpty && widget.episodeIds != null && widget.episodeIds!.isNotEmpty) {
      currentIndex = widget.episodeIds!.indexOf(widget.currentId ?? '');
      if (currentIndex == -1) currentIndex = 0;
      id = widget.episodeIds![currentIndex];
    }

    if (id.isNotEmpty) {
      currentEpisodeId = id;
      _loadEpisode(id);
    } else {
      Get.back();
    }
  }

  Future<void> _loadEpisode(String id) async {
    if (id.isEmpty) return;
    currentEpisodeId = id;
    print('Loading Episode ID: $id');
    await audioPlayApiController.audioPlayApiMethod(id);

    // DEBUG: Only use titleOriginal (as per your model)
    final item = audioPlayApiController.chooseInterestItem.value;
    print("After API Call - Episode Title: ${item?.titleOriginal ?? 'null'}");
    print("Podcast Title: ${item?.podcast?.titleOriginal ?? 'null'}");
  }

  Future<void> _playNext() async {
    final ids = widget.episodeIds ?? [];
    if (ids.isEmpty || currentIndex >= ids.length - 1) return;
    currentIndex++;
    await _loadEpisode(ids[currentIndex]);
  }

  Future<void> _playPrevious() async {
    final ids = widget.episodeIds ?? [];
    if (ids.isEmpty || currentIndex <= 0) return;
    currentIndex--;
    await _loadEpisode(ids[currentIndex]);
  }

  String _format(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFF3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const CustomAppBar(title: Text('')),
              const SizedBox(height: 5),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Loading Indicator
                      Obx(() => audioPlayApiController.isLoading.value
                          ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(color: kTeal),
                      )
                          : const SizedBox()),

                      // Error Message
                      Obx(() => audioPlayApiController.errorMessage.value != null
                          ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          audioPlayApiController.errorMessage.value!,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                          : const SizedBox()),

                      // Album Art
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Obx(() {
                          final item = audioPlayApiController.chooseInterestItem.value;
                          final imageUrl = item?.image ?? '';
                          return Image.network(
                            imageUrl,
                            width: 300,
                            height: 320,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 300,
                                height: 320,
                                color: kTeal.withOpacity(0.12),
                                child: const Center(child: CircularProgressIndicator(color: kTeal)),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              width: 300,
                              height: 320,
                              color: kTeal.withOpacity(0.12),
                              child: const Icon(Icons.image_not_supported, size: 80, color: kTeal),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 30),

                      // Title & Podcast Name (FIXED - Only titleOriginal)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                final item = audioPlayApiController.chooseInterestItem.value;

                                // Use ONLY titleOriginal - as per your model
                                final episodeTitle = item?.title ?? 'Unknown Episode';
                                final podcastTitle = item?.description ?? 'Unknown Podcast';
                                print("------$episodeTitle $podcastTitle");

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      episodeTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      podcastTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),

                            // Summary Button
                            Obx(() => Visibility(
                              visible: !audioSummaryApiController.isLoading.value,
                              replacement: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Please wait...",
                                  style: TextStyle(color: Colors.red, fontSize: 14),
                                ),
                              ),
                              child: IconButton(
                                onPressed: audioSummaryApiController.isLoading.value
                                    ? null
                                    : _summaryApiMethod,
                                icon: Image.asset(
                                  'assets/icons/menu.png',
                                  width: 26,
                                  height: 26,
                                  color: kTeal,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Progress Bar
                      Obx(() {
                        final durSec = audioPlayApiController.duration.value.inSeconds;
                        final posSec = audioPlayApiController.position.value.inSeconds;
                        final progress = durSec > 0 ? posSec / durSec : 0.0;

                        return Column(
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxHeight: 80),
                              child: WaveformProgressBar(
                                progress: progress,
                                onChanged: audioPlayApiController.seekTo,
                                barCount: 80,
                                preferredBarWidth: 3,
                                gap: 2,
                                maxBarHeight: 48,
                                activeColor: kTeal,
                                inactiveColor: kTeal.withOpacity(0.25),
                                thumbRadius: 7,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_format(posSec), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                Text(_format(durSec), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 50),

                      // Control Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Image.asset('assets/icons/shuffle.png', width: 26, height: 26, color: kTeal),
                          ),
                          IconButton(
                            onPressed: _playPrevious,
                            icon: const Icon(Icons.skip_previous, size: 30, color: kTeal),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: kTeal, width: 2),
                            ),
                            child: IconButton(
                              onPressed: audioPlayApiController.togglePlayPause,
                              icon: Obx(() => Icon(
                                audioPlayApiController.isPlaying.value ? Icons.pause : Icons.play_arrow,
                                size: 30,
                                color: kTeal,
                              )),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                          IconButton(
                            onPressed: _playNext,
                            icon: const Icon(Icons.skip_next, size: 30, color: kTeal),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Image.asset('assets/icons/repeat.png', width: 26, height: 26, color: kTeal),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _summaryApiMethod() async {
    final item = audioPlayApiController.chooseInterestItem.value;
    if (item?.audio == null || item!.audio!.isEmpty) {
      Get.snackbar("Error", "No audio URL found", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    String audioUrl = item.audio!;
    print("Summary API Called with URL: $audioUrl");

    bool isSuccess = await audioSummaryApiController.audioSummaryApiController(audioUrl);

    if (isSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PodcastDescriptionScreen(urls: audioUrl)),
      );
    } else {
      String error = audioSummaryApiController.errorMessage ?? "Failed to generate summary";
      Get.snackbar("Error", error, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}

// WaveformProgressBar (Unchanged)
class WaveformProgressBar extends StatelessWidget {
  const WaveformProgressBar({
    super.key,
    required this.progress,
    required this.onChanged,
    this.barCount = 60,
    this.preferredBarWidth = 3.0,
    this.gap = 2.0,
    this.maxBarHeight = 40.0,
    this.activeColor = Colors.black,
    this.inactiveColor = Colors.grey,
    this.thumbRadius = 6.0,
  });

  final double progress;
  final ValueChanged<double> onChanged;
  final int barCount;
  final double preferredBarWidth;
  final double gap;
  final double maxBarHeight;
  final Color activeColor;
  final Color inactiveColor;
  final double thumbRadius;

  List<double> _sampleHeights() {
    final List<double> h = [];
    for (int i = 0; i < barCount; i++) {
      final t = i / barCount;
      final v = (0.55 +
          0.35 * math.sin(2 * math.pi * (3 * t)) +
          0.25 * math.sin(2 * math.pi * (7 * t + 0.4)) +
          0.15 * math.sin(2 * math.pi * (13 * t + 1.7)));
      h.add(v.clamp(0.1, 1.0));
    }
    return h;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final totalWidth = c.maxWidth;
        final double barWidth = (totalWidth - gap * (barCount - 1)) / barCount;
        final bars = _sampleHeights();
        final activeCount = (progress * barCount).clamp(0, barCount.toDouble()).floor();

        void _seekFromDx(double dx) {
          final p = (dx / totalWidth).clamp(0.0, 1.0);
          onChanged(p);
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => _seekFromDx(d.localPosition.dx),
          onHorizontalDragUpdate: (d) => _seekFromDx(d.localPosition.dx),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Row(
                children: List.generate(barCount, (i) {
                  final h = bars[i] * maxBarHeight;
                  final isActive = i < activeCount;
                  return Padding(
                    padding: EdgeInsets.only(right: i == barCount - 1 ? 0 : gap),
                    child: Container(
                      width: barWidth,
                      height: h,
                      decoration: BoxDecoration(
                        color: isActive ? activeColor : inactiveColor,
                        borderRadius: BorderRadius.circular(barWidth),
                      ),
                    ),
                  );
                }),
              ),
              Positioned(
                left: (totalWidth * progress) - thumbRadius,
                child: Container(
                  width: thumbRadius * 2,
                  height: thumbRadius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}