/*
// lib/feature/choose_interest/controller/choose_interest_api_controller.dart
import 'package:get/get.dart';
import 'package:naomithedose/core/network_caller/network_config.dart';
import 'package:naomithedose/core/services_class/shared_preferences_helper.dart';
import '../../../core/network_path/natwork_path.dart';
import '../model/choose_interest_response_model.dart';

class ChooseInterestApiController extends GetxController {
  final RxList<ChooseInterestItem> episodes = <ChooseInterestItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final int pageSize = 10;

  String? _currentQuery;

  Future<void> chooseInterestApiMethod({
    required String? interest,
    bool loadMore = false,
  }) async {
    if (interest != null && interest != _currentQuery) {
      _currentQuery = interest;
      currentPage.value = 1;
      episodes.clear();
      hasMore.value = true;
    }

    if (interest == null || interest.trim().isEmpty) {
      errorMessage.value = 'Please provide a guide term';
      return;
    }

    if (isLoading.value && !loadMore) return;

    try {
      if (!loadMore) {
        isLoading.value = true;
        errorMessage.value = '';
      }

      final String url = Urls.chooseInterest(
        interest: _currentQuery!,
        page: currentPage.value,
        pageSize: pageSize,
      );

      final NetworkResponse response = await NetworkCall.getRequest(url: url);

      if (response.isSuccess) {
        await SharedPreferencesHelper.getAccessToken();
        final data = response.responseData!;
        final model = ChooseInterestResponseModel.fromJson(data);
        final List<ChooseInterestItem> newEpisodes = model.results ?? [];

        if (loadMore) {
          episodes.addAll(newEpisodes);
        } else {
          episodes.assignAll(newEpisodes);
        }

        // FIXED: Use camelCase field
        hasMore.value = model.nextOffset != null && model.nextOffset! > 0;
      } else {
        errorMessage.value = response.errorMessage ?? 'Failed to load episodes';
        hasMore.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (hasMore.value && !isLoading.value) {
      currentPage.value++;
      chooseInterestApiMethod(interest: _currentQuery, loadMore: true);
    }
  }

  Future<void> refresh({String? interest}) async {
    currentPage.value = 1;
    hasMore.value = true;
    await chooseInterestApiMethod(interest: interest ?? _currentQuery);
  }

  void retry() {
    errorMessage.value = '';
    chooseInterestApiMethod(interest: _currentQuery);
  }
}*/
// lib/feature/choose_interest/controller/choose_interest_api_controller.dart
import 'package:edwardsrt/core/network_caller/network_config.dart';
import 'package:get/get.dart';
import '../../../core/network_path/natwork_path.dart';
import '../../../core/services_class/shared_preferences_helper.dart';
import '../model/choose_interest_response_model.dart';

class ChooseInterestApiController extends GetxController {
  final RxList<ChooseInterestItem> episodes = <ChooseInterestItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final int pageSize = 10;

  String? _currentQuery;

  Future<void> chooseInterestApiMethod({
    required String? interest,
    bool loadMore = false,
  }) async {
    // যদি নতুন সার্চ বা ক্যাটাগরি, অথবা loadMore না হয় → পুরোনো ডেটা ক্লিয়ার
    if (!loadMore) {
      final bool isNewQuery = interest != null && interest != _currentQuery;
      if (isNewQuery || episodes.isNotEmpty) {
        _currentQuery = interest;
        currentPage.value = 1;
        episodes.clear();
        hasMore.value = true;
        errorMessage.value = '';
      }
    }

    if (interest == null || interest.trim().isEmpty) {
      errorMessage.value = 'Please provide a guide term';
      isLoading.value = false;
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final String url = Urls.chooseInterest(
        interest: _currentQuery!,
        page: currentPage.value,
        pageSize: pageSize,
      );

      final NetworkResponse response = await NetworkCall.getRequest(url: url);

      if (response.isSuccess) {
        await SharedPreferencesHelper.getAccessToken();
        final data = response.responseData!;
        final model = ChooseInterestResponseModel.fromJson(data);
        final List<ChooseInterestItem> newEpisodes = model.results ?? [];

        if (loadMore) {
          episodes.addAll(newEpisodes);
        } else {
          episodes.assignAll(newEpisodes);
        }

        // nextOffset থাকলে পেজিনেশন চালু
        hasMore.value = model.nextOffset != null && model.nextOffset! > currentPage.value * pageSize;
      } else {
        errorMessage.value = response.errorMessage ?? 'Failed to load episodes';
        hasMore.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (hasMore.value && !isLoading.value && _currentQuery != null) {
      currentPage.value++;
      chooseInterestApiMethod(interest: _currentQuery, loadMore: true);
    }
  }

  Future<void> refresh({String? interest}) async {
    currentPage.value = 1;
    hasMore.value = true;
    await chooseInterestApiMethod(interest: interest ?? _currentQuery, loadMore: false);
  }

  void retry() {
    errorMessage.value = '';
    chooseInterestApiMethod(interest: _currentQuery, loadMore: false);
  }
}