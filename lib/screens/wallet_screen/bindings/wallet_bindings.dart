import 'package:get/get.dart';
import 'package:jara_vendor/screens/wallet_screen/controller/wallet_controller.dart';

class WalletBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletController());
  }
}
