import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_boy_app/screens/home_screen.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';



class AuthProvider extends ChangeNotifier {
  File image;
  bool isPicAvailable = false;
  String pickerError = '';
  double shopLatitude;
  double shopLongtitude;
  String shopAddress;
  String email;
  String error = '';
  String placeName;
  bool loading =false;
  CollectionReference _Boys =
        FirebaseFirestore.instance.collection('deliveryboys');
  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected.';
      print('No image selected.');
      notifyListeners();
    }
    return this.image;
  }

  getemail(email) {
    this.email = email;
  }
  isloading() {
    this.loading = true;
    notifyListeners();
  }

  Future getCurrentAddress() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    this.shopLatitude = _locationData.latitude;
    this.shopLongtitude = _locationData.longitude;
    notifyListeners();

    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var _addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var shopAddress = _addresses.first;
    this.shopAddress = shopAddress.addressLine;
    this.placeName = shopAddress.featureName;
    print("${shopAddress.featureName}:${shopAddress.addressLine}");
    notifyListeners();
    return shopAddress;
  }

  Future<UserCredential> registerBoys(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password that provided is too weak';
        notifyListeners();
        print('The password that provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The Email is already exist';
        notifyListeners();
        print('The Email is already exist');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

//login vendor
  Future<UserCredential> loginBoys(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

//reset password

  Future<void> resetPassword(email) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email).whenComplete((){});
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  Future<void> saveBoysDataToFirestore({
    String url,
    String name,
    String mobile,
    String password,
    context,
  }) {
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference _Boys =
        FirebaseFirestore.instance.collection('deliveryboys');
    _Boys.doc(this.email).update({
      'uid': user.uid,
      'name': name,
      'mobile': mobile,
      'password': password,
      'email': this.email,
      'address': '${this.placeName} :${this.shopAddress}',
      'location': GeoPoint(this.shopLatitude, this.shopLongtitude),
      'imageUrl': url,
      'accountVerified': false,
    }).whenComplete((){Navigator.pushNamed(
                                            context, HomeScreen.id);} );
    return null;
  }
}
