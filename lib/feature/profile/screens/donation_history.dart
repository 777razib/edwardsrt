import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/donation_history_controller.dart';

class DonationHistoryScreen extends StatelessWidget {
  DonationHistoryScreen({super.key}) {
    Get.put(DonationHistoryController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DonationHistoryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Donation History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isHistoryLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.donationHistory.isEmpty) {
          return const Center(child: Text('No donations found.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: controller.donationHistory.map((donation) {
              final amount = donation['amount'] ?? 0;
              final type = donation['type'] ?? 'ONE_TIME';
              final recurring = donation['recurringInterval'] ?? '';
              final honoree = donation['honoreeName'];
              final dateStr = donation['createdAt'] ?? '';
              final date = dateStr.isNotEmpty
                  ? DateFormat('dd/MM/yyyy').format(DateTime.parse(dateStr))
                  : '';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$date • ${type == 'RECURRING' ? recurring : 'One-time'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (honoree != null && honoree.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Honoree: $honoree',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}