import 'dart:convert';

EmailVerificationModel emailVerificationModelFromJson(String str) =>
    EmailVerificationModel.fromJson(json.decode(str));

String emailVerificationModelToJson(EmailVerificationModel data) =>
    json.encode(data.toJson());




class EmailVerificationModel {
  bool? status;
  String? message;
  Data? data;

  EmailVerificationModel({this.status, this.message, this.data});

  EmailVerificationModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? firstname;
  String? lastname;
  String? email;
  String? phoneNumber;
  String? profilePicture;
  String? country;
  String? businessName;
  String? businessAddress;
  String? shopSize;
  String? latitude;
  String? longitude;
  String? accountNumber;
  String? accountName;
  String? bankName;
  bool? emailVerified;
  String? role;
  bool? isVendor;
  List<dynamic>? vendorCategories;
  String? referralCode;
  dynamic referrerId;
  String? referralCount;
  bool? hasPin;
  int? isActive;
  String? createdAt;
  String? lastLogin;
  Wallet? wallet;
  List<dynamic>? favorites;
  List<dynamic>? contactAddress;

  Data({
    this.id,
    this.name,
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.country,
    this.businessName,
    this.businessAddress,
    this.shopSize,
    this.latitude,
    this.longitude,
    this.accountNumber,
    this.accountName,
    this.bankName,
    this.emailVerified,
    this.role,
    this.isVendor,
    this.vendorCategories,
    this.referralCode,
    this.referrerId,
    this.referralCount,
    this.hasPin,
    this.isActive,
    this.createdAt,
    this.lastLogin,
    this.wallet,
    this.favorites,
    this.contactAddress,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    profilePicture = json['profile_picture'];
    country = json['country'];
    businessName = json['business_name'];
    businessAddress = json['business_address'];
    shopSize = json['shop_size'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    accountNumber = json['account_number'];
    accountName = json['account_name'];
    bankName = json['bank_name'];
    emailVerified = json['email_verified'];
    role = json['role'];
    isVendor = json['is_vendor'];
    vendorCategories = json['vendor_categories'];
    referralCode = json['referral_code'];
    referrerId = json['referrer_id'];
    referralCount = json['referral_count'];
    hasPin = json['has_pin'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    lastLogin = json['last_login'];
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    favorites = json['favorites'];
    contactAddress = json['contact_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['profile_picture'] = this.profilePicture;
    data['country'] = this.country;
    data['business_name'] = this.businessName;
    data['business_address'] = this.businessAddress;
    data['shop_size'] = this.shopSize;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['account_number'] = this.accountNumber;
    data['account_name'] = this.accountName;
    data['bank_name'] = this.bankName;
    data['email_verified'] = this.emailVerified;
    data['role'] = this.role;
    data['is_vendor'] = this.isVendor;
    data['vendor_categories'] = this.vendorCategories;
    data['referral_code'] = this.referralCode;
    data['referrer_id'] = this.referrerId;
    data['referral_count'] = this.referralCount;
    data['has_pin'] = this.hasPin;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['last_login'] = this.lastLogin;
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    data['favorites'] = this.favorites;
    data['contact_address'] = this.contactAddress;
    return data;
  }
}


class Wallet {
  int? id;
  String? balance;

  Wallet({this.id, this.balance});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['balance'] = this.balance;
    return data;
  }
}
