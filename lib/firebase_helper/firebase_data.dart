// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_waste/constants/constants.dart';
import 'package:e_waste/models/categories_model.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseStorage storage = FirebaseStorage.instance;

  // Future<List<EWasteModel>> getEWasteList() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore.collection('products').get();

  //     List<EWasteModel> eWasteList = querySnapshot.docs
  //         .map((e) => EWasteModel.fromJson(e.data()))
  //         .toList();
  //     debugPrint(eWasteList[0].title.toString());
  //     return eWasteList;
  //   } catch (e) {
  //     showMessage(e.toString());
  //     print(e.toString());
  //     return [];
  //   }
  // }

  static Future<List<CategoryModel>> getCategories() async {
    final CollectionReference categoriesCollection =
        FirebaseFirestore.instance.collection('categories');
    List<CategoryModel> categoryList = [];
    try {
      QuerySnapshot querySnapshot = await categoriesCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          // Access document data as a Map
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          categoryList.add(CategoryModel.fromJson(data));
          // String id = document.id;
          // String categoryName = data['name'];
          // // Process the data as needed
          // print('Category ID: $id, Name: $categoryName');
        }
      } else {
        print('No categories found in the collection.');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
    return categoryList;
  }
  static Future<List<Product>> getAllProducts() async {
    final CollectionReference categoriesCollection =
        FirebaseFirestore.instance.collection('products');
    List<Product> productList = [];
    try {
      QuerySnapshot querySnapshot = await categoriesCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          // Access document data as a Map
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          productList.add(Product.fromFirestore(data));
          // String id = document.id;
          // String categoryName = data['name'];
          // // Process the data as needed
          // print('Category ID: $id, Name: $categoryName');
        }
      } else {
        print('No categories found in the collection.');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
    return productList;
  }

  Future<List<CategoryModel>> getCategoryList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection('categories').get();

      List<CategoryModel> categoryList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();
      print(categoryList[1].image);
      return categoryList;
    } catch (e) {
      showMessage(e.toString());
      print(e.toString());
      return [];
    }
  }

  // Future<List<Product>> getProductList() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore.collectionGroup('products').get();

  //     List<Product> productList = querySnapshot.docs
  //         .map((e) => Product.fromJson(e.data()))
  //         .toList();
  //     print(productList[1].image);
  //     return productList;
  //   } catch (e) {
  //     showMessage(e.toString());
  //     print(e.toString());
  //     return [];
  //   }
  // }

  // Future<List<Product>> getCategoryView(String id) async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore
  //             .collection('Categories')
  //             .doc(id)
  //             .collection('products')
  //             .get();

  //     List<Product> productList = querySnapshot.docs
  //         .map((e) => Product.fromJson(e.data()))
  //         .toList();
  //     print(productList[1].image);
  //     return productList;
  //   } catch (e) {
  //     showMessage(e.toString());
  //     print(e.toString());
  //     return [];
  //   }
  // }
}
