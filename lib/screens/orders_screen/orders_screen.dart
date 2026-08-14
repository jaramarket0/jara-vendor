import 'package:audioplayers/audioplayers.dart';
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

  /// The buyer's own note / voice note for the whole order.
  Widget _buildCustomerMessage(String? remarks, String? audioUrl) {
    final hasText = remarks != null && remarks.trim().isNotEmpty;
    final hasAudio = audioUrl != null && audioUrl.trim().isNotEmpty;
    if (!hasText && !hasAudio) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        border: Border.all(color: const Color(0xFFFFE0A3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.sticky_note_2_outlined,
                  size: 15, color: Color(0xFFB07400)),
              SizedBox(width: 6),
              Text('Note from customer',
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB07400))),
            ],
          ),
          if (hasText) ...[
            const SizedBox(height: 5),
            Text(remarks.trim(),
                style: const TextStyle(
                    fontSize: 12.5, height: 1.35, color: Color(0xFF5C4300))),
          ],
          if (hasAudio) ...[
            const SizedBox(height: 6),
            _VoiceNotePlayer(url: audioUrl),
          ],
        ],
      ),
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
                      dataAvaialable.displayCustomer,
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
                      dataAvaialable.displayOrderId,
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
                    // Line total, not the unit price -- a food item can be
                    // e.g. 3 cups at N1,000, and the shopper needs the N3,000.
                    Text(
                      '₦${_lineTotal(dataAvaialable)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                        color: Color(0xffFA254C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _qtyBreakdown(dataAvaialable),
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'Inter',
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      spacing: 3,
                      children: [
                        Text(
                          dataAvaialable.displayName.length > 7
                              ? "${dataAvaialable.displayName.substring(0, 6)}..."
                              : dataAvaialable.displayName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                            //fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dataAvaialable.unit ?? '',
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
          _buildCustomerMessage(
              dataAvaialable.orderRemarks, dataAvaialable.orderAudio),
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
                      dataHistory.displayCustomer,
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
                      dataHistory.displayOrderId,
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
                          dataHistory.displayName.length > 7
                              ? "${dataHistory.displayName.substring(0, 6)}..."
                              : dataHistory.displayName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                            //fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dataHistory.unit ?? '',
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
                      "₦${dataHistory.price ?? '0.00'}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Row(
                      spacing: 3,
                      children: [
                        (dataHistory.status ?? '').toLowerCase() == 'processing'
                            ? SvgPicture.asset('assets/processing.svg')
                            : SvgPicture.asset('assets/completed.svg'),
                        Text(dataHistory.status ?? ''),
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

/// Money formatting shared by the order cards.
String _money(num v) => v
    .toStringAsFixed(2)
    .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

/// What the shopper actually has to buy: quantity x unit price. The backend
/// sends `amount` as the line total, but fall back to qty x price if it's
/// missing so the card never shows a bare unit price.
String _lineTotal(dynamic item) {
  final amount = double.tryParse('${item.amount ?? ''}') ?? 0;
  if (amount > 0) return _money(amount);
  final unit = double.tryParse('${item.price ?? ''}') ?? 0;
  final qty = (item.quantity ?? 1) as int;
  return _money(unit * qty);
}

/// e.g. "3 cup x N1,000.00"
String _qtyBreakdown(dynamic item) {
  final unit = double.tryParse('${item.price ?? ''}') ?? 0;
  final qty = (item.quantity ?? 1) as int;
  final unitLabel = (item.unit ?? '').toString().trim();
  final measure = unitLabel.isEmpty ? '$qty' : '$qty $unitLabel';
  return '$measure × ₦${_money(unit)}';
}

/// Small play/pause control for the buyer's recorded note.
class _VoiceNotePlayer extends StatefulWidget {
  final String url;
  const _VoiceNotePlayer({required this.url});

  @override
  State<_VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<_VoiceNotePlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playing = false);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    try {
      if (_playing) {
        await _player.pause();
        if (mounted) setState(() => _playing = false);
      } else {
        await _player.play(UrlSource(widget.url));
        if (mounted) setState(() => _playing = true);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not play the voice note.')),
        );
        setState(() => _playing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggle,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFB07400),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_playing ? Icons.pause : Icons.play_arrow,
                size: 15, color: Colors.white),
            const SizedBox(width: 5),
            Text(_playing ? 'Playing…' : 'Play voice note',
                style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
