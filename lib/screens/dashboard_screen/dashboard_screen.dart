import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:jara_vendor/screens/dashboard_screen/controller/dashboard_controller.dart';
import 'package:jara_vendor/screens/dashboard_screen/models/models.dart';
import 'package:jara_vendor/utils/storage.dart';
import '../../widgets/status_bar.dart';
import '../orders_screen/orders_screen.dart';
import '../wallet_screen/wallet_screen.dart';
import '../profile_screen/profile_screen.dart';

DashboardController controller = Get.put(DashboardController());

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const OrdersTab(),
    const WalletTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(child: _tabs[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF9800),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/home_unselected.svg'),
            activeIcon: SvgPicture.asset('assets/home_selected.svg'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/order_unselected.svg'),
            activeIcon: SvgPicture.asset('assets/order_selected.svg'),
            label: 'Orders',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/profile_unselected.svg'),
            activeIcon: SvgPicture.asset('assets/profile_selected.svg'),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.dashboardData.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF9800)),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.dashboardData.value == null) {
          return _ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchDashboard,
          );
        }

        final data = controller.dashboardData.value;

        return RefreshIndicator(
          color: const Color(0xFFFF9800),
          onRefresh: controller.fetchDashboard,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _TopBar(controller: controller)),
              SliverToBoxAdapter(child: _WalletCard(data: data)),
              SliverToBoxAdapter(child: _SectionLabel(label: 'Overview')),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(child: _StatsGrid(data: data)),
              ),
              SliverToBoxAdapter(child: _SectionLabel(label: 'Quick actions')),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(child: _QuickActions()),
              ),
              SliverToBoxAdapter(
                child: _SectionLabel(
                  label: 'Recent orders',
                  trailing: TextButton(
                    onPressed: () => Get.toNamed('/orders'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFFF9800),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: _RecentOrdersList(data: data),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrdersScreen();
  }
}

class WalletTab extends StatelessWidget {
  const WalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const WalletScreen();
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:jara_vendor/screens/dashboard_screen/controller/dashboard_controller.dart';
// import 'package:jara_vendor/screens/dashboard_screen/models/models.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final DashboardController controller = Get.find<DashboardController>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7F5),
//       body: Obx(() {
//         if (controller.isLoading.value && controller.dashboardData.value == null) {
//           return const Center(
//             child: CircularProgressIndicator(color: Color(0xFFFF9800)),
//           );
//         }

//         if (controller.errorMessage.value.isNotEmpty &&
//             controller.dashboardData.value == null) {
//           return _ErrorView(
//             message: controller.errorMessage.value,
//             onRetry: controller.fetchDashboard,
//           );
//         }

//         final data = controller.dashboardData.value;

//         return RefreshIndicator(
//           color: const Color(0xFFFF9800),
//           onRefresh: controller.fetchDashboard,
//           child: CustomScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             slivers: [
//               SliverToBoxAdapter(child: _TopBar(controller: controller)),
//               SliverToBoxAdapter(child: _WalletCard(data: data)),
//               SliverToBoxAdapter(child: _SectionLabel(label: 'Overview')),
//               SliverPadding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 sliver: SliverToBoxAdapter(child: _StatsGrid(data: data)),
//               ),
//               SliverToBoxAdapter(child: _SectionLabel(label: 'Quick actions')),
//               SliverPadding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 sliver: SliverToBoxAdapter(child: _QuickActions()),
//               ),
//               SliverToBoxAdapter(
//                 child: _SectionLabel(
//                   label: 'Recent orders',
//                   trailing: TextButton(
//                     onPressed: () => Get.toNamed('/orders'),
//                     style: TextButton.styleFrom(
//                       foregroundColor: const Color(0xFFFF9800),
//                       padding: EdgeInsets.zero,
//                       minimumSize: Size.zero,
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     child: const Text(
//                       'See all',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SliverPadding(
//                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
//                 sliver: _RecentOrdersList(data: data),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

// ── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatefulWidget {
  final DashboardController controller;
  const _TopBar({required this.controller});

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning,',
                      style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Jara Vendor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => widget.controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFFF9800),
                        ),
                      )
                    : GestureDetector(
                        onTap: widget.controller.fetchDashboard,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFFE0B2),
                              width: 0.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_outline_rounded,
                            color: Color(0xFFFF9800),
                            size: 18,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Obx(() =>
          _PeriodSelector(controller: widget.controller),
          //),
          const SizedBox(height: 1),
        ],
      ),
    );
  }
}

// ── Period Selector ───────────────────────────────────────────────────────────

class _PeriodSelector extends StatefulWidget {
  final DashboardController controller;
  const _PeriodSelector({required this.controller});

