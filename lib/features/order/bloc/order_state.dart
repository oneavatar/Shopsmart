import 'package:shopsmart/data/models/order_model.dart';

abstract class OrderState {}
class OrderInitial extends OrderState {}
class OrderLoading extends OrderState{}
class OrderSuccess extends OrderState{}
class OrderLoaded extends OrderState{
  final List<OrderModel> orders;
  OrderLoaded(this.orders);
}
class OrderError extends OrderState{
  final String error;
  OrderError(this.error);

  String get message => error;
}
