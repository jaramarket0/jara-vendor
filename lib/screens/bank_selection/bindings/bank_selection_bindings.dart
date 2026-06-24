import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:jara_vendor/screens/bank_selection/controller/bank_selection_controller.dart';

class BankSelectionBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BankSelectionController());
  }
}
