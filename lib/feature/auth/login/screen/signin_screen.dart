// lib/feature/auth/login/screen/signin_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app_colors.dart';
import '../../../choose interest/screen/choose_interest_screen.dart';
import '../../account text editing controller/account_text_editing_controller.dart';
import '../../forget password/screen/forget_password_screen.dart';
import '../../signup/screen/signup_screen.dart';
import '../controller/login_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Get controllers (singleton)
  final LoginApiRiderController _loginCtrl = Get.put(LoginApiRiderController());
  final AccountTextEditingController _acctCtrl = Get.find<AccountTextEditingController>();

  bool obscurePassword = true;
  bool rememberMe = false;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

 /* @override
  void dispose() {
    // Clear text when leaving screen (optional)
    _acctCtrl.clearAll();

    // Dispose only local FocusNodes
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF6EC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // Logo
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/icons/WhatsApp Image 2025-10-31 at 17.04.52_8ebc47d0.jpg",
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, size: 50, color: Colors.grey);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Title
              const Center(
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Email Field
              const Text("Email Address", style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              TextField(
                controller: _acctCtrl.emailController,
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Enter your email address",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              const Text("Password", style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              TextField(
                controller: _acctCtrl.passwordController,
                focusNode: passwordFocusNode,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  suffixIcon: IconButton(
                    icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Remember Me + Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                          return states.contains(MaterialState.selected) ? AppColors.primary : Colors.white;
                        }),
                        side: BorderSide(color: Colors.grey.shade400),
                        onChanged: (value) => setState(() => rememberMe = value ?? false),
                      ),
                      const Text("Remember Me", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => const ForgetPasswordScreen()),
                    child: const Text("Forgot Password", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _apiCallButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Sign Up Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    GestureDetector(
                      onTap: () => Get.to(() => const SignUpScreen()),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _apiCallButton() async {
    final isSuccess = await _loginCtrl.loginApiRiderMethod();
    if (isSuccess) {
      Get.offAll(() => const ChooseInterestScreen()); // Clears navigation stack
    } else {
      Get.snackbar(
        "Login Failed",
        _loginCtrl.errorMessage ?? "Something went wrong",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
}