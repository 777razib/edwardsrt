import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/app_colors.dart';
import '../../account text editing controller/account_text_editing_controller.dart';
import '../../create new password/screen/create_new_password_screen.dart';
import '../../forget password/controller/send_email_with_otp_controller.dart';
import '../controller/otp_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final OtpController otpController = Get.put(OtpController());
  ResetPasswordController resetPasswordController = Get.find<ResetPasswordController>();

  final AccountTextEditingController accountTextEditingController = Get.find<AccountTextEditingController>();

  int _secondsRemaining = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < AccountTextEditingController.otpLength - 1) {
      FocusScope.of(context).requestFocus(accountTextEditingController.focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(accountTextEditingController.focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(50),
            ),
            child: const BackButton(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Enter OTP',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(color: Colors.grey, fontSize: 14),
                children: [
                  TextSpan(text: "We have just sent you 5 digit code via your\nemail "),
                  TextSpan(
                    text: "example@gmail.com",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ✅ Use otpInputController (the actual field name)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(AccountTextEditingController.otpLength, (index) {
                return SizedBox(
                  width: 56,
                  height: 56,
                  child: TextField(
                    // ✅ Use the operator instead of direct field access
                    controller: accountTextEditingController[index],
                    focusNode: accountTextEditingController.focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) => _onChanged(value, index),
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: apiCallButton,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: const Text(
                  'Confirm Code',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  const TextSpan(text: 'Resend code in '),
                  TextSpan(
                    text: '$_secondsRemaining s',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _secondsRemaining == 0
                  ? () {
                setState(() {
                  _secondsRemaining = 60;
                  startTimer();
                });
              }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive code? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: resendOtpApiCallMethod,
                    child: Text(
                      'Resend Code',
                      style: TextStyle(
                        color: _secondsRemaining == 0 ? AppColors.primary : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> apiCallButton() async{
    Get.to(() => CreateNewPasswordScreen());
/*
    bool isSuccess=await otpController.otpApiCallMethod();
  if(isSuccess){
      // Get the complete OTP using the getOtpString method
      final otp = accountTextEditingController.getOtpString();
      print('Entered OTP: $otp');
      Get.to(() => CreateNewPasswordScreen());
  }*/

  }

  Future<void> resendOtpApiCallMethod()async {
    bool isSuccess=await  resetPasswordController.resetPasswordApiCallMethod();
    if(isSuccess) {
      Get.snackbar("Success", "OTP sent successfully");
     /// Get.to(() => OtpScreen());
    }else {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}