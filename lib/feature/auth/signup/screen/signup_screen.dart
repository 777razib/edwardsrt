import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app_colors.dart';
import '../../account text editing controller/account_text_editing_controller.dart';
import '../../login/screen/signin_screen.dart';
import '../controller/sign_up_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final AccountTextEditingController accountTextEditingController = Get.find<AccountTextEditingController>();
  final SignUpApiController signUpApiController = Get.put(SignUpApiController());
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Password Visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(
          "Sign Up".tr,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Header
               Center(
                child: Column(
                  children: [
                    Text(
                      "Create your account".tr,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Lorem ipsum dolor sit amet".tr,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // First Name
              _buildLabel("First Name".tr),
              _buildTextField(
                controller: accountTextEditingController.firstNameController,
                hintText: "Enter your first name".tr,
                validator: (value) => value?.isEmpty == true ? 'Please enter your first name' : null,
              ),
              const SizedBox(height: 16),

              // Last Name
              _buildLabel("Last Name".tr),
              _buildTextField(
                controller: accountTextEditingController.lastNameController,
                hintText: "Enter your last name".tr,
                validator: (value) => value?.isEmpty == true ? 'Please enter your last name' : null,
              ),
              const SizedBox(height: 16),

              // Email
              _buildLabel("E-mail".tr),
              _buildTextField(
                controller: accountTextEditingController.emailController,
                hintText: "Enter your email".tr,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Please enter your email'.tr;
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                    return 'Please enter a valid email address'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              _buildLabel("Password".tr),
              _buildTextField(
                controller: accountTextEditingController.passwordController,
                hintText: "Enter your password".tr,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),

              // Confirm Password
              _buildLabel("Confirm Password".tr),
              _buildTextField(
                controller: _confirmPasswordController,
                hintText: "Enter your password again".tr,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
                validator: (value) {
                  if (value?.isEmpty == true) return 'Please confirm your password'.tr;
                  if (value != accountTextEditingController.passwordController.text) {
                    return 'Passwords do not match'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _handleSignUp,
                  child:  Text(
                    "Sign Up".tr,
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text("Already have an account? ".tr, style: TextStyle(color: Colors.black54)),
                    GestureDetector(
                      onTap: () => Get.off(() => const SignInScreen()),
                      child:  Text(
                        "Login".tr,
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Label
  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14));
  }

  // Reusable TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      validator: validator,
    );
  }

  // Strong Password Validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password'.tr;
    if (value.length < 8) return 'Password must be at least 8 characters long'.tr;

    int numCount = value.replaceAll(RegExp(r'[^0-9]'), '').length;
    int lowerCount = value.replaceAll(RegExp(r'[^a-z]'), '').length;
    int upperCount = value.replaceAll(RegExp(r'[^A-Z]'), '').length;
    int specialCount = value.replaceAll(RegExp(r'[a-zA-Z0-9]'), '').length;

    if (numCount < 2) return 'Password must contain at least 2 numbers'.tr;
    if (lowerCount < 2) return 'Password must contain at least 2 lowercase letters'.tr;
    if (upperCount < 2) return 'Password must contain at least 2 uppercase letters'.tr;
    if (specialCount < 2) return 'Password must contain at least 2 special characters'.tr;

    return null;
  }

  // Handle Sign Up
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      bool isSuccess = await signUpApiController.signUpApiMethod();
      if (isSuccess) {
        Get.offAll(() => const SignInScreen());
      }
    }
  }
}
