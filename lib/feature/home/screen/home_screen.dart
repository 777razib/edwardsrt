import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../choose interest/controller/choose_interest_api_controller.dart';
import '../../media/audio/screen/audio_play.dart';
import '../widget/audio_image_widget.dart';

import 'package:intl/intl.dart'; // For date formatting

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ChooseInterestApiController controller = Get.find<ChooseInterestApiController>();

  bool isVideo = false;
  int selectedIndex = 0;
  bool isLoading = false;

  // Use user's selected interests as categories
  late List<String> categories;

  @override
  void initState() {
    super.initState();

    // Wait for episodes to load, then set categories
    ever(controller.episodes, (_) {
      if (controller.episodes.isNotEmpty && categories.isEmpty) {
        _updateCategories();
      }
    });

    // If already loaded
    if (controller.episodes.isNotEmpty) {
      _updateCategories();
    }
  }

  void _updateCategories() {
    // Extract unique podcast titles or use search terms
    final Set<String> uniqueTitles = {};
    for (var ep in controller.episodes) {
      final title = ep.podcast?.titleOriginal ?? "Unknown";
      uniqueTitles.add(title.split(" ").take(3).join(" ")); // Shorten long titles
    }
    categories = uniqueTitles.take(8).toList(); // Limit to 8
    if (categories.isEmpty) categories = ["All Podcasts"];

    setState(() {});

    // Load first category
    _loadEpisodesForCategory(categories.first);
  }

  void _loadEpisodesForCategory(String category) async {
    setState(() => isLoading = true);

    // Search by category name
    await controller.chooseInterestApiMethod(interest: category);

    setState(() => isLoading = false);
  }

  String _formatDate(int? timestampMs) {
    if (timestampMs == null) return "Unknown";
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return "";
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return "${mins}m ${secs}s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF3),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  child: Image.asset("assets/icons/linly-high-resolution-logo 1.png"),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => setState(() => isVideo = !isVideo),
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
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: isVideo ? Alignment.centerLeft : Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              isVideo ? "List" : "Grid",
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 300),
                          alignment: isVideo ? Alignment.centerRight : Alignment.centerLeft,
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

          // Category Buttons (from API)
          Obx(() => controller.episodes.isEmpty && controller.isLoading.value
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CircularProgressIndicator(),
          )
              : Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedIndex = index);
                    _loadEpisodesForCategory(categories[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ),

          const SizedBox(height: 10),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(controller.errorMessage.value),
                      ElevatedButton(onPressed: controller.retry, child: Text("Retry")),
                    ],
                  ),
                );
              }

              if (controller.episodes.isEmpty) {
                return const Center(child: Text("No podcasts found"));
              }

              return isVideo
                  ? _buildVideoList()
                  : _buildAudioGrid();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.episodes.length,
      itemBuilder: (context, i) {
        final ep = controller.episodes[i];
        return AudioImageWidget(
          title: ep.titleOriginal ?? "Untitled",
          subTitle: "${_formatDuration(ep.audioLengthSec)} • ${ep.podcast?.publisherOriginal ?? ""}",
          date: _formatDate(ep.pubDateMs),
          episodes: "Episodes: 13",
          imageUrl: ep.thumbnail ?? ep.image ?? "https://via.placeholder.com/327x144",
          onTap: () {

            final List<String> nearbyEpisodeIds = [ep.id.toString()]; // খালি রাখো না!

            if (nearbyEpisodeIds.isEmpty) {
              Get.to(() => MusicPlayerScreen(Id: ep.id.toString())); // পুরানো সিঙ্গেল Id ওয়ে
            } else {
              Get.to(() => MusicPlayerScreen(
                episodeIds: nearbyEpisodeIds,
                currentId: ep.id.toString(),
              ));
            }
            // Pass audio URL to player
            //Get.to(() => MusicPlayerScreen(Id: '${ep.id}',));
            //Get.to(() => AudioListScreen(episodeId: ep.audio ?? ""));
          },
        );
      },
    );
  }

  Widget _buildAudioGrid() {
    return RefreshIndicator(
      onRefresh: () => controller.refresh(interest: categories[selectedIndex]),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: controller.episodes.length,
        itemBuilder: (context, i) {
          final ep = controller.episodes[i];
          return AudioImageWidget(
            title: ep.titleOriginal ?? "Untitled",
            subTitle: "${_formatDuration(ep.audioLengthSec)} • ${ep.podcast?.publisherOriginal ?? ""}",
            date: _formatDate(ep.pubDateMs),
            episodes: "Episodes: 13",
            imageUrl: ep.thumbnail ?? ep.image ?? "https://via.placeholder.com/327x144",
            onTap: () {

              final List<String> nearbyEpisodeIds = [ep.id.toString()]; // খালি রাখো না!

              if (nearbyEpisodeIds.isEmpty) {
                Get.to(() => MusicPlayerScreen(Id: ep.id.toString())); // পুরানো সিঙ্গেল Id ওয়ে
              } else {
                Get.to(() => MusicPlayerScreen(
                  episodeIds: nearbyEpisodeIds,
                  currentId: ep.id.toString(),
                ));
              }
              // Pass audio URL to player
             //Get.to(() => MusicPlayerScreen(Id: '${ep.id}',));
              //Get.to(() => AudioListScreen(episodeId: ep.audio ?? ""));
            },
          );
        },
      ),
    );
  }
}