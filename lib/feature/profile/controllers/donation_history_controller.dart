import 'package:get/get.dart';

class DonationHistoryController extends GetxController {
  final isHistoryLoading = false.obs;
  final donationHistory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    getDonationHistory();
  }

  // Simulate loading donation history
  Future<void> getDonationHistory() async {
    isHistoryLoading.value = true;
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock donation history data
    donationHistory.assignAll([
      {
        'amount': 50.0,
        'type': 'ONE_TIME',
        'recurringInterval': '',
        'honoreeName': 'John Smith',
        'createdAt': '2024-01-15T10:30:00Z',
      },
      {
        'amount': 100.0,
        'type': 'RECURRING',
        'recurringInterval': 'Monthly',
        'honoreeName': null,
        'createdAt': '2024-01-10T14:20:00Z',
      },
      {
        'amount': 25.0,
        'type': 'ONE_TIME',
        'recurringInterval': '',
        'honoreeName': 'Sarah Johnson',
        'createdAt': '2024-01-05T09:15:00Z',
      },
      {
        'amount': 200.0,
        'type': 'RECURRING',
        'recurringInterval': 'Yearly',
        'honoreeName': 'In Memory of Robert Brown',
        'createdAt': '2024-01-01T16:45:00Z',
      },
      {
        'amount': 75.0,
        'type': 'ONE_TIME',
        'recurringInterval': '',
        'honoreeName': null,
        'createdAt': '2023-12-28T11:20:00Z',
      },
    ]);
    
    isHistoryLoading.value = false;
  }
}