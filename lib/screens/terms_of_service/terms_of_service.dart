import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:jara_vendor/screens/terms_of_service/controller/terms_of_service_controller.dart';

TermsOfServiceController termsOfServiceController = Get.put(
  TermsOfServiceController(),
);

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'JARAMARKET VENDOR SERVICE AGREEMENT',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This Vendor Service Agreement ("Agreement") is made between JaraMarket ("Platform") and the Vendor ("Vendor") who signs up to supply and fulfill customer orders on the JaraMarket platform.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildSection(
              '1. Vendor Responsibilities',
              'Vendor agrees to maintain an up-to-date inventory of goods listed on JaraMarket.\n\n'
                  'Vendor shall process all received orders within the stipulated timeframe and ensure prompt delivery to the JaraMarket Packaging Hub before the countdown timer elapses. Vendor shall maintain quality standards and accurate order fulfillment.',
            ),
            _buildSection(
              '2. Order Fulfillment & Countdown',
              'Once an order is received, a countdown timer (as specified per item or category) begins. Vendor must deliver the items to the designated Packaging Hub before the timer expires otherwise, the vendor will be losing rating with Jaramarket and Failure to meet delivery times consistently may result in temporary suspension or permanent delisting.',
            ),
            _buildSection(
              '3. Payments & Fees',
              'JaraMarket shall remit payments for fulfilled orders within 2 hrs after successful delivery. A 5% service fee shall be deducted from each order to cover platform services and logistics. All payments are made via the platform\'s vendor wallet or directly to the vendor\'s bank account.',
            ),
            _buildSection(
              '4. Product Quality & Liability',
              'Vendor is responsible for ensuring all products are of acceptable quality and fit for consumption/use. JaraMarket reserves the right to remove any product or vendor reported for repeated customer dissatisfaction or product issues and may terminate this contract on such repeated infractions.',
            ),
            _buildSection(
              '5. Cancellation & Refunds',
              'Vendors must notify JaraMarket immediately of any order they are unable to fulfill by refusing to accept the order. Any losses due to late cancellations or non-availability may be charged to the Vendor if avoidable.',
            ),
            _buildSection(
              '6. Compliance',
              'Vendor agrees to comply with all laws and regulations applicable to the sale and handling of food or goods listed. JaraMarket reserves the right to audit, inspect or request documentation for compliance.',
            ),
            _buildSection(
              '7. Termination',
              'Either party may terminate this Agreement with a [15-30 day] notice. JaraMarket may terminate the agreement immediately for breach of contract, repeated lateness, or customer complaints.',
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'By accepting this agreement, you are bound by the terms as stated.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text('I Accept'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
