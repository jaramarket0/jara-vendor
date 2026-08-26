import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/data/apiClient/apiClient.dart';
import 'package:jara_vendor/screens/new_password_screen/new_password_screen.dart';

class ForgetPasswordController extends GetxController {
  ApiClient apiService = ApiClient(Duration(seconds: 60 * 5));
  RxBool isLoading = false.obs;
  TextEditingController emailController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> requestPasswordReset() async {
    isLoading.value = true;

    try {
      final resetData = {
        'email': emailController.text,
        //'reset_password': true, // Flag to indicate password reset request
      };

      // Use login endpoint to trigger password reset flow
      final response = await apiService.forgotPassword(resetData);

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final email = emailController.text.trim();
        // Straight to the reset screen -- the signup OTP screen verifies via
        // the signup endpoint and drops the user into vendor onboarding,
        // which is not what a password reset should do. It also consumes the
        // OTP that /reset-password still needs.
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => NewPasswordScreen(email: email),
          ),
        );
      } else {
        String message = 'Something went wrong';
        try {
          message = (jsonDecode(response.body)['message'] ?? message).toString();
        } catch (_) {}
        Get.snackbar('Password reset failed', message,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;

      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
