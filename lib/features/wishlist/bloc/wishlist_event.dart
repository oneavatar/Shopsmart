import 'package:shopsmart/data/models/produt_model.dart';

abstract class WishlistEvent {}

class ToggleWishlist extends WishlistEvent {
  final ProductModel product;

  ToggleWishlist(this.product);
}
