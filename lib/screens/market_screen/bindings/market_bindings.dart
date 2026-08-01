import 'package:get/get.dart';
import 'package:jara_vendor/screens/market_screen/controller/market_controller.dart';

class MarketBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MarketController());
  }
}
