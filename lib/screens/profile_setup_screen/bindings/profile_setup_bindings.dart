import 'package:get/get.dart';
import 'package:jara_vendor/screens/profile_setup_screen/controller/profile_setup_controller.dart';

class ProfileSetupBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileSetupController());
  }
}
