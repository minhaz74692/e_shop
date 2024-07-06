// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:e_waste/models/user_model.dart';
import 'package:e_waste/providers/e_waste_provider.dart';
import 'package:e_waste/providers/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_waste/constants/constants.dart';
import 'package:e_waste/providers/auth.dart';
import 'package:e_waste/screens/home/view/home_page.dart';
import 'package:e_waste/screens/signup.dart';
import 'package:e_waste/utils/nextscreen.dart';
import 'package:e_waste/widgets/primary_button.dart';
import 'package:e_waste/widgets/top_titles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool showPassword = true;
  late IconData lockIcon = Icons.visibility;
  TextEditingController email = TextEditingController(text: 'admin@gmail.com');
  TextEditingController password = TextEditingController(text: '123456');

  handleSignInwithemailPassword() async {
    final FirebaseAuthBloc sb =
        Provider.of<FirebaseAuthBloc>(context, listen: false);
    var ub = context.read<UserProvider>();
    var eWasteProvider = context.read<EWasteProvider>();
    showLoaderDialog(context: context, title: 'Loading...');
    try {
      await sb
          .signInwithEmailPassword(email.text, password.text)
          .then((_) async {
        if (sb.hasError == false) {
          ub
              .saveUserData(
                  UserModel(
                    userId: 'ksdf',
                    userName: 'userName',
                    emailId: email.text,
                    phone: 'phone',
                    role: 'reguler',
                  ),
                  'email')
              .then(
                (value) => ub.setSignIn().then(
                  (value) async {
                    // await context.read<TabControllerProvider>().controlTab(0);
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
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            TopTitles(
              title: 'Log In',
              subTitle: 'Welcome to the E-Waste Buddy',
            ),
            SizedBox(
              height: 45,
            ),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              onEditingComplete: handleSignInwithemailPassword,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                  hintText: 'E-mail'),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: password,
              obscureText: showPassword,
              onEditingComplete: handleSignInwithemailPassword,
              decoration: InputDecoration(
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
              title: 'Log In',
              onPressed: handleSignInwithemailPassword,
            ),
            // CustomRoundedLoadingButton2(
            //   doSomething: () async {
            //     handleSignInwithemailPassword;
            //   },
            //   title: 'Log In',
            // ),
            SizedBox(height: 18),
            Center(child: Text('Do not have an account?')),
            SizedBox(height: 0),
            Center(
              child: CupertinoButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  nextScreen(context, SignUp());
                },
                child: Text(
                  'create account',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
