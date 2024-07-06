// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste/adjust_map.dart';
import 'package:e_waste/constants/constants.dart';
import 'package:e_waste/constants/text_style.dart';
import 'package:e_waste/models/categories_model.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:e_waste/providers/e_waste_provider.dart';
import 'package:e_waste/providers/tab_controller_bloc.dart';
import 'package:e_waste/screens/home/view/home_page.dart';
import 'package:e_waste/services/firebase_service.dart';
import 'package:e_waste/utils/custom_text_field.dart';
import 'package:e_waste/utils/nextscreen.dart';
import 'package:e_waste/widgets/loading_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SellTab extends StatefulWidget {
  const SellTab({super.key});

  @override
  State<SellTab> createState() => _SellTabState();
}

class _SellTabState extends State<SellTab> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List textControllers = List.generate(
    9,
    (index) => index == 1
        ? MaskedTextController(mask: '00000-000000')
        : TextEditingController(),
  );

  List<FocusNode> focusNodes = List.generate(
    9,
    (index) => FocusNode(),
  );
  String? selectedItem;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  getCategories() async {
    List<CategoryModel> categories =
        context.read<EWasteProvider>().categoryList;
    setState(() {
      selectedItem = categories[0].name;
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  String selectedId() {
    var eWasteProvider = context.read<EWasteProvider>();
    List<CategoryModel> listOfCats = eWasteProvider.categoryList;
    String selectedId =
        listOfCats.firstWhere((element) => element.name == selectedItem).id;
    return selectedId;
  }

  bool loading = false;

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();

    FocusScope.of(context).unfocus();
  }

  String? imageUrl;

  String testString =
      ' aljsdfkajfklajf j kfjakfjdk jaksf kajskfj ajakjf kajdfk jak ';
  @override
  Widget build(BuildContext context) {
    var eWasteProvider = context.watch<EWasteProvider>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              context.read<TabControllerProvider>().controlTab(0);
            },
          ),
          title: const Text(
            'Sell Your E-Waste',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
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
                          index == 3
                              ? Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF6F6F6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButtonFormField(
                                    padding: EdgeInsets.all(0),
                                    itemHeight: 50,
                                    decoration: const InputDecoration(
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 0,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        selectedItem = value;
                                      });
                                    },
                                    validator: (value) => value == null
                                        ? 'Select an option'
                                        : null,
                                    value: selectedItem,
                                    hint: const Text('Select Category'),
                                    items: eWasteProvider.categoryList.map(
                                      (f) {
                                        return DropdownMenuItem(
                                          value: f.name,
                                          child: Text(f.name),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                )
                              : index == 5
                                  ? Container(
                                      child: Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              pickImage();
                                            },
                                            child: Text('Choose'),
                                          ),
                                          Spacer(),
                                          _imageFile != null
                                              ? Container(
                                                  child: Text(
                                                    // '_imageFile!.name.toString()'.length > 30? ,
                                                    _imageFile!.name
                                                                .toString()
                                                                .length >
                                                            25
                                                        ? '${_imageFile!.name.toString().substring(0, 25)}...'
                                                        : _imageFile!.name
                                                            .toString(),
                                                  ),
                                                )
                                              : SizedBox(),
                                          _imageFile != null
                                              ? IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _imageFile = null;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    CupertinoIcons.trash,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    )
                                  : CustomTextField(
                                      focusNode: focusNodes[index],
                                      controller: textControllers[index],
                                      fontSize: 16,
                                      verticalSize: 14,
                                      horizontalSize: 12,
                                      isShowBorder: false,
                                      isSearch: false,
                                      onChanged: (value) {
                                        try {
                                          debugPrint(
                                              textControllers[index].text);
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
                                                        textControllers[index]
                                                            .text) ==
                                                false) {
                                          return 'Invalid Email Address';
                                        }
                                        return null;
                                      },
                                      fillColor: Color(0xFFF6F6F6),
                                      borderRadius: 8,
                                      isIcon: true,
                                      enabledBorderColor: Colors.white,
                                      hintText: SellTabConstants.hints[index],
                                      // "Enter average size of ${attribute.label}",
                                      hintFontSize: 14,
                                      inputType:
                                          SellTabConstants.inputTypes[index],
                                      inputAction: index < focusNodes.length - 1
                                          ? TextInputAction.next
                                          : TextInputAction.done,
                                      onFieldSubmitted: (value) {
                                        if (index < focusNodes.length) {
                                          FocusScope.of(context).requestFocus(
                                              focusNodes[index + 1]);
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
                  Row(
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
                          );
                          // :
                          // openBottomSheet(
                          //     context,
                          //     AdjustPinScreen(
                          //       lat: 23.791451184441417,
                          //       lon: 90.40905497968197,
                          //     ),
                          //   );
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              if (context
                                  .read<EWasteProvider>()
                                  .locationAdded) {
                                showLoaderDialog(
                                  context: context,
                                  title: 'Uploading...',
                                );
                                setState(() {
                                  _isLoading = true;
                                });

                                if (_imageFile != null) {
                                  await compressAndUploadImage(
                                      File(_imageFile!.path));
                                }
                                await addProductToFirestore(
                                  Product(
                                      sellerName: textControllers[0].text,
                                      mobile: textControllers[1].text,
                                      email: textControllers[2].text,
                                      category: selectedItem ?? '',
                                      productName: textControllers[4].text,
                                      image: imageUrl,
                                      price:
                                          double.parse(textControllers[6].text),
                                      description: textControllers[7].text,
                                      location: textControllers[8].text,
                                      latitude: eWasteProvider.locationAdded
                                          ? eWasteProvider.latitude
                                          : null,
                                      longitude: eWasteProvider.locationAdded
                                          ? eWasteProvider.longitude
                                          : null,
                                      timeStamp: Timestamp.now()),
                                ).then((value) async {
                                  if (value) {
                                    await FirebaseService()
                                        .increaseProductCountInCategory(
                                      selectedId(),
                                    );
                                    await FirebaseService()
                                        .increaseProductsCount();
                                    await eWasteProvider.getAllProducts();
                                    nextScreenCloseOthers(context, HomePage());
                                    Fluttertoast.showToast(
                                        msg: 'Successfully Uploaded');
                                  } else {
                                    await Future.delayed(Duration(seconds: 1));
                                    Fluttertoast.showToast(
                                        msg: 'Upload Failed');
                                    Navigator.pop(context);
                                  }
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Add Location to continue');
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Fill the Required Fields');
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          } catch (e) {
                            Fluttertoast.showToast(msg: 'Error: $e');
                          }
                        },
                        child: Padding(
                          padding: _isLoading
                              ? EdgeInsets.all(0)
                              : EdgeInsets.all(12.0),
                          child: _isLoading
                              ? LoadingIndicatorWidget(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Upload Product',
                                  style:
                                      headline3.copyWith(color: Colors.white),
                                ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> addProductToFirestore(Product product) async {
    // Access a Firestore instance
    final firestore = FirebaseFirestore.instance;

    try {
      // Create a new document without specifying the ID
      final docRef =
          await firestore.collection('products').add(product.toFireStore());

      // Set the 'id' property of the Product to the generated document ID
      product.id = docRef.id;

      // Update the document with the 'id' property set
      await docRef.update({'id': product.id});
      print('Product added to Firestore with ID: ${product.id}');
      return true;
    } catch (e) {
      print('Error adding product to Firestore: $e');
      return false;
    }
  }

  Future<void> compressAndUploadImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Compress the image using flutter_image_compress package
    final result = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 50,
    );

    if (result != null && result.lengthInBytes > 0) {
      final compressedImageFile = File('$path/$fileName')
        ..writeAsBytesSync(result);

      final storage = FirebaseStorage.instance;
      final Reference storageReference =
          storage.ref().child('images/$fileName');

      final UploadTask uploadTask =
          storageReference.putFile(compressedImageFile);
      final TaskSnapshot snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final url = await storageReference.getDownloadURL();
        setState(() {
          imageUrl = url;
        });
        print('Image uploaded to Firebase Storage. Download URL: $url');
      } else {
        print('Failed to upload image to Firebase Storage.');
      }
    } else {
      print('Image compression failed.');
    }
  }
}

class SellTabConstants {
  static List<String> fieldLabels = [
    'Seller Name',
    'Mobile',
    'Email',
    'Category',
    'Product Name',
    'Product Image',
    'Offered Price',
    'Description',
    'Address',
  ];

  static List<String> hints = [
    'Enter Name',
    '01XXX-XXXXX',
    'example@gmail.com',
    'Enter Category Name',
    'Enter Product Name',
    'Enter Product Image',
    'Enter Offered Price',
    'Enter Product Description',
    'Enter Address In Details',
  ];
  static List<TextInputType> inputTypes = [
    TextInputType.text,
    TextInputType.phone,
    TextInputType.emailAddress,
    TextInputType.text,
    TextInputType.text,
    TextInputType.text,
    TextInputType.number,
    TextInputType.text,
    TextInputType.text,
  ];
}

// seller name, mobile, email, category, product name, offered price, product details, location in details
