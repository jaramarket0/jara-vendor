import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:jara_vendor/screens/address_screen/controller/address_controller.dart';

class AddressBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddressController());
  }
}
