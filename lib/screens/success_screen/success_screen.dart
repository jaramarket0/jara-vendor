import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jara_vendor/screens/orders_screen/models/models.dart';

class SuccessScreen extends StatefulWidget {
  final Data dataHistory;
  const SuccessScreen({super.key, required this.dataHistory});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF4F4F4),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.chevron_left_rounded),
          ),
          title: const Text('Order Details'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 30),
            SvgPicture.asset('assets/success.svg'),
            const SizedBox(height: 20),
            const Text(
              'Successful',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(
                        13,
                      ), // Changed from withOpacity(0.05)
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
                                widget.dataHistory.customer!,
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
                                widget.dataHistory.orderId.toString(),
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
                                '₦${widget.dataHistory.price}',
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
                                    widget.dataHistory.name!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w800,
                                      //fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.dataHistory.unit!,
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
                                  fontFamily: 'Mont',
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
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
                                    fontFamily: 'Mont',
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
                                "₦${widget.dataHistory.price!}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Mont',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  'Lorem ipsum dolor sit amet consectetur. Nibh malesuada nisi massa pulvinar gravida volutpat vitae consectetur.',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: const Color(0xffE83C00),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/dashboard',
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text(
                  'Back To Home',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
