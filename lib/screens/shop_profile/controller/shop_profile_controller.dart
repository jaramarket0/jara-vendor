import 'dart:convert';
import 'dart:developer' as myLog;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jara_vendor/data/apiClient/apiClient.dart';
import 'package:jara_vendor/screens/checkout_address_change/models/lga_model.dart';
import 'package:jara_vendor/screens/checkout_address_change/models/state_model.dart';
import 'package:jara_vendor/screens/market_screen/models/models.dart';
import 'package:jara_vendor/screens/product_selection/models/mdels.dart';

/// Lets a vendor change the market they trade from and the categories they
/// carry, after onboarding. Both feed order routing -- an order only reaches
/// a vendor who is at the chosen market AND holds the item's category -- so
/// this is the screen that decides what work they get offered.
class ShopProfileController extends GetxController {
  final ApiClient apiClient = ApiClient(const Duration(seconds: 60));

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;

  // Current, as saved on the server.
  final Rx<MarketData?> currentMarket = Rx<MarketData?>(null);
  final RxList<Data> currentCategories = <Data>[].obs;

  // Pickers.
  final RxList<MarketData> markets = <MarketData>[].obs;
  final RxBool isLoadingMarkets = false.obs;
  final RxList<Data> allCategories = <Data>[].obs;
  final RxBool isLoadingCategories = false.obs;

  // Market filters, mirroring onboarding so the list stays navigable.
  final RxList<StateData> states = <StateData>[].obs;
  final RxList<LgaData> lgas = <LgaData>[].obs;
  final Rx<StateData?> selectedState = Rx<StateData?>(null);
  final Rx<LgaData?> selectedLga = Rx<LgaData?>(null);
  final RxBool isLoadingLgas = false.obs;

  /// Ticked in the category sheet; only committed on save.
  final RxSet<int> draftCategoryIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    load();
    fetchStates();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await apiClient.getVendorShopProfile();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as Map<String, dynamic>;
        final market = data['market'];
        currentMarket.value =
            market == null ? null : MarketData.fromJson(market as Map<String, dynamic>);
        currentCategories.value = ((data['categories'] as List?) ?? [])
            .map((e) => Data.fromJson(e as Map<String, dynamic>))
            .toList();
        draftCategoryIds
          ..clear()
          ..addAll(currentCategories.map((c) => c.id));
      } else {
        errorMessage.value = 'Could not load your shop details.';
      }
    } catch (e) {
      myLog.log('ShopProfile load: $e');
      errorMessage.value = 'Could not connect. Pull down to retry.';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Market ────────────────────────────────────────────────────────────────

  Future<void> fetchStates() async {
    try {
      final response = await apiClient.fetchState();
      if (response.statusCode == 200 || response.statusCode == 201) {
        states.value = stateModelFromJson(response.body).data ?? [];
      }
    } catch (e) {
      myLog.log('ShopProfile fetchStates: $e');
    }
  }

  Future<void> onStateChanged(StateData? state) async {
    selectedState.value = state;
    selectedLga.value = null;
    lgas.clear();
    fetchMarkets();
    if (state?.id == null) return;
    isLoadingLgas.value = true;
    try {
      final response = await apiClient.fetchLgas(state!.id.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        lgas.value = lgaModelFromJson(response.body).data ?? [];
      }
    } catch (e) {
      myLog.log('ShopProfile fetchLgas: $e');
    } finally {
      isLoadingLgas.value = false;
    }
  }

  void onLgaChanged(LgaData? lga) {
    selectedLga.value = lga;
    fetchMarkets();
  }

  Future<void> fetchMarkets() async {
    isLoadingMarkets.value = true;
    try {
      final response = await apiClient.fetchMarkets(
        stateId: selectedState.value?.id,
        lgaId: selectedLga.value?.id,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        markets.value = marketModelFromJson(response.body).data;
      }
    } catch (e) {
      myLog.log('ShopProfile fetchMarkets: $e');
    } finally {
      isLoadingMarkets.value = false;
    }
  }

  Future<void> saveMarket(MarketData market) async {
    if (isSaving.value) return;
    isSaving.value = true;
    try {
      final response = await apiClient.updateVendorShopProfile(marketId: market.id);
      if (_ok(response.statusCode)) {
        currentMarket.value = market;
        Get.back();
        _toast('Market updated', 'You now trade from ${market.name}.', ok: true);
      } else {
        _toast('Could not update market', _messageOf(response.body));
      }
    } catch (e) {
      _toast('Could not update market', 'Please try again.');
    } finally {
      isSaving.value = false;
    }
  }

  // ── Categories ────────────────────────────────────────────────────────────

  Future<void> fetchCategories() async {
    if (allCategories.isNotEmpty) return;
    isLoadingCategories.value = true;
    try {
      final response = await apiClient.fetchVendorCategories();
      if (response.statusCode == 200 || response.statusCode == 201) {
        allCategories.value = vendorCategoryModelFromJson(response.body).data;
      }
    } catch (e) {
      myLog.log('ShopProfile fetchCategories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  void toggleCategory(int id) {
    if (draftCategoryIds.contains(id)) {
      draftCategoryIds.remove(id);
    } else {
      draftCategoryIds.add(id);
    }
  }

  void resetDraft() {
    draftCategoryIds
      ..clear()
      ..addAll(currentCategories.map((c) => c.id));
  }

  Future<void> saveCategories() async {
    if (isSaving.value) return;
    if (draftCategoryIds.isEmpty) {
      // The server rejects this too; saying so here avoids a pointless round
      // trip and explains why it matters.
      _toast('Pick at least one',
          'Orders are matched to you by the categories you carry.');
      return;
    }
    isSaving.value = true;
    try {
      final response = await apiClient.updateVendorShopProfile(
          categoryIds: draftCategoryIds.toList());
      if (_ok(response.statusCode)) {
        final data = jsonDecode(response.body)['data'] as Map<String, dynamic>;
        currentCategories.value = ((data['categories'] as List?) ?? [])
            .map((e) => Data.fromJson(e as Map<String, dynamic>))
            .toList();
        Get.back();
        _toast('Categories updated',
            'You now carry ${currentCategories.length} '
            '${currentCategories.length == 1 ? 'category' : 'categories'}.',
            ok: true);
      } else {
        _toast('Could not update categories', _messageOf(response.body));
      }
    } catch (e) {
      _toast('Could not update categories', 'Please try again.');
    } finally {
      isSaving.value = false;
    }
  }

  bool _ok(int code) => code == 200 || code == 201;

  String _messageOf(String body) {
    try {
      return jsonDecode(body)['message']?.toString() ?? 'Please try again.';
    } catch (_) {
      return 'Please try again.';
    }
  }

  void _toast(String title, String message, {bool ok = false}) {
    Get.snackbar(title, message,
        backgroundColor: ok ? Colors.green : Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP);
  }
}
