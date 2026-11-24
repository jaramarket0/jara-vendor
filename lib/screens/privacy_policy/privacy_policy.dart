import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/screens/legal/privacy_policy_content.dart';
import 'package:jara_vendor/screens/privacy_policy/controller.dart/privacy_policy_controller.dart';

PrivacyPolicyController controller = Get.put(PrivacyPolicyController());

/// Renders the privacy policy from [PrivacyPolicyContent].
///
/// Identical text to the website and the customer app: the three are generated
/// from one source, because a policy that differs between surfaces is exactly
/// what an app store reviewer flags. Only the chrome differs here.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                PrivacyPolicyContent.title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Effective ${PrivacyPolicyContent.effectiveDate}\n'
                'Jurisdiction: ${PrivacyPolicyContent.jurisdiction}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 28),
            for (final section in PrivacyPolicyContent.sections) ...[
              // Section 24 is the contact block, which comes from
              // configuration rather than the document, so it is spliced in
              // ahead of 25 to keep the numbering in order.
              if (section.title.startsWith('25.')) ...[
                _contactSection(),
                const SizedBox(height: 18),
              ],
              _sectionTitle(section.title),
              for (final block in section.blocks) _block(block),
              const SizedBox(height: 18),
            ],
            const SizedBox(height: 10),
            const Center(
              child: Column(
                children: [
                  Text('JARAMARKET',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(height: 4),
                  Text('Market at Your Door.',
                      style: TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 24),
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

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, height: 1.3),
        ),
      );

  Widget _block(PolicyBlock block) {
    switch (block.kind) {
      case 'h3':
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(
            block.text,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, height: 1.4),
          ),
        );
      case 'ul':
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [for (final item in block.items) _bullet('•', item)],
          ),
        );
      case 'ol':
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < block.items.length; i++)
                _bullet('${i + 1}.', block.items[i]),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(block.text,
              style: const TextStyle(fontSize: 13, height: 1.55)),
        );
    }
  }

  /// Marker and text in a Row so wrapped lines align under the text rather
  /// than under the bullet.
  Widget _bullet(String marker, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4, left: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
              child: Text(marker,
                  style: const TextStyle(fontSize: 13, height: 1.55)),
            ),
            Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 13, height: 1.55)),
            ),
          ],
        ),
      );

  /// Section 24. Rows with an empty value are skipped: an absent detail must
  /// disappear, never render as "[Insert support email]".
  Widget _contactSection() {
    final rows = PrivacyPolicyContent.contactRows
        .where((r) => r[1].trim().isNotEmpty)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('24. CONTACT AND PRIVACY COMPLAINTS'),
        Text(PrivacyPolicyContent.contactIntro,
            style: const TextStyle(fontSize: 13, height: 1.55)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final row in rows)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(row[0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 9,
                              letterSpacing: 0.6,
                              color: Colors.grey)),
                      const SizedBox(height: 2),
                      Text(row[1],
                          style: const TextStyle(fontSize: 12, height: 1.4)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(PrivacyPolicyContent.contactOutro,
            style: const TextStyle(fontSize: 13, height: 1.55)),
      ],
    );
  }
}
