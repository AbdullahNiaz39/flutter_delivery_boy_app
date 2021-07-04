import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_boy_app/providers/auth_provider.dart';
import 'package:flutter_delivery_boy_app/providers/order_provider.dart';
import 'package:flutter_delivery_boy_app/screens/forget_password_screen.dart';
import 'package:flutter_delivery_boy_app/screens/home_screen.dart';
import 'package:flutter_delivery_boy_app/screens/login_screen.dart';
import 'package:flutter_delivery_boy_app/screens/register_screen.dart';
import 'package:flutter_delivery_boy_app/screens/splash_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthProvider()),
        Provider(create: (_) => OrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
      },
    );
  }
}
