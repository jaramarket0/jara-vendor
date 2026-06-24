import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:jara_vendor/screens/payment_method/controller/payment_method_controller.dart';
import '../../widgets/status_bar.dart';
import '../../widgets/back_button.dart';

PaymentMethodController controller = Get.put(PaymentMethodController());

/// PaymentMethodScreen allows users to choose between online and offline payment methods
/// This is the fifth step in the vendor onboarding process
class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  // Default selected payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status bar and progress indicator
            const StatusBar(),
            _buildProgressIndicator(),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Back button and title
                    Row(
                      children: [
                        const CustomBackButton(),
                        const SizedBox(width: 16),
                        Text(
                          'Payment method',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Description text
                    Text(
                      'Let us know how you want to be paid. Don\'t forget, JaraMarket gets paid via bank transfer from our users.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Payment method cards
                    Row(
                      children: [
                        // Online Payment Card
                        Expanded(
                          child: _buildPaymentCard(
                            title: 'Online Payment',
                            icon: Icons.credit_card,
                            iconColor: Colors.white,
                            iconBackground: Colors.green,
                            description: 'Get paid in minutes.',
                            features: [
                              'Enjoy fast payment',
                              'Secure',
                              'Get jaraloan to boost your stock',
                              'Enjoy order preferences.',
                              // 'Lorem ipsum dolor sit a',
                              // 'Lorem ipsum dolor sit a',
                            ],
                            isSelected:
                                controller.selectedPaymentMethod.value ==
                                'online',
                            onTap: () {
                              setState(() {
                                controller.selectedPaymentMethod.value =
                                    'online';
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Offline Payment Card
                        Expanded(
                          child: _buildPaymentCard(
                            title: 'Offline Payment',
                            icon: Icons.cloud_outlined,
                            iconColor: Colors.white,
                            iconBackground: Colors.orange,
                            description: 'Get paid within 6 hours.',
                            features: [
                              'Physical delivery record is needed.',
                              'Payment is done within 6 hours.',
                              // 'Lorem ipsum dolor sit a',
                              // 'Lorem ipsum dolor sit a',
                            ],
                            isSelected:
                                controller.selectedPaymentMethod.value ==
                                'offline',
                            onTap: () {
                              setState(() {
                                controller.selectedPaymentMethod.value =
                                    'offline';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  controller.updateVendorProfilePaymentMethod();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Row(
        children: List.generate(
          7,
          (index) => Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index < 5 ? Colors.orange : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String description,
    required List<String> features,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        //height: 410,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),

            // Features with checkmarks
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
