import 'package:flutter/material.dart';
import '../../../core/style/text_style.dart';
import '../audio/screen/audio_screen.dart' show AudioScreen;
import '../book/screen/book_screen.dart';
import '../other/screen/other_screen.dart';
import '../podcast/screen/podcast_screen.dart';
import '../widget/media_body_widget.dart';



class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final List<Map<String, dynamic>> mediaItems = [
    {
      "image": "assets/icons/Group.png",
      "text": "Podcast",
      "screen": const PodcastScreen(),
    },
    {
      "image": "assets/icons/Vector.png",
      "text": "Audio",
      "screen": const AudioScreen(),
    },
    {
      "image": "assets/icons/Vector (1).png",
      "text": "Books",
      "screen": const BooksScreen(),
    },
    {
      "image": "assets/icons/Frame (1).png",
      "text": "Others",
      "screen": const OthersScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
          child: SingleChildScrollView(
           child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text("Media", style: globalHeadingTextStyle()),
      const SizedBox(height: 8),

      // Banner
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          "assets/icons/Frame 2147228495.png",
          width: double.infinity,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(color: Colors.grey[300]);
          },
        ),
      ),
      const SizedBox(height: 8),

      Text("Media Sections", style: globalTextStyle()),
      const SizedBox(height: 8),

      // GridView
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 8,
          childAspectRatio: 155.5 / 206,
        ),
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          final item = mediaItems[index];
          return MediaBodyWidget(
            image: item["image"],
            text: item["text"],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => item["screen"] as Widget,
                ),
              );
            },
          );
        },
      ),
      ],
    ),
    ),
    ),
    );
  }
}
