import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jara_vendor/data/apiClient/apiClient.dart';
import 'package:jara_vendor/screens/market_screen/models/models.dart';
import 'package:jara_vendor/utils/storage.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'dart:developer' as myLog;

class MarketController extends GetxController {
  ApiClient apiClient = ApiClient(Duration(seconds: 60 * 5));

  RxList<MarketData> markets = <MarketData>[].obs;
  RxBool isLoading = false.obs;
  Rx<MarketData?> selectedMarket = Rx<MarketData?>(null);

  @override
  onInit() {
    super.onInit();
    fetchMarkets();
  }

  Future<void> fetchMarkets() async {
    isLoading.value = true;
    try {
      var response = await apiClient.fetchMarkets();
      if (response.statusCode == 200 || response.statusCode == 201) {
        var model = marketModelFromJson(response.body);
        markets.value = model.data;
      } else {
        Get.snackbar(
          "Error",
          "Failed to load markets: ${response.body}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      myLog.log(e.toString());
      Get.snackbar(
        "Error occurred:",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateVendorProfileMarket() async {
    if (selectedMarket.value == null) return;
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
    var email = await dataBase.getEmail();
    try {
      String url = '${apiClient.baseUrl}/profile-update/$email';
      Map<String, String> headers = {'Accept': 'application/json'};

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields['market_id'] = selectedMarket.value!.id.toString();

      var response = await request.send();
      myLog.log('Response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        await dataBase.saveMarketName(selectedMarket.value!.name);
        Get.snackbar(
          "Success",
          "Market updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.pushNamed(Get.context!, '/payment-method');
      } else {
        OverlayLoadingProgress.stop();
        var responseBody = await response.stream.bytesToString();
        Get.snackbar("Error:", " ${response.statusCode} - $responseBody");
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      Get.snackbar("Error occurred:", e.toString());
      myLog.log(e.toString());
    } finally {
      OverlayLoadingProgress.stop();
    }
  }
}
