class Event {
  final String id;
  final String title;
  final DateTime date;
  final String host;
  final String location;
  final bool isRegistered;
  final String? mapUrl;
  final String? goal;
  final int seatsLeft; // Add this field

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.host,
    required this.location,
    this.isRegistered = false,
    this.mapUrl,
    this.goal,
    required this.seatsLeft, // Add this to constructor
  });
}