// podcast_screen.dart
import 'package:flutter/material.dart';
import '../podcast widget/calender_widget.dart';
import '../podcast widget/podcast_widget.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  List<Map<String, String>> _selectedVideos = [];
  List<Map<String, dynamic>> _apiEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVideosFromApi();
  }

  Future<void> _fetchVideosFromApi() async {
    setState(() => _isLoading = true);

    // এখানে আপনার API কল
    await Future.delayed(const Duration(seconds: 1)); // সিমুলেশন

    // উদাহরণ API রেসপন্স
    final List<Map<String, dynamic>> mockApiResponse = [
      {
        "title": "Sunday Sermon",
        "subTitle": "Pastor John",
        "date": "2025-10-27",
        "videoUrl": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      },
      {
        "title": "Youth Revival",
        "subTitle": "Worship Team",
        "date": "2025-10-20",
        "videoUrl": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      },
      {
        "title": "Bible Study",
        "subTitle": "Elder Mark",
        "date": "2025-10-27", // একই দিনে ২টা ভিডিও
        "videoUrl": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      },
    ];

    setState(() {
      _apiEvents = mockApiResponse;
      _isLoading = false;
    });
  }

  void _onDateSelected(List<Map<String, String>> videos) {
    setState(() {
      _selectedVideos = videos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Podcasts')),
      body: Stack(
        children: [
          // মূল কন্টেন্ট
          if (!_isLoading)
            Column(
              children: [
                CalenderWidget(
                  apiEvents: _apiEvents,
                  onDateSelected: _onDateSelected,
                ),
                if (_selectedVideos.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Videos for ${_selectedVideos[0]['date']}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                Expanded(
                  child: _selectedVideos.isEmpty
                      ? const Center(
                    child: Text(
                      "No video for selected date",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _selectedVideos.length,
                    itemBuilder: (context, index) {
                      final video = _selectedVideos[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: PodcastWidget(
                          title: video["title"]!,
                          subTitle: video["subTitle"]!,
                          date: video["date"]!,
                          videoUrl: video["videoUrl"]!,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          // লোডিং
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}