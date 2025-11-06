
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/Get.dart';
import '../../../../core/services_class/shared_preferences_helper.dart';
import '../controller/audio_paly_api_controller.dart';
import '../controller/search_text_api_controller.dart';

const kTeal = Color(0xFF39CCCC);

class PodcastDescriptionScreen extends StatelessWidget {
  PodcastDescriptionScreen({super.key, required this.urls});

  final String urls;
  final SearchTextApiController searchTextApiController = Get.put(SearchTextApiController());
  OverlayEntry? _overlayEntry;

  // সিলেক্ট করা টেক্সট
  String _selectedText = '';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AudioPlayApiController>();

    // ever() → সাকসেস হলে ডায়লগ দেখাও
    ever(searchTextApiController.isSuccess, (bool success) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (success && searchTextApiController.topicSummaryModel.value != null) {
        _showExplanationDialog(context);
      }
    });

    return Obx(() {
      final item = controller.chooseInterestItem.value;

      if (item == null || controller.isLoading.value) {
        return const Scaffold(
          backgroundColor: Color(0xffFFFFF3),
          body: Center(child: CircularProgressIndicator(color: kTeal)),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xffFFFFF3),
        appBar: AppBar(
          backgroundColor: const Color(0xffFFFFF3),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Podcast Details', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: _searchApiButton,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Search in transcript...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image + Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item.image ?? '',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: kTeal.withOpacity(0.2),
                              child: const Icon(Icons.music_note, size: 40, color: kTeal),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title ?? 'Unknown Title',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.description ?? 'Unknown Podcast',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Summary with Copy Buttons
                    FutureBuilder<String?>(
                      future: SharedPreferencesHelper.getAudioSummaryAsync(),
                      builder: (context, snapshot) {
                        String displayText = 'No description available.';
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          displayText = 'Loading summary...';
                        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          displayText = snapshot.data!;
                        } else {
                          displayText = item.descriptionOriginal ?? item.descriptionHighlighted ?? displayText;
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
                    item.image ?? '',
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
                      item.titleOriginal ?? '',
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
                          const SizedBox(width: 8),
                          Text('Host: ${item.podcast?.publisherOriginal ?? 'Unknown'}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
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

  // সার্চ ফাংশন
  Future<void> _searchApiButton(String value) async {
    if (value.trim().isEmpty) {
      Get.snackbar('Info', 'Please enter a search term', backgroundColor: Colors.orange);
      return;
    }

    searchTextApiController.clearSearch();

    // লোডিং ডায়লগ
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: kTeal),
              SizedBox(height: 16),
              Text(
                'Searching in transcript...\n(This may take a few seconds)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    bool success = await searchTextApiController.searchTextApiMethod(urls, value);

    if (Get.isDialogOpen == true) Get.back();

    if (!success) {
      Get.snackbar(
        'Error',
        searchTextApiController.errorMessage ?? 'Search failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    }
  }

  void _showExplanationDialog(BuildContext context) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    final model = searchTextApiController.topicSummaryModel.value!;
    String dialogSelectedText = '';

    _overlayEntry = OverlayEntry(
      builder: (ctx) => Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            child: Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(32),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                model.topic,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTeal),
                                onSelectionChanged: (selection, cause) {
                                  dialogSelectedText = selection.textInside(model.topic);
                                },
                              ),
                            ),
                            TextButton.icon(
                              onPressed: dialogSelectedText.isEmpty ? null : () {
                                Clipboard.setData(ClipboardData(text: dialogSelectedText));
                                Get.snackbar('Copied!', 'Topic copied', backgroundColor: kTeal, colorText: Colors.white, duration: const Duration(seconds: 1));
                              },
                              icon: const Icon(Icons.content_copy, size: 14, color: kTeal),
                              label: const Text('Copy', style: TextStyle(color: kTeal, fontSize: 11)),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: '${model.topic}\n\n${model.explanation}'));
                                Get.snackbar('Copied!', 'Full copied', backgroundColor: kTeal, colorText: Colors.white, duration: const Duration(seconds: 1));
                              },
                              icon: const Icon(Icons.copy_all, size: 14, color: kTeal),
                              label: const Text('All', style: TextStyle(color: kTeal, fontSize: 11)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () {
                                _overlayEntry?.remove();
                                _overlayEntry = null;
                              },
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        SelectableText(
                          model.explanation,
                          style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                          onSelectionChanged: (selection, cause) {
                            dialogSelectedText = selection.textInside(model.explanation);
                          },
                        ),
                        const SizedBox(height: 12),
                        if (model.occurrences.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: model.occurrences.map((time) => Chip(
                              label: Text(time, style: const TextStyle(fontSize: 12)),
                              backgroundColor: kTeal.withOpacity(0.1),
                            )).toList(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (context.mounted) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }
}