import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../controllers/donation_controller.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final RxInt selectedTab = 0.obs;
  final RxInt selectedAmount = (-1).obs;
  final TextEditingController otherAmountController = TextEditingController();
  final TextEditingController honoreeController = TextEditingController();
  final RxBool isDedicated = false.obs;
  final RxString recurringType = 'Monthly'.obs;

  final List<int> donationOptions = [20, 50, 100, 200];
  final donationController = Get.put(DonationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Donation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => Row(
              children: [
                _buildToggleButton('One-time', 0),
                const SizedBox(width: 12),
                _buildToggleButton('Recurring', 1),
              ],
            )),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() => SingleChildScrollView(
                child: selectedTab.value == 0
                    ? _buildDonationForm(showRecurringDropdown: false)
                    : _buildDonationForm(showRecurringDropdown: true),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String title, int index) {
    bool isSelected = selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => selectedTab.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey[300]!,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonationForm({required bool showRecurringDropdown}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showRecurringDropdown)
          Column(
            children: [
              const Text(
                'Recurring Donation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Obx(
                  () => DropdownButton<String>(
                    isExpanded: true,
                    underline: const SizedBox(),
                    value: recurringType.value,
                    items: const [
                      DropdownMenuItem(
                        value: 'Monthly',
                        child: Text('Monthly', style: TextStyle(fontSize: 16)),
                      ),
                      DropdownMenuItem(
                        value: 'Yearly',
                        child: Text('Yearly', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                    onChanged: (value) => recurringType.value = value!,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),

        const Text(
          'Choose an amount to donate',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ..._buildAmountRows(),

        const SizedBox(height: 20),
        const Text(
          'Or enter custom amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              width: 80,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              alignment: Alignment.center,
              child: const Text(
                'USD',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: otherAmountController,
                  keyboardType: TextInputType.number,
                  onTap: () => selectedAmount.value = -1,
                  decoration: const InputDecoration(
                    hintText: 'Enter amount',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        Obx(() => Row(
          children: [
            Checkbox(
              value: isDedicated.value,
              activeColor: AppColors.primary,
              onChanged: (val) => isDedicated.value = val ?? false,
            ),
            const Text(
              'Dedicate my donation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )),
        Obx(() {
          if (isDedicated.value) {
            return Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: honoreeController,
                decoration: const InputDecoration(
                  hintText: 'Enter honoree name',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),

        const SizedBox(height: 32),

        // Donate Button
        Obx(() => SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            onPressed: donationController.isLoading.value
                ? null
                : _handleDonation,
            child: donationController.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Donate Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        )),
        
        const SizedBox(height: 16),
        
        // Success Message
        Obx(() {
          if (donationController.donationSuccess.value) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Thank you for your donation!',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  List<Widget> _buildAmountRows() {
    List<Widget> rows = [];
    for (int i = 0; i < donationOptions.length; i += 2) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              _buildAmountBox(donationOptions[i], i),
              const SizedBox(width: 12),
              if (i + 1 < donationOptions.length)
                _buildAmountBox(donationOptions[i + 1], i + 1)
              else
                const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      );
    }
    return rows;
  }

  Widget _buildAmountBox(int amount, int index) {
    bool isSelected = selectedAmount.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectedAmount.value = index;
          otherAmountController.clear();
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey[300]!,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '\$$amount',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _handleDonation() {
    FocusScope.of(context).unfocus();

    double amountToSend = selectedAmount.value != -1
        ? donationOptions[selectedAmount.value].toDouble()
        : double.tryParse(otherAmountController.text) ?? 0;

    if (amountToSend <= 0) {
      Get.snackbar(
        'Invalid Amount',
        'Please enter a valid donation amount',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    donationController.createDonation(
      amount: amountToSend,
      type: selectedTab.value == 0 ? 'ONE_TIME' : 'RECURRING',
      recurringInterval: selectedTab.value == 1 ? recurringType.value.toUpperCase() : null,
      honoreeName: isDedicated.value ? honoreeController.text : null,
    );
  }

  void _resetForm() {
    otherAmountController.clear();
    selectedAmount.value = -1;
    isDedicated.value = false;
    honoreeController.clear();
  }

  @override
  void dispose() {
    otherAmountController.dispose();
    honoreeController.dispose();
    super.dispose();
  }
}