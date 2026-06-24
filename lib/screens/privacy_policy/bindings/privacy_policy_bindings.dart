import 'package:get/get.dart';
import 'package:jara_vendor/screens/privacy_policy/controller.dart/privacy_policy_controller.dart';

class PrivacyPolicyBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrivacyPolicyController());
  }
}
