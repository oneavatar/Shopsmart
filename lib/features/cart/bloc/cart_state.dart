import 'package:shopsmart/data/models/cart_item_model.dart';

class CartState {
  final List<CartItemModel> items;

  CartState({required this.items});

  double get totalPrice {
    double total = 0.0;

    for (var item in items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }
}
