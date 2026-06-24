import 'package:get/get.dart';
import 'package:jara_vendor/screens/checkout_screen/controller/checkout_controller.dart';

class CheckoutBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckoutController());
  }
}
