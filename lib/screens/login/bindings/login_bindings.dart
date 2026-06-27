import 'package:get/get.dart';
import 'package:jara_vendor/data/apiClient/auth_service.dart';
import 'package:jara_vendor/screens/login/controller/login_controller.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => AuthController(), fenix: true);
  }
}
