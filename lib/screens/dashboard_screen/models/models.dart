class DashboardModel {
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final int cancelledOrders;
  final double totalRevenue;
  final double walletBalance;
  final List<RecentOrder> recentOrders;

  DashboardModel({
    required this.totalOrders,
    required this.pendingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.totalRevenue,
    required this.walletBalance,
    required this.recentOrders,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DashboardModel(
      totalOrders: _parseInt(data['total_orders']),
      pendingOrders: _parseInt(data['pending_orders']),
      completedOrders: _parseInt(data['completed_orders']),
      cancelledOrders: _parseInt(data['cancelled_orders']),
      totalRevenue: _parseDouble(data['total_revenue']),
      walletBalance: _parseDouble(data['wallet_balance']),
      recentOrders: (data['recent_orders'] as List<dynamic>? ?? [])
          .map((o) => RecentOrder.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }

  static int _parseInt(dynamic v) =>
      v == null ? 0 : int.tryParse(v.toString()) ?? 0;

  static double _parseDouble(dynamic v) =>
      v == null ? 0.0 : double.tryParse(v.toString()) ?? 0.0;
}

class RecentOrder {
  final String id;
  final String status;
  final double amount;
  final String createdAt;
  final String? customerName;

  RecentOrder({
    required this.id,
    required this.status,
    required this.amount,
    required this.createdAt,
    this.customerName,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) {
    return RecentOrder(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at']?.toString() ?? '',
      customerName: json['customer_name']?.toString(),
    );
  }
}