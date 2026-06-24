import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:jara_vendor/screens/address_screen/controller/address_controller.dart';
import '../../widgets/status_bar.dart';
import '../../widgets/back_button.dart';

AddressController controller = Get.put(AddressController());

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _noPhysicalAddress = false;

  @override
  void dispose() {
    controller.addressController.dispose();
    super.dispose();
  }

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
                    'Set your address',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Tell us where your business is located. E.g Akpan Andem Market uyo, shop 3 block 34.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Where\'s your business located?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: controller.addressController,
                decoration: const InputDecoration(
                  hintText: 'Enter your business address',
                  border: OutlineInputBorder(),
                ),
                enabled: !_noPhysicalAddress,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _noPhysicalAddress,
                    onChanged: (value) {
                      setState(() {
                        _noPhysicalAddress = value ?? false;
                        if (_noPhysicalAddress) {
                          controller.addressController.clear();
                        }
                      });
                    },
                    activeColor: const Color(0xFFFF9800),
                  ),
                  const Expanded(
                    child: Text(
                      'I don\'t have a business address (mobile and online services only)',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed:
                    (_noPhysicalAddress ||
                        controller.addressController.text.isNotEmpty)
                    ? () {
                        //    Navigator.pushNamed(context, '/payment-method');
                        controller.updateVendorProfileBusinessAddress();
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
}
