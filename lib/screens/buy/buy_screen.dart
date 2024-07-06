// ignore_for_file: prefer_const_constructors, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste/adjust_map.dart';
import 'package:e_waste/cards/card3.dart';
import 'package:e_waste/constants/constants.dart';
import 'package:e_waste/constants/text_style.dart';
import 'package:e_waste/models/order_model.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:e_waste/providers/e_waste_provider.dart';
import 'package:e_waste/providers/user_provider.dart';
import 'package:e_waste/screens/home/view/home_page.dart';
import 'package:e_waste/utils/custom_text_field.dart';
import 'package:e_waste/utils/nextscreen.dart';
import 'package:e_waste/widgets/custom_elevated_button.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BuyProductScreen extends StatefulWidget {
  const BuyProductScreen({super.key, required this.product});
  final Product product;

  @override
  State<BuyProductScreen> createState() => _BuyProductScreenState();
}

class _BuyProductScreenState extends State<BuyProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List textControllers = List.generate(
    5,
    (index) => index == 1
        ? MaskedTextController(mask: '00000-000000')
        : TextEditingController(),
  );

  List<FocusNode> focusNodes = List.generate(
    5,
    (index) => FocusNode(),
  );

  Future<bool> addOrderToFirestore(OrderModel orderModel) async {
    // Access a Firestore instance
    final firestore = FirebaseFirestore.instance;

    try {
      // Create a new document without specifying the ID
      final docRef =
          await firestore.collection('orders').add(orderModel.toFireStore());

      // Set the 'id' property of the Product to the generated document ID
      orderModel.id = docRef.id;

      // Update the document with the 'id' property set
      await docRef.update({'id': orderModel.id});

      print('Product added to Firestore with ID: ${orderModel.id}');
      return true;
    } catch (e) {
      print('Error adding product to Firestore: $e');
      return false;
    }
  }

  setData() {
    var up = context.read<UserProvider>();
    setState(() {
      textControllers[0].text = up.name;
      textControllers[1].text = up.phone;
      textControllers[2].text = up.email;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    var eWasteProvider = context.watch<EWasteProvider>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(color: Colors.black),
            title: Text(
              'Order Details',
              style: robotoStyle400Regular.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                title: 'Checkout',
                verticlaPadding: 12,
                style: interStyle18_600.copyWith(color: Colors.white),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      if (_formKey.currentState!.validate()) {
                        if (context.read<EWasteProvider>().locationAdded) {
                          showLoaderDialog(
                            context: context,
                            title: 'Uploading...',
                          );
                          setState(() {
                            _isLoading = true;
                          });

                          await addOrderToFirestore(
                            OrderModel(
                              buyerName: textControllers[0].text,
                              mobile: textControllers[1].text,
                              email: textControllers[2].text,
                              message: textControllers[3].text,
                              address: textControllers[4].text,
                              latitude: eWasteProvider.locationAdded
                                  ? eWasteProvider.latitude
                                  : null,
                              longitude: eWasteProvider.locationAdded
                                  ? eWasteProvider.longitude
                                  : null,
                              product: Product.toJson(widget.product),
                              timeStamp: Timestamp.now(),
                              status: 'pending',
                            ),
                          ).then((value) async {
                            if (value) {
                              Fluttertoast.showToast(
                                  msg: 'Successfully Ordered');
                              await eWasteProvider.getAllProducts();
                              // ignore: use_build_context_synchronously
                              nextScreenCloseOthers(context, HomePage());
                            } else {
                              await Future.delayed(Duration(seconds: 1));
                              Fluttertoast.showToast(
                                  msg: 'Order Upload Failed');
                              Navigator.pop(context);
                            }
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Add Location to continue');
                        }
                      } else {
                        Fluttertoast.showToast(msg: 'Fill the Required Fields');
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    } catch (e) {
                      Fluttertoast.showToast(msg: 'Error: $e');
                    }
                  }
                },
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card3(product: widget.product),

                //Form
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: SellTabConstants.fieldLabels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            SellTabConstants.fieldLabels[index],
                            style: headline3.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            isEnabled: index == 0 || index == 1 || index == 2
                                ? false
                                : true,
                            focusNode: focusNodes[index],
                            controller: textControllers[index],
                            fontSize: 16,
                            verticalSize: 14,
                            horizontalSize: 12,
                            isShowBorder: false,
                            isSearch: false,
                            onChanged: (value) {
                              try {
                                debugPrint(textControllers[index].text);
                              } catch (e) {
                                Fluttertoast.showToast(msg: 'msg');
                              }

                              return null;
                            },
                            validation: (value) {
                              if (value!.isEmpty) {
                                return '${SellTabConstants.fieldLabels[index]} is required';
                                // } else if (index == 1 &&
                                //     RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
                                //             .hasMatch(value) ==
                                //         false) {
                                //   return 'Invalid Phone Number';
                              } else if (index == 2 &&
                                  RegExp(r"^[a-zA-Z0-9.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(
                                              textControllers[index].text) ==
                                      false) {
                                return 'Invalid Email Address';
                              }
                              return null;
                            },
                            fillColor: Color(0xFFF6F6F6),
                            borderRadius: 8,
                            isIcon: true,
                            textColor: index == 0 || index == 1 || index == 2
                                ? Colors.black.withOpacity(.3)
                                : Colors.black,
                            enabledBorderColor: Colors.white,
                            hintText: SellTabConstants.hints[index],
                            // "Enter average size of ${attribute.label}",
                            hintFontSize: 14,
                            inputType: SellTabConstants.inputTypes[index],
                            inputAction: index < focusNodes.length - 1
                                ? TextInputAction.next
                                : TextInputAction.done,
                            onFieldSubmitted: (value) {
                              if (index < focusNodes.length) {
                                FocusScope.of(context)
                                    .requestFocus(focusNodes[index + 1]);
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // eWasteProvider.locationAdded
                          //     ?
                          openBottomSheet(
                            context,
                            AdjustPinScreen(
                              lat:
                                  eWasteProvider.latitude ?? 23.791451184441417,
                              lon:
                                  eWasteProvider.longitude ?? 90.40905497968197,
                            ),
                            //   )
                            // : openBottomSheet(
                            //     context,
                            //     AdjustPinScreen(
                            //       lat: 23.791451184441417,
                            //       lon: 90.40905497968197,
                            //     ),
                          );
                        },
                        child: Text(
                          eWasteProvider.locationAdded
                              ? 'Change Location'
                              : 'Set Location',
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Visibility(
                          visible: eWasteProvider.locationAdded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Latitude: ${eWasteProvider.latitude}',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'Longitude: ${eWasteProvider.longitude}',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SellTabConstants {
  static List<String> fieldLabels = [
    'Name',
    'Mobile',
    'Email',
    'Message To Seller',
    'Address',
  ];

  static List<String> hints = [
    'Enter Name',
    '01XXX-XXXXX',
    'example@gmail.com',
    'Write Your Message',
    'Enter Address in Details',
  ];
  static List<TextInputType> inputTypes = [
    TextInputType.text,
    TextInputType.phone,
    TextInputType.emailAddress,
    TextInputType.text,
    TextInputType.text,
  ];
}
