import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopsmart/data/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order) async {
    await firestore.collection('orders').doc(order.id).set(order.toJson());
  }

  Future<List<OrderModel>> fetchOrders() async {
    final snapshot = await firestore.collection('orders').get();

    return snapshot.docs.map((doc) {
      return OrderModel.fromJsonMap(doc.data());
    }).toList();
  }
}
