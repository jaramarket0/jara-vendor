import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:jara_vendor/screens/privacy_policy/controller.dart/privacy_policy_controller.dart';

PrivacyPolicyController controller = Get.put(PrivacyPolicyController());

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'JARAMARKET VENDOR PRIVACY POLICY',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'At JaraMarket, your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our platform, including our website and mobile applications. By using JaraMarket, you agree to the terms of this policy.',
              style: TextStyle(fontSize: 14),
            ),
            _buildSection(
              '1. Information We Collect',
              'a. Personal Information. We may collect personal details such as:\n'
                  'Full name - Email address - Phone number - Delivery address - Payment information\n\n'
                  'b. Vendor Information\n'
                  'Vendors may be required to provide: Business name - Account details - Bank information for payouts - Location for pickup coordination\n\n'
                  'c. Usage Information\n'
                  'We collect: Order history - Interaction with the app/website - Device and browser data - Location data (with permission)',
            ),
            _buildSection(
              '2. How We Use Your Information',
              'We use collected data to: Process and fulfill orders - Coordinate logistics and deliveries - Communicate with users and vendors - Improve platform performance and user experience - Prevent fraud and unauthorized activity - Provide customer support',
            ),
            _buildSection(
              '3. Sharing Your Information',
              'We may share your data with: Ryda dispatch partners for delivery coordination - Payment processors for secure transactions - Third-party service providers helping us run the platform - Legal authorities, if required by law or to protect rights - We do not sell your personal data to third parties.',
            ),
            _buildSection(
              '4. Data Security',
              'We implement strong security measures to protect your data, including: Secure socket layer (SSL) encryption - Access controls and authentication protocols - Regular security reviews',
            ),
            _buildSection(
              '5. User Rights',
              'You have the right to: Access or update your personal information - Request deletion of your data (subject to legal obligations) - Opt out of promotional communications at any time',
            ),
            _buildSection(
              '6. Cookies & Tracking',
              'We may use cookies to enhance user experience and analytics. You can manage cookie preferences through your browser settings.',
            ),
            _buildSection(
              '7. Children\'s Privacy',
              'JaraMarket is not intended for children under 13. We do not knowingly collect personal information from minors.',
            ),
            _buildSection(
              '8. Changes to This Policy',
              'We may update this Privacy Policy from time to time. Any changes will be posted on this page with an updated effective date.',
            ),
            _buildSection(
              '9. Contact Us',
              'For questions or concerns about this Privacy Policy, please contact: JaraMarket Support\n'
                  'Email: jaramarket1@gmail.com - Phone: 08088884983',
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
                child: const Text('I Understand'),
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
