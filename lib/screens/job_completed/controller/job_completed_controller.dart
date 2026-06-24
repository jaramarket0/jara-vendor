import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/data/apiClient/apiClient.dart';
import 'package:jara_vendor/screens/orders_screen/controller/orders_controller.dart';
import 'package:jara_vendor/screens/orders_screen/models/models.dart';
import 'package:overlay_kit/overlay_kit.dart';

class JobCompletedController extends GetxController {
  // RxBool isStarted = false.obs;
  // RxBool isAccepted = false.obs;
  // RxBool isRejected = false.obs;
  // final RxBool isCompleted = false.obs;
  OrdersController controller = Get.find<OrdersController>();
  ApiClient apiClient = ApiClient(const Duration(seconds: 60 * 5));
  final CountDownController countDownController = CountDownController();
  RxInt remainingSeconds = 100.obs;

  Future<void> acceptOrder(String itemId, int vendorId, Data myData) async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);

    try {
      var response = await apiClient.acceptedOrders(itemId, vendorId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        myData.isAccepted.value = true;
        //isAccepted.value = true;
        countDownController.start();
        //controller.fetchOrders();
        controller.fetchAcceptedOrders();
        Get.snackbar(
          'Success',
          jsonDecode(response.body)['message'] ?? 'Sucess',
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } else {
        OverlayLoadingProgress.stop();
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      myLog.log(e.toString());
    } finally {
      OverlayLoadingProgress.stop();
    }
  }

  Future<void> rejectOrder(String itemId, int vendorId, Data myData) async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);

    try {
      var response = await apiClient.rejectedOrders(itemId, vendorId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        myData.isRejected.value = true;
        //isRejected.value = true;
        //countDownController.start();
        controller.fetchOrders();
        controller.fetchAcceptedOrders();
        Get.snackbar(
          'Success',
          jsonDecode(response.body)['message'] ?? 'Sucess',
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } else {
        OverlayLoadingProgress.stop();
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      myLog.log(e.toString());
    } finally {
      OverlayLoadingProgress.stop();
    }
  }

  Future<void> deliverOrder() async {}
}
