import 'dart:convert';

AcceptedOrderModel acceptedOrderModelFromJson(String x) =>
    AcceptedOrderModel.fromJson(jsonDecode(x));

class AcceptedOrderModel {
  bool? status;
  String? message;
  List<AcceptedData>? data;

  AcceptedOrderModel({this.status, this.message, this.data});

  AcceptedOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null && json['data']['data'] != null) {
      data = <AcceptedData>[];
      json['data']['data'].forEach((v) {
        data!.add(AcceptedData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AcceptedData {
  int? itemId;
  String? customer;
  String? orderReference;
  String? ingredientName;
  String? productName;
  String? orderDate;
  String? name;
  String? price;
  String? amount;
  String? unit;
  int? quantity;
  String? imageUrl;
  String? status;
  Vendor? vendor;

  String get displayCustomer => customer ?? 'Customer';
  String get displayName => ingredientName ?? name ?? 'N/A';
  String get displayOrderId => orderReference ?? itemId?.toString() ?? 'N/A';

  AcceptedData({
    this.itemId,
    this.customer,
    this.orderReference,
    this.ingredientName,
    this.productName,
    this.orderDate,
    this.name,
    this.price,
    this.amount,
    this.unit,
    this.quantity,
    this.imageUrl,
    this.status,
    this.vendor,
  });

  AcceptedData.fromJson(Map<String, dynamic> json) {
    itemId = json['id'] ?? json['item_id'] ?? json['ingredient_id'];
    customer = json['customer_name'] ?? json['customer'];
    orderReference = json['order_reference'] ?? json['order_no'];
    ingredientName = json['ingredient_name'];
    productName = json['product_name'];
    orderDate = json['created_at'] ?? json['order_date'];
    name = json['name'];
    price = json['price'];
    amount = json['amount'];
    unit = json['unit'];
    quantity = json['quantity'];
    imageUrl = json['image_url'];
    status = json['status'];
    vendor = json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = itemId;
    data['customer_name'] = customer;
    data['order_reference'] = orderReference;
    data['ingredient_name'] = ingredientName;
    data['product_name'] = productName;
    data['order_date'] = orderDate;
    data['name'] = name;
    data['price'] = price;
    data['amount'] = amount;
    data['unit'] = unit;
    data['quantity'] = quantity;
    data['image_url'] = imageUrl;
    data['status'] = status;
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    return data;
  }
}

class Vendor {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;

  Vendor({this.id, this.name, this.email, this.phoneNumber});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}
