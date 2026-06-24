import 'package:flutter/material.dart';
import 'package:jara_vendor/screens/shop_size/controller/shop_size_controller.dart';
import '../../widgets/status_bar.dart';
import '../../widgets/back_button.dart';
import 'package:get/get.dart';

ShopSizeController controller = Get.put(ShopSizeController());

class ShopSizeScreen extends StatefulWidget {
  const ShopSizeScreen({super.key});

  @override
  State<ShopSizeScreen> createState() => _ShopSizeScreenState();
}

class _ShopSizeScreenState extends State<ShopSizeScreen> {
  // String? _selectedSize;

  final List<Map<String, String>> _shopSizes = [
    {'id': 'just_me', 'name': 'It\'s just me'},
    {'id': '2-5', 'name': '2-5 people'},
    {'id': '6-10', 'name': '6-10 people'},
    {'id': '11+', 'name': '11+ people'},
  ];

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
                    'Shop size',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Kindly select your actual business size below.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: _shopSizes.length,
                  itemBuilder: (context, index) {
                    final size = _shopSizes[index];
                    final isSelected =
                        controller.selectedSize.value == size['id'];

                    return _buildSizeItem(size['name']!, isSelected, () {
                      setState(() {
                        controller.selectedSize.value = size['id']!;
                      });
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.selectedSize.value.isNotEmpty
                    ? () {
                        controller.updateVendorProfileBusinessShopSize();
                        //print(controller.selectedSize.value);
                      }
                    : null,
                child: const Text('Continue'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSizeItem(String name, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFFF9800) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFFFF9800) : Colors.black,
                ),
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
