import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/data/models/produt_model.dart';
import 'package:shopsmart/features/wishlist/bloc/wishlist_event.dart';
import 'package:shopsmart/features/wishlist/bloc/wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(WishlistState(wishlist: [])) {
    on<ToggleWishlist>((event, emit) {
      final items = List<ProductModel>.from(state.wishlist);
      final exists = items.any((item) => item.id == event.product.id);

      if (exists) {
        items.removeWhere((item) => item.id == event.product.id);
      } else {
        items.add(event.product);
      }

      emit(WishlistState(wishlist: items));
    });
  }
}
