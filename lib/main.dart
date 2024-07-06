// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:e_waste/constants/app_constants.dart';
import 'package:e_waste/providers/e_waste_provider.dart';
import 'package:e_waste/providers/tab_controller_bloc.dart';
import 'package:e_waste/providers/user_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:e_waste/providers/auth.dart';
import 'package:e_waste/providers/search_bloc.dart';
import 'package:e_waste/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_waste/screens/splash.dart';
import 'firebase_options.dart';
import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

void main() async {
   await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox(AppConstants.favouriteTag);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<TabControllerProvider>(
          create: (context) => TabControllerProvider(),
        ),
        ChangeNotifierProvider<FirebaseAuthBloc>(
          create: (context) => FirebaseAuthBloc(),
        ),
        ChangeNotifierProvider<SearchBloc>(
          create: (context) => SearchBloc(),
        ),
        ChangeNotifierProvider<EWasteProvider>(
          create: (context) => EWasteProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: themeData,
        home: SplashPage(),
        // home: StreamBuilder(
        //   stream: FirebaseAuthBloc().getAuthChange,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return HomePage();
        //     } else {
        //       return SplashPage();
        //     }
        //   },
        // ),
      ),
    );
  }
}
