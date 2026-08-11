import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jara_vendor/data/apiClient/apiClient.dart';
import 'package:jara_vendor/screens/checkout_address_change/models/lga_model.dart';
import 'package:jara_vendor/screens/checkout_address_change/models/state_model.dart';
import 'package:jara_vendor/screens/market_screen/models/models.dart';
import 'package:jara_vendor/utils/storage.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'dart:developer' as myLog;

class MarketController extends GetxController {
  ApiClient apiClient = ApiClient(Duration(seconds: 60 * 5));

  RxList<MarketData> markets = <MarketData>[].obs;
  RxBool isLoading = false.obs;
  Rx<MarketData?> selectedMarket = Rx<MarketData?>(null);

  // State/LGA filters -- LGA list depends on the chosen state, and every
  // change refetches the (server-filtered) market list.
  RxList<StateData> states = <StateData>[].obs;
  RxList<LgaData> lgas = <LgaData>[].obs;
  Rx<StateData?> selectedState = Rx<StateData?>(null);
  Rx<LgaData?> selectedLga = Rx<LgaData?>(null);
  RxBool isLoadingLgas = false.obs;

  @override
  onInit() {
    super.onInit();
    fetchStates();
    fetchMarkets();
  }

  Future<void> fetchStates() async {
    try {
      var response = await apiClient.fetchState();
      if (response.statusCode == 200 || response.statusCode == 201) {
        var model = stateModelFromJson(response.body);
        states.value = model.data ?? [];
      }
    } catch (e) {
      myLog.log('fetchStates: $e');
    }
  }

  Future<void> onStateChanged(StateData? state) async {
    selectedState.value = state;
    selectedLga.value = null;
    lgas.clear();
    // A previously picked market outside the new filter shouldn't stay
    // silently selected behind the scenes.
    selectedMarket.value = null;
    fetchMarkets();
    if (state?.id == null) return;
    isLoadingLgas.value = true;
    try {
      var response = await apiClient.fetchLgas(state!.id.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var model = lgaModelFromJson(response.body);
        lgas.value = model.data ?? [];
      }
    } catch (e) {
      myLog.log('fetchLgas: $e');
    } finally {
      isLoadingLgas.value = false;
    }
  }

  void onLgaChanged(LgaData? lga) {
    selectedLga.value = lga;
    selectedMarket.value = null;
    fetchMarkets();
  }

  Future<void> fetchMarkets() async {
    isLoading.value = true;
    try {
      var response = await apiClient.fetchMarkets(
        stateId: selectedState.value?.id,
        lgaId: selectedLga.value?.id,
      );
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
