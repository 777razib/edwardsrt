/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:edwardsrt/core/app_colors.dart';
import '../controller/audio_paly_api_controller.dart';
import '../controller/search_text_api_controller.dart';
import '../controller/audio_summary_api_controller.dart';

class DescriptionScreen extends StatefulWidget {
  final dynamic item;

  const DescriptionScreen({super.key, required this.item});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final AudioPlayApiController controller = Get.put(AudioPlayApiController());
  //final SearchTextApiController searchTextApiController = Get.put(SearchTextApiController());
  final AudioSummaryApiController audioSummaryApiController = Get.put(AudioSummaryApiController());
  
  String _selectedText = '';
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    controller.fetchAndPlayAudio(widget.item.id);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Obx(() {
      if (controller.isLoading.value && controller.audio.value == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      if (controller.errorMessage.value != null) {
        return Scaffold(body: Center(child: Text(controller.errorMessage.value!)));
      }

      if (controller.audio.value == null) {
        return const Scaffold(body: Center(child: Text('Audio not available.')));
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(controller.audio.value!.title ?? 'Audio Player'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Column(
          children: [
            LinearProgressIndicator(value: searchTextApiController.isLoading.value ? null : 0),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: searchTextApiController.searchController,
                      decoration: InputDecoration(
                        hintText: 'Search in summary...',
                        prefixIcon: const Icon(Icons.search, color: kTeal),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: searchTextApiController.clearSearch,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      ),
                      onSubmitted: (value) => searchTextApiController.searchText(value),
                    ),
                    const SizedBox(height: 16),

                    Obx(() {
                        String displayText = controller.audio.value!.description ?? '';

                        if (searchTextApiController.isLoading.value) {
                          displayText = 'Searching...';
                        } else if (searchTextApiController.errorMessage.value.isNotEmpty) {
                          displayText = searchTextApiController.errorMessage.value;
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Copy Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: _selectedText.isEmpty
                                      ? null
                                      : () {
                                    Clipboard.setData(ClipboardData(text: _selectedText));
                                    Get.snackbar('Copied!', 'Selected text copied', backgroundColor: kTeal, colorText: Colors.white, duration: const Duration(seconds: 1));
                                  },
                                  icon: const Icon(Icons.content_copy, size: 16, color: kTeal),
                                  label: const Text('Copy Selected', style: TextStyle(color: kTeal, fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: displayText));
                                    Get.snackbar('Copied!', 'Full summary copied', backgroundColor: kTeal, colorText: Colors.white, duration: const Duration(seconds: 1));
                                  },
                                  icon: const Icon(Icons.copy_all, size: 16, color: kTeal),
                                  label: const Text('Copy All', style: TextStyle(color: kTeal, fontSize: 12)),
                                ),
                              ],
                            ),

                            // Selectable Text
                            SelectableText(
                              displayText,
                              style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                              textAlign: TextAlign.justify,
                              onSelectionChanged: (selection, cause) {
                                if (selection.isValid && selection.textInside(displayText).isNotEmpty) {
                                  _selectedText = selection.textInside(displayText);
                                } else {
                                  _selectedText = '';
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Bottom Playing Card
        bottomSheet: Container(
          height: 80,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    controller.audio.value!.thumbnail ?? '',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: kTeal.withOpacity(0.2), child: const Icon(Icons.music_note)),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.audio.value!.title ?? '',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Obx(() {
                      final posStr = controller.format(controller.position.value.inSeconds);
                      final durStr = controller.format(controller.duration.value.inSeconds);
                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: kTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text('$posStr / $durStr', style: const TextStyle(fontSize: 12, color: kTeal, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: controller.togglePlayPause,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: kTeal, borderRadius: BorderRadius.circular(20)),
                    child: Obx(() => Icon(
                      controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
*/
