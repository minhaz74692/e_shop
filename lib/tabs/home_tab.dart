// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste/cards/card2.dart';
import 'package:e_waste/constants/text_style.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:e_waste/models/user_model.dart';
import 'package:e_waste/providers/e_waste_provider.dart';
import 'package:e_waste/providers/user_provider.dart';
import 'package:e_waste/screens/home/widgets/category_section.dart';
// import 'package:e_waste/services/bookmark_service.dart';
import 'package:e_waste/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_waste/utils/app_name.dart';
import 'package:e_waste/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // List<EWasteModel> eWaseList = [];
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  ScrollController _gridController = ScrollController();
  ScrollController _gridController2 = ScrollController();

  List<Product> productList = [];

  var scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _gridController.dispose();
    _gridController2.dispose();
  }

  getData() async {
    var up = context.read<UserProvider>();
    Map<String, dynamic>? _userData = {};

    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: up.email)
        .get();

    // _userData = userData.data() as Map<String, dynamic>?;
    _userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
    UserModel user = UserModel.fromFirestore(_userData);
    await up.saveUserInformation(user);
    // setState(() {
    //   isLoading = true;
    // });
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // print('Data; ${sp.getBool("signed_in")}');
    // // categoryList = await FirebaseFirestoreHelper.getCategories();
    // // productList = await FirebaseFirestoreHelper.getAllProducts();
    // // await eWasteProvider.getAllProducts();
    // // setState(() {
    // //   productList = eWasteProvider.productList;
    // // });

    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    var eWasteProvider = context.watch<EWasteProvider>();
    // var up = context.watch<UserProvider>();

    print(productList);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppName(
          fontSize: 24,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.shopping_cart,
              ),
            ),
          ),
        ],
        // actions: [
        //   Row(
        //     children: [
        //       ShopingCartButton(
        //         productListInCart: productListInCart,
        //       ),
        //       SignoutButton(),
        //       SizedBox(width: 5),
        //     ],
        //   ),
        // ],
      ),
      drawer: DrawerMenu(),
      key: scaffoldKey,
      body: RefreshIndicator(
        onRefresh: () async {
          await eWasteProvider.clearAllProduct();
          await eWasteProvider.getAllProducts();
        },
        child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // Text(up.phone ?? ''),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 5,
                      ),
                      child: Text(
                        'Categories',
                        style: headline3.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     await FirebaseService().increaseUserCount();
                    //   },
                    //   child: Text('Click'),
                    // ),

                    SizedBox(
                      height: 5,
                    ),
                    CategorySection(),
                    Divider(
                      height: 5,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        eWasteProvider.categoryClicked
                            ? '${eWasteProvider.categoryList[eWasteProvider.activeCategory].name}s'
                            : 'Explore Products',
                        style: headline3.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    eWasteProvider.categoryClicked
                        ? eWasteProvider.catProductList.isEmpty
                            ? SizedBox(
                                height: 400,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Empty Category',
                                            style: headline2,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'No product available in this category.',
                                            style: headline6,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  controller: _gridController,
                                  // itemCount: ProductList().products.length,
                                  itemCount:
                                      eWasteProvider.catProductList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 0.65,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Product singleProduct =
                                        // ProductList().products[index];
                                        eWasteProvider.catProductList[index];

                                    return Card2(product: singleProduct);
                                    // List<Product> thisProductList = productListInCart
                                    //     .where((product) => product.id == singleProduct.id)
                                    //     .toList();
                                    // // return Text(singleProduct.name);
                                    // return Card1(
                                    //   product: singleProduct,
                                    //   thisProductList: thisProductList,
                                    // );
                                  },
                                ),
                              )
                        : eWasteProvider.isLoading
                            ? Center(
                                child: SizedBox(
                                  height: 400,
                                  child: LoadingIndicatorWidget(
                                    color: ThemeData().primaryColor,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  controller: _gridController2,
                                  // itemCount: ProductList().products.length,
                                  itemCount: eWasteProvider.productList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 0.75,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Product singleProduct =
                                        // ProductList().products[index];
                                        eWasteProvider.productList[index];

                                    return Card2(product: singleProduct);
                                    // List<Product> thisProductList = productListInCart
                                    //     .where((product) => product.id == singleProduct.id)
                                    //     .toList();
                                    // // return Text(singleProduct.name);
                                    // return Card1(
                                    //   product: singleProduct,
                                    //   thisProductList: thisProductList,
                                    // );
                                  },
                                ),
                              ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}


//OLD Code
//  body: isLoading
//             ? Center(
//                 child: SizedBox(
//                   height: 100,
//                   width: 100,
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//             : SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 physics: AlwaysScrollableScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Text(
//                         'Categories',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: categoriesList.map((e) {
//                             String imageName = e.name;
//                             String imageUrl = e.image;
//                             return CategoryCard(
//                               categoryModel: e,
//                               imageName: imageName,
//                               imageUrl: imageUrl,
//                             );
//                           }).toList()),
//                     ),
//                     SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Text(
//                         'Best Products',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
                    // GridView.builder(
                    //   physics: NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   // itemCount: ProductList().products.length,
                    //   itemCount: productList.length,
                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2,
                    //     crossAxisSpacing: 15,
                    //     mainAxisSpacing: 10,
                    //     childAspectRatio: 0.6,
                    //   ),
                    //   itemBuilder: (BuildContext context, int index) {
                    //     ProductsModel singleProduct =
                    //         // ProductList().products[index];
                    //         productList[index];
                    //     List<ProductsModel> thisProductList = productListInCart
                    //         .where((product) => product.id == singleProduct.id)
                    //         .toList();
                    //     // return Text(singleProduct.name);
                    //     return Card1(
                    //       product: singleProduct,
                    //       thisProductList: thisProductList,
                    //     );
                    //   },
                    // ),
//                     SizedBox(height: 12.0),
//                   ],
//                 ),
//               ),