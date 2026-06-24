import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:jara_vendor/screens/order_history/controller/order_history_controller.dart';

class OrderHistoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderHistoryController());
  }
}
