import 'package:get/get.dart';
import 'package:jara_vendor/screens/help_and_support/help_and_support_controller/help_and_support_controller.dart';

class HelpAndSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpAndSupportController>(() => HelpAndSupportController());
  }
}
