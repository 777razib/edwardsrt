// lib/features/events/controllers/events_controller.dart
import 'package:get/get.dart';

import '../model/event_model.dart';

class EventsController extends GetxController {
  final events = <Event>[].obs;
  final selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _loadEvents();
  }

void _loadEvents() {
  // Mock data - replace with API call
  events.assignAll([
    Event(
      id: '1',
      title: 'Bible Study Groups',
      date: DateTime(2025, 2, 13, 22, 30),
      host: 'Andrew',
      location: 'Sent grago church',
      isRegistered: true,
      seatsLeft: 2, // Few seats left - will show red
    ),
    Event(
      id: '2',
      title: 'Bible Study Groups',
      date: DateTime(2025, 2, 13, 22, 30),
      host: 'Andrew',
      location: 'Sent grago church',
      seatsLeft: 8, // Plenty of seats - will show grey
    ),
    Event(
      id: '3',
      title: 'Bible Study Groups',
      date: DateTime(2025, 2, 13, 22, 30),
      host: 'Andrew',
      location: 'Sent grago church',
      seatsLeft: 3, // Few seats left - will show red
    ),
    Event(
      id: '4',
      title: 'Bible Study Groups',
      date: DateTime(2025, 2, 13, 22, 30),
      host: 'Andrew',
      location: 'Sent grago church',
      seatsLeft: 15, // Plenty of seats - will show grey
    ),
    Event(
      id: '5',
      title: 'Bible Study Groups',
      date: DateTime(2025, 2, 13, 22, 30),
      host: 'Andrew',
      location: 'Sent grago church',
      seatsLeft: 0, // No seats left - will show red
    ),
  ]);
}

void registerForEvent(String eventId) {
  final eventIndex = events.indexWhere((event) => event.id == eventId);
  if (eventIndex != -1) {
    final updatedEvent = Event(
      id: events[eventIndex].id,
      title: events[eventIndex].title,
      date: events[eventIndex].date,
      host: events[eventIndex].host,
      location: events[eventIndex].location,
      isRegistered: true,
      mapUrl: events[eventIndex].mapUrl,
      goal: events[eventIndex].goal,
      seatsLeft: events[eventIndex].seatsLeft, // Add this line
    );
    events[eventIndex] = updatedEvent;
  }
}
}