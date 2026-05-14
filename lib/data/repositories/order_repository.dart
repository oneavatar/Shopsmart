import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shopsmart/data/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> placeOrder(OrderModel order) async {
    await firestore.collection('orders').doc(order.id).set({
      ...order.toJson(),

      'userId': auth.currentUser!.uid,
    });
  }

  Future<List<OrderModel>> fetchOrders() async {
    final snapshot = await firestore
        .collection('orders')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return OrderModel.fromJsonMap(doc.data());
    }).toList();
  }
}
