import 'package:get/get.dart';
import 'package:jara_vendor/screens/onboarding_screen/controller/onboarding_controller.dart';

class OnboardingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}
