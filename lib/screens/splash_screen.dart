import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_boy_app/screens/home_screen.dart';
import 'package:flutter_delivery_boy_app/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';


import 'fade_in_animation.dart';


class SplashScreen extends StatefulWidget {
  static const id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _scaleController;
  AnimationController _scale2Controller;
  AnimationController _widthController;
  AnimationController _positionController;

  Animation<double> _scaleAnimation;
  Animation<double> _scale2Animation;
  Animation<double> _widthAnimation;
  Animation<double> _positionAnimation;

  bool hideIcon = false;

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, myPage);
  }

  void myPage() {
    _scaleController.forward();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _widthController.forward();
            }
          });

    _widthController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    _widthAnimation =
        Tween<double>(begin: 80.0, end: 300.0).animate(_widthController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _positionController.forward();
            }
          });

    _positionController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _positionAnimation =
        Tween<double>(begin: 0.0, end: 215.0).animate(_positionController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                hideIcon = true;
              });
              _scale2Controller.forward();
            }
          });

    _scale2Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    _scale2Animation =
        Tween<double>(begin: 1.0, end: 32.0).animate(_scale2Controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
//        Navigator.pushReplacement(
//            context, MaterialPageRoute(builder: (context) => SplashScreen(sec: 1)));
              getSessionValues();
//        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: LoginPage()));
            }
          });
  }

  getSessionValues() async {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        Navigator.pushReplacementNamed(
          context,
          LoginScreen.id,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          HomeScreen.id,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
//
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: FadeAnimation(
                      1.6,
                      Container(
                        width: width / 1.3,
                        height: height / 2.8,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage('images/logo.png'),
                                fit: BoxFit.cover)),
                      )),
                )),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//                  SizedBox(height: height / 30,),
                  FadeAnimation(
                      1,
                      Text(
                        "Welcome",
                        style: GoogleFonts.vollkorn(
                            color: Colors.black, fontSize: 45),
                      )),
                  SizedBox(
                    height: height / 400,
                  ),
                  FadeAnimation(
                      1.3,
                      Text(
                        "To Animated Splash Screen Application..!!",
                        style: GoogleFonts.vollkorn(
                            color: Colors.black.withOpacity(.7),
                            height: 1.4,
                            fontSize: 24),
                      )),
//                  FadeAnimation(1.5, Text("Application..!!",
//                    style: GoogleFonts.vollkorn(color: Colors.black.withOpacity(.7), height: 1.4, fontSize: 24),)),
                  SizedBox(
                    height: height / 20,
                  ),
                  FadeAnimation(
                      1.6,
                      AnimatedBuilder(
                        animation: _scaleController,
                        builder: (context, child) => Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _widthController,
                                builder: (context, child) => Container(
                                  width: _widthAnimation.value,
                                  height: 80,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.teal.withOpacity(.4)),
                                  child: InkWell(
                                    onTap: () {
                                      _scaleController.forward();
                                    },
                                    child: Stack(children: <Widget>[
                                      AnimatedBuilder(
                                        animation: _positionController,
                                        builder: (context, child) => Positioned(
                                          left: _positionAnimation.value,
                                          child: AnimatedBuilder(
                                            animation: _scale2Controller,
                                            builder: (context, child) =>
                                                Transform.scale(
                                                    scale:
                                                        _scale2Animation.value,
                                                    child: Container(
                                                      width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.teal),
                                                      child: hideIcon == false
                                                          ? Icon(
                                                              Icons
                                                                  .arrow_forward,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Container(),
                                                    )),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            )),
                      )),
                  SizedBox(
                    height: height / 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
