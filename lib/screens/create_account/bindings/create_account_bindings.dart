import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:jara_vendor/screens/create_account/controller/create_account_controller.dart';

class CreateAccountBindings extends Bindings {
  @override
  void dependencies() {
    // Lazy loading the CreateAccountController
    Get.lazyPut(() => CreateAccountController());
  }
}
