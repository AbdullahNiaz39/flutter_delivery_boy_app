import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_boy_app/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_delivery_boy_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'forgetpasswordscreen-screen';
  ResetPasswordScreen({Key key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String email;
  bool _isloading = false;
  var _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 70.0,
                    ),
                    Image.asset(
                      'images/forgetpassword.png',
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    Column(
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: 'Forget Password : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  fontSize: 16)),
                          TextSpan(
                              text:
                                  'Enter the email address you used to create your account and we will email you a link to reset your password',
                              style: TextStyle(color: Colors.teal))
                        ])),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: _emailTextController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Email';
                            }
                            final bool _isValid = EmailValidator.validate(
                                _emailTextController.text);
                            if (!_isValid) {
                              return 'invalid Email';
                            }
                            setState(() {
                              email = value;
                            });
                            return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Enter Email',
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.teal)),
                              focusColor: Colors.teal),
                        ),
                        FlatButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isloading = true;
                                });
                               _authData.resetPassword(email);
                              
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Please Check Your Email')));
                              
                              }
                              Navigator.pushReplacementNamed(context, LoginScreen.id);
                            },
                            child: _isloading
                                ? LinearProgressIndicator()
                                : Text(
                                    'Reset Password',
                                    style: TextStyle(color: Colors.white),
                                  ),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)))
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
