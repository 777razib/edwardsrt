// lib/feature/guide/ui/guide_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';
import '../../choose interest/controller/choose_interest_api_controller.dart';
import '../../media/audio/screen/audio_play.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
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