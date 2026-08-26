import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/data/apiClient/apiClient.dart';

class NewPasswordController extends GetxController {
  ApiClient apiClient = ApiClient(const Duration(seconds: 60 * 5));

  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    // Disposed here rather than mid-flow, so returning to the screen (or a
    // failed attempt) never hits a disposed controller.
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  String? validate() {
    if (otpController.text.trim().isEmpty) return 'Enter the code sent to your email.';
    if (passwordController.text.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    if (passwordController.text != confirmPasswordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  /// Backend's /reset-password takes {email, otp, password} in one call, so
  /// the OTP must NOT be consumed by a separate verify step beforehand.
  Future<void> resetPassword(String email) async {
    final problem = validate();
    if (problem != null) {
      Get.snackbar('Check your details', problem,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await apiClient.resetPassword({
        'email': email,
        'otp': otpController.text.trim(),
        'password': passwordController.text,
      });
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Password reset successful. Please log in.',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed('/login');
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
      Get.snackbar('Error', 'Network error — please try again.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
