import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/screens/checkout_address_change/models/lga_model.dart'
    show LgaData; // lga_model also defines a `State` class that clashes with Flutter's
import 'package:jara_vendor/screens/checkout_address_change/models/state_model.dart';
import 'package:jara_vendor/screens/market_screen/controller/market_controller.dart';
import 'package:jara_vendor/screens/market_screen/models/models.dart';
import '../../widgets/status_bar.dart';
import '../../widgets/back_button.dart';

MarketController controller = Get.put(MarketController());

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusBar(),
              const SizedBox(height: 16),
              Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 16),
                  const Text(
                    'Select your market',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'We\'ll route nearby orders to vendors stationed at the market you pick, so deliveries stay fast.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildFilters(),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: _buildMarketList(),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.selectedMarket.value != null
                      ? () => controller.updateVendorProfileMarket()
                      : null,
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildDropdown<StateData>(
              hint: 'All States',
              value: controller.selectedState.value,
              items: controller.states,
              labelOf: (s) => s.name ?? '',
              onChanged: (s) => controller.onStateChanged(s),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: controller.isLoadingLgas.value
                ? Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.amber,
                      ),
                    ),
                  )
                : _buildDropdown<LgaData>(
                    hint: 'All LGAs',
                    value: controller.selectedLga.value,
                    items: controller.lgas,
                    labelOf: (l) => l.name ?? '',
                    onChanged: controller.selectedState.value != null
                        ? (l) => controller.onLgaChanged(l)
                        : null,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) labelOf,
    required void Function(T?)? onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: onChanged == null ? Colors.grey.shade100 : Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T?>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          items: [
            DropdownMenuItem<T?>(
              value: null,
              child: Text(
                hint,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
            ...items.map(
              (item) => DropdownMenuItem<T?>(
                value: item,
                child: Text(
                  labelOf(item),
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildMarketList() {
    if (controller.isLoading.value) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }
    if (controller.markets.isEmpty) {
      return Center(
        key: const ValueKey('empty'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront_outlined,
                size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              controller.selectedState.value != null
                  ? 'No markets in this location yet.\nTry a different state or LGA.'
                  : 'No markets available yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      key: ValueKey(
        'list-${controller.selectedState.value?.id}-${controller.selectedLga.value?.id}',
      ),
      itemCount: controller.markets.length,
      itemBuilder: (context, index) {
        final market = controller.markets[index];
        final isSelected = controller.selectedMarket.value?.id == market.id;

        return _buildMarketItem(market, isSelected, () {
          controller.selectedMarket.value = market;
        });
      },
    );
  }

  Widget _buildMarketItem(
      MarketData market, bool isSelected, VoidCallback onTap) {
    final location = [
      market.lgaName,
      market.stateName,
    ].where((part) => part != null && part.isNotEmpty).join(', ');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFFF9800) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? const Color(0xFFFFF8EE) : Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    market.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected ? const Color(0xFFFF9800) : Colors.black,
                    ),
                  ),
                  if (location.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              location,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (market.address != null && market.address!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        market.address!,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFFFF9800)),
          ],
        ),
      ),
    );
  }
}
