import 'package:shopsmart/data/models/order_model.dart';

abstract class OrderEvent {}

class PlaceOrderEvent extends OrderEvent {
  final OrderModel order;
  PlaceOrderEvent(this.order);
}

class LoadOrdersEvent extends OrderEvent {}
