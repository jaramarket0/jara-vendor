import 'dart:convert';

MarketModel marketModelFromJson(String x) => MarketModel.fromJson(jsonDecode(x));

class MarketModel {
  final bool status;
  final String message;
  final List<MarketData> data;

  MarketModel({required this.status, required this.message, required this.data});

  factory MarketModel.fromJson(Map<String, dynamic> json) {
    return MarketModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => MarketData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class MarketData {
  final int id;
  final String name;
  final String? address;
  final String? latitude;
  final String? longitude;
  final bool isActive;

  MarketData({
    required this.id,
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.isActive = true,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'],
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      isActive: json['is_active'] ?? true,
    );
  }
}
