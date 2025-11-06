// lib/feature/search/ui/search_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';
import '../../choose interest/controller/choose_interest_api_controller.dart';
import '../../home/widget/audio_image_widget.dart';
import '../../media/audio/screen/audio_play.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Singleton
  final ChooseInterestApiController apiCtrl = Get.put(ChooseInterestApiController());

  // UI state
  bool isListView = true;
  int selectedCategoryIndex = 0;

  // Track current query for pagination
  String _currentQuery = "Business"; // ← এই লাইনটি যোগ করা হয়েছে

  final List<String> categories = [
    "Business",
    "Education",
    "Comedy",
    "Fiction",
    "History",
  ];

  @override
  void initState() {
    super.initState();
    _loadCategory(categories[selectedCategoryIndex]);

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (query.isEmpty) {
        _loadCategory(categories[selectedCategoryIndex]);
      } else {
        _searchInApi(query);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load category
  Future<void> _loadCategory(String term) async {
    _currentQuery = term;
    _searchController.clear();
    await apiCtrl.chooseInterestApiMethod(interest: term, loadMore: false);
  }

  // Search API
  Future<void> _searchInApi(String query) async {
    _currentQuery = query;
    await apiCtrl.chooseInterestApiMethod(interest: query, loadMore: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF3),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // SEARCH BAR + TOGGLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E9DC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          final query = value.trim();
                          if (query.isNotEmpty) {
                            _searchInApi(query);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Search audios…",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(Icons.search, color: AppColors.primary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Toggle
                  GestureDetector(
                    onTap: () => setState(() => isListView = !isListView),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 120,
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 300),
                            alignment: isListView ? Alignment.centerLeft : Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                isListView ? "List" : "Grid",
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 300),
                            alignment: isListView ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CATEGORY CHIPS
            SizedBox(
              height: 45,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, i) {
                  final selected = selectedCategoryIndex == i;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedCategoryIndex = i);
                      _loadCategory(categories[i]);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          categories[i],
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // RESULTS
            Expanded(
              child: Obx(() {
                if (apiCtrl.isLoading.value && apiCtrl.episodes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (apiCtrl.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(apiCtrl.errorMessage.value, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: apiCtrl.retry, child: const Text("Retry")),
                      ],
                    ),
                  );
                }

                if (apiCtrl.episodes.isEmpty) {
                  return const Center(child: Text("No results found", style: TextStyle(color: Colors.grey, fontSize: 16)));
                }

                return isListView ? _buildListView() : _buildGridView();
              }),
            ),
          ],
        ),
      ),
    );
  }

  // LIST VIEW
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: apiCtrl.episodes.length + (apiCtrl.hasMore.value ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == apiCtrl.episodes.length) {
          apiCtrl.loadNextPage();
          return const Padding(padding: EdgeInsets.all(12), child: Center(child: CircularProgressIndicator()));
        }

        final item = apiCtrl.episodes[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AudioImageWidget(
            title: item.titleOriginal ?? "Untitled",
            subTitle: "${_formatDuration(item.audioLengthSec)} • ${item.podcast?.publisherOriginal ?? ""}",
            date: _formatDate(item.pubDateMs),
            episodes: "Episodes: 13",
            imageUrl: item.thumbnail ?? item.image ?? "https://via.placeholder.com/327x144",
            onTap: () {
              Get.to(() => MusicPlayerScreen(
                episodeIds: [item.id.toString()],
                currentId: item.id.toString(),
              ));
            },
          ),
        );
      },
    );
  }

  // GRID VIEW
  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: apiCtrl.episodes.length + (apiCtrl.hasMore.value ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == apiCtrl.episodes.length) {
          apiCtrl.loadNextPage();
          return const Center(child: CircularProgressIndicator());
        }

        final item = apiCtrl.episodes[i];
        return AudioImageWidget(
          title: item.titleOriginal ?? "Untitled",
          subTitle: "${_formatDuration(item.audioLengthSec)} • ${item.podcast?.publisherOriginal ?? ""}",
          date: _formatDate(item.pubDateMs),
          episodes: "Episodes: 13",
          imageUrl: item.thumbnail ?? item.image ?? "https://via.placeholder.com/327x144",
          onTap: () {
            Get.to(() => MusicPlayerScreen(
              episodeIds: [item.id.toString()],
              currentId: item.id.toString(),
            ));
          },
        );
      },
    );
  }

  // Helper: format duration
  String _formatDuration(int? sec) {
    if (sec == null || sec <= 0) return "";
    final m = sec ~/ 60;
    final s = sec % 60;
    return "${m}m ${s}s";
  }

  // Helper: format date
  String _formatDate(int? ms) {
    if (ms == null) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(ms);
    return DateFormat('yyyy-MM-dd').format(dt);
  }
}