// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:jara_vendor/screens/wallet_screen/controller/wallet_controller.dart';
// import '../../widgets/status_bar.dart';

// WalletController controller = Get.put(WalletController());

// class WalletScreen extends StatelessWidget {
//   const WalletScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const StatusBar(),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Wallet',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.notifications_outlined,
//                       color: Colors.grey,
//                       size: 28,
//                     ),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.orange.withAlpha(77), // Changed from withOpacity(0.3)
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Available Balance',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       '₦10,000,000.34',
//                       style: TextStyle(
//                         fontSize: 32,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.white.withAlpha(204), // Changed from withOpacity(0.8)
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pushNamed(context, '/add-money');
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withAlpha(13),
//                               blurRadius: 10,
//                               offset: const Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: 48,
//                               height: 48,
//                               decoration: BoxDecoration(
//                                 color: Colors.green.shade100,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.add,
//                                 color: Colors.green,
//                                 size: 28,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             const Text(
//                               'Add Money',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pushNamed(context, '/withdraw-money');
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withAlpha(13), // Changed from withOpacity(0.05)
//                               blurRadius: 10,
//                               offset: const Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: 48,
//                               height: 48,
//                               decoration: BoxDecoration(
//                                 color: Colors.red.shade100,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.arrow_downward,
//                                 color: Colors.red,
//                                 size: 28,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             const Text(
//                               'Withdraw',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Wallet History',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.filter_list, color: Colors.grey),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.block,
//                         size: 40,
//                         color: Colors.grey.shade400,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'No data found',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:jara_vendor/screens/add_money_screen/add_money_screen.dart';
import 'package:jara_vendor/screens/wallet_screen/withdraw_screen.dart';
import 'package:jara_vendor/widgets/status_bar.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/screens/wallet_screen/controller/wallet_controller.dart';
import '../../widgets/balance_card.dart';

WalletController controller = Get.put(WalletController());

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    // _fetchWalletData();
    controller.fetchWallet();
  }

  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  // RefreshController
  void onRefresh() {
    controller.fetchWallet();
    controller.fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: refreshController,
        onRefresh: onRefresh,
        child: SafeArea(
          child: Obx(() {
            return controller.isLoading.value ||
                    controller.isTransactionLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  )
                : Column(
                    children: [
                      // const CustomBackHeader(title: 'Wallet'),
                      const StatusBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ElevatedButton(onPressed: (){controller.fetchTransaction();}, child: Text('transaction')),
                              Obx(() {
                                return BalanceCard(
                                  balance: controller.isLoading.value
                                      ? 'Loading...'
                                      : (controller.walletModel.data?.balance
                                                ?.toString() ??
                                            '0.00'),
                                  subtitle: 'JaraWallet - Seamless Pay',
                                  isBalanceVisible: _isBalanceVisible,
                                  onToggleVisibility: () {
                                    setState(() {
                                      _isBalanceVisible = !_isBalanceVisible;
                                    });
                                  },
                                );
                              }),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    icon: 'assets/add.svg',
                                    label: 'Add Money',
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AddMoneyScreen(),
                                        ),
                                      );

                                      // Navigator.pushNamed(context, '/add-money');
                                    },
                                  ),
                                  _buildActionButton(
                                    icon: 'assets/withdraw.svg',
                                    label: 'Withdraw',
                                    onTap: () {
                                      // Navigator.pushNamed(
                                      //   context,
                                      //   '/withdraw-money',
                                      // );
                                      Get.to(() => WithdrawScreen());
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              const Text(
                                'Wallet History',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 16),
                              controller.transactions.isEmpty
                                  ? _buildEmptyState()
                                  : Obx(() {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            controller.transactions.length,
                                        itemBuilder: (context, index) {
                                          final transaction =
                                              controller.transactions[index];
                                          return controller
                                                  .isTransactionLoading1
                                                  .value
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.amber,
                                                      ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                      ),
                                                  child: ListTile(
                                                    onTap: () {
                                                      controller
                                                          .fetchTransaction(
                                                            transaction.id,
                                                          );
                                                    },
                                                    tileColor: Colors.grey[100],
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      side: BorderSide(
                                                        width: 1,
                                                        color: Color(
                                                          0xff1919190D,
                                                        ),
                                                      ),
                                                    ),
                                                    //BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                    leading: Icon(
                                                      transaction.status ==
                                                              'success'
                                                          ? Icons.arrow_upward
                                                          : Icons
                                                                .arrow_downward,
                                                      color:
                                                          transaction.status ==
                                                              'success'
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                    title: Text(
                                                      transaction
                                                          .gatewayResponse,
                                                    ),
                                                    subtitle: Text(
                                                      transaction.createdAt,
                                                    ),
                                                    trailing: Text(
                                                      '${transaction.status == 'success' ? '+' : '-'}${transaction.amount}',
                                                      style: TextStyle(
                                                        color:
                                                            transaction
                                                                    .status ==
                                                                'success'
                                                            ? Colors.green
                                                            : Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                        },
                                      );
                                    }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
              shape: BoxShape.rectangle,
            ),
            child: SvgPicture.asset(
              icon,
              fit: BoxFit.cover,
              // height: 14,
              // width: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 362,
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xff1919190D)),
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon(
          //   Icons.block,
          //   size: 48,
          //   color: Colors.grey[400],
          // ),
          SvgPicture.asset('assets/block.svg'),
          const SizedBox(height: 16),
          // Text(
          //   'No transactions found',
          //   style: TextStyle(
          //     fontSize: 16,
          //     color: Colors.grey[600],
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          //  const SizedBox(height: 256), // Increase the height here
        ],
      ),
    );
  }
}
