import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:jara_vendor/screens/earnings_screen/controller/earnings_controller.dart';

class EarningsBindings extends Bindings {
  @override
  void dependencies() {
    // Lazy loading the DashboardController
    Get.lazyPut(() => EarningsController());
  }
}
