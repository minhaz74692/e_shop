import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? id;
  String buyerName;
  String mobile;
  String email;
  String? message;
  String? address;
  double? latitude;
  double? longitude;
  Map<String, dynamic> product;
  Timestamp timeStamp;
  final String status;

  OrderModel({
    this.id,
    required this.buyerName,
    required this.mobile,
    required this.email,
    required this.message,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.product,
    required this.timeStamp,
    required this.status,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      buyerName: map['buyer_name'],
      mobile: map['mobile'],
      email: map['email'],
      message: map['message'],
      address: map['address'],
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      product: map['product'],
      timeStamp: map['timeStamp'],
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'buyer_name': buyerName,
      'mobile': mobile,
      'email': email,
      'message': message,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'product': product,
      'timeStamp': timeStamp,
      'status': status,
    };
  }
}
