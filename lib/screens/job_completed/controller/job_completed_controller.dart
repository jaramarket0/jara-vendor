import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/data/apiClient/apiClient.dart';
import 'package:jara_vendor/screens/orders_screen/controller/orders_controller.dart';
import 'package:jara_vendor/screens/orders_screen/models/models.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:jara_vendor/utils/app_feedback.dart';

class JobCompletedController extends GetxController {
  // RxBool isStarted = false.obs;
  // RxBool isAccepted = false.obs;
  // RxBool isRejected = false.obs;
  // final RxBool isCompleted = false.obs;
  OrdersController controller = Get.find<OrdersController>();
  ApiClient apiClient = ApiClient(const Duration(seconds: 60 * 5));
  final CountDownController countDownController = CountDownController();
  RxInt remainingSeconds = (20 * 60).obs; // 20-minute delivery window

  Future<void> acceptOrder(String itemId, int vendorId, Data myData) async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);

    try {
      var response = await apiClient.acceptedOrders(itemId, vendorId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        myData.isAccepted.value = true;
        //isAccepted.value = true;
        countDownController.start();
        controller.fetchOrders();
        controller.fetchAcceptedOrders();
        AppFeedback.showApiError(response);
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
        AppFeedback.showApiError(response);
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

  Future<bool> deliverOrder(String itemId) async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);

    try {
      var response = await apiClient.deliverOrder(itemId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        controller.fetchAcceptedOrders();
        AppFeedback.showApiError(response);
        return true;
      } else {
        OverlayLoadingProgress.stop();
        AppFeedback.showApiError(response);
        return false;
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      myLog.log(e.toString());
      AppFeedback.showError(e);
      return false;
    } finally {
      OverlayLoadingProgress.stop();
    }
  }
}
