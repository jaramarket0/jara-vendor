import 'package:get/get.dart';
import 'package:jara_vendor/screens/shop_profile/controller/shop_profile_controller.dart';

class ShopProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopProfileController());
  }
}
