import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:jara_vendor/screens/splash_screen/controller/splash_controller.dart';
import 'dart:async';
import '../../widgets/status_bar.dart';

SplashController splashScreenController = Get.put(SplashController());

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBar(),
            Expanded(
              child: Center(child: Image.asset('assets/logo.png', height: 80)),
            ),
          ],
        ),
      ),
    );
  }
}
