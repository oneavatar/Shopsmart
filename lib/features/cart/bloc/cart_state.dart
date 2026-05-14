import 'package:shopsmart/data/models/cart_item_model.dart';

class CartState {
  final List<CartItemModel> Items;

  CartState({required this.Items});

  double get totalPrice {
    double total = 0.0;

    for (var item in Items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }
}
