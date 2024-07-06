import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste/firebase_helper/firebase_data.dart';
import 'package:e_waste/models/categories_model.dart';
import 'package:e_waste/models/order_model.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:e_waste/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EWasteProvider extends ChangeNotifier {
  int count = 0;
  int price = 0;

  bool _locationAdded = false;
  bool get locationAdded => _locationAdded;

  double? _latitude;
  double? get latitude => _latitude;

  double? _longitude;
  double? get longitude => _longitude;

  getLocation() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _latitude = sp.getDouble('latitude');
    _latitude = sp.getDouble('latitude');
    notifyListeners();
  }

  saveLocation(double lat, double lon) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setDouble('latitude', lat);
    await sp.setDouble('longitude', lon);
    _latitude = lat;
    _longitude = lon;
    _locationAdded = true;
    notifyListeners();
  }

  List<Product> productListOfCart = [];

  List<Product> _productList = [];
  List<Product> get productList => _productList;

  List<CategoryModel> _categoryList = [];
  List<CategoryModel> get categoryList => _categoryList;

  List<Product> _catProductList = [];
  List<Product> get catProductList => _catProductList;

  int _activeCategory = -1;
  int get activeCategory => _activeCategory;

  bool _categoryClicked = false;
  bool get categoryClicked => _categoryClicked;

  handleCategoryClick(int index) {
    if (_activeCategory == index) {
      _activeCategory = -1;
      _categoryClicked = !_categoryClicked;
      _catProductList.clear();
    } else {
      _activeCategory = index;
      _categoryClicked = true;
      _catProductList.clear();
      _catProductList = productList
          .where((service) => service.category == _categoryList[index].name)
          .toList();
    }

    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  getAllProducts() async {
    _isLoading = true;
    _productList = await FirebaseFirestoreHelper.getAllProducts();
    _isLoading = false;
    notifyListeners();
  }

  getCategories() async {
    _isLoading = true;
    _categoryList = await FirebaseFirestoreHelper.getCategories();
    _isLoading = false;
    notifyListeners();
  }

  clearAllProduct() {
    _productList.clear();
    notifyListeners();
  }

  List<Product> bookmarkedProductList = [];

  void addProductToCart(Product x) {
    productListOfCart.add(x);
    notifyListeners();
  }

  void addProductToBookmark(Product x) {
    bookmarkedProductList.add(x);
    notifyListeners();
  }

  void removeProductFromBookmark(Product x) {
    bookmarkedProductList.remove(x);
    notifyListeners();
  }

  void clearProductFromBookmark() {
    bookmarkedProductList.clear();
    notifyListeners();
  }

  void removeProductFromCart(Product x) {
    productListOfCart.remove(x);
    notifyListeners();
  }

  void increment() {
    count++;
    notifyListeners();
  }

  void decrement() {
    if (count > 0) {
      count--;
      notifyListeners();
    }
  }

  void removePrice(int x) {
    if (price > x) {
      price = price - x;
      notifyListeners();
    }
  }

  void addPrice(int x) {
    price = price + x;
    notifyListeners();
  }

  List<OrderModel> _orderList = [];
  List<OrderModel> get orderList => _orderList;

  Future getOrderList(BuildContext context) async {
    _orderList.clear();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var up = context.read<UserProvider>();
    Map<String, dynamic>? _orderData = {};

    QuerySnapshot querySnapshot = await _firestore
        .collection('orders')
        .where('email', isEqualTo: up.email)
        .get();

    // _userData = userData.data() as Map<String, dynamic>?;
    if (querySnapshot.docs.isNotEmpty) {
      _orderData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      OrderModel order = OrderModel.fromFirestore(_orderData);
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        _orderList.add(OrderModel.fromFirestore(
            querySnapshot.docs[i].data() as Map<String, dynamic>));
      }
    }
    // Fluttertoast.showToast(msg: _orderList.length.toString());

    notifyListeners();
  }
}
