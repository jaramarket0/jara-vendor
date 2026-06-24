// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// class DashboardController extends GetxController {

// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jara_vendor/screens/dashboard_screen/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  // ─── State ──────────────────────────────────────────────────────────────────
  final Rx<DashboardModel?> dashboardData = Rx<DashboardModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// 'day' | 'week' | 'month'  (default per API docs: week)
  final RxString selectedPeriod = 'week'.obs;

  static const String _baseUrl = 'https://jaramarket.kenjeffy.com/api/jaram';

  // ─── Lifecycle ───────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  // ─── API Call ────────────────────────────────────────────────────────────────
  Future<void> fetchDashboard({String? period}) async {
    final activePeriod = period ?? selectedPeriod.value;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final url = Uri.parse('$_baseUrl/vendor/dashboard');
      debugPrint('[DashboardController] GET $url (period: $activePeriod)');

      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('[DashboardController] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        dashboardData.value = DashboardModel.fromJson(body);
        selectedPeriod.value = activePeriod;
      } else if (response.statusCode == 401) {
        Get.snackbar('SESSEION EXPIRED', 'Please log in again to continue');
        Get.toNamed('/login');
      } else {
        final body = jsonDecode(response.body);
        errorMessage.value =
            body['message']?.toString() ?? 'Failed to load dashboard';
      }
    } catch (e) {
      debugPrint('[DashboardController] Error: $e');
      errorMessage.value = 'An error occurred. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void changePeriod(String period) {
    if (period == selectedPeriod.value) return;
    fetchDashboard(period: period);
  }
}
