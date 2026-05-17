import 'package:shopsmart/data/models/produt_model.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final ProductModel product;

  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final ProductModel product;

  RemoveFromCart(this.product);
}

class ClearCart extends CartEvent {}

class LoadCart extends CartEvent {}

