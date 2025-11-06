import 'package:flutter/material.dart';

class PodcastCard extends StatelessWidget {
  const PodcastCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/podcast_bg.jpg'), // your image
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const Positioned(
            top: 10,
            left: 10,
            child: Text(
              "Host: Father Adam",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const Positioned(
            bottom: 15,
            left: 15,
            child: Text(
              "How Bible put impact of life",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Positioned(
            bottom: 15,
            right: 15,
            child: Icon(Icons.play_circle_fill,
                color: Colors.white, size: 35),
          ),
        ],
      ),
    );
  }
}
