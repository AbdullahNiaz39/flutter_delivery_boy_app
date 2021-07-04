import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_boy_app/screens/home_screen.dart';
import 'package:flutter_delivery_boy_app/screens/login_screen.dart';

class DrawerServices {
  // FirebaseAuth _auth = FirebaseAuth();

  // logOut() async {
  //   return await _auth.signOut();
  // }
  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget drawerScreen(title, context) {
    if (title == 'Orders') {
      return HomeScreen();
    }

    if (title == 'LogOut') {
      Future.delayed(Duration.zero, () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      });
      //   return LoginScreen();

      //     return Navigator();

    }

    return HomeScreen();
  }
}
