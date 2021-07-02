import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_boy_app/screens/login_screen.dart';

import 'package:flutter_delivery_boy_app/services/firebase_services.dart';
import 'package:flutter_delivery_boy_app/widgets/order_summary_card.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User _user = FirebaseAuth.instance.currentUser;
  FirebaseServices _services = FirebaseServices();
  int tag = 0;
  String status;
  List<String> options = [
    'All',
    'Accepted',
    'Picked Up',
    'On the way',
    'Delivered',
  ];
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 100),
                child: Text(
                  'Orders',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 100),
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.popAndPushNamed(context, LoginScreen.id);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
                choiceStyle: C2ChoiceStyle(),
                value: tag,
                onChanged: (val) {
                  if (val == 0) {
                    setState(() {
                      status = null;
                    });
                  }
                  setState(() {
                    tag = val;
                    status = options[val];
                  });
                },
                choiceItems: C2Choice.listFrom<int, String>(
                  source: options,
                  value: (i, v) => i,
                  label: (i, v) => v,
                )),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _services.orders
                  .where('deliveryboy.phone', isEqualTo: _user.phoneNumber)
                  // .where('deliveryboy.email', isEqualTo: _user.email)
                  .where('orderStatus', isEqualTo: tag == 0 ? null : status)
                  //
                  // .where('orderStatus', isEqualTo: 'Accepted')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data.size == 0) {
                  return Center(child: Text('No $status Orders'));
                }

                return Expanded(
                  child: new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      //  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, bottom: 8),
                        child: new OrderSummaryCard(document),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
