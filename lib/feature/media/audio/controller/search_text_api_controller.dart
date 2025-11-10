/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:edwardsrt/core/network_path/natwork_path.dart';

// Search Model
class SearchResult {
  final String title;
  final String thumbnail;

  SearchResult({required this.title, required this.thumbnail});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}

// Search Controller
class SearchTextApiController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<SearchResult> searchResults = <SearchResult>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Trigger search whenever the text changes
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        searchText(searchController.text);
      }
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    errorMessage.value = '';
  }

  Future<void> searchText(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse('${Urls.searchingText}?query=$query'), // Corrected
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null) {
          final List<SearchResult> results = (data['results'] as List)
              .map((item) => SearchResult.fromJson(item))
              .toList();
          searchResults.value = results;
        } else {
          searchResults.clear();
        }
      } else {
        errorMessage.value = "Failed to fetch results: ${response.statusCode}";
        searchResults.clear();
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
*/
