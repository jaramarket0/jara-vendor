import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:jara_vendor/screens/onboarding_screen/controller/onboarding_controller.dart';
import '../../widgets/status_bar.dart';

OnboardingController controller = Get.put(OnboardingController());

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome Onboard.',
      'description': 'Welcome to the JaraMarket Vendor App.',
      'icon': 'camera',
    },
    {
      'title': 'Hey Vendor',
      'description': 'Sell More - More Profit.',
      'icon': 'shopping_bag',
    },
    {
      'title': 'Dear Vendor',
      'description':
          'You can qualify for jaraFund to boost your market stock and make more profit.',
      'icon': 'delivery',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBar(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(
                    _onboardingData[index]['title']!,
                    _onboardingData[index]['description']!,
                    _onboardingData[index]['icon']!,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/create-account',
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? const Color(0xFFFF9800)
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_currentPage < _onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          '/create-account',
                        );
                      }
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Already existing user',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(String title, String description, String icon) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(icon),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String icon) {
    // Use dotted line drawings for icons
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1,
          style: BorderStyle.none,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: icon == 'camera'
            ? _buildDottedCamera()
            : icon == 'shopping_bag'
            ? _buildDottedShoppingBag()
            : _buildDottedDelivery(),
      ),
    );
  }

  Widget _buildDottedCamera() {
    return CustomPaint(
      size: const Size(100, 100),
      painter: DottedCameraPainter(),
    );
  }

  Widget _buildDottedShoppingBag() {
    return CustomPaint(
      size: const Size(100, 100),
      painter: DottedShoppingBagPainter(),
    );
  }

  Widget _buildDottedDelivery() {
    return CustomPaint(
      size: const Size(100, 100),
      painter: DottedDeliveryPainter(),
    );
  }
}

class DottedCameraPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    // Draw a dotted camera shape
    final Path path = Path();

    // Camera body
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width * 0.8,
          height: size.height * 0.6,
        ),
        const Radius.circular(10),
      ),
    );

    // Camera lens
    path.addOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.4,
        height: size.height * 0.4,
      ),
    );

    // Camera flash
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.75, size.height * 0.25),
          width: size.width * 0.2,
          height: size.height * 0.1,
        ),
        const Radius.circular(5),
      ),
    );

    // Draw the path with dotted effect
    _drawDottedPath(canvas, path, paint);
  }

  void _drawDottedPath(Canvas canvas, Path path, Paint paint) {
    final dashWidth = 3.0;
    final dashSpace = 3.0;
    final dashLength = dashWidth + dashSpace;

    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      var distance = 0.0;

      while (distance < metric.length) {
        final start = distance;
        final end = (distance + dashWidth < metric.length)
            ? distance + dashWidth
            : metric.length;

        final extractPath = metric.extractPath(start, end);
        canvas.drawPath(extractPath, paint);

        distance += dashLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DottedShoppingBagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    // Draw a dotted shopping bag shape
    final Path path = Path();

    // Bag body
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2 + size.height * 0.1),
          width: size.width * 0.7,
          height: size.height * 0.7,
        ),
        const Radius.circular(10),
      ),
    );

    // Bag handles
    final handleWidth = size.width * 0.2;
    final handleHeight = size.height * 0.3;
    final handleTop = size.height * 0.15;
    final leftHandleX = size.width / 2 - handleWidth;
    final rightHandleX = size.width / 2 + handleWidth;

    // Left handle
    path.moveTo(leftHandleX, handleTop);
    path.arcToPoint(
      Offset(leftHandleX, handleTop + handleHeight),
      radius: const Radius.circular(20),
      clockwise: false,
    );

    // Right handle
    path.moveTo(rightHandleX, handleTop);
    path.arcToPoint(
      Offset(rightHandleX, handleTop + handleHeight),
      radius: const Radius.circular(20),
      clockwise: true,
    );

    // Circle in the middle of the bag
    path.addOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2 + size.height * 0.1),
        width: size.width * 0.4,
        height: size.height * 0.4,
      ),
    );

    // Draw the path with dotted effect
    _drawDottedPath(canvas, path, paint);
  }

  void _drawDottedPath(Canvas canvas, Path path, Paint paint) {
    final dashWidth = 3.0;
    final dashSpace = 3.0;
    final dashLength = dashWidth + dashSpace;

    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      var distance = 0.0;

      while (distance < metric.length) {
        final start = distance;
        final end = (distance + dashWidth < metric.length)
            ? distance + dashWidth
            : metric.length;

        final extractPath = metric.extractPath(start, end);
        canvas.drawPath(extractPath, paint);

        distance += dashLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DottedDeliveryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    // Draw a dotted delivery truck shape
    final Path path = Path();

    // Truck body
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width * 0.8,
          height: size.height * 0.4,
        ),
        const Radius.circular(10),
      ),
    );

    // Truck cabin
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.3, size.height / 2),
          width: size.width * 0.3,
          height: size.height * 0.4,
        ),
        const Radius.circular(5),
      ),
    );

    // Wheels
    path.addOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.3, size.height * 0.7),
        width: size.width * 0.15,
        height: size.height * 0.15,
      ),
    );
    path.addOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.7, size.height * 0.7),
        width: size.width * 0.15,
        height: size.height * 0.15,
      ),
    );

    // Draw the path with dotted effect
    _drawDottedPath(canvas, path, paint);
  }

  void _drawDottedPath(Canvas canvas, Path path, Paint paint) {
    final dashWidth = 3.0;
    final dashSpace = 3.0;
    final dashLength = dashWidth + dashSpace;

    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      var distance = 0.0;

      while (distance < metric.length) {
        final start = distance;
        final end = (distance + dashWidth < metric.length)
            ? distance + dashWidth
            : metric.length;

        final extractPath = metric.extractPath(start, end);
        canvas.drawPath(extractPath, paint);

        distance += dashLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
