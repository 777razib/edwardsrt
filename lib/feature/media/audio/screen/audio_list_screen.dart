/*
import 'package:flutter/material.dart';
import 'package:naomithedose/feature/media/audio/screen/audio_play.dart';

class AudioListScreen extends StatelessWidget {
   AudioListScreen({super.key, required this.episodeId});
  final String episodeId;

  @override
  Widget build(BuildContext context) {
    final items = _mockEpisodes();

    return Scaffold(
      backgroundColor: const Color(0xffFFFFF3),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Top image
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/top_image.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Title & Meta
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Business is Business',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Hosted By Jems Gang',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Episode: 13',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff39CCCC),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Scrollable list
            SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _EpisodeTile(item: items[index]),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

// --------- DATA ---------
class EpisodeItem {
  const EpisodeItem({
    required this.title,
    required this.durationCode,
    required this.host,
    required this.listened,
    required this.assetImage,
  });

  final String title;
  final String durationCode;
  final String host;
  final String listened;
  final String assetImage;
}

List<EpisodeItem> _mockEpisodes() {
  return const [
    EpisodeItem(
      title: 'The Business Blueprint',
      durationCode: '23:1',
      host: 'Daniel Don',
      listened: '64k',
      assetImage: 'assets/images/podcast1.png',
    ),
    EpisodeItem(
      title: 'Scaling Smarter, Not Harder',
      durationCode: '14:7',
      host: 'Maya Khan',
      listened: '12.3k',
      assetImage: 'assets/images/podcast2.png',
    ),
    EpisodeItem(
      title: 'From Zero to Launch',
      durationCode: '31:5',
      host: 'Aarav Patel',
      listened: '88k',
      assetImage: 'assets/images/podcast3.png',
    ),
    EpisodeItem(
      title: 'Cashflow Rules',
      durationCode: '19:3',
      host: 'Sophia Lee',
      listened: '9.1k',
      assetImage: 'assets/images/podcast4.png',
    ),
    EpisodeItem(
      title: 'Ops that Actually Work',
      durationCode: '27:2',
      host: 'Daniel Don',
      listened: '41k',
      assetImage: 'assets/images/podcast5.png',
    ),
    EpisodeItem(
      title: 'Hiring Your First 5',
      durationCode: '11:9',
      host: 'Maya Khan',
      listened: '7.8k',
      assetImage: 'assets/images/podcast1.png',
    ),
    EpisodeItem(
      title: 'Pricing Psychology 101',
      durationCode: '22:6',
      host: 'Aarav Patel',
      listened: '56k',
      assetImage: 'assets/images/podcast1.png',
    ),
    EpisodeItem(
      title: 'Customer > Everything',
      durationCode: '16:4',
      host: 'Sophia Lee',
      listened: '18.2k',
      assetImage: 'assets/images/podcast2.png',
    ),
    EpisodeItem(
      title: 'B2B Sales Tactics',
      durationCode: '29:8',
      host: 'Daniel Don',
      listened: '33k',
      assetImage: 'assets/images/podcast3.png',
    ),
    EpisodeItem(
      title: 'Fundraising Pitfalls',
      durationCode: '35:1',
      host: 'Maya Khan',
      listened: '22k',
      assetImage: 'assets/images/podcast4.png',
    ),
    EpisodeItem(
      title: 'Retention is a Moat',
      durationCode: '13:5',
      host: 'Aarav Patel',
      listened: '48k',
      assetImage: 'assets/images/podcast5.png',
    ),
    EpisodeItem(
      title: 'Roadmap Reality Check',
      durationCode: '24:3',
      host: 'Sophia Lee',
      listened: '5.6k',
      assetImage: 'assets/images/podcast1.png',
    ),
  ];
}

// --------- TILE ---------
class _EpisodeTile extends StatelessWidget {
  const _EpisodeTile({required this.item});

  final EpisodeItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // Navigate to the Music Player Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MusicPlayerScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item.assetImage,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${item.durationCode}  Host: ${item.host}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xffB8B8A9),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.remove_red_eye_outlined,
                          size: 16, color: Color(0xffB8B8A9)),
                      const SizedBox(width: 6),
                      Text(
                        'Listened: ${item.listened}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xffB8B8A9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Play button
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff39CCCC),
              ),
              child: const Icon(Icons.play_arrow_outlined,
                  color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
*/
