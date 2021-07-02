import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_boy_app/providers/auth_provider.dart';
import 'package:flutter_delivery_boy_app/screens/register_form.dart';
import 'package:flutter_delivery_boy_app/widgets/image_picker_shop.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
  static const String id = 'register-screen';
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
              child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      ImagePickerOfShop(),
                      RegistorForm(),
                      // _authData.loading==true ? Container():
                    ],
                  ),
                ),
              ),
            ),
          )),
        ),
      ],
    );
  }
}
