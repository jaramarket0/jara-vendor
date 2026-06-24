import 'dart:async';
import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/data/apiClient/apiClient.dart';
import 'package:jara_vendor/screens/email_verification/models/models.dart';
import 'package:jara_vendor/utils/storage.dart';
import 'package:overlay_kit/overlay_kit.dart';
// import 'package:overlay_kit/overlay_kit.dart';

class OtpVerificationController extends GetxController {
  ApiClient apiClient = ApiClient(Duration(milliseconds: 60 * 5));
  EmailVerificationModel emailVerificationModel = EmailVerificationModel();
  Data data = Data();
  RxBool isLoading = false.obs;
  RxInt resendSeconds = 240.obs; // 15 minutes in seconds

  // int _resendSeconds = 900; // 4 minutes in seconds
  Timer? timer;

  void startResendTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //  setState(() {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
      } else {
        timer?.cancel();
      }
      // });
    });
  }

  Future<void> verifyEmail(Map<String, String> otpData) async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
    myLog.log('Verifying OTP: ${otpData['otp']}');
    isLoading.value = true;

    try {
      // final otpData = {
      //   'email': widget.email,
      //   'otp': _otpController.text,
      // };

      final response = await apiClient.validateUserSignupEmail(otpData);

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        // Navigator.pushReplacement(
        //   Get.context!,
        //   MaterialPageRoute(builder: (context) => const LoginScreen()),
        // );
        var responseBody = jsonDecode(response.body);
        emailVerificationModel = emailVerificationModelFromJson(response.body);
        data = emailVerificationModel.data!;
        await dataBase.saveReferalCode(data.referralCode ?? 'N/A');
        await dataBase.saveRole(data.role ?? 'N/A');
        var message = responseBody['message'] ?? 'something went wrong';
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Success: \n${message}'),
            backgroundColor: Colors.green,
          ),
        );
        // Get.offAllNamed('/login_screen');
        //Navigator.of(Get.context!).push(CupertinoPageRoute(builder: (context)=> const ProfileSetupScreen()));
        Navigator.pushNamed(Get.context!, '/business-name');
      } else {
        OverlayLoadingProgress.stop();
        var responseBody = jsonDecode(response.body);
        var message =
            responseBody['errors']['otp'][0] ?? 'something went wrong';

        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('OTP verification failed: ${message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      isLoading.value = false;
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> verifyOtp(Map<String, String> otpData) async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
    myLog.log('Verifying OTP: ${otpData['otp']}');
    isLoading.value = true;

    try {
      // final otpData = {
      //   'email': widget.email,
      //   'otp': _otpController.text,
      // };

      final response = await apiClient.validateUserLoginOtp(otpData);

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        // Navigator.pushReplacement(
        //   Get.context!,
        //   MaterialPageRoute(builder: (context) => const LoginScreen()),
        // );
        var responseBody = jsonDecode(response.body);
        emailVerificationModel = emailVerificationModelFromJson(response.body);
        data = emailVerificationModel.data!;
        await dataBase.saveReferalCode(data.referralCode ?? 'N/A');
        await dataBase.saveRole(data.role ?? 'N/A');
        var message = responseBody['message'] ?? 'something went wrong';
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Success: \n${message}'),
            backgroundColor: Colors.green,
          ),
        );
        // Get.offAllNamed('/login_screen');
        //Navigator.of(Get.context!).push(CupertinoPageRoute(builder: (context)=> const ProfileSetupScreen()));
        Get.offAllNamed('/login');
      } else {
        OverlayLoadingProgress.stop();
        var responseBody = jsonDecode(response.body);
        var message =
            responseBody['errors']['otp'][0] ?? 'something went wrong';

        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('OTP verification failed: ${message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      isLoading.value = false;
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> resendOtp(Map<String, String> resendData) async {
    try {
      // final resendData = {
      //   'email': widget.email,
      // };

      // You might need to implement a resend OTP endpoint in your API service
      // For now, we'll reuse the registration endpoint
      final response = await apiClient.resendOtp(resendData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        resendSeconds.value = 240;
        startResendTimer();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('A new code has been sent to your email'),
            backgroundColor: Colors.amber,
          ),
        );
        //_startCountdown();
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Failed to resend code: ${response.body}["message"]'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
