import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsmart/data/models/cart_item_model.dart';
import 'package:shopsmart/features/cart/bloc/cart_event.dart';
import 'package:shopsmart/features/cart/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  static const String cartKey = "cart_items";

  CartBloc() : super(CartState(items: [])) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString(cartKey);
      if (cartData != null) {
        final List<dynamic> decoded = jsonDecode(cartData);
        final items = decoded.map((item) => CartItemModel.fromJson(item)).toList();
        emit(CartState(items: items));
      }
    } catch (e) {
      print("Error loading cart: $e");
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final items = List<CartItemModel>.from(state.items);

    final existingIndex = items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (existingIndex >= 0) {
      items[existingIndex].quantity++;
    } else {
      items.add(CartItemModel(product: event.product));
    }

    emit(CartState(items: items));
    await _saveCart(items);
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    final items = List<CartItemModel>.from(state.items);
    items.removeWhere((item) => item.product.id == event.product.id);
    emit(CartState(items: items));
    await _saveCart(items);
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(CartState(items: []));
    await _saveCart([]);
  }

  Future<void> _saveCart(List<CartItemModel> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = jsonEncode(items.map((item) => item.toJson()).toList());
      await prefs.setString(cartKey, cartData);
    } catch (e) {
      print("Error saving cart: $e");
    }
  }
}
