import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/screens/orders_screen/controller/orders_controller.dart';
import 'package:jara_vendor/screens/orders_screen/models/accepted_order.dart';
import 'package:jara_vendor/screens/orders_screen/models/models.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../widgets/status_bar.dart';

OrdersController controller = Get.put(OrdersController());

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  _onRefresh() {
    controller.fetchOrders();
    controller.fetchAcceptedOrders();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: Column(
            children: [
              const StatusBar(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/logo.png', height: 32),
                    IconButton(
                      icon: SvgPicture.asset('assets/notification.svg'),
                      // const Icon(
                      //   Icons.notifications_outlined,
                      //   color: Colors.grey,
                      //   size: 28,
                      // ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Container(
                height: 35,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xffD9D9D9),
                ),
                child: TabBar(
                  dividerColor: Colors.grey.shade50,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffF19A0D),
                  ),
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Orders'),
                    Tab(text: 'History'),
                  ],
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.white,
                  indicatorSize:
                      TabBarIndicatorSize.tab, // 👈 Ensures full tab width
                  // indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Obx(() {
                      return controller.isLoadingOrders.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              ),
                            )
                          : controller.availableData.isEmpty
                          ? const Center(
                              child: Text(
                                'You currently do not have any order yet',
                              ),
                            )
                          : _buildOrdersList();
                    }),
                    Obx(() {
                      return controller.isloadingAccpted.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              ),
                            )
                          : controller.acceptedData.isEmpty
                          ? const Center(
                              child: Text(
                                'You currently do not have any accepted order yet',
                              ),
                            )
                          : _buildOrderHistory();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      key: const ValueKey('orders_list'),
      padding: const EdgeInsets.all(16),
      itemCount: controller.availableData.length,
      itemBuilder: (context, index) {
        Data dataAvaialable = controller.availableData[index];
        return _buildOrderCardAvailable(false, dataAvaialable);
      },
    );
  }

  Widget _buildOrderHistory() {
    return ListView.builder(
      key: const ValueKey('history_list'),
      padding: const EdgeInsets.all(16),
      itemCount: controller.acceptedData.length,
      itemBuilder: (context, index) {
        AcceptedData dataHistory = controller.acceptedData[index];
        return _buildOrderCardHistory(true, dataHistory);
      },
    );
  }

  Widget _buildOrderCardAvailable(bool isCompleted, Data dataAvaialable) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // Changed from withOpacity(0.05)
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.grey.shade500,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // 'Brenda OKeefe',
                      dataAvaialable.customer!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mont',
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Order ID:',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      // '294.702.3148',
                      dataAvaialable.orderId.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₦${dataAvaialable.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                        color: Color(0xffFA254C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      spacing: 3,
                      children: [
                        Text(
                          dataAvaialable.name!.length > 7
                              ? "${dataAvaialable.name!.substring(0, 6)}..."
                              : dataAvaialable.name!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                            //fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dataAvaialable.unit!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            //sfontWeight: FontWeight.w800,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // const SizedBox(width: 8),
                // const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 3,
                      children: [
                        SvgPicture.asset('assets/location.svg'),
                        Text(
                          'Drop-off',
                          style: TextStyle(
                            fontSize: 9,
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Jara Market Store, Itam',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 57,
                  height: 29,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/job-completed',
                        arguments: dataAvaialable,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: const Color(0xffE83C00),
                    ),
                    child: const Text(
                      'view',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOrderCardHistory(bool isCompleted, AcceptedData dataHistory) {
    // Data dataHistory;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // Changed from withOpacity(0.05)
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.grey.shade500,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // 'Brenda OKeefe',
                      dataHistory.customer!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mont',
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Order ID:',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      // '294.702.3148',
                      dataHistory.orderId.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₦${dataHistory.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                        color: Color(0xffFA254C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      spacing: 3,
                      children: [
                        Text(
                          dataHistory.name!.length > 7
                              ? "${dataHistory.name!.substring(0, 6)}..."
                              : dataHistory.name!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                            //fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dataHistory.unit!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            //sfontWeight: FontWeight.w800,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // const SizedBox(width: 8),
                // const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 3,
                      children: [
                        SvgPicture.asset('assets/location.svg'),
                        Text(
                          'Drop-off',
                          style: TextStyle(
                            fontSize: 9,
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Jara Market Store, Itam',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text('Message'),
                      Text(
                        'Lorem ipsum dolor sit amet consectetur. Nibh malesuada nisi massa pulvinar gravida volutpat vitae consectetur.',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Cost'),
                    Text(
                      "₦${dataHistory.price!}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Row(
                      spacing: 3,
                      children: [
                        dataHistory.status!.toLowerCase() == 'processing'
                            ? SvgPicture.asset('assets/processing.svg')
                            : dataHistory.status!.toLowerCase() == 'pending'
                            ? SvgPicture.asset('assets/rejected.svg')
                            : SvgPicture.asset('assets/completed.svg'),
                        dataHistory.status!.toLowerCase() == 'pending'
                            ? const Text('rejected')
                            : Text(dataHistory.status!),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
