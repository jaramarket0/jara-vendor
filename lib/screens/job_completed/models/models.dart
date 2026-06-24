import 'dart:convert';

DecisionOrderModel decisionOrderModelFromJson(String x)=> DecisionOrderModel.fromJson(jsonDecode(x));


class DecisionOrderModel {
  bool? status;
  String? message;
  Data? data;

  DecisionOrderModel({this.status, this.message, this.data});

  DecisionOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? itemId;
  String? customer;
  int? orderId;
  String? orderNo;
  String? orderDate;
  String? name;
  String? price;
  String? unit;
  String? imageUrl;
  String? status;
  Vendor? vendor;

  Data(
      {this.itemId,
      this.customer,
      this.orderId,
      this.orderNo,
      this.orderDate,
      this.name,
      this.price,
      this.unit,
      this.imageUrl,
      this.status,
      this.vendor});

  Data.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    customer = json['customer'];
    orderId = json['order_id'];
    orderNo = json['order_no'];
    orderDate = json['order_date'];
    name = json['name'];
    price = json['price'];
    unit = json['unit'];
    imageUrl = json['image_url'];
    status = json['status'];
    vendor =
        json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['customer'] = this.customer;
    data['order_id'] = this.orderId;
    data['order_no'] = this.orderNo;
    data['order_date'] = this.orderDate;
    data['name'] = this.name;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['image_url'] = this.imageUrl;
    data['status'] = this.status;
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
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
