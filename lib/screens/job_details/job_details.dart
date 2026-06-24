import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:jara_vendor/screens/job_details/controller/job_details_controller.dart';

JobDetailsController controller = Get.put(JobDetailsController());

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get theme data

    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Lighter background
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        // Allow scrolling for long lists
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer and Order ID Card
              Card(
                elevation: 2,
                margin: EdgeInsets.zero, // Remove default Card margin
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: 294.702.3148',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding:
                            EdgeInsets.zero, // Remove default ListTile padding
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Icon(
                            Icons.person_outline,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: const Text(
                          'Brenda OKeefe',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Add subtitle for phone or other info if needed
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Drop-off and Time Card
              Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.location_on,
                          color: Colors.red.shade700,
                          size: 28,
                        ),
                        title: Text(
                          'Drop-off Location',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        subtitle: const Text(
                          'Jara Market Store, Itam',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Divider(height: 24, thickness: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.timer_outlined,
                          color: theme.colorScheme.secondary,
                          size: 28,
                        ),
                        title: Text(
                          'Estimated Delivery Time',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        subtitle: const Text(
                          '23 mins',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Market List Section
              Text(
                'Market List',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ), // Padding top/bottom
                  child: Column(
                    children: [
                      _buildMarketItem(
                        context, // Pass context for theme access
                        'Rice',
                        'Half Bag',
                        '₦25,000',
                        '₦2,199.99',
                        1,
                      ),
                      const Divider(indent: 16, endIndent: 16),
                      _buildMarketItem(
                        context,
                        'Beans',
                        'Half Bag',
                        '₦5,000',
                        '',
                        2,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Message Section
              Text(
                'Message from Customer',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Lorem ipsum dolor sit amet consectetur. Nibh malesuada nisi massa pulvinar gravida volutpat vitae consectetur. Rutrum felis tellus posuere id ultrices.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Order Cost Section
              Text(
                'Total Order Cost',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color:
                    theme.colorScheme.primaryContainer, // Highlight cost card
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      '₦85,000',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar for Actions
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                // Use OutlinedButton for Cancel
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade400),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ), // Consistent padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                // Use ElevatedButton for Accept
                onPressed: () {
                  Navigator.pushNamed(context, '/job-progress');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      theme.colorScheme.primary, // Theme primary color
                  foregroundColor:
                      theme.colorScheme.onPrimary, // Theme onPrimary color
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                ),
                child: const Text('Accept Job'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated _buildMarketItem
  Widget _buildMarketItem(
    BuildContext context, // Need context for theme
    String name,
    String quantity,
    String price,
    String originalPrice,
    int count,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ), // Item padding
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center align items vertically
        children: [
          Expanded(
            // Allow text details to expand
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quantity,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      price,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error, // Use theme error color
                      ),
                    ),
                    if (originalPrice.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          originalPrice,
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16), // Space between details and count
          // Styled Count Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Subtle background for count
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              'Qty: $count', // Add label to count
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
