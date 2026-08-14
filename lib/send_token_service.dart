import 'dart:convert';
import 'dart:io';


import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';


import 'dart:developer' as myLog;

import 'package:jara_vendor/data/apiClient/apiClient.dart';
import 'package:jara_vendor/utils/storage.dart';

// import 'package:novelux/config/api_service.dart';

class SendTokenService extends GetxService {
  // This class is intentionally left empty as the token refresh listener
  // has been moved to main.dart for better lifecycle management.
  ApiClient apiClient = ApiClient(Duration(seconds: 60 * 5));

  ///devicetokens/register

  void registerToken(
    String token,
    String? deviceModel,
    String? appVersion,
  ) async {
    // The endpoint is authenticated: posting before login returns 401, which
    // AuthHttpClient treats as an expired session and bounces the user to
    // the login screen. registerCurrentToken() re-runs this after login.
    final authToken = await dataBase.getToken();
    if (authToken.isEmpty) {
      myLog.log('No auth token — skipping FCM registration until after login');
      return;
    }
    myLog.log('Registering token: $token');

    final deviceInfo = DeviceInfoPlugin();
    if (deviceModel == null || appVersion == null) {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceModel ??= androidInfo.model;
        appVersion ??= androidInfo.version.release;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceModel ??= iosInfo.utsname.machine;
        appVersion ??= iosInfo.systemVersion;
      }
    }
    var body = {
      "fcm_token": token,
      // "platform": Platform.isAndroid ? "Android" : "iOS", // "iOS" or "Android"
      // "device_model": deviceModel,
      // "app_version": appVersion,
    };

    myLog.log('Request body: $body');

    var response = await apiClient.sendFcmToken(body);

    if (response.statusCode == 200) {
      myLog.log('Token registered successfully');
      var responseBody = jsonDecode(response.body);
      myLog.log('Response body: $responseBody');
      myLog.log('Message from server: ${responseBody['message']}');
    } else {
      myLog.log('Failed to register token: ${response.statusCode}');
    }

    // try {
    //   var response = await apiClient.postData('/register-token', {'token': token});
    //   if (response.statusCode == 200) {
    //     print('Token registered successfully');
    //   } else {
    //     print('Failed to register token: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   print('Error registering token: $e');
    // }
  }

  /// Fetch the device's current FCM token and register it with the backend.
  ///
  /// Registration at app start is skipped when nobody is signed in yet (the
  /// endpoint is authenticated), and onTokenRefresh only fires when the
  /// token actually changes -- so without calling this right after login the
  /// token never reaches the server and every push is silently dropped.
  Future<void> registerCurrentToken() async {
    try {
      final authToken = await dataBase.getToken();
      if (authToken.isEmpty) return;
      if (!kIsWeb &&
          Platform.isIOS &&
          await FirebaseMessaging.instance.getAPNSToken() == null) {
        return; // APNS not ready yet; onTokenRefresh will cover it
      }
      final token = await FirebaseMessaging.instance
          .getToken()
          .timeout(const Duration(seconds: 20), onTimeout: () => null);
      if (token != null) registerToken(token, null, null);
    } catch (e) {
      myLog.log('registerCurrentToken failed: $e');
    }
  }
}
