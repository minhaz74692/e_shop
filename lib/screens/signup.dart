// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste/constants/constants.dart';
import 'package:e_waste/models/user_model.dart';
import 'package:e_waste/providers/auth.dart';
import 'package:e_waste/providers/e_waste_provider.dart';
import 'package:e_waste/providers/user_provider.dart';
import 'package:e_waste/screens/home/view/home_page.dart';
import 'package:e_waste/screens/login.dart';
import 'package:e_waste/services/firebase_service.dart';
import 'package:e_waste/utils/nextscreen.dart';
import 'package:e_waste/widgets/primary_button.dart';
import 'package:e_waste/widgets/top_titles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showPassword = true;
  late IconData lockIcon = Icons.visibility;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  String selectedItem = dropdownItems[0];

  Future<bool> addUserToFirestore(UserModel userModel) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final docRef =
          await firestore.collection('users').add(userModel.toFirestore());
      userModel.userId = docRef.id;

      await docRef.update({'user_id': userModel.userId});
      print('Product added to Firestore with ID: ${userModel.userId}');
      return true;
    } catch (e) {
      print('Error adding product to Firestore: $e');
      return false;
    }
  }

  handleSignUpwithemailPassword() async {
    final FirebaseAuthBloc sb =
        Provider.of<FirebaseAuthBloc>(context, listen: false);
    var ub = context.read<UserProvider>();
    var eWasteProvider = context.read<EWasteProvider>();
    showLoaderDialog(context: context, title: 'Loading...');
    await sb
        .signUpwithEmailPassword(name.text, email.text, password.text)
        .then((value) async {
      await addUserToFirestore(
        UserModel(
          userName: name.text,
          emailId: email.text,
          phone: phone.text,
          role: selectedItem == dropdownItems[0] ? 'regular' : 'recycler',
        ),
      );
      await FirebaseService().increaseUserCount();
    }).then((_) async {
      if (sb.hasError == false) {
        ub
            .saveUserData(
                UserModel(
                  userName: name.text,
                  emailId: email.text,
                  phone: phone.text,
                  role:
                      selectedItem == dropdownItems[0] ? 'regular' : 'recycler',
                ),
                'email')
            .then(
              (value) => ub.setSignIn().then(
                (value) async {
                  await eWasteProvider.getCategories();
                  await eWasteProvider.getAllProducts();
                  nextScreen(context, HomePage());
                },
              ),
            );
      } else {
        showMessage(sb.errorCode.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  TopTitles(
                    title: 'Create an account',
                    subTitle: 'Have a good experience with E-Waste Buddy',
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  TextFormField(
                    focusNode: nameFocus,
                    controller: name,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                        ),
                        hintText: 'Full Name'),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: email,
                    focusNode: emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                        ),
                        hintText: 'E-mail'),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: phone,
                    focusNode: phoneFocus,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                        ),
                        hintText: 'Phone Number'),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      validator: (value) =>
                          value == null ? 'Select an option' : null,
                      value: selectedItem,
                      hint: const Text('Select Category'),
                      items: dropdownItems.map(
                        (f) {
                          return DropdownMenuItem(
                            value: f,
                            child: Text(f),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: password,
                    focusNode: passwordFocus,
                    obscureText: showPassword,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        // isDense: true,
                        // filled: true,
                        suffixIcon: CupertinoButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                              lockIcon = lockIcon == Icons.visibility
                                  ? Icons.visibility_off
                                  : Icons.visibility;
                            });
                          },
                          child: Icon(
                            lockIcon,
                            color: Colors.grey,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.lock_open_outlined,
                        ),
                        hintText: 'Password'),
                  ),
                  SizedBox(height: 35),
                  PrimaryButton(
                      title: 'Sign Up',
                      onPressed: () async {
                        bool isValid = signUpValidation(
                            email.text, password.text, name.text, phone.text);
                        if (isValid) {
                          handleSignUpwithemailPassword();
                        }
                      }),
                  SizedBox(height: 18),
                  Center(child: Text('I have already an account?')),
                  SizedBox(height: 0),
                  Center(
                    child: CupertinoButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        nextScreen(context, LogIn());
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<String> dropdownItems = [
  'Regular User',
  'Recycle Company',
];
