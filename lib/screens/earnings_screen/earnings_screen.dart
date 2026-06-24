import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:jara_vendor/screens/earnings_screen/controller/earnings_controller.dart';
import '../../widgets/status_bar.dart';

EarningsController controller = Get.put(EarningsController());

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusBar(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.menu, color: Colors.black87),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Earnings',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildEarningsCard(
                      'Daily Earnings',
                      'N12,500',
                      '12 Orders Delivered',
                      [0.3, 0.5, 0.4, 0.7, 0.6, 0.8, 0.5],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildEarningsCard(
                      'Weekly Earnings',
                      'N87,500',
                      '84 Orders Delivered',
                      [0.4, 0.6, 0.5, 0.8, 0.7, 0.9, 0.6],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Additional content can be added here
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsCard(
    String title,
    String amount,
    String ordersText,
    List<double> chartData,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // Changed from withOpacity(0.05)
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.visibility, size: 20, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            ordersText,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 40, child: _buildSimpleChart(chartData)),
        ],
      ),
    );
  }

  Widget _buildSimpleChart(List<double> data) {
    return CustomPaint(
      size: const Size(double.infinity, 40),
      painter: ChartPainter(data),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<double> data;

  ChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF9800)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();

    final width = size.width;
    final height = size.height;
    final segmentWidth = width / (data.length - 1);

    path.moveTo(0, height * (1 - data[0]));

    for (int i = 1; i < data.length; i++) {
      path.lineTo(segmentWidth * i, height * (1 - data[i]));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
