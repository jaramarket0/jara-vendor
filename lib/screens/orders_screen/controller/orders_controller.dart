import 'dart:convert';

import 'package:get/get.dart';
import 'package:jara_vendor/data/apiClient/apiClient.dart';
import 'package:jara_vendor/screens/orders_screen/models/accepted_order.dart';
import 'package:jara_vendor/screens/orders_screen/models/models.dart';
import 'dart:developer' as myLog;
import 'package:jara_vendor/utils/app_feedback.dart';

class OrdersController extends GetxController {
  ApiClient apiClient = ApiClient(Duration(seconds: 60 * 5));

  OrderModel orderModel = OrderModel();
  AcceptedOrderModel acceptedOrderModel = AcceptedOrderModel();
  RxList<Data> availableData = <Data>[].obs;

  RxList<AcceptedData> acceptedData = <AcceptedData>[].obs;

  RxBool isLoadingOrders = false.obs;
  RxBool isloadingAccpted = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderByCondition();
    fetchAcceptedOrderByCondition();
  }

  fetchOrderByCondition() {
    if (availableData.isNotEmpty) return;
    fetchOrders();
  }

  fetchAcceptedOrderByCondition() {
    if (acceptedData.isNotEmpty) return;
    fetchAcceptedOrders();
  }

  Future<void> fetchOrders() async {
    isLoadingOrders.value = true;
    try {
      var response = await apiClient.fetchorders();

      if (response.statusCode == 201 || response.statusCode == 200) {
        isLoadingOrders.value = false;
        myLog.log('Response: ${response.body}');
        myLog.log('Status Code: ${response.statusCode}');
        orderModel = orderModelFromJson(response.body);
        availableData.value = orderModel.data ?? [];
      } else {
        isLoadingOrders.value = false;
        AppFeedback.showApiError(response);
        myLog.log(jsonDecode(response.body));
      }
    } catch (e) {
      isLoadingOrders.value = false;
      AppFeedback.showError(e);
      myLog.log(e.toString());
    } finally {
      isLoadingOrders.value = false;
    }
  }

  Future<void> fetchAcceptedOrders() async {
    isloadingAccpted.value = true;
    try {
      var response = await apiClient.fetchAcceptedOrders();

      if (response.statusCode == 201 || response.statusCode == 200) {
        isloadingAccpted.value = false;
        acceptedOrderModel = acceptedOrderModelFromJson(response.body);
        acceptedData.value = acceptedOrderModel.data ?? [];
      } else {
        isloadingAccpted.value = false;
        AppFeedback.showApiError(response);
        myLog.log(jsonDecode(response.body));
      }
    } catch (e) {
      myLog.log(e.toString());
      isloadingAccpted.value = false;
      AppFeedback.showError(e);
      myLog.log(e.toString());
    } finally {
      isloadingAccpted.value = false;
    }
  }
}
