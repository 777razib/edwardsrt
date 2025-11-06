import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../core/app_colors.dart';
import '../../account text editing controller/account_text_editing_controller.dart';
import '../../otp/screen/otp_screen.dart';
import '../controller/send_email_with_otp_controller.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  AccountTextEditingController accountTextEditingController = Get.find<AccountTextEditingController>();
  ResetPasswordController resetPasswordController = Get.put(ResetPasswordController());


  // Focus nodes for highlighting on focus
  final FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    accountTextEditingController.emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Icon(Icons.arrow_back)),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(  // Scrollable
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Forget Password",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text("Recover your account password")
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Email Field
              const Text(
                "Email Address",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: accountTextEditingController.emailController,
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your email address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(  // Blue on focus
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 12),
                ),
              ),
              const SizedBox(height: 30),


              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _otpApiCallMethod,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _otpApiCallMethod()async {

    bool isSuccess=await  resetPasswordController.resetPasswordApiCallMethod();
    if(isSuccess) {
      Get.to(() => OtpScreen());
    }else {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
