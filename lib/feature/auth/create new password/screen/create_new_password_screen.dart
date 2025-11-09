import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/app_colors.dart';
import '../../account text editing controller/account_text_editing_controller.dart';
import '../../widget/dialog_screen.dart';
import '../controller/create_new_password_controller.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  @override
  _CreateNewPasswordScreenState createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {

  final AccountTextEditingController accountTextEditingController=Get.find<AccountTextEditingController>();
  final AddNewPassword addNewPassword=Get.put(AddNewPassword());

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogScreen(
          onContinue: () {
            Navigator.of(context).pop(); // Close dialog
            // Optionally: Navigate somewhere else after closing dialog
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    'Create a',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'New Password',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter your new password',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'New Password',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: _obscureNewPassword,
              controller: accountTextEditingController.newPasswordController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(  // Blue on focus
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                hintText: 'Enter new password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Confirm Password',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: _obscureConfirmPassword,
              controller: accountTextEditingController.passwordController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(  // Blue on focus
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                hintText: 'Confirm your password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _apiCallMethod,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _apiCallMethod() async {
    bool isSuccess = await addNewPassword.addNewPasswordApiCallMethod();

    if (isSuccess) {
      _showSuccessDialog();
    } else {
      Get.snackbar('Error', addNewPassword.errorMessage ?? 'Try again',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
