import 'package:get/get.dart';
import 'package:jara_vendor/screens/forget_password_screen/controller/forget_password_controller.dart';

class ForgetPasswordBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetPasswordController());
  }
}
