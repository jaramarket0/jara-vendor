import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:jara_vendor/screens/business_screen/controller/business_controller.dart';

class BusinessBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessController());
  }
}
