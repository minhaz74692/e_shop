import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  String sellerName;
  String mobile;
  String email;
  String category;
  String productName;
  double price;
  String description;
  String? location;
  String? image;
  double? latitude;
  double? longitude;
  Timestamp? timeStamp;

  Product({
    this.id,
    required this.sellerName,
    required this.mobile,
    required this.email,
    required this.category,
    required this.productName,
    required this.price,
    required this.description,
    this.location,
    this.image,
    this.latitude,
    this.longitude,
    required this.timeStamp,
  });

  factory Product.fromFirestore(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      sellerName: map['sellerName'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      category: map['category'] ?? '',
      productName: map['productName'] ?? '',
      price: map['price'].toDouble() ?? 0.0,
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      // image: map['image'] ?? 'https://meyertimber.com/uploads/images/presets/product_page_normal/store/products/NO_IMAGE.jpg',
      image: map['image'] ??
          'https://firebasestorage.googleapis.com/v0/b/e-waste-b3d5d.appspot.com/o/dummy-image_rectangular.jpeg?alt=media&token=70393941-5b37-43dc-9bf7-4e244be55148',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      timeStamp: map['timeStamp'] ?? Timestamp.now(),
    );
  }
  factory Product.fromHive(Map<dynamic, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      sellerName: map['sellerName'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      category: map['category'] ?? '',
      productName: map['productName'] ?? '',
      price: map['price'].toDouble() ?? 0.0,
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      // image: map['image'] ?? 'https://meyertimber.com/uploads/images/presets/product_page_normal/store/products/NO_IMAGE.jpg',
      image: map['image'] ??
          'https://firebasestorage.googleapis.com/v0/b/e-waste-b3d5d.appspot.com/o/dummy-image_rectangular.jpeg?alt=media&token=70393941-5b37-43dc-9bf7-4e244be55148',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      timeStamp: map['timeStamp'] ,
    );
  }
  static Map<String, dynamic> toJson(Product p) => {
        'id': p.id,
        'sellerName': p.sellerName,
        'mobile': p.mobile,
        'email': p.email,
        'category': p.category,
        'productName': p.productName,
        'price': p.price,
        'description': p.description,
        'location': p.location,
        'image': p.image,
        'latitude': p.latitude,
        'longitude': p.longitude,
        'timeStamp': p.timeStamp,
      };

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'sellerName': sellerName,
      'mobile': mobile,
      'email': email,
      'category': category,
      'productName': productName,
      'price': price,
      'description': description,
      'location': location,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
      'timeStamp': timeStamp,
    };
  }
}
