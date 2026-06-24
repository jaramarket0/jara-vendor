import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/screens/business_screen/controller/business_controller.dart';
import '../../widgets/status_bar.dart';
import '../../widgets/back_button.dart';

BusinessController controller = Get.put(BusinessController());

class BusinessNameScreen extends StatefulWidget {
  const BusinessNameScreen({super.key});

  @override
  State<BusinessNameScreen> createState() => _BusinessNameScreenState();
}

class _BusinessNameScreenState extends State<BusinessNameScreen> {
  // final TextEditingController _businessNameController = TextEditingController();

  @override
  void dispose() {
    // _businessNameController.dispose();
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
              const Row(
                children: [
                  CustomBackButton(),
                  SizedBox(width: 16),
                  Text(
                    'Your business name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Your business name speaks of your business identity - if you don\'t have it, you can create it now.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Business Name*',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.businessNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your business name',
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  controller.updateVendorProfileBusinessName();
                },
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
