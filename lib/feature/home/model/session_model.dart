class Session {
  final String image;
  final String title;
  final String subtitle;
  final Duration duration;
  final String audioPath;
  final String? afterText;

  Session({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.audioPath,
    this.afterText,
  });
}