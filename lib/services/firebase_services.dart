import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference deliveryBoys =
      FirebaseFirestore.instance.collection('deliveryboys');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot> validateUser(id) async {
    DocumentSnapshot result = await deliveryBoys.doc(id).get();
    return result;
  }

  Future<DocumentSnapshot> getCustomerDetails(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  Future<void> updateStatus({id, status}) {
    return orders.doc(id).update({'orderStatus': status});
  }
}
