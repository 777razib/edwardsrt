import 'package:get/get.dart';

class DonationController extends GetxController {
  final isLoading = false.obs;
  final donationSuccess = false.obs;
  final errorMessage = ''.obs;

  // Simulate donation process
  Future<void> createDonation({
    required double amount,
    required String type,
    String? recurringInterval,
    String? honoreeName,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    donationSuccess.value = false;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Simulate success
    donationSuccess.value = true;
    isLoading.value = false;

    // For demo purposes - you can add error simulation here
    // if (amount <= 0) {
    //   errorMessage.value = 'Invalid amount';
    //   isLoading.value = false;
    //   return;
    // }
  }
}