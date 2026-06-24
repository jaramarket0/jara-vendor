import 'package:get/get.dart';
import 'package:jara_vendor/screens/terms_of_service/controller/terms_of_service_controller.dart';

class TermsOfServiceBindings extends Bindings {
  @override
  void dependencies() {
    // Add your controller dependencies here
    // For example:
    Get.lazyPut(() => TermsOfServiceController());
  }
}
