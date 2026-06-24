import 'package:get/get.dart';
import 'package:jara_vendor/screens/faq_screen/controller/faq_controller.dart';

class FaqBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FaqController());
  }
}
