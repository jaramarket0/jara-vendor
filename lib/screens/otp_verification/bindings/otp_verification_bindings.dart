import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:jara_vendor/screens/email_verification/controller/email_verification_controller.dart';

class EmailVerificationBindings extends Bindings {
  @override
  void dependencies() {
    // Lazy loading the DashboardController
    Get.lazyPut(() => EmailVerificationController());
  }
}
