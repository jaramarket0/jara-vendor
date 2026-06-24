import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jara_vendor/screens/splash_screen/controller/splash_controller.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
