// calender_widget.dart
import 'package:flutter/material.dart';

class CalenderWidget extends StatefulWidget {
  final Function(List<Map<String, String>>)? onDateSelected;
  final List<Map<String, dynamic>> apiEvents; // API থেকে আসবে

  const CalenderWidget({
    super.key,
    this.onDateSelected,
    required this.apiEvents,
  });

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  late Map<DateTime, List<Map<String, String>>> _events;
  DateTime? _selectedDate;
  DateTime? _focusedMonth;

  @override
  void initState() {
    super.initState();
    _parseApiEvents();
  }

  @override
  void didUpdateWidget(covariant CalenderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.apiEvents != widget.apiEvents) {
      _parseApiEvents();
    }
  }

  void _parseApiEvents() {
    final Map<DateTime, List<Map<String, String>>> parsed = {};

    for (var event in widget.apiEvents) {
      final String? dateStr = event['date']; // "2025-10-27"
      if (dateStr == null) continue;

      final DateTime date = DateTime.parse(dateStr);
      final normalized = DateTime(date.year, date.month, date.day);

      parsed[normalized] ??= [];
      parsed[normalized]!.add({
        "title": event['title']?.toString() ?? "No Title",
        "subTitle": event['subTitle']?.toString() ?? "Unknown",
        "date": _formatDate(normalized),
        "videoUrl": event['videoUrl']?.toString() ?? "",
      });
    }

    final now = DateTime.now();
    final today = _normalize(now);

    setState(() {
      _events = parsed;
      // Default: আজকের তারিখের ভিডিও
      _selectedDate = _events.containsKey(today) ? today : _events.keys.firstOrNull;
      _focusedMonth = _selectedDate != null
          ? DateTime(_selectedDate!.year, _selectedDate!.month)
          : DateTime(now.year, now.month);
      _notifySelection();
    });
  }

  DateTime _normalize(DateTime date) => DateTime(date.year, date.month, date.day);

  String _formatDate(DateTime date) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${date.day} ${months[date.month]}";
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  int _firstDayOffset(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    return firstDay.weekday % 7;
  }

  int _daysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }

  void _notifySelection() {
    final videos = _selectedDate != null ? _events[_selectedDate!] ?? [] : <Map<String, String>>[];
    widget.onDateSelected?.call(videos);
  }

  @override
  Widget build(BuildContext context) {
    if (_focusedMonth == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          // Header with navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(_focusedMonth!.year, _focusedMonth!.month - 1);
                  });
                },
              ),
              Text(
                "${_getMonthName(_focusedMonth!.month)} ${_focusedMonth!.year}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(_focusedMonth!.year, _focusedMonth!.month + 1);
                  });
                },
              ),
            ],
          ),
          // Week days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => Text(day, style: const TextStyle(fontWeight: FontWeight.bold)))
                .toList(),
          ),
          // Days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 42, // Fixed 6 rows
            itemBuilder: (context, index) {
              if (index < _firstDayOffset(_focusedMonth!)) {
                return Container();
              }
              final day = index - _firstDayOffset(_focusedMonth!) + 1;
              if (day > _daysInMonth(_focusedMonth!)) {
                return Container();
              }
              final date = DateTime(_focusedMonth!.year, _focusedMonth!.month, day);
              final hasEvent = _events.containsKey(_normalize(date));
              final isSelected = _selectedDate != null && _normalize(_selectedDate!) == _normalize(date);

              return GestureDetector(
                onTap: hasEvent
                    ? () {
                  setState(() {
                    _selectedDate = date;
                  });
                  _notifySelection();
                }
                    : null,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : (hasEvent ? Colors.blue.shade100 : null),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: hasEvent ? (isSelected ? Colors.white : Colors.blue.shade700) : Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}