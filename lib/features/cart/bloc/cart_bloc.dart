import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/data/models/cart_item_model.dart';
import 'package:shopsmart/features/cart/bloc/cart_event.dart';
import 'package:shopsmart/features/cart/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(Items: [])) {
    on<AddToCart>((event, emit) {
      final items = List<CartItemModel>.from(state.Items);

      final existingIndex = items.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      if (existingIndex >= 0) {
        items[existingIndex].quantity++;
      } else {
        items.add(CartItemModel(product: event.product));
      }

      emit(CartState(Items: items));
    });

    on<RemoveFromCart>((event, emit) {
      final items = List<CartItemModel>.from(state.Items);

      items.removeWhere((item) => item.product.id == event.product.id);

      emit(CartState(Items: items));
    });
  }
}