  @override
  State<_PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<_PeriodSelector> {
  @override
  Widget build(BuildContext context) {
    const periods = [
      ('day', 'Today'),
      ('week', 'This week'),
      ('month', 'This month'),
    ];

    return Row(
      children: periods.map(((String, String) p) {
        final isActive = widget.controller.selectedPeriod.value == p.$1;
        return GestureDetector(
          onTap: () => setState(() {
            widget.controller.changePeriod(p.$1);
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(right: 6, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFFF9800)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive
                    ? const Color(0xFFFF9800)
                    : const Color(0xFFE0E0E0),
                width: 0.5,
              ),
            ),
            child: Text(
              p.$2,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF757575),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Wallet Card ───────────────────────────────────────────────────────────────

class _WalletCard extends StatelessWidget {
  final DashboardModel? data;
  const _WalletCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en_NG');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -30,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.07),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wallet balance',
                  style: TextStyle(fontSize: 12, color: Color(0x80FFFFFF)),
                ),
                const SizedBox(height: 6),
                Text(
                  '₦ ${fmt.format(data?.walletBalance ?? 0)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),
                Container(height: 0.5, color: Colors.white12),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _WalletSubStat(
                      label: 'Total revenue',
                      value: '₦ ${fmt.format(data?.totalRevenue ?? 0)}',
                    ),
                    const SizedBox(width: 28),
                    const _WalletSubStat(label: 'This period', value: '₦ 0.00'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletSubStat extends StatelessWidget {
  final String label;
  final String value;
  const _WalletSubStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0x66FFFFFF)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xE6FFFFFF),
          ),
        ),
      ],
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Widget? trailing;
  const _SectionLabel({required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9E9E9E),
              letterSpacing: 0.8,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ── Stats Grid ────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final DashboardModel? data;
  const _StatsGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatCardData(
        label: 'Total orders',
        value: '${data?.totalOrders ?? 0}',
        icon: Icons.receipt_long_outlined,
        iconColor: const Color(0xFFE65100),
        bgColor: const Color(0xFFFFF3E0),
      ),
      _StatCardData(
        label: 'Pending',
        value: '${data?.pendingOrders ?? 0}',
        icon: Icons.access_time_rounded,
        iconColor: const Color(0xFF1565C0),
        bgColor: const Color(0xFFE3F2FD),
      ),
      _StatCardData(
        label: 'Completed',
        value: '${data?.completedOrders ?? 0}',
        icon: Icons.check_rounded,
        iconColor: const Color(0xFF2E7D32),
        bgColor: const Color(0xFFE8F5E9),
      ),
      _StatCardData(
        label: 'Cancelled',
        value: '${data?.cancelledOrders ?? 0}',
        icon: Icons.close_rounded,
        iconColor: const Color(0xFFC62828),
        bgColor: const Color(0xFFFFEBEE),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (_, i) => _StatCard(data: cards[i]),
    );
  }
}

class _StatCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  const _StatCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

class _StatCard extends StatelessWidget {
  final _StatCardData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 34,
            height: 33,
            decoration: BoxDecoration(
              color: data.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions ─────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _QAData(label: 'Add product', icon: Icons.add_rounded, route: null),
      _QAData(label: 'Orders', icon: Icons.list_alt_rounded, route: '/orders'),
      _QAData(
        label: 'Withdraw',
        icon: Icons.credit_card_rounded,
        route: '/withdraw-money',
      ),
      _QAData(
        label: 'Profile',
        icon: Icons.person_outline_rounded,
        route: '/profile',
      ),
    ];

    return Row(
      children: actions
          .map(
            (a) => Expanded(
              child: GestureDetector(
                onTap: () {
                  if (a.route != null) Get.toNamed(a.route!);
                },
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFEEEEEE),
                          width: 0.5,
                        ),
                      ),
                      child: Icon(
                        a.icon,
                        color: const Color(0xFF1A1A1A),
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      a.label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9E9E9E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _QAData {
  final String label;
  final IconData icon;
  final String? route;
  const _QAData({required this.label, required this.icon, this.route});
}

// ── Recent Orders ─────────────────────────────────────────────────────────────

class _RecentOrdersList extends StatelessWidget {
  final DashboardModel? data;
  const _RecentOrdersList({required this.data});

  @override
  Widget build(BuildContext context) {
    final orders = data?.recentOrders ?? [];
    if (orders.isEmpty) {
      return SliverToBoxAdapter(child: _EmptyOrders());
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, i) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _OrderRow(order: orders[i]),
        ),
        childCount: orders.length,
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final RecentOrder order;
  const _OrderRow({required this.order});

  Color _statusBg(String s) {
    switch (s.toLowerCase()) {
      case 'completed':
        return const Color(0xFFE8F5E9);
      case 'pending':
        return const Color(0xFFFFF3E0);
      case 'cancelled':
      case 'rejected':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _statusText(String s) {
    switch (s.toLowerCase()) {
      case 'completed':
        return const Color(0xFF2E7D32);
      case 'pending':
        return const Color(0xFFE65100);
      case 'cancelled':
      case 'rejected':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF757575);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en_NG');
    final status = order.status;
    final label = status.isNotEmpty
        ? status[0].toUpperCase() + status.substring(1)
        : status;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Color(0xFFFF9800),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                if (order.customerName != null &&
                    order.customerName!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      order.customerName!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₦ ${fmt.format(order.amount)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusBg(status),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusText(status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Empty & Error ─────────────────────────────────────────────────────────────

class _EmptyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Color(0xFFBDBDBD)),
          SizedBox(height: 10),
          Text(
            'No recent orders',
            style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 52,
              color: Color(0xFFBDBDBD),
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
