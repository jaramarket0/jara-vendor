import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jara_vendor/screens/payment_method/controller/payment_method_controller.dart';

class PaymentMethodBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentMethodController());
  }
}
